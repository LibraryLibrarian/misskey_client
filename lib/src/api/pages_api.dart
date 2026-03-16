import '../client/auth_mode.dart';
import '../client/misskey_http.dart';
import '../client/request_options.dart';
import '../models/users/misskey_page.dart';

/// ページ関連API（`/api/pages/*`）
///
/// ページの作成・更新・削除・閲覧・いいね操作を提供する。
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

  /// ページを作成する（`/api/pages/create`）
  ///
  /// 認証必須。レート制限: 10回/時。
  ///
  /// - [title]: タイトル（必須）
  /// - [name]: ページのURLパス名（1文字以上、必須）
  /// - [content]: コンテンツブロック配列（必須）
  /// - [variables]: 変数定義配列（必須）
  /// - [script]: スクリプト（必須）
  /// - [summary]: 概要文
  /// - [eyeCatchingImageId]: アイキャッチ画像のドライブファイルID
  /// - [font]: フォント設定（`serif` / `sans-serif`、デフォルト: `sans-serif`）
  /// - [alignCenter]: 中央揃えにするか（デフォルト: false）
  /// - [hideTitleWhenPinned]: ピン留め時にタイトルを隠すか（デフォルト: false）
  ///
  /// 主なエラー:
  /// - `NO_SUCH_FILE`: アイキャッチ画像が存在しない
  /// - `NAME_ALREADY_EXISTS`: 同名のページが既に存在する
  Future<MisskeyPage> create({
    required String title,
    required String name,
    required List<Map<String, dynamic>> content,
    required List<Map<String, dynamic>> variables,
    required String script,
    String? summary,
    String? eyeCatchingImageId,
    String? font,
    bool? alignCenter,
    bool? hideTitleWhenPinned,
  }) async {
    final body = <String, dynamic>{
      'title': title,
      'name': name,
      'content': content,
      'variables': variables,
      'script': script,
      if (summary != null) 'summary': summary,
      if (eyeCatchingImageId != null) 'eyeCatchingImageId': eyeCatchingImageId,
      if (font != null) 'font': font,
      if (alignCenter != null) 'alignCenter': alignCenter,
      if (hideTitleWhenPinned != null)
        'hideTitleWhenPinned': hideTitleWhenPinned,
    };
    final res = await http.send<Map<String, dynamic>>(
      '/pages/create',
      body: body,
    );
    return MisskeyPage.fromJson(res);
  }

  /// ページを更新する（`/api/pages/update`）
  ///
  /// 認証必須。レート制限: 300回/時。
  /// [pageId] のみ必須。他のパラメータは指定した項目のみ更新される。
  ///
  /// - [pageId]: 更新対象のページID（必須）
  /// - [title]: タイトル
  /// - [name]: ページのURLパス名（1文字以上）
  /// - [content]: コンテンツブロック配列
  /// - [variables]: 変数定義配列
  /// - [script]: スクリプト
  /// - [summary]: 概要文
  /// - [eyeCatchingImageId]: アイキャッチ画像のドライブファイルID
  /// - [font]: フォント設定（`serif` / `sans-serif`）
  /// - [alignCenter]: 中央揃えにするか
  /// - [hideTitleWhenPinned]: ピン留め時にタイトルを隠すか
  ///
  /// 主なエラー:
  /// - `NO_SUCH_PAGE`: ページが存在しない
  /// - `ACCESS_DENIED`: 権限がない
  /// - `NO_SUCH_FILE`: アイキャッチ画像が存在しない
  /// - `NAME_ALREADY_EXISTS`: 同名のページが既に存在する
  Future<void> update({
    required String pageId,
    String? title,
    String? name,
    List<Map<String, dynamic>>? content,
    List<Map<String, dynamic>>? variables,
    String? script,
    String? summary,
    String? eyeCatchingImageId,
    String? font,
    bool? alignCenter,
    bool? hideTitleWhenPinned,
  }) {
    final body = <String, dynamic>{
      'pageId': pageId,
      if (title != null) 'title': title,
      if (name != null) 'name': name,
      if (content != null) 'content': content,
      if (variables != null) 'variables': variables,
      if (script != null) 'script': script,
      if (summary != null) 'summary': summary,
      if (eyeCatchingImageId != null) 'eyeCatchingImageId': eyeCatchingImageId,
      if (font != null) 'font': font,
      if (alignCenter != null) 'alignCenter': alignCenter,
      if (hideTitleWhenPinned != null)
        'hideTitleWhenPinned': hideTitleWhenPinned,
    };
    return http.send<Object?>(
      '/pages/update',
      body: body,
    );
  }

  /// ページを削除する（`/api/pages/delete`）
  ///
  /// 認証必須。本人またはモデレーターのみ削除可能。
  ///
  /// - [pageId]: 削除対象のページID（必須）
  ///
  /// 主なエラー:
  /// - `NO_SUCH_PAGE`: ページが存在しない
  /// - `ACCESS_DENIED`: 権限がない
  Future<void> delete({required String pageId}) => http.send<Object?>(
        '/pages/delete',
        body: <String, dynamic>{'pageId': pageId},
      );

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
