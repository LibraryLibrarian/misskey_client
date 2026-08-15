import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:meta/meta.dart';

import '../client/token_provider.dart';
import '../exception/misskey_client_exception.dart';
import '../logging/logger.dart';
import 'internal/streaming_socket.dart';
import 'internal/streaming_uri_builder.dart';
import 'streaming_channel.dart';
import 'streaming_config.dart';
import 'streaming_connection_state.dart';
import 'streaming_message.dart';
import 'streaming_subscription.dart';

/// A reusable connection to the Misskey Streaming API.
class MisskeyStreaming {
  static const int _maximumSubscriptions = 32;

  /// Creates a Misskey Streaming API client.
  factory MisskeyStreaming({
    required Uri baseUrl,
    TokenProvider? tokenProvider,
    MisskeyStreamingConfig? config,
    Logger? logger,
    bool enableLog = false,
  }) => MisskeyStreaming.withConnector(
    baseUrl: baseUrl,
    tokenProvider: tokenProvider,
    config: config,
    logger: logger,
    enableLog: enableLog,
    connector: connectStreamingSocket,
  );

  /// Creates a client with an injectable socket transport.
  ///
  /// This constructor is intended for package tests. Applications should use
  /// the default constructor.
  @visibleForTesting
  MisskeyStreaming.withConnector({
    required Uri baseUrl,
    required StreamingSocketConnector connector,
    TokenProvider? tokenProvider,
    MisskeyStreamingConfig? config,
    Logger? logger,
    bool enableLog = false,
    double Function()? jitterSource,
  }) : _baseUrl = baseUrl,
       _tokenProvider = tokenProvider,
       config = config ?? MisskeyStreamingConfig(),
       _logger = logger ?? const StdoutLogger(),
       _enableLog = enableLog,
       _connector = connector,
       _jitterSource = jitterSource ?? Random().nextDouble;

  final Uri _baseUrl;
  final TokenProvider? _tokenProvider;
  final Logger _logger;
  final bool _enableLog;
  final StreamingSocketConnector _connector;
  final double Function() _jitterSource;

  /// The connection and reconnection settings.
  final MisskeyStreamingConfig config;

  final StreamController<MisskeyStreamingConnectionState> _stateController =
      StreamController<MisskeyStreamingConnectionState>.broadcast();
  final StreamController<MisskeyStreamingException> _errorController =
      StreamController<MisskeyStreamingException>.broadcast();
  final StreamController<MisskeyStreamingMessage> _messageController =
      StreamController<MisskeyStreamingMessage>.broadcast();
  final Map<String, _SubscriptionEntry> _subscriptions = {};

  MisskeyStreamingConnectionState _state =
      MisskeyStreamingConnectionState.disconnected;
  bool _wantsConnection = false;
  bool _isDisposed = false;
  int _generation = 0;
  int _reconnectAttempts = 0;
  int _nextSubscriptionId = 0;
  _ActiveConnection? _connection;
  Future<void>? _connectFuture;
  int? _connectFutureGeneration;
  Future<void>? _disposeFuture;
  Timer? _reconnectTimer;

  /// The current connection state.
  MisskeyStreamingConnectionState get state => _state;

  /// State changes that occur after listening.
  Stream<MisskeyStreamingConnectionState> get stateChanges =>
      _stateController.stream;

  /// Transport and protocol errors.
  Stream<MisskeyStreamingException> get errors => _errorController.stream;

  /// Decoded raw Streaming API messages.
  Stream<MisskeyStreamingMessage> get messages => _messageController.stream;

  /// Subscribes to a raw Misskey Streaming API channel.
  ///
  /// When connected, the returned future completes after the server sends a
  /// `connected` acknowledgement. When disconnected, the definition is kept
  /// locally and sent after the next successful connection.
  Future<MisskeyStreamingSubscription> subscribeRaw({
    required String channel,
    Map<String, Object?> params = const {},
    String? id,
  }) => _subscribe(channel: channel, params: params, id: id);

