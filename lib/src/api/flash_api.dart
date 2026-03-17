import '../client/auth_mode.dart';
import '../client/misskey_http.dart';
import '../client/request_options.dart';
import '../models/users/misskey_flash.dart';
import '../models/users/misskey_flash_like.dart';

/// Flash（Play）関連API（`/api/flash/*`）
///
/// Flashの作成・更新・削除・閲覧・いいね操作を提供する。
/// 自分のFlash一覧は [my]、他ユーザーのFlashは `UsersApi.flashs` を使用する。
class FlashApi {
  const FlashApi({required this.http});

  final MisskeyHttp http;

  /// Flashを作成する（`/api/flash/create`）
  ///
  /// 認証必須。レート制限: 10回/時。
  ///
  /// - [title]: タイトル（必須）
  /// - [summary]: 概要（必須）
  /// - [script]: AiScriptコード（必須）
  /// - [permissions]: 要求するパーミッション（必須）
  /// - [visibility]: 公開範囲（`public`/`private`、デフォルト: `public`）
  ///
  /// 主なエラー:
  /// - `TOO_MANY_FLASHES`: Flash上限に達している
  Future<MisskeyFlash> create({
    required String title,
    required String summary,
    required String script,
    required List<String> permissions,
    String? visibility,
  }) async {
    final res = await http.send<Map<String, dynamic>>(
      '/flash/create',
      body: <String, dynamic>{
        'title': title,
        'summary': summary,
        'script': script,
        'permissions': permissions,
        if (visibility != null) 'visibility': visibility,
      },
    );
    return MisskeyFlash.fromJson(res);
  }

  /// Flashを更新する（`/api/flash/update`）
  ///
  /// 認証必須。レート制限: 300回/時。
  /// [flashId] のみ必須。他のパラメータは指定した項目のみ更新される。
  ///
  /// 主なエラー:
  /// - `NO_SUCH_FLASH`: Flashが存在しない
  /// - `ACCESS_DENIED`: 権限がない
  Future<void> update({
    required String flashId,
    String? title,
    String? summary,
    String? script,
    List<String>? permissions,
    String? visibility,
  }) {
    final body = <String, dynamic>{
      'flashId': flashId,
      if (title != null) 'title': title,
      if (summary != null) 'summary': summary,
      if (script != null) 'script': script,
      if (permissions != null) 'permissions': permissions,
      if (visibility != null) 'visibility': visibility,
    };
    return http.send<Object?>(
      '/flash/update',
      body: body,
    );
  }

  /// Flashを削除する（`/api/flash/delete`）
  ///
  /// 認証必須。本人またはモデレーターのみ削除可能。
  ///
  /// - [flashId]: 削除対象のFlash ID（必須）
  ///
  /// 主なエラー:
  /// - `NO_SUCH_FLASH`: Flashが存在しない
  /// - `ACCESS_DENIED`: 権限がない
  Future<void> delete({required String flashId}) => http.send<Object?>(
        '/flash/delete',
        body: <String, dynamic>{'flashId': flashId},
      );

  /// Flashの詳細を取得する（`/api/flash/show`）
  ///
  /// 認証不要。
  ///
  /// - [flashId]: 対象のFlash ID（必須）
  ///
  /// 主なエラー:
  /// - `NO_SUCH_FLASH`: Flashが存在しない
  Future<MisskeyFlash> show({required String flashId}) async {
    final res = await http.send<Map<String, dynamic>>(
      '/flash/show',
      body: <String, dynamic>{'flashId': flashId},
      options: const RequestOptions(
        authMode: AuthMode.optional,
        idempotent: true,
      ),
    );
    return MisskeyFlash.fromJson(res);
  }

  /// 自分のFlash一覧を取得する（`/api/flash/my`）
  ///
  /// 認証必須。
  ///
  /// - [limit]: 取得件数 1〜100（デフォルト10）
  /// - [sinceId] / [untilId]: IDによるページング
  /// - [sinceDate] / [untilDate]: Unixタイムスタンプ（ms）によるページング
  Future<List<MisskeyFlash>> my({
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
      '/flash/my',
      body: body,
      options: const RequestOptions(idempotent: true),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyFlash.fromJson)
        .toList();
  }

