/// リクエスト単位のオプション（内部使用）
class RequestOptions {
  /// リクエスト単位のオプション
  ///
  /// - [authRequired]: 認証必須か（デフォルト: true）
  /// - [idempotent]: 冪等なリクエストか（デフォルト: false）
  /// - [contentType]: リクエストのContent-Type（未指定時はDioが推論）
  /// - [headers]: リクエスト固有の追加ヘッダ
  const RequestOptions({
    this.authRequired = true,
    this.idempotent = false,
    this.contentType,
    this.headers = const {},
  });

  /// 認証必須か
  ///
  /// trueの場合 POSTのJSON bodyに`i`を自動注入する
  final bool authRequired;

  /// 冪等リクエストか
  ///
  /// true の場合のみ自動リトライ対象
  final bool idempotent;

  /// このリクエストのContent-Typeを明示的に指定する
  ///
  /// 未指定時はDioが推論する
  final String? contentType;

  /// このリクエスト固有の追加ヘッダ
  final Map<String, String> headers;
}