  /// Subscribes to an official Misskey Streaming API channel.
  Future<MisskeyStreamingSubscription> subscribe(
    MisskeyStreamingChannel channel,
  ) async {
    final params = channel.params;
    _validateTypedChannel(channel.name, params);
    if (_sharedChannelNames.contains(channel.name) &&
        _subscriptions.values.any((entry) => entry.channel == channel.name)) {
      throw MisskeyStreamingSubscriptionException(
        message: 'Shared Streaming channel is already subscribed',
        operation: 'subscribe',
        context: {'channel': channel.name},
      );
    }
    return _subscribe(channel: channel.name, params: params);
  }

  Future<MisskeyStreamingSubscription> _subscribe({
    required String channel,
    required Map<String, Object?> params,
    String? id,
  }) async {
    _ensureNotDisposed();
    if (channel.isEmpty) {
      throw const MisskeyStreamingSubscriptionException(
        message: 'Streaming channel must not be empty',
        operation: 'subscribe',
      );
    }
    if (id != null && id.isEmpty) {
      throw const MisskeyStreamingSubscriptionException(
        message: 'Streaming subscription ID must not be empty',
        operation: 'subscribe',
      );
    }
    if (id != null && _subscriptions.containsKey(id)) {
      throw MisskeyStreamingSubscriptionException(
        message: 'Streaming subscription ID is already in use',
        operation: 'subscribe',
        context: {'subscriptionId': id},
      );
    }
    if (_subscriptions.length >= _maximumSubscriptions) {
      throw MisskeyStreamingSubscriptionException(
        message: 'Streaming subscription limit reached',
        operation: 'subscribe',
        context: {'maximum': _maximumSubscriptions},
      );
    }

    final subscriptionId = id ?? _generateSubscriptionId();
    final entry = _SubscriptionEntry(
      id: subscriptionId,
      channel: channel,
      params: Map.unmodifiable(params),
    );
    entry.subscription = MisskeyStreamingSubscription(
      id: subscriptionId,
      channel: channel,
      params: entry.params,
      messages: entry.messageController.stream,
      onUnsubscribe: () => _unsubscribeSubscription(subscriptionId),
    );
    _subscriptions[subscriptionId] = entry;

    if (isConnected) {
      _sendSubscription(entry);
    }
    return entry.ready.future;
  }

  static const Set<String> _sharedChannelNames = {
    'main',
    'drive',
    'serverStats',
    'queueStats',
    'admin',
    'reversi',
  };

  void _validateTypedChannel(String channel, Map<String, Object?> params) {
    final requiredParameter = switch (channel) {
      'userList' => 'listId',
      'roleTimeline' => 'roleId',
      'antenna' => 'antennaId',
      'channel' => 'channelId',
      'reversiGame' => 'gameId',
      'chatUser' => 'otherId',
      'chatRoom' => 'roomId',
      _ => null,
    };
    if (requiredParameter != null) {
      final id = params[requiredParameter];
      if (id is! String || id.trim().isEmpty) {
        throw MisskeyStreamingSubscriptionException(
          message: 'Streaming channel ID must not be empty',
          operation: 'subscribe',
          context: {'channel': channel, 'parameter': requiredParameter},
        );
      }
    }

    if (channel == 'hashtag') {
      final q = params['q'];
      if (q is! List<List<String>> ||
          q.isEmpty ||
          q.any(
            (condition) =>
                condition.isEmpty || condition.any((tag) => tag.trim().isEmpty),
          )) {
        throw MisskeyStreamingSubscriptionException(
          message: 'Hashtag conditions must contain non-empty tags',
          operation: 'subscribe',
          context: {'channel': channel, 'parameter': 'q'},
        );
      }
    }
  }

  /// Whether the WebSocket is open and ready to send messages.
  bool get isConnected => _state == MisskeyStreamingConnectionState.connected;

  /// Establishes the WebSocket connection.
  ///
  /// Concurrent calls join the same connection attempt. An explicit initial
  /// failure is reported to the caller and is not automatically retried.
  Future<void> connect() {
    _ensureNotDisposed();
    if (isConnected) {
      return Future<void>.value();
    }

    final currentFuture = _connectFuture;
    if (currentFuture != null &&
        (_state == MisskeyStreamingConnectionState.connecting ||
            _state == MisskeyStreamingConnectionState.reconnecting)) {
      return currentFuture;
    }

    _cancelReconnectTimer();
    _wantsConnection = true;
    _reconnectAttempts = 0;
    return _beginConnection(reconnecting: false, automaticAttempt: false);
  }

