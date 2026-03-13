import 'package:dio/dio.dart';

import '../exception/misskey_client_exception.dart';

/// [DioException]を[MisskeyClientException]に変換する
///
/// MisskeyHttp内で共通して使用する内部ユーティリティ
MisskeyClientException convertDioException(DioException e, [String? endpoint]) {
  final status = e.response?.statusCode;
  var message = e.message ?? 'HTTP error';
  String? code;
  String? errorId;
  final data = e.response?.data;

  if (data is Map) {
    final dynamic errorObj = data['error'];
    if (errorObj is Map) {
      final dynamic c = errorObj['code'];
      final dynamic m = errorObj['message'];
      final dynamic id = errorObj['id'];
      if (c != null) code = c.toString();
      if (m != null) message = m.toString();
      if (id != null) errorId = id.toString();
    } else {
      final dynamic c = data['code'];
      final dynamic m = data['message'];
      if (c != null) code = c.toString();
      if (m != null) message = m.toString();
    }
  }

  final retryAfter = _parseRetryAfter(e.response);

  if (status != null) {
    return switch (status) {
      401 => MisskeyUnauthorizedException(
        message: message,
        code: code,
        errorId: errorId,
        endpoint: endpoint,
        raw: e,
      ),
      403 => MisskeyForbiddenException(
        message: message,
        code: code,
        errorId: errorId,
        endpoint: endpoint,
        raw: e,
      ),
      404 => MisskeyNotFoundException(
        message: message,
        code: code,
        errorId: errorId,
        endpoint: endpoint,
        raw: e,
      ),
      422 => MisskeyValidationException(
        message: message,
        code: code,
        errorId: errorId,
        endpoint: endpoint,
        raw: e,
      ),
      429 => MisskeyRateLimitException(
        message: message,
        code: code,
        errorId: errorId,
        endpoint: endpoint,
        raw: e,
        retryAfter: retryAfter,
      ),
      >= 500 => MisskeyServerException(
        statusCode: status,
        message: message,
        code: code,
        errorId: errorId,
        endpoint: endpoint,
        raw: e,
      ),
      _ => MisskeyApiException(
        statusCode: status,
        message: message,
        code: code,
        errorId: errorId,
        endpoint: endpoint,
        raw: e,
      ),
    };
  }

  // ネットワークエラー（タイムアウト・接続不可など）
  return MisskeyNetworkException(
    message: message,
    endpoint: endpoint,
    cause: e,
  );
}

Duration? _parseRetryAfter(Response<dynamic>? response) {
  final ra = response?.headers.value('retry-after');
  if (ra != null) {
    final seconds = int.tryParse(ra.trim());
    if (seconds != null) {
      return Duration(seconds: seconds);
    }
  }
  return null;
}
