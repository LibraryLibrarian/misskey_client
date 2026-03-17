import '../../client/misskey_http.dart';
import '../../client/request_options.dart';
import '../../models/chat/misskey_chat_room.dart';
import '../../models/chat/misskey_chat_room_invitation.dart';
import '../../models/chat/misskey_chat_room_member.dart';

/// チャットルーム関連API（`/api/chat/rooms/*`）
///
/// ルームの作成・更新・削除・参加/退出・ミュート・メンバー取得、
/// および招待（invitations）操作を提供する。
/// 全エンドポイントで認証必須。
class ChatRoomsApi {
  const ChatRoomsApi({required this.http});

  final MisskeyHttp http;

  /// ルームを作成する（`/api/chat/rooms/create`）
  ///
  /// - [name]: ルーム名（最大256文字、必須）
  /// - [description]: 説明文（最大1024文字）
  Future<MisskeyChatRoom> create({
    required String name,
    String? description,
  }) async {
    final res = await http.send<Map<String, dynamic>>(
      '/chat/rooms/create',
      body: <String, dynamic>{
        'name': name,
        if (description != null) 'description': description,
      },
    );
    return MisskeyChatRoom.fromJson(res);
  }

  /// ルームを更新する（`/api/chat/rooms/update`）
  ///
  /// - [roomId]: 更新対象のルームID（必須）
  /// - [name]: ルーム名（最大256文字）
  /// - [description]: 説明文（最大1024文字）
  ///
  /// 主なエラー:
  /// - `NO_SUCH_ROOM`: ルームが存在しない
  Future<MisskeyChatRoom> update({
    required String roomId,
    String? name,
    String? description,
  }) async {
    final body = <String, dynamic>{
      'roomId': roomId,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
    };
    final res = await http.send<Map<String, dynamic>>(
      '/chat/rooms/update',
      body: body,
    );
    return MisskeyChatRoom.fromJson(res);
  }

  /// ルームを削除する（`/api/chat/rooms/delete`）
  ///
  /// - [roomId]: 削除対象のルームID（必須）
  ///
  /// 主なエラー:
  /// - `NO_SUCH_ROOM`: ルームが存在しない
  Future<void> delete({required String roomId}) => http.send<Object?>(
        '/chat/rooms/delete',
        body: <String, dynamic>{'roomId': roomId},
      );

  /// ルームの詳細を取得する（`/api/chat/rooms/show`）
  ///
  /// - [roomId]: 対象のルームID（必須）
  ///
  /// 主なエラー:
  /// - `NO_SUCH_ROOM`: ルームが存在しない
  Future<MisskeyChatRoom> show({required String roomId}) async {
    final res = await http.send<Map<String, dynamic>>(
      '/chat/rooms/show',
      body: <String, dynamic>{'roomId': roomId},
      options: const RequestOptions(idempotent: true),
    );
    return MisskeyChatRoom.fromJson(res);
  }

  /// ルームに参加する（`/api/chat/rooms/join`）
  ///
  /// - [roomId]: 参加するルームID（必須）
  ///
  /// 主なエラー:
  /// - `NO_SUCH_ROOM`: ルームが存在しない
  Future<void> join({required String roomId}) => http.send<Object?>(
        '/chat/rooms/join',
        body: <String, dynamic>{'roomId': roomId},
      );

  /// ルームから退出する（`/api/chat/rooms/leave`）
  ///
  /// - [roomId]: 退出するルームID（必須）
  ///
  /// 主なエラー:
  /// - `NO_SUCH_ROOM`: ルームが存在しない
  Future<void> leave({required String roomId}) => http.send<Object?>(
        '/chat/rooms/leave',
        body: <String, dynamic>{'roomId': roomId},
      );

  /// ルームのミュート設定を変更する（`/api/chat/rooms/mute`）
  ///
  /// - [roomId]: 対象のルームID（必須）
  /// - [mute]: `true`でミュート、`false`で解除（必須）
  ///
  /// 主なエラー:
  /// - `NO_SUCH_ROOM`: ルームが存在しない
  Future<void> setMute({
    required String roomId,
    required bool mute,
  }) =>
      http.send<Object?>(
        '/chat/rooms/mute',
        body: <String, dynamic>{'roomId': roomId, 'mute': mute},
      );