  /// Stops the WebSocket without discarding future subscription state.
  ///
  /// Calling this method more than once is safe. Automatic reconnection remains
  /// disabled until [connect] or [reconnect] is called.
  Future<void> disconnect() async {
    if (_isDisposed) {
      return;
    }

    _wantsConnection = false;
    _cancelReconnectTimer();
    _pauseSubscriptionAcknowledgements();
    _generation++;
    _connectFuture = null;
    _connectFutureGeneration = null;

    final connection = _connection;
    _connection = null;
    _setState(MisskeyStreamingConnectionState.disconnected);
    if (connection != null) {
      connection.terminationHandled = true;
      _completePendingReadyAsCancelled(connection);
      await _releaseConnection(connection, waitForSocket: connection.ready);
    }
  }

  /// Replaces the current WebSocket and resolves the token again.
  Future<void> reconnect() async {
    _ensureNotDisposed();
    _wantsConnection = false;
    _cancelReconnectTimer();
    _pauseSubscriptionAcknowledgements();
    final stopGeneration = ++_generation;
    _connectFuture = null;
    _connectFutureGeneration = null;

    final connection = _connection;
    _connection = null;
    _setState(MisskeyStreamingConnectionState.disconnected);
    if (connection != null) {
      connection.terminationHandled = true;
      _completePendingReadyAsCancelled(connection);
      await _releaseConnection(connection, waitForSocket: connection.ready);
    }

    if (_isDisposed || _generation != stopGeneration) {
      return;
    }
    _wantsConnection = true;
    _reconnectAttempts = 0;
    await _beginConnection(reconnecting: true, automaticAttempt: false);
  }

  /// Permanently releases the socket and all stream controllers.
  ///
  /// Calling this method concurrently or repeatedly is safe.
  Future<void> dispose() {
    final currentFuture = _disposeFuture;
    if (currentFuture != null) {
      return currentFuture;
    }

    _isDisposed = true;
    _wantsConnection = false;
    _cancelReconnectTimer();
    final subscriptionEntries = _disposeSubscriptions();
    _generation++;
    _connectFuture = null;
    _connectFutureGeneration = null;

    final connection = _connection;
    _connection = null;
    if (connection != null) {
      connection.terminationHandled = true;
      _completePendingReadyAsCancelled(connection);
    }
    _setState(MisskeyStreamingConnectionState.disposed);

    final future = _performDispose(connection, subscriptionEntries);
    _disposeFuture = future;
    return future;
  }

  Future<void> _performDispose(
    _ActiveConnection? connection,
    List<_SubscriptionEntry> subscriptionEntries,
  ) async {
    try {
      if (connection != null) {
        await _releaseConnection(connection, waitForSocket: connection.ready);
      }
    } finally {
      try {
        await Future.wait(
          subscriptionEntries.map((entry) => entry.messageController.close()),
        );
      } finally {
        await _messageController.close();
        await _errorController.close();
        await _stateController.close();
      }
    }
  }

  Future<void> _beginConnection({
    required bool reconnecting,
    required bool automaticAttempt,
  }) {
    final generation = ++_generation;
    _setState(
      reconnecting
          ? MisskeyStreamingConnectionState.reconnecting
          : MisskeyStreamingConnectionState.connecting,
    );

    late final Future<void> future;
    future = _openConnection(generation, automaticAttempt: automaticAttempt)
        .whenComplete(() {
          if (_connectFutureGeneration == generation) {
            _connectFuture = null;
            _connectFutureGeneration = null;
          }
        });
    _connectFutureGeneration = generation;
    _connectFuture = future;
    return future;
  }