  /// 注目Flash一覧を取得する（`/api/flash/featured`）
  ///
  /// 認証不要。offsetベースのページネーション。
  ///
  /// - [offset]: スキップ件数（デフォルト: 0）
  /// - [limit]: 取得件数 1〜100（デフォルト10）
  Future<List<MisskeyFlash>> featured({
    int? offset,
    int? limit,
  }) async {
    final body = <String, dynamic>{
      if (offset != null) 'offset': offset,
      if (limit != null) 'limit': limit,
    };
    final res = await http.send<List<dynamic>>(
      '/flash/featured',
      body: body,
      options: const RequestOptions(
        authMode: AuthMode.optional,
        idempotent: true,
      ),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyFlash.fromJson)
        .toList();
  }

  /// Flashにいいねする（`/api/flash/like`）
  ///
  /// 認証必須。
  ///
  /// 主なエラー:
  /// - `NO_SUCH_FLASH`: Flashが存在しない
  /// - `YOUR_FLASH`: 自分のFlashにはいいねできない
  /// - `ALREADY_LIKED`: 既にいいね済み
  Future<void> like({required String flashId}) => http.send<Object?>(
        '/flash/like',
        body: <String, dynamic>{'flashId': flashId},
      );

  /// Flashのいいねを解除する（`/api/flash/unlike`）
  ///
  /// 認証必須。
  ///
  /// 主なエラー:
  /// - `NO_SUCH_FLASH`: Flashが存在しない
  /// - `NOT_LIKED`: いいねしていない
  Future<void> unlike({required String flashId}) => http.send<Object?>(
        '/flash/unlike',
        body: <String, dynamic>{'flashId': flashId},
      );

  /// 自分がいいねしたFlash一覧を取得する（`/api/flash/my-likes`）
  ///
  /// 認証必須。
  ///
  /// - [limit]: 取得件数 1〜100（デフォルト10）
  /// - [sinceId] / [untilId]: IDによるページング
  /// - [sinceDate] / [untilDate]: Unixタイムスタンプ（ms）によるページング
  /// - [search]: ノート本文をスペース区切りAND検索（1〜100文字）
  Future<List<MisskeyFlashLike>> myLikes({
    int? limit,
    String? sinceId,
    String? untilId,
    int? sinceDate,
    int? untilDate,
    String? search,
  }) async {
    final body = <String, dynamic>{
      if (limit != null) 'limit': limit,
      if (sinceId != null) 'sinceId': sinceId,
      if (untilId != null) 'untilId': untilId,
      if (sinceDate != null) 'sinceDate': sinceDate,
      if (untilDate != null) 'untilDate': untilDate,
      if (search != null) 'search': search,
    };
    final res = await http.send<List<dynamic>>(
      '/flash/my-likes',
      body: body,
      options: const RequestOptions(idempotent: true),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyFlashLike.fromJson)
        .toList();
  }

  /// Flashを検索する（`/api/flash/search`）
  ///
  /// 認証不要。
  ///
  /// - [query]: 検索文字列（1〜100文字、必須）
  /// - [limit]: 取得件数 1〜100（デフォルト5）
  /// - [sinceId] / [untilId]: IDによるページング
  /// - [sinceDate] / [untilDate]: Unixタイムスタンプ（ms）によるページング
  Future<List<MisskeyFlash>> search({
    required String query,
    int? limit,
    String? sinceId,
    String? untilId,
    int? sinceDate,
    int? untilDate,
  }) async {
    final body = <String, dynamic>{
      'query': query,
      if (limit != null) 'limit': limit,
      if (sinceId != null) 'sinceId': sinceId,
      if (untilId != null) 'untilId': untilId,
      if (sinceDate != null) 'sinceDate': sinceDate,
      if (untilDate != null) 'untilDate': untilDate,
    };
    final res = await http.send<List<dynamic>>(
      '/flash/search',
      body: body,
      options: const RequestOptions(
        authMode: AuthMode.optional,
        idempotent: true,
      ),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyFlash.fromJson)
        .toList();
  }
}