  /// ルームのメンバー一覧を取得する（`/api/chat/rooms/members`）
  ///
  /// - [roomId]: 対象のルームID（必須）
  /// - [limit]: 取得件数 1〜100（デフォルト30）
  /// - [sinceId] / [untilId]: IDによるページング
  /// - [sinceDate] / [untilDate]: Unixタイムスタンプ（ms）によるページング
  ///
  /// 主なエラー:
  /// - `NO_SUCH_ROOM`: ルームが存在しない
  Future<List<MisskeyChatRoomMember>> members({
    required String roomId,
    int? limit,
    String? sinceId,
    String? untilId,
    int? sinceDate,
    int? untilDate,
  }) async {
    final body = <String, dynamic>{
      'roomId': roomId,
      if (limit != null) 'limit': limit,
      if (sinceId != null) 'sinceId': sinceId,
      if (untilId != null) 'untilId': untilId,
      if (sinceDate != null) 'sinceDate': sinceDate,
      if (untilDate != null) 'untilDate': untilDate,
    };
    final res = await http.send<List<dynamic>>(
      '/chat/rooms/members',
      body: body,
      options: const RequestOptions(idempotent: true),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyChatRoomMember.fromJson)
        .toList();
  }

  /// 自分が所有するルーム一覧を取得する（`/api/chat/rooms/owned`）
  ///
  /// - [limit]: 取得件数 1〜100（デフォルト30）
  /// - [sinceId] / [untilId]: IDによるページング
  /// - [sinceDate] / [untilDate]: Unixタイムスタンプ（ms）によるページング
  Future<List<MisskeyChatRoom>> owned({
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
      '/chat/rooms/owned',
      body: body,
      options: const RequestOptions(idempotent: true),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyChatRoom.fromJson)
        .toList();
  }

  /// 参加中のルーム一覧を取得する（`/api/chat/rooms/joining`）
  ///
  /// レスポンスはメンバーシップ情報（ルーム情報を含む）のリスト。
  ///
  /// - [limit]: 取得件数 1〜100（デフォルト30）
  /// - [sinceId] / [untilId]: IDによるページング
  /// - [sinceDate] / [untilDate]: Unixタイムスタンプ（ms）によるページング
  Future<List<MisskeyChatRoomMember>> joining({
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
      '/chat/rooms/joining',
      body: body,
      options: const RequestOptions(idempotent: true),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyChatRoomMember.fromJson)
        .toList();
  }

  /// ルームにユーザーを招待する（`/api/chat/rooms/invitations/create`）
  ///
  /// - [roomId]: 招待するルームID（必須）
  /// - [userId]: 招待するユーザーID（必須）
  ///
  /// 主なエラー:
  /// - `NO_SUCH_ROOM`: ルームが存在しない
  Future<MisskeyChatRoomInvitation> invitationsCreate({
    required String roomId,
    required String userId,
  }) async {
    final res = await http.send<Map<String, dynamic>>(
      '/chat/rooms/invitations/create',
      body: <String, dynamic>{'roomId': roomId, 'userId': userId},
    );
    return MisskeyChatRoomInvitation.fromJson(res);
  }

  /// 受信した招待一覧を取得する（`/api/chat/rooms/invitations/inbox`）
  ///
  /// - [limit]: 取得件数 1〜100（デフォルト30）
  /// - [sinceId] / [untilId]: IDによるページング
  /// - [sinceDate] / [untilDate]: Unixタイムスタンプ（ms）によるページング
  Future<List<MisskeyChatRoomInvitation>> invitationsInbox({
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
      '/chat/rooms/invitations/inbox',
      body: body,
      options: const RequestOptions(idempotent: true),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyChatRoomInvitation.fromJson)
        .toList();
  }

  /// 送信した招待一覧を取得する（`/api/chat/rooms/invitations/outbox`）
  ///
  /// - [roomId]: 対象のルームID（必須）
  /// - [limit]: 取得件数 1〜100（デフォルト30）
  /// - [sinceId] / [untilId]: IDによるページング
  /// - [sinceDate] / [untilDate]: Unixタイムスタンプ（ms）によるページング
  ///
  /// 主なエラー:
  /// - `NO_SUCH_ROOM`: ルームが存在しない
  Future<List<MisskeyChatRoomInvitation>> invitationsOutbox({
    required String roomId,
    int? limit,
    String? sinceId,
    String? untilId,
    int? sinceDate,
    int? untilDate,
  }) async {
    final body = <String, dynamic>{
      'roomId': roomId,
      if (limit != null) 'limit': limit,
      if (sinceId != null) 'sinceId': sinceId,
      if (untilId != null) 'untilId': untilId,
      if (sinceDate != null) 'sinceDate': sinceDate,
      if (untilDate != null) 'untilDate': untilDate,
    };
    final res = await http.send<List<dynamic>>(
      '/chat/rooms/invitations/outbox',
      body: body,
      options: const RequestOptions(idempotent: true),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyChatRoomInvitation.fromJson)
        .toList();
  }

  /// 受信した招待を無視する（`/api/chat/rooms/invitations/ignore`）
  ///
  /// - [roomId]: 対象のルームID（必須）
  ///
  /// 主なエラー:
  /// - `NO_SUCH_ROOM`: ルームが存在しない
  Future<void> invitationsIgnore({required String roomId}) =>
      http.send<Object?>(
        '/chat/rooms/invitations/ignore',
        body: <String, dynamic>{'roomId': roomId},
      );
}