  Future<void> _openConnection(
    int generation, {
    required bool automaticAttempt,
  }) async {
    _ActiveConnection? connection;
    try {
      final token = await _resolveToken();
      if (!_isCurrentIntent(generation)) {
        return;
      }

      final safeUri = _safeStreamingUri();
      final uri = buildStreamingUri(_baseUrl, token: token);
      _logInfo('Connecting to Misskey Streaming API at $safeUri');

      final socket = _connector(uri);
      if (!_isCurrentIntent(generation)) {
        _closeWithoutWaiting(socket);
        return;
      }

      connection = _ActiveConnection(
        generation: generation,
        socket: socket,
        automaticAttempt: automaticAttempt,
      );
      _connection = connection;
      connection.subscription = socket.stream.listen(
        (data) => _handleMessage(connection!, data),
        onError: (Object error, StackTrace stackTrace) {
          _handleSocketError(connection!, error, stackTrace);
        },
        onDone: () => _handleSocketDone(connection!),
        cancelOnError: false,
      );

      await Future.any<void>([
        socket.ready.timeout(
          config.connectTimeout,
          onTimeout: () => throw MisskeyStreamingTimeoutException(
            message: 'Streaming connection timed out',
            operation: 'connect',
            timeout: config.connectTimeout,
          ),
        ),
        connection.terminatedBeforeReady.future.then((error) => throw error),
      ]);

      if (!_isCurrentConnection(connection) || connection.terminationHandled) {
        return;
      }
      connection.ready = true;
      _reconnectAttempts = 0;
      _setState(MisskeyStreamingConnectionState.connected);
      _restoreSubscriptions();
      _logInfo('Connected to Misskey Streaming API');
    } catch (error, stackTrace) {
      if (!_isCurrentIntent(generation)) {
        if (connection != null) {
          unawaited(_releaseConnection(connection, waitForSocket: false));
        }
        return;
      }

      final exception = _toStreamingException(error, stackTrace);
      if (connection == null) {
        _handleAttemptFailure(
          generation,
          exception,
          automaticAttempt: automaticAttempt,
        );
      } else if (!connection.terminationHandled) {
        _terminateConnection(connection, error: exception);
      }
      throw exception;
    }
  }

  Future<String?> _resolveToken() async => _tokenProvider?.call();

  String _generateSubscriptionId() {
    String candidate;
    do {
      candidate = 'subscription-${++_nextSubscriptionId}';
    } while (_subscriptions.containsKey(candidate));
    return candidate;
  }

  void _restoreSubscriptions() {
    for (final entry in List<_SubscriptionEntry>.of(_subscriptions.values)) {
      _sendSubscription(entry);
    }
  }

  void _sendSubscription(_SubscriptionEntry entry) {
    final connection = _connection;
    if (!isConnected ||
        connection == null ||
        !connection.ready ||
        entry.sentGeneration == connection.generation) {
      return;
    }

    final generation = connection.generation;
    entry
      ..sentGeneration = generation
      ..acknowledgementTimer?.cancel()
      ..acknowledgementTimer = Timer(
        config.subscriptionTimeout,
        () => _handleSubscriptionTimeout(entry, generation),
      );

    try {
      connection.socket.add(
        jsonEncode({
          'type': 'connect',
          'body': {
            'channel': entry.channel,
            'id': entry.id,
            'params': entry.params,
            'pong': true,
          },
        }),
      );
    } catch (error, stackTrace) {
      _handleSubscriptionSendFailure(entry, error, stackTrace);
    }
  }

  void _handleSubscriptionSendFailure(
    _SubscriptionEntry entry,
    Object error,
    StackTrace stackTrace,
  ) {
    entry
      ..acknowledgementTimer?.cancel()
      ..acknowledgementTimer = null
      ..sentGeneration = null;
    final exception = MisskeyStreamingSubscriptionException(
      message: 'Could not send Streaming subscription request',
      cause: error,
      stackTrace: stackTrace,
      operation: 'subscribe',
      context: {'subscriptionId': entry.id, 'channel': entry.channel},
    );

    if (!entry.ready.isCompleted) {
      if (identical(_subscriptions[entry.id], entry)) {
        _subscriptions.remove(entry.id);
      }
      unawaited(entry.messageController.close());
      entry.ready.completeError(exception, stackTrace);
    } else {
      _emitError(exception);
    }
  }

