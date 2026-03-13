import 'dart:async';

import 'package:dio/dio.dart';
import 'package:retry/retry.dart';

import '../exception/misskey_client_exception.dart';
import '../internal/dio_error_handler.dart';
import '../logging/logger.dart';
import '../logging/package_logger.dart';
import 'constants.dart';
import 'misskey_client_config.dart';
import 'request_options.dart' as ro;
import 'token_provider.dart';

/// MisskeyAPI用の内部HTTPクライアント
class MisskeyHttp {
  MisskeyHttp({
    required this.config,
    this.tokenProvider,
    Logger? logger,
    HttpClientAdapter? httpClientAdapter,
  }) : logger = logger ?? const StdoutLogger() {
    final baseOptions = BaseOptions(
      baseUrl: _ensureApiBase(config.baseUrl).toString(),
      connectTimeout: config.timeout,
      sendTimeout: config.timeout,
      receiveTimeout: config.timeout,
      headers: {
        ...config.defaultHeaders,
        if (config.userAgent != null) 'User-Agent': config.userAgent,
        'Accept': 'application/json',
      },
    );
    _dio = Dio(baseOptions);
    if (httpClientAdapter != null) {
      _dio.httpClientAdapter = httpClientAdapter;
    }

    _dio.interceptors.add(
      _MisskeyInterceptor(
        tokenProvider: tokenProvider,
        enableLog: config.enableLog,
        logger: this.logger,
      ),
    );
  }

  final MisskeyClientConfig config;
  final TokenProvider? tokenProvider;
  final Logger logger;

  /// 公開ベースURL（`/api` 付与前の元URL）
  Uri get baseUrl => config.baseUrl;

  late final Dio _dio;

  /// `path`は`/notes/create`のように`/api`より後のパスを渡す
  ///
  /// [body]には`Map<String,dynamic>`（JSON）・`FormData`（multipart）・`null`を指定可能
  ///
  /// アップロード時は[onSendProgress]で進捗を受け取れる
  Future<T> send<T>(
    String path, {
    String method = 'POST',
    dynamic body,
    ro.RequestOptions options = const ro.RequestOptions(),
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
  }) async {
    final r = RetryOptions(
      maxAttempts: options.idempotent ? config.maxRetries : 1,
      delayFactor: const Duration(milliseconds: 500),
      maxDelay: const Duration(seconds: 5),
    );

    try {
      final result = await r.retry(
        () async {
          final reqOptions = Options(
            method: method,
            contentType: options.contentType,
            headers: options.headers.isEmpty
                ? null
                : Map<String, dynamic>.from(options.headers),
            extra: {
              'authRequired': options.authRequired,
            },
          );
          final res = await _dio.request<dynamic>(
            path.startsWith('/') ? path : '/$path',
            data: body,
            options: reqOptions,
            cancelToken: cancelToken,
            onSendProgress: onSendProgress,
          );
          return res;
        },
        retryIf: (e) => _shouldRetry(e, options.idempotent),
        onRetry: (e) {
          if (config.enableLog && kDebugMode) {
            clientLog.w('[HTTP RETRY] due to: $e');
          }
        },
      );
      return result.data as T;
    } on DioException catch (e) {
      throw convertDioException(e, path);
    } on Exception catch (e) {
      throw MisskeyNetworkException(
        message: 'Unexpected error',
        endpoint: path,
        cause: e,
      );
    }
  }

  static Uri _ensureApiBase(Uri base) {
    final normalized = base.replace(
      path: base.path.replaceAll(RegExp(r'/+$'), ''),
    );
    final path = normalized.path.endsWith('/api')
        ? normalized.path
        : '${normalized.path.isEmpty ? '' : normalized.path}/api';
    return normalized.replace(path: path);
  }

  static bool _shouldRetry(Object e, bool idempotent) {
    if (!idempotent) return false;
    if (e is DioException) {
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.unknown ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        return true;
      }
      final status = e.response?.statusCode;
      if (status == null) return false;
      return status == 429 || (status >= 500 && status < 600);
    }
    return false;
  }

}

class _MisskeyInterceptor extends Interceptor {
  _MisskeyInterceptor({
    required this.tokenProvider,
    required this.enableLog,
    required this.logger,
  });

  final TokenProvider? tokenProvider;
  final bool enableLog;
  final Logger logger;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final extra = options.extra;
    final authRequired = (extra['authRequired'] as bool?) ?? true;
    if (authRequired && options.method.toUpperCase() == 'POST') {
      final token = await tokenProvider?.call();
      if (token != null && token.isNotEmpty) {
        final data = options.data;
        if (data is Map<String, dynamic>) {
          if (!data.containsKey('i')) {
            options.data = <String, dynamic>{...data, 'i': token};
          }
        } else if (data is FormData) {
          final hasI = data.fields.any((e) => e.key == 'i');
          if (!hasI) {
            data.fields.add(MapEntry('i', token));
          }
        } else if (data == null) {
          options.data = <String, dynamic>{'i': token};
        }
      }
    }

    if (enableLog && kDebugMode) {
      clientLog.d(
        '[HTTP REQ] ${options.method} ${options.uri} data=${options.data}',
      );
    }

    super.onRequest(options, handler);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    if (enableLog && kDebugMode) {
      clientLog.d(
        '[HTTP RES] ${response.statusCode} ${response.requestOptions.uri}',
      );
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (enableLog && kDebugMode) {
      final statusCode = err.response?.statusCode;
      final isExpectedClientError = statusCode != null &&
          (statusCode == 401 || statusCode == 403 || statusCode == 404);

      if (isExpectedClientError) {
        clientLog.d('[HTTP ERR] ${err.requestOptions.uri} status=$statusCode');
      } else {
        clientLog.e(
          '[HTTP ERR] ${err.requestOptions.uri}',
          error: err,
          stackTrace: err.stackTrace,
        );
      }
    }
    super.onError(err, handler);
  }
}
