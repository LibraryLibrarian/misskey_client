import '../client/auth_mode.dart';
import '../client/misskey_http.dart';
import '../client/request_options.dart';
import '../models/misskey_hashtag.dart';
import '../models/misskey_hashtag_trend.dart';
import '../models/misskey_user.dart';

/// ハッシュタグ関連API（`/api/hashtags/*`）
///
/// ハッシュタグの検索・一覧取得・トレンド取得を提供する。
class HashtagsApi {
  const HashtagsApi({required this.http});

  final MisskeyHttp http;

  /// ハッシュタグ一覧を取得する（`/api/hashtags/list`）
  ///
  /// ソート順を指定してハッシュタグを一覧取得する。認証不要。
  ///
  /// - [sort]: ソート順（必須）。以下のいずれかを指定:
  ///   `+mentionedUsers` / `-mentionedUsers` /
  ///   `+mentionedLocalUsers` / `-mentionedLocalUsers` /
  ///   `+mentionedRemoteUsers` / `-mentionedRemoteUsers` /
  ///   `+attachedUsers` / `-attachedUsers` /
  ///   `+attachedLocalUsers` / `-attachedLocalUsers` /
  ///   `+attachedRemoteUsers` / `-attachedRemoteUsers`
  /// - [limit]: 取得件数 1〜100（デフォルト: 10）
  /// - [attachedToUserOnly]: プロフィールに設定されたタグのみ
  /// - [attachedToLocalUserOnly]: ローカルユーザーのプロフィールに設定されたタグのみ
  /// - [attachedToRemoteUserOnly]: リモートユーザーのプロフィールに設定されたタグのみ
  Future<List<MisskeyHashtag>> list({
    required String sort,
    int? limit,
    bool? attachedToUserOnly,
    bool? attachedToLocalUserOnly,
    bool? attachedToRemoteUserOnly,
  }) async {
    final body = <String, dynamic>{
      'sort': sort,
      if (limit != null) 'limit': limit,
      if (attachedToUserOnly != null)
        'attachedToUserOnly': attachedToUserOnly,
      if (attachedToLocalUserOnly != null)
        'attachedToLocalUserOnly': attachedToLocalUserOnly,
      if (attachedToRemoteUserOnly != null)
        'attachedToRemoteUserOnly': attachedToRemoteUserOnly,
    };
    final res = await http.send<List<dynamic>>(
      '/hashtags/list',
      body: body,
      options: const RequestOptions(
        authMode: AuthMode.none,
        idempotent: true,
      ),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyHashtag.fromJson)
        .toList();
  }

  /// ハッシュタグを検索する（`/api/hashtags/search`）
  ///
  /// 前方一致でハッシュタグ名を検索する。認証不要。
  /// レスポンスはハッシュタグ名の文字列リスト。
  ///
  /// - [query]: 検索文字列（必須）
  /// - [limit]: 取得件数 1〜100（デフォルト: 10）
  /// - [offset]: スキップ件数（デフォルト: 0）
  Future<List<String>> search({
    required String query,
    int? limit,
    int? offset,
  }) async {
    final body = <String, dynamic>{
      'query': query,
      if (limit != null) 'limit': limit,
      if (offset != null) 'offset': offset,
    };
    final res = await http.send<List<dynamic>>(
      '/hashtags/search',
      body: body,
      options: const RequestOptions(
        authMode: AuthMode.none,
        idempotent: true,
      ),
    );
    return res.cast<String>();
  }

  /// ハッシュタグの詳細情報を取得する（`/api/hashtags/show`）
  ///
  /// 認証不要。
  ///
  /// - [tag]: ハッシュタグ名（必須）
  ///
  /// 主なエラー:
  /// - `NO_SUCH_HASHTAG`: 指定したハッシュタグが存在しない
  Future<MisskeyHashtag> show({required String tag}) async {
    final res = await http.send<Map<String, dynamic>>(
      '/hashtags/show',
      body: <String, dynamic>{'tag': tag},
      options: const RequestOptions(
        authMode: AuthMode.none,
        idempotent: true,
      ),
    );
    return MisskeyHashtag.fromJson(res);
  }

  /// トレンドハッシュタグを取得する（`/api/hashtags/trend`）
  ///
  /// 直近の人気ハッシュタグを最大10件返す。認証不要。
  /// レスポンスは60秒間キャッシュされる。
  Future<List<MisskeyHashtagTrend>> trend() async {
    final res = await http.send<List<dynamic>>(
      '/hashtags/trend',
      body: const <String, dynamic>{},
      options: const RequestOptions(
        authMode: AuthMode.none,
        idempotent: true,
      ),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyHashtagTrend.fromJson)
        .toList();
  }

  /// ハッシュタグを使用しているユーザー一覧を取得する（`/api/hashtags/users`）
  ///
  /// 認証不要。
  ///
  /// - [tag]: ハッシュタグ名（必須）
  /// - [sort]: ソート順（必須）。以下のいずれかを指定:
  ///   `+follower` / `-follower` /
  ///   `+createdAt` / `-createdAt` /
  ///   `+updatedAt` / `-updatedAt`
  /// - [limit]: 取得件数 1〜100（デフォルト: 10）
  /// - [offset]: スキップ件数（デフォルト: 0）
  /// - [state]: アクティビティ状態でフィルタ（`all` / `alive`、デフォルト: `all`）
  /// - [origin]: ユーザーの所在でフィルタ（`combined` / `local` / `remote`、デフォルト: `local`）
  Future<List<MisskeyUser>> users({
    required String tag,
    required String sort,
    int? limit,
    int? offset,
    String? state,
    String? origin,
  }) async {
    final body = <String, dynamic>{
      'tag': tag,
      'sort': sort,
      if (limit != null) 'limit': limit,
      if (offset != null) 'offset': offset,
      if (state != null) 'state': state,
      if (origin != null) 'origin': origin,
    };
    final res = await http.send<List<dynamic>>(
      '/hashtags/users',
      body: body,
      options: const RequestOptions(
        authMode: AuthMode.none,
        idempotent: true,
      ),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyUser.fromJson)
        .toList();
  }
}