  void _handleSubscriptionTimeout(_SubscriptionEntry entry, int generation) {
    if (entry.sentGeneration != generation ||
        !identical(_subscriptions[entry.id], entry)) {
      return;
    }
    entry.acknowledgementTimer = null;
    final exception = MisskeyStreamingTimeoutException(
      message: 'Streaming subscription acknowledgement timed out',
      operation: 'subscribe',
      timeout: config.subscriptionTimeout,
      context: {'subscriptionId': entry.id, 'channel': entry.channel},
    );

    if (!entry.ready.isCompleted) {
      _subscriptions.remove(entry.id);
      try {
        _sendUnsubscribeFrame(entry.id);
      } catch (_) {
        // タイムアウト後のロールバック送信失敗は元の例外を優先する
      }
      unawaited(entry.messageController.close());
      entry.ready.completeError(exception, StackTrace.current);
    } else {
      _emitError(exception);
    }
  }

  void _handleSubscriptionProtocolMessage(MisskeyStreamingMessage message) {
    if (message.type != 'connected') {
      return;
    }

    final body = message.body;
    if (body is! Map<Object?, Object?>) {
      throw const MisskeyStreamingProtocolException(
        message: 'Streaming connected acknowledgement body must be an object',
        operation: 'acknowledgeSubscription',
      );
    }
    final id = body['id'];
    if (id is! String || id.isEmpty) {
      throw const MisskeyStreamingProtocolException(
        message: 'Streaming connected acknowledgement ID is invalid',
        operation: 'acknowledgeSubscription',
      );
    }

    final entry = _subscriptions[id];
    final connection = _connection;
    if (entry == null ||
        connection == null ||
        entry.sentGeneration != connection.generation) {
      return;
    }

    entry
      ..acknowledgementTimer?.cancel()
      ..acknowledgementTimer = null;
    if (!entry.ready.isCompleted) {
      entry.ready.complete(entry.subscription);
    }
  }

  Future<void> _unsubscribeSubscription(String id) async {
    final entry = _subscriptions.remove(id);
    if (entry == null) {
      return;
    }

    entry
      ..acknowledgementTimer?.cancel()
      ..acknowledgementTimer = null
      ..sentGeneration = null;

    MisskeyStreamingSubscriptionException? exception;
    try {
      _sendUnsubscribeFrame(id);
    } catch (error, stackTrace) {
      exception = MisskeyStreamingSubscriptionException(
        message: 'Could not send Streaming unsubscribe request',
        cause: error,
        stackTrace: stackTrace,
        operation: 'unsubscribe',
        context: {'subscriptionId': id, 'channel': entry.channel},
      );
    } finally {
      await entry.messageController.close();
    }

    if (exception != null) {
      throw exception;
    }
  }

  void _sendUnsubscribeFrame(String id) {
    final connection = _connection;
    if (!isConnected || connection == null || !connection.ready) {
      return;
    }
    connection.socket.add(
      jsonEncode({
        'type': 'disconnect',
        'body': {'id': id},
      }),
    );
  }

  void _pauseSubscriptionAcknowledgements() {
    for (final entry in _subscriptions.values) {
      entry
        ..acknowledgementTimer?.cancel()
        ..acknowledgementTimer = null
        ..sentGeneration = null;
    }
  }

  List<_SubscriptionEntry> _disposeSubscriptions() {
    final entries = List<_SubscriptionEntry>.of(_subscriptions.values);
    _subscriptions.clear();
    final stackTrace = StackTrace.current;
    for (final entry in entries) {
      entry
        ..acknowledgementTimer?.cancel()
        ..acknowledgementTimer = null
        ..sentGeneration = null;
      if (!entry.ready.isCompleted) {
        entry.ready.completeError(
          MisskeyStreamingSubscriptionException(
            message: 'Streaming client was disposed before subscription ACK',
            operation: 'subscribe',
            context: {'subscriptionId': entry.id, 'channel': entry.channel},
          ),
          stackTrace,
        );
      }
    }
    return entries;
  }

