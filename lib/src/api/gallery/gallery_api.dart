import '../../client/auth_mode.dart';
import '../../client/misskey_http.dart';
import '../../client/request_options.dart';
import '../../models/gallery/misskey_gallery_post.dart';

/// ギャラリー関連API（`/api/gallery/*`）
///
/// ギャラリー投稿の閲覧・作成・更新・削除・いいね操作を提供する。
/// 自分のギャラリー投稿一覧は `AccountApi.galleryPosts`、
/// 他ユーザーのギャラリーは `UsersApi.galleryPosts` を使用する。
class GalleryApi {
  const GalleryApi({required this.http});

  final MisskeyHttp http;

  /// フィーチャードギャラリー投稿一覧を取得する（`/api/gallery/featured`）
  ///
  /// ランキングキャッシュ（30分TTL）に基づく注目投稿を返す。認証不要。
  ///
  /// - [limit]: 取得件数 1〜100（デフォルト10）
  /// - [untilId]: IDによるページング
  Future<List<MisskeyGalleryPost>> featured({
    int? limit,
    String? untilId,
  }) async {
    final body = <String, dynamic>{
      if (limit != null) 'limit': limit,
      if (untilId != null) 'untilId': untilId,
    };
    final res = await http.send<List<dynamic>>(
      '/gallery/featured',
      body: body,
      options: const RequestOptions(
        authMode: AuthMode.optional,
        idempotent: true,
      ),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyGalleryPost.fromJson)
        .toList();
  }

  /// 人気ギャラリー投稿一覧を取得する（`/api/gallery/popular`）
  ///
  /// いいね数が1以上の投稿をいいね数降順で最大10件返す。認証不要。
  Future<List<MisskeyGalleryPost>> popular() async {
    final res = await http.send<List<dynamic>>(
      '/gallery/popular',
      body: const <String, dynamic>{},
      options: const RequestOptions(
        authMode: AuthMode.optional,
        idempotent: true,
      ),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyGalleryPost.fromJson)
        .toList();
  }

  /// ギャラリー投稿一覧（タイムライン）を取得する（`/api/gallery/posts`）
  ///
  /// 全ユーザーの投稿を新着順で返す。認証不要。
  ///
  /// - [limit]: 取得件数 1〜100（デフォルト10）
  /// - [sinceId] / [untilId]: IDによるページング
  /// - [sinceDate] / [untilDate]: Unixタイムスタンプ（ms）によるページング
  Future<List<MisskeyGalleryPost>> posts({
    int? limit,
    String? sinceId,
    String? untilId,
    int? sinceDate,
    int? untilDate,
  }) async {
    final body = <String, dynamic>{
      if (limit != null) 'limit': limit,
      if (sinceId != null) 'sinceId': sinceId,
      if (untilId != null) 'untilId': untilId,
      if (sinceDate != null) 'sinceDate': sinceDate,
      if (untilDate != null) 'untilDate': untilDate,
    };
    final res = await http.send<List<dynamic>>(
      '/gallery/posts',
      body: body,
      options: const RequestOptions(
        authMode: AuthMode.optional,
        idempotent: true,
      ),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyGalleryPost.fromJson)
        .toList();
  }

  /// ギャラリー投稿の詳細を取得する（`/api/gallery/posts/show`）
  ///
  /// 認証不要。
  ///
  /// 主なエラー:
  /// - `NO_SUCH_POST`: 投稿が存在しない
  Future<MisskeyGalleryPost> postsShow({required String postId}) async {
    final res = await http.send<Map<String, dynamic>>(
      '/gallery/posts/show',
      body: <String, dynamic>{'postId': postId},
      options: const RequestOptions(
        authMode: AuthMode.optional,
        idempotent: true,
      ),
    );
    return MisskeyGalleryPost.fromJson(res);
  }

  /// ギャラリー投稿を作成する（`/api/gallery/posts/create`）
  ///
  /// 認証必須。レート制限: 20回/時。
  ///
  /// - [title]: タイトル（必須）
  /// - [fileIds]: 添付ファイルIDリスト（必須、1〜32件、重複不可）
  /// - [description]: 説明文
  /// - [isSensitive]: センシティブコンテンツか（デフォルト: false）
  Future<MisskeyGalleryPost> postsCreate({
    required String title,
    required List<String> fileIds,
    String? description,
    bool? isSensitive,
  }) async {
    final body = <String, dynamic>{
      'title': title,
      'fileIds': fileIds,
      if (description != null) 'description': description,
      if (isSensitive != null) 'isSensitive': isSensitive,
    };
    final res = await http.send<Map<String, dynamic>>(
      '/gallery/posts/create',
      body: body,
    );
    return MisskeyGalleryPost.fromJson(res);
  }

  /// ギャラリー投稿を更新する（`/api/gallery/posts/update`）
  ///
  /// 認証必須。レート制限: 300回/時。
  ///
  /// - [postId]: 更新対象の投稿ID（必須）
  /// - [title]: タイトル
  /// - [fileIds]: 添付ファイルIDリスト（1〜32件、重複不可）
  /// - [description]: 説明文
  /// - [isSensitive]: センシティブコンテンツか
  Future<MisskeyGalleryPost> postsUpdate({
    required String postId,
    String? title,
    List<String>? fileIds,
    String? description,
    bool? isSensitive,
  }) async {
    final body = <String, dynamic>{
      'postId': postId,
      if (title != null) 'title': title,
      if (fileIds != null) 'fileIds': fileIds,
      if (description != null) 'description': description,
      if (isSensitive != null) 'isSensitive': isSensitive,
    };
    final res = await http.send<Map<String, dynamic>>(
      '/gallery/posts/update',
      body: body,
    );
    return MisskeyGalleryPost.fromJson(res);
  }

  /// ギャラリー投稿を削除する（`/api/gallery/posts/delete`）
  ///
  /// 認証必須。本人またはモデレーターのみ削除可能。
  ///
  /// 主なエラー:
  /// - `NO_SUCH_POST`: 投稿が存在しない
  /// - `ACCESS_DENIED`: 権限がない
  Future<void> postsDelete({required String postId}) => http.send<Object?>(
        '/gallery/posts/delete',
        body: <String, dynamic>{'postId': postId},
      );

  /// ギャラリー投稿にいいねする（`/api/gallery/posts/like`）
  ///
  /// 認証必須。
  ///
  /// 主なエラー:
  /// - `NO_SUCH_POST`: 投稿が存在しない
  /// - `YOUR_POST`: 自分の投稿にはいいねできない
  /// - `ALREADY_LIKED`: 既にいいね済み
  Future<void> postsLike({required String postId}) => http.send<Object?>(
        '/gallery/posts/like',
        body: <String, dynamic>{'postId': postId},
      );

  /// ギャラリー投稿のいいねを解除する（`/api/gallery/posts/unlike`）
  ///
  /// 認証必須。
  ///
  /// 主なエラー:
  /// - `NO_SUCH_POST`: 投稿が存在しない
  /// - `NOT_LIKED`: いいねしていない
  Future<void> postsUnlike({required String postId}) => http.send<Object?>(
        '/gallery/posts/unlike',
        body: <String, dynamic>{'postId': postId},
      );
}
