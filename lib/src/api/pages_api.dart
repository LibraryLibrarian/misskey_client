import '../client/auth_mode.dart';
import '../client/misskey_http.dart';
import '../client/request_options.dart';
import '../models/users/misskey_page.dart';

/// ページ関連API（`/api/pages/*`）
///
/// ページの閲覧・いいね操作を提供する。
/// 自分のページ一覧は `AccountApi.pages`、
/// 他ユーザーのページは `UsersApi.pages` を使用する。
class PagesApi {
  const PagesApi({required this.http});

  final MisskeyHttp http;

  /// ページIDを指定してページ詳細を取得する（`/api/pages/show`）
  ///
  /// 認証不要。
  ///
  /// 主なエラー:
  /// - `NO_SUCH_PAGE`: ページが存在しない
  Future<MisskeyPage> showById({required String pageId}) async {
    final res = await http.send<Map<String, dynamic>>(
      '/pages/show',
      body: <String, dynamic>{'pageId': pageId},
      options: const RequestOptions(
        authMode: AuthMode.optional,
        idempotent: true,
      ),
    );
    return MisskeyPage.fromJson(res);
  }

  /// ユーザー名とページ名を指定してページ詳細を取得する（`/api/pages/show`）
  ///
  /// 認証不要。
  ///
  /// - [name]: ページのURLパス名（必須）
  /// - [username]: ページ作成者のユーザー名（必須）
  ///
  /// 主なエラー:
  /// - `NO_SUCH_PAGE`: ページが存在しない
  Future<MisskeyPage> showByName({
    required String name,
    required String username,
  }) async {
    final res = await http.send<Map<String, dynamic>>(
      '/pages/show',
      body: <String, dynamic>{'name': name, 'username': username},
      options: const RequestOptions(
        authMode: AuthMode.optional,
        idempotent: true,
      ),
    );
    return MisskeyPage.fromJson(res);
  }

  /// 人気ページ一覧を取得する（`/api/pages/featured`）
  ///
  /// いいね数が1以上のページをいいね数降順で最大10件返す。認証不要。
  Future<List<MisskeyPage>> featured() async {
    final res = await http.send<List<dynamic>>(
      '/pages/featured',
      body: const <String, dynamic>{},
      options: const RequestOptions(
        authMode: AuthMode.optional,
        idempotent: true,
      ),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyPage.fromJson)
        .toList();
  }

  /// ページにいいねする（`/api/pages/like`）
  ///
  /// 認証必須。
  ///
  /// 主なエラー:
  /// - `NO_SUCH_PAGE`: ページが存在しない
  /// - `YOUR_PAGE`: 自分のページにはいいねできない
  /// - `ALREADY_LIKED`: 既にいいね済み
  Future<void> like({required String pageId}) => http.send<Object?>(
        '/pages/like',
        body: <String, dynamic>{'pageId': pageId},
      );

  /// ページのいいねを解除する（`/api/pages/unlike`）
  ///
  /// 認証必須。
  ///
  /// 主なエラー:
  /// - `NO_SUCH_PAGE`: ページが存在しない
  /// - `NOT_LIKED`: いいねしていない
  Future<void> unlike({required String pageId}) => http.send<Object?>(
        '/pages/unlike',
        body: <String, dynamic>{'pageId': pageId},
      );
}