  void _handleMessage(_ActiveConnection connection, Object? data) {
    if (!_isCurrentConnection(connection) || _isDisposed) {
      return;
    }

    try {
      final String text;
      if (data is String) {
        text = data;
      } else if (data is List<int>) {
        text = utf8.decode(data);
      } else {
        throw MisskeyStreamingProtocolException(
          message: 'Unsupported WebSocket message type',
          operation: 'decodeMessage',
          context: {'runtimeType': data.runtimeType.toString()},
        );
      }

      final Object? decoded = jsonDecode(text);
      if (decoded is! Map<Object?, Object?>) {
        throw MisskeyStreamingProtocolException(
          message: 'Streaming message must be a JSON object',
          operation: 'decodeMessage',
        );
      }

      final raw = <String, Object?>{};
      for (final entry in decoded.entries) {
        final key = entry.key;
        if (key is! String) {
          throw MisskeyStreamingProtocolException(
            message: 'Streaming message keys must be strings',
            operation: 'decodeMessage',
          );
        }
        raw[key] = entry.value;
      }
      final message = MisskeyStreamingMessage.fromJson(raw);
      _messageController.add(message);
      _handleSubscriptionProtocolMessage(message);
    } catch (error, stackTrace) {
      final exception = error is MisskeyStreamingException
          ? error
          : MisskeyStreamingProtocolException(
              message: 'Could not decode Streaming API message',
              cause: error,
              stackTrace: stackTrace,
              operation: 'decodeMessage',
            );
      _emitError(exception);
    }
  }

  void _handleSocketError(
    _ActiveConnection connection,
    Object error,
    StackTrace stackTrace,
  ) {
    _terminateConnection(
      connection,
      error: _toStreamingException(error, stackTrace),
    );
  }

  void _handleSocketDone(_ActiveConnection connection) {
    _terminateConnection(connection);
  }

  void _terminateConnection(
    _ActiveConnection connection, {
    MisskeyStreamingException? error,
  }) {
    if (!_isCurrentConnection(connection) ||
        connection.terminationHandled ||
        _isDisposed) {
      return;
    }

    connection.terminationHandled = true;
    _pauseSubscriptionAcknowledgements();
    _connection = null;
    final beforeReadyError =
        error ??
        const MisskeyStreamingConnectionException(
          message: 'Streaming socket closed before becoming ready',
          operation: 'connect',
        );
    if (!connection.ready && !connection.terminatedBeforeReady.isCompleted) {
      connection.terminatedBeforeReady.complete(beforeReadyError);
    }

    _setState(MisskeyStreamingConnectionState.disconnected);
    if (error != null || !connection.ready) {
      _emitError(error ?? beforeReadyError);
    } else {
      _logWarn('Misskey Streaming API connection closed');
    }
    unawaited(_releaseConnection(connection, waitForSocket: false));

    if (_wantsConnection && (connection.ready || connection.automaticAttempt)) {
      _scheduleReconnect();
    }
  }

  void _handleAttemptFailure(
    int generation,
    MisskeyStreamingException exception, {
    required bool automaticAttempt,
  }) {
    if (!_isCurrentIntent(generation)) {
      return;
    }
    _pauseSubscriptionAcknowledgements();
    _setState(MisskeyStreamingConnectionState.disconnected);
    _emitError(exception);
    if (automaticAttempt) {
      _scheduleReconnect();
    }
  }

  void _scheduleReconnect() {
    if (_isDisposed ||
        !_wantsConnection ||
        !config.enableAutoReconnect ||
        _reconnectTimer != null) {
      return;
    }

    final attempt = _reconnectAttempts + 1;
    final maximum = config.maxReconnectAttempts;
    if (maximum != null && attempt > maximum) {
      _emitError(
        MisskeyStreamingConnectionException(
          message: 'Streaming reconnect limit reached',
          operation: 'reconnect',
          context: {'attempt': attempt, 'maximum': maximum},
        ),
      );
      return;
    }

    _reconnectAttempts = attempt;
    final delay = _computeReconnectDelay(attempt);
    final scheduledGeneration = _generation;
    _logInfo(
      'Reconnecting to Misskey Streaming API in '
      '${delay.inMilliseconds}ms (attempt $attempt)',
    );
    _reconnectTimer = Timer(delay, () {
      _reconnectTimer = null;
      if (_isDisposed ||
          !_wantsConnection ||
          _generation != scheduledGeneration) {
        return;
      }
      final future = _beginConnection(
        reconnecting: true,
        automaticAttempt: true,
      );
      unawaited(future.catchError((Object _) {}));
    });
  }

  Duration _computeReconnectDelay(int attempt) {
    final initial = config.reconnectInitialDelay.inMicroseconds;
    final maximum = config.reconnectMaxDelay.inMicroseconds;
    var delay = initial;
    for (var current = 1; current < attempt && delay < maximum; current++) {
      delay = delay > maximum ~/ 2 ? maximum : delay * 2;
    }

    final sample = _jitterSource().clamp(0.0, 1.0);
    final factor = 0.8 + (sample * 0.4);
    final jittered = (delay * factor).round().clamp(1, maximum);
    return Duration(microseconds: jittered);
  }

