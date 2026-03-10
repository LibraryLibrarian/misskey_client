import '../../client/misskey_http.dart';
import '../../exception/misskey_client_exception.dart';

/// 現在ログイン中ユーザー（自分）のAPI
class AccountApi {
  const AccountApi({required this.http});

  final MisskeyHttp http;

  /// 現在ログイン中ユーザーの詳細を取得（`/api/i`）
  ///
  /// 認証トークンに紐づくユーザー（自分）の詳細情報（MeDetailed）を返す。
  /// 例外は[MisskeyClientException]としてthrowされる。
  Future<Map<String, dynamic>> i() async {
    final res = await http.send<Map<dynamic, dynamic>>(
      '/i',
      body: const <String, dynamic>{},
    );
    return res.cast<String, dynamic>();
  }
}
