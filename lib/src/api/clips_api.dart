import '../client/misskey_http.dart';
import '../client/request_options.dart';
import '../models/misskey_clip.dart';
import '../models/misskey_note.dart';

/// クリップ関連API（`/api/clips/*`）
///
/// ノートのブックマーク機能（クリップ）の
/// 作成・更新・削除・ノート追加/削除・お気に入りを提供する。
/// 全エンドポイントで認証必須。
class ClipsApi {
  const ClipsApi({required this.http});

  final MisskeyHttp http;

  /// クリップを作成する（`/api/clips/create`）
  ///
  /// - [name]: クリップ名（1〜100文字、必須）
  /// - [isPublic]: 公開するか（デフォルト: false）
  /// - [description]: 説明文（最大2048文字）
  ///
  /// 主なエラー:
  /// - `TOO_MANY_CLIPS`: クリップ上限に達している
  Future<MisskeyClip> create({
    required String name,
    bool? isPublic,
    String? description,
  }) async {
    final res = await http.send<Map<String, dynamic>>(
      '/clips/create',
      body: <String, dynamic>{
        'name': name,
        if (isPublic != null) 'isPublic': isPublic,
        if (description != null) 'description': description,
      },
    );
    return MisskeyClip.fromJson(res);
  }

  /// クリップを更新する（`/api/clips/update`）
  ///
  /// - [clipId]: 更新対象のクリップID（必須）
  /// - [name]: クリップ名（1〜100文字）
  /// - [isPublic]: 公開するか
  /// - [description]: 説明文（最大2048文字）
  ///
  /// 主なエラー:
  /// - `NO_SUCH_CLIP`: クリップが存在しない
  Future<MisskeyClip> update({
    required String clipId,
    String? name,
    bool? isPublic,
    String? description,
  }) async {
    final body = <String, dynamic>{
      'clipId': clipId,
      if (name != null) 'name': name,
      if (isPublic != null) 'isPublic': isPublic,
      if (description != null) 'description': description,
    };
    final res = await http.send<Map<String, dynamic>>(
      '/clips/update',
      body: body,
    );
    return MisskeyClip.fromJson(res);
  }

  /// クリップを削除する（`/api/clips/delete`）
  ///
  /// - [clipId]: 削除対象のクリップID（必須）
  ///
  /// 主なエラー:
  /// - `NO_SUCH_CLIP`: クリップが存在しない
  Future<void> delete({required String clipId}) => http.send<Object?>(
        '/clips/delete',
        body: <String, dynamic>{'clipId': clipId},
      );

  /// クリップの詳細を取得する（`/api/clips/show`）
  ///
  /// - [clipId]: 対象のクリップID（必須）
  ///
  /// 主なエラー:
  /// - `NO_SUCH_CLIP`: クリップが存在しない
  Future<MisskeyClip> show({required String clipId}) async {
    final res = await http.send<Map<String, dynamic>>(
      '/clips/show',
      body: <String, dynamic>{'clipId': clipId},
      options: const RequestOptions(idempotent: true),
    );
    return MisskeyClip.fromJson(res);
  }

  /// 自分のクリップ一覧を取得する（`/api/clips/list`）
  ///
  /// - [limit]: 取得件数 1〜100（デフォルト10）
  /// - [sinceId] / [untilId]: IDによるページング
  /// - [sinceDate] / [untilDate]: Unixタイムスタンプ（ms）によるページング
  Future<List<MisskeyClip>> list({
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
      '/clips/list',
      body: body,
      options: const RequestOptions(idempotent: true),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyClip.fromJson)
        .toList();
  }

  /// クリップにノートを追加する（`/api/clips/add-note`）
  ///
  /// - [clipId]: クリップID（必須）
  /// - [noteId]: 追加するノートID（必須）
  ///
  /// 主なエラー:
  /// - `NO_SUCH_CLIP`: クリップが存在しない
  /// - `NO_SUCH_NOTE`: ノートが存在しない
  /// - `ALREADY_CLIPPED`: 既にクリップ済み
  /// - `TOO_MANY_CLIP_NOTES`: クリップのノート上限に達している
  Future<void> addNote({
    required String clipId,
    required String noteId,
  }) =>
      http.send<Object?>(
        '/clips/add-note',
        body: <String, dynamic>{'clipId': clipId, 'noteId': noteId},
      );

  /// クリップからノートを削除する（`/api/clips/remove-note`）
  ///
  /// - [clipId]: クリップID（必須）
  /// - [noteId]: 削除するノートID（必須）
  ///
  /// 主なエラー:
  /// - `NO_SUCH_CLIP`: クリップが存在しない
  /// - `NO_SUCH_NOTE`: ノートが存在しない
  Future<void> removeNote({
    required String clipId,
    required String noteId,
  }) =>
      http.send<Object?>(
        '/clips/remove-note',
        body: <String, dynamic>{'clipId': clipId, 'noteId': noteId},
      );

  /// クリップ内のノート一覧を取得する（`/api/clips/notes`）
  ///
  /// - [clipId]: 対象のクリップID（必須）
  /// - [limit]: 取得件数 1〜100（デフォルト10）
  /// - [sinceId] / [untilId]: IDによるページング
  /// - [sinceDate] / [untilDate]: Unixタイムスタンプ（ms）によるページング
  /// - [search]: ノート本文をスペース区切りAND検索（1〜100文字）
  ///
  /// 主なエラー:
  /// - `NO_SUCH_CLIP`: クリップが存在しない
  Future<List<MisskeyNote>> notes({
    required String clipId,
    int? limit,
    String? sinceId,
    String? untilId,
    int? sinceDate,
    int? untilDate,
    String? search,
  }) async {
    final body = <String, dynamic>{
      'clipId': clipId,
      if (limit != null) 'limit': limit,
      if (sinceId != null) 'sinceId': sinceId,
      if (untilId != null) 'untilId': untilId,
      if (sinceDate != null) 'sinceDate': sinceDate,
      if (untilDate != null) 'untilDate': untilDate,
      if (search != null) 'search': search,
    };
    final res = await http.send<List<dynamic>>(
      '/clips/notes',
      body: body,
      options: const RequestOptions(idempotent: true),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyNote.fromJson)
        .toList();
  }

  /// クリップをお気に入りに追加する（`/api/clips/favorite`）
  ///
  /// - [clipId]: クリップID（必須）
  ///
  /// 主なエラー:
  /// - `NO_SUCH_CLIP`: クリップが存在しない
  /// - `ALREADY_FAVORITED`: 既にお気に入り済み
  Future<void> favorite({required String clipId}) => http.send<Object?>(
        '/clips/favorite',
        body: <String, dynamic>{'clipId': clipId},
      );

  /// クリップのお気に入りを解除する（`/api/clips/unfavorite`）
  ///
  /// - [clipId]: クリップID（必須）
  ///
  /// 主なエラー:
  /// - `NO_SUCH_CLIP`: クリップが存在しない
  /// - `NOT_FAVORITED`: お気に入りしていない
  Future<void> unfavorite({required String clipId}) => http.send<Object?>(
        '/clips/unfavorite',
        body: <String, dynamic>{'clipId': clipId},
      );

  /// お気に入り登録したクリップ一覧を取得する（`/api/clips/my-favorites`）
  Future<List<MisskeyClip>> myFavorites() async {
    final res = await http.send<List<dynamic>>(
      '/clips/my-favorites',
      body: const <String, dynamic>{},
      options: const RequestOptions(idempotent: true),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyClip.fromJson)
        .toList();
  }
}