  Future<void> _releaseConnection(
    _ActiveConnection connection, {
    required bool waitForSocket,
  }) async {
    try {
      await connection.subscription?.cancel();
    } catch (_) {
      _logWarn('Could not cancel the Streaming socket listener');
    }

    try {
      final closeFuture = connection.socket.close(1000, 'Client disconnect');
      if (waitForSocket) {
        await closeFuture;
      } else {
        unawaited(
          closeFuture.catchError((Object _) {
            _logWarn('Could not close the Streaming socket');
          }),
        );
      }
    } catch (_) {
      _logWarn('Could not close the Streaming socket');
    }
  }

  void _closeWithoutWaiting(StreamingSocket socket) {
    try {
      unawaited(
        socket.close(1000, 'Superseded connection').catchError((Object _) {}),
      );
    } catch (_) {
      // 接続が既に終了している場合は追加の処理は不要
    }
  }

  void _completePendingReadyAsCancelled(_ActiveConnection connection) {
    if (!connection.ready && !connection.terminatedBeforeReady.isCompleted) {
      connection.terminatedBeforeReady.complete(
        const MisskeyStreamingConnectionException(
          message: 'Streaming connection attempt was cancelled',
          operation: 'connect',
        ),
      );
    }
  }

  MisskeyStreamingException _toStreamingException(
    Object error,
    StackTrace stackTrace,
  ) {
    if (error is MisskeyStreamingException) {
      return error;
    }
    return MisskeyStreamingConnectionException(
      cause: error,
      stackTrace: stackTrace,
      operation: 'connect',
    );
  }

  Uri _safeStreamingUri() {
    final uri = buildStreamingUri(_baseUrl);
    return uri.replace(userInfo: '');
  }

  void _emitError(MisskeyStreamingException exception) {
    if (!_errorController.isClosed) {
      _errorController.add(exception);
    }
    _logError(
      'Misskey Streaming API operation failed: '
      '${exception.operation ?? 'unknown'}',
    );
  }

  void _logInfo(String message) {
    if (_enableLog) {
      _logger.info(message);
    }
  }

  void _logWarn(String message) {
    if (_enableLog) {
      _logger.warn(message);
    }
  }

  void _logError(String message) {
    if (_enableLog) {
      _logger.error(message);
    }
  }

  bool _isCurrentIntent(int generation) =>
      !_isDisposed && _wantsConnection && _generation == generation;

  bool _isCurrentConnection(_ActiveConnection connection) =>
      _isCurrentIntent(connection.generation) &&
      identical(_connection, connection);

  void _cancelReconnectTimer() {
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
  }

  void _setState(MisskeyStreamingConnectionState value) {
    if (_state == value) {
      return;
    }
    _state = value;
    if (!_stateController.isClosed) {
      _stateController.add(value);
    }
  }

  void _ensureNotDisposed() {
    if (_isDisposed) {
      throw StateError('MisskeyStreaming has been disposed');
    }
  }
}

final class _SubscriptionEntry {
  _SubscriptionEntry({
    required this.id,
    required this.channel,
    required this.params,
  });

  final String id;
  final String channel;
  final Map<String, Object?> params;
  final StreamController<MisskeyStreamingMessage> messageController =
      StreamController<MisskeyStreamingMessage>.broadcast();
  final Completer<MisskeyStreamingSubscription> ready =
      Completer<MisskeyStreamingSubscription>();
  late final MisskeyStreamingSubscription subscription;
  Timer? acknowledgementTimer;
  int? sentGeneration;
}

final class _ActiveConnection {
  _ActiveConnection({
    required this.generation,
    required this.socket,
    required this.automaticAttempt,
  });

  final int generation;
  final StreamingSocket socket;
  final bool automaticAttempt;
  final Completer<MisskeyStreamingException> terminatedBeforeReady =
      Completer<MisskeyStreamingException>();
  StreamSubscription<Object?>? subscription;
  bool terminationHandled = false;
  bool ready = false;
}
