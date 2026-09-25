import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';

/// A response returned by [ScriptedHttpClientAdapter].
class ScriptedResponse {
  const ScriptedResponse(
    this.body, {
    this.status = 200,
    this.headers = const {},
  });

  /// Creates a JSON response.
  factory ScriptedResponse.json(
    Object? body, {
    int status = 200,
    Map<String, String> headers = const {},
  }) => ScriptedResponse(body, status: status, headers: headers);

  /// Creates a Misskey-shaped error response.
  factory ScriptedResponse.error(
    int status, {
    required String code,
    String message = '',
    String id = '',
    String? retryAfter,
  }) {
    return ScriptedResponse.json(
      {
        'error': {'code': code, 'message': message, 'id': id},
      },
      status: status,
      headers: {'retry-after': ?retryAfter},
    );
  }

  /// Creates an empty response for endpoints returning no content.
  factory ScriptedResponse.noContent() =>
      const ScriptedResponse(null, status: 204);

  /// Creates a response which waits for [gate] before returning [then].
  factory ScriptedResponse.gated(Future<void> gate, ScriptedResponse then) =>
      _GatedScriptedResponse(gate, then);

  final Object? body;
  final int status;
  final Map<String, String> headers;
}

final class _GatedScriptedResponse extends ScriptedResponse {
  const _GatedScriptedResponse(this.gate, this.then) : super(null);

  final Future<void> gate;
  final ScriptedResponse then;
}

/// A request observed by [ScriptedHttpClientAdapter].
class RecordedRequest {
  const RecordedRequest({
    required this.path,
    this.jsonBody,
    this.formFields = const {},
    this.formFileNames = const [],
    this.formFileBytes,
  });

  /// API path without the `/api` prefix.
  final String path;
  final Map<String, dynamic>? jsonBody;
  final Map<String, String> formFields;
  final List<String> formFileNames;
  final List<int>? formFileBytes;
}

/// A deterministic Dio transport for API tests.
class ScriptedHttpClientAdapter implements HttpClientAdapter {
  final Map<String, FutureOr<ScriptedResponse> Function(RecordedRequest)>
  _handlers = {};
  final Map<String, ListQueue<ScriptedResponse>> _queued = {};

  /// All requests in arrival order.
  final List<RecordedRequest> requests = [];

  /// Number of requests currently awaiting a response.
  int inFlight = 0;

  /// Highest observed [inFlight] count.
  int maxInFlight = 0;

  /// Paths requested so far.
  List<String> get paths => requests.map((request) => request.path).toList();

  /// Registers the fallback handler for [path].
  void on(
    String path,
    FutureOr<ScriptedResponse> Function(RecordedRequest request) handler,
  ) {
    _handlers[path] = handler;
  }

  /// Queues [response] ahead of the registered handler for [path].
  void enqueue(String path, ScriptedResponse response) {
    (_queued[path] ??= ListQueue()).add(response);
  }

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    inFlight++;
    if (inFlight > maxInFlight) maxInFlight = inFlight;
    try {
      final request = await _record(options, requestStream);
      requests.add(request);
      final queue = _queued[request.path];
      ScriptedResponse response;
      if (queue != null && queue.isNotEmpty) {
        response = queue.removeFirst();
      } else {
        final handler = _handlers[request.path];
        if (handler == null) {
          throw StateError(
            'No scripted response or handler registered for ${request.path}.',
          );
        }
        response = await handler(request);
      }
      if (response case _GatedScriptedResponse(:final gate, :final then)) {
        await gate;
        response = then;
      }
      return _responseBody(response);
    } finally {
      inFlight--;
    }
  }

  @override
  void close({bool force = false}) {}

  Future<RecordedRequest> _record(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
  ) async {
    final path = _stripApiPrefix(options.uri.path);
    final data = options.data;
    final bytes = await _drain(requestStream);
    if (data is Map) {
      return RecordedRequest(
        path: path,
        jsonBody: Map<String, dynamic>.from(data),
      );
    }
    if (data is! FormData) return RecordedRequest(path: path);

    final multipart = _parseMultipart(bytes, options.contentType);
    return RecordedRequest(
      path: path,
      formFields: multipart.fields,
      formFileNames: multipart.fileNames,
      formFileBytes: multipart.firstFileBytes,
    );
  }

  static String _stripApiPrefix(String path) =>
      path.startsWith('/api/') ? path.substring(4) : path;

  static Future<List<int>> _drain(Stream<Uint8List>? stream) async {
    if (stream == null) return const [];
    final bytes = <int>[];
    await for (final chunk in stream) {
      bytes.addAll(chunk);
    }
    return bytes;
  }

  static ResponseBody _responseBody(ScriptedResponse response) {
    final headers = <String, List<String>>{
      if (response.status != 204)
        Headers.contentTypeHeader: ['application/json'],
      for (final entry in response.headers.entries) entry.key: [entry.value],
    };
    final body = response.body == null ? '' : jsonEncode(response.body);
    return ResponseBody.fromString(body, response.status, headers: headers);
  }
}

class _MultipartParts {
  const _MultipartParts(this.fields, this.fileNames, this.firstFileBytes);

  final Map<String, String> fields;
  final List<String> fileNames;
  final List<int>? firstFileBytes;
}

_MultipartParts _parseMultipart(List<int> bytes, String? contentType) {
  final boundaryMatch = RegExp(
    r'boundary=(?:"([^"]+)"|([^;\s]+))',
  ).firstMatch(contentType ?? '');
  if (boundaryMatch == null) {
    throw StateError('Multipart request did not include a boundary.');
  }
  final boundary = boundaryMatch.group(1) ?? boundaryMatch.group(2)!;
  final marker = latin1.encode('--$boundary');
  final text = latin1.decode(bytes);
  final markerText = latin1.decode(marker);
  final fields = <String, String>{};
  final fileNames = <String>[];
  List<int>? firstFileBytes;

  for (final section in text.split(markerText).skip(1)) {
    if (section.startsWith('--')) break;
    final trimmed = section.startsWith('\r\n') ? section.substring(2) : section;
    final headerEnd = trimmed.indexOf('\r\n\r\n');
    if (headerEnd < 0) continue;
    final headers = trimmed.substring(0, headerEnd);
    var value = trimmed.substring(headerEnd + 4);
    if (value.endsWith('\r\n')) value = value.substring(0, value.length - 2);
    final disposition = RegExp(
      r'content-disposition:\s*form-data;[^\r\n]*',
      caseSensitive: false,
    ).firstMatch(headers)?.group(0);
    if (disposition == null) continue;
    final name = RegExp(r'name="([^"]+)"').firstMatch(disposition)?.group(1);
    if (name == null) continue;
    final filename = RegExp(
      r'filename="([^"]*)"',
    ).firstMatch(disposition)?.group(1);
    if (filename == null) {
      fields[name] = _decodeUtf8(value);
    } else {
      fileNames.add(_decodeUtf8(filename));
      firstFileBytes ??= latin1.encode(value);
    }
  }
  return _MultipartParts(fields, fileNames, firstFileBytes);
}

String _decodeUtf8(String value) => utf8.decode(latin1.encode(value));
