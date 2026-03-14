import 'auth_mode.dart';

/// リクエスト単位のオプション（内部使用）
class RequestOptions {
  /// リクエスト単位のオプション
  ///
  /// - [authMode]: 認証モード（デフォルト: [AuthMode.required]）
  /// - [idempotent]: 冪等なリクエストか（デフォルト: false）
  /// - [contentType]: リクエストのContent-Type（未指定時はDioが推論）
  /// - [headers]: リクエスト固有の追加ヘッダ
  const RequestOptions({
    this.authMode = AuthMode.required,
    this.idempotent = false,
    this.contentType,
    this.headers = const {},
  });

  /// 認証モード
  ///
  /// - [AuthMode.required]: トークンを必ず注入する
  /// - [AuthMode.optional]: トークンがあれば注入する
  /// - [AuthMode.none]: トークンを注入しない
  final AuthMode authMode;

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
