import '../client/misskey_http.dart';
import '../models/ap_show_result.dart';

/// ActivityPub関連API（`/api/ap/*`）
///
/// リモートサーバーのActivityPubオブジェクトを解決する。
class ApApi {
  const ApApi({required this.http});

  final MisskeyHttp http;

  /// ActivityPub URIからユーザーまたはノートを解決する（`/api/ap/show`）
  ///
  /// URIに対応するオブジェクトがユーザーの場合は [ApShowUser]、
  /// ノートの場合は [ApShowNote] を返す。
  /// 認証必須。レート制限: 30回/時。
  ///
  /// - [uri]: 解決するActivityPub URI（必須）
  ///
  /// 主なエラー:
  /// - `FEDERATION_NOT_ALLOWED`: 対象ホストとのフェデレーションが許可されていない
  /// - `URI_INVALID`: URIが無効
  /// - `REQUEST_FAILED`: リモートサーバーへのリクエスト失敗
  /// - `RESPONSE_INVALID`: リモートサーバーからのレスポンスが無効
  /// - `NO_SUCH_OBJECT`: オブジェクトが見つからない
  Future<ApShowResult> show({required String uri}) async {
    final res = await http.send<Map<String, dynamic>>(
      '/ap/show',
      body: <String, dynamic>{'uri': uri},
    );
    return ApShowResult.fromJson(res);
  }
}
