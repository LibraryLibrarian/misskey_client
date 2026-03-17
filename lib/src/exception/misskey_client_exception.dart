/// Misskey API クライアントが送出する例外の基底クラス
sealed class MisskeyClientException implements Exception {
  const MisskeyClientException(this.message);

  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

/// HTTP レスポンスエラーを表す例外
///
/// [statusCode] に HTTP ステータスコード、[message] にサーバーから返されたメッセージを持つ。
class MisskeyApiException extends MisskeyClientException {
  const MisskeyApiException({
    required this.statusCode,
    required String message,
    this.code,
    this.errorId,
    this.endpoint,
    this.raw,
  }) : super(message);

  final int statusCode;

  /// Misskey固有のエラーコード（例: `AUTHENTICATION_FAILED`）
  final String? code;

  /// Misskeyエラー種別のUUID
  final String? errorId;

  /// エラーが発生したAPIエンドポイント
  final String? endpoint;

  /// 元例外やエラーオブジェクト
  final Object? raw;

  @override
  String toString() => '$runtimeType($statusCode): $message'
      '${code != null ? ' code=$code' : ''}'
      '${endpoint != null ? ' endpoint=$endpoint' : ''}';
}

/// 認証エラー（HTTP 401）
///
/// アクセストークンが無効または期限切れ
class MisskeyUnauthorizedException extends MisskeyApiException {
  const MisskeyUnauthorizedException({
    super.message = 'Unauthorized',
    super.code,
    super.errorId,
    super.endpoint,
    super.raw,
  }) : super(statusCode: 401);
}

/// 権限エラー（HTTP 403）
///
/// 操作が許可されていない
class MisskeyForbiddenException extends MisskeyApiException {
  const MisskeyForbiddenException({
    super.message = 'Forbidden',
    super.code,
    super.errorId,
    super.endpoint,
    super.raw,
  }) : super(statusCode: 403);
}

/// リソースが見つからない（HTTP 404）
class MisskeyNotFoundException extends MisskeyApiException {
  const MisskeyNotFoundException({
    super.message = 'Not found',
    super.code,
    super.errorId,
    super.endpoint,
    super.raw,
  }) : super(statusCode: 404);
}

/// レートリミットエラー（HTTP 429）
///
/// リクエスト頻度が制限を超えた
class MisskeyRateLimitException extends MisskeyApiException {
  const MisskeyRateLimitException({
    super.message = 'Rate limited',
    super.code,
    super.errorId,
    super.endpoint,
    super.raw,
    this.retryAfter,
  }) : super(statusCode: 429);

  /// サーバーが示した推奨待機時間
  final Duration? retryAfter;
}

/// バリデーションエラー（HTTP 422）
///
/// リクエストの内容が不正
class MisskeyValidationException extends MisskeyApiException {
  const MisskeyValidationException({
    super.message = 'Unprocessable entity',
    super.code,
    super.errorId,
    super.endpoint,
    super.raw,
  }) : super(statusCode: 422);
}

/// サーバーエラー（HTTP 5xx）
class MisskeyServerException extends MisskeyApiException {
  const MisskeyServerException({
    required super.statusCode,
    super.message = 'Server error',
    super.code,
    super.errorId,
    super.endpoint,
    super.raw,
  });
}

/// ネットワーク接続エラー（タイムアウト・接続不可など）
class MisskeyNetworkException extends MisskeyClientException {
  const MisskeyNetworkException({
    String message = 'Network error',
    this.endpoint,
    this.cause,
  }) : super(message);

  /// エラーが発生したAPIエンドポイント
  final String? endpoint;

  /// 元となった例外
  final Object? cause;
}
