/// MisskeyAPI呼び出し時の例外
class MisskeyClientException implements Exception {
  const MisskeyClientException({
    this.statusCode,
    this.code,
    this.errorId,
    required this.message,
    this.endpoint,
    this.retryAfter,
    this.raw,
  });

  /// HTTPステータスコード
  final int? statusCode;

  /// Misskey固有のエラーコード（例: `AUTHENTICATION_FAILED`）
  final String? code;

  /// Misskeyエラー種別のUUID（例: `b0a7f5f8-dc2f-4171-b91f-de207571ffe0`）
  final String? errorId;

  /// エラーメッセージ（人間可読）
  final String message;

  /// エラーが発生したAPIエンドポイント（例: `/notes/create`）
  final String? endpoint;

  /// 429 Too Many Requests 時に応じるまでの推奨待機時間
  final Duration? retryAfter;

  /// 元例外やエラーオブジェクト
  final Object? raw;

  @override
  String toString() {
    return 'MisskeyClientException('
        'statusCode: $statusCode, '
        'code: $code, '
        'errorId: $errorId, '
        'message: $message, '
        'endpoint: $endpoint, '
        'retryAfter: $retryAfter'
        ')';
  }
}
