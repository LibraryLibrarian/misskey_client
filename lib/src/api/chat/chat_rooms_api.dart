import '../../client/misskey_http.dart';
import '../../client/request_options.dart';
import '../../models/chat/misskey_chat_room.dart';
import '../../models/chat/misskey_chat_room_invitation.dart';
import '../../models/chat/misskey_chat_room_member.dart';

/// Provides chat room operations (`/api/chat/rooms/*`).
///
/// Handles room creation, updating, deletion, joining/leaving, muting,
/// member retrieval, and invitation management.
/// All endpoints require authentication.
class ChatRoomsApi {
  const ChatRoomsApi({required this.http});

  final MisskeyHttp http;

  /// Creates a chat room (`/api/chat/rooms/create`).
  ///
  /// [name] is the room name (up to 256 characters). [description] is an
  /// optional room description (up to 1024 characters).
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

  /// Updates a chat room (`/api/chat/rooms/update`).
  ///
  /// [roomId] identifies the room to update. [name] sets a new room name (up
  /// to 256 characters) and [description] sets a new description (up to 1024
  /// characters). Throws `NO_SUCH_ROOM` if the room does not exist.
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

  /// Deletes a chat room (`/api/chat/rooms/delete`).
  ///
  /// [roomId] is the ID of the room to delete.
  /// Throws `NO_SUCH_ROOM` if the room does not exist.
  Future<void> delete({required String roomId}) => http.send<Object?>(
        '/chat/rooms/delete',
        body: <String, dynamic>{'roomId': roomId},
      );

  /// Retrieves the details of a chat room (`/api/chat/rooms/show`).
  ///
  /// [roomId] is the target room ID.
  /// Throws `NO_SUCH_ROOM` if the room does not exist.
  Future<MisskeyChatRoom> show({required String roomId}) async {
    final res = await http.send<Map<String, dynamic>>(
      '/chat/rooms/show',
      body: <String, dynamic>{'roomId': roomId},
      options: const RequestOptions(idempotent: true),
    );
    return MisskeyChatRoom.fromJson(res);
  }

  /// Joins a chat room (`/api/chat/rooms/join`).
  ///
  /// [roomId] is the ID of the room to join.
  /// Throws `NO_SUCH_ROOM` if the room does not exist.
  Future<void> join({required String roomId}) => http.send<Object?>(
        '/chat/rooms/join',
        body: <String, dynamic>{'roomId': roomId},
      );

  /// Leaves a chat room (`/api/chat/rooms/leave`).
  ///
  /// [roomId] is the ID of the room to leave.
  /// Throws `NO_SUCH_ROOM` if the room does not exist.
  Future<void> leave({required String roomId}) => http.send<Object?>(
        '/chat/rooms/leave',
        body: <String, dynamic>{'roomId': roomId},
      );

  /// Updates the mute setting for a chat room (`/api/chat/rooms/mute`).
  ///
  /// [roomId] is the target room ID. Pass `true` for [mute] to mute the room
  /// or `false` to unmute it. Throws `NO_SUCH_ROOM` if the room does not
  /// exist.
  Future<void> setMute({
    required String roomId,
    required bool mute,
  }) =>
      http.send<Object?>(
        '/chat/rooms/mute',
        body: <String, dynamic>{'roomId': roomId, 'mute': mute},
      );

  /// Retrieves the member list of a chat room (`/api/chat/rooms/members`).
  ///
  /// [roomId] is the target room ID. [limit] caps the number of results
  /// (1-100, default 30). Use [sinceId] and [untilId] to paginate by ID, or
  /// [sinceDate] and [untilDate] to paginate by Unix timestamp in milliseconds.
  /// Throws `NO_SUCH_ROOM` if the room does not exist.
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

  /// Retrieves a list of rooms owned by the authenticated user
  /// (`/api/chat/rooms/owned`).
  ///
  /// [limit] caps the number of results (1-100, default 30). Use [sinceId]
  /// and [untilId] to paginate by ID, or [sinceDate] and [untilDate] to
  /// paginate by Unix timestamp in milliseconds.
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

  /// Retrieves a list of rooms the authenticated user has joined
  /// (`/api/chat/rooms/joining`).
  ///
  /// Returns a list of membership records (including room information).
  ///
  /// [limit] caps the number of results (1-100, default 30). Use [sinceId]
  /// and [untilId] to paginate by ID, or [sinceDate] and [untilDate] to
  /// paginate by Unix timestamp in milliseconds.
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

  /// Invites a user to a room (`/api/chat/rooms/invitations/create`).
  ///
  /// [roomId] is the room to invite to and [userId] is the user to invite.
  /// Throws `NO_SUCH_ROOM` if the room does not exist.
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

  /// Retrieves received invitations (`/api/chat/rooms/invitations/inbox`).
  ///
  /// [limit] caps the number of results (1-100, default 30). Use [sinceId]
  /// and [untilId] to paginate by ID, or [sinceDate] and [untilDate] to
  /// paginate by Unix timestamp in milliseconds.
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

  /// Retrieves sent invitations (`/api/chat/rooms/invitations/outbox`).
  ///
  /// [roomId] is the target room ID. [limit] caps the number of results
  /// (1-100, default 30). Use [sinceId] and [untilId] to paginate by ID, or
  /// [sinceDate] and [untilDate] to paginate by Unix timestamp in milliseconds.
  /// Throws `NO_SUCH_ROOM` if the room does not exist.
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

  /// Ignores a received invitation (`/api/chat/rooms/invitations/ignore`).
  ///
  /// [roomId] is the target room ID.
  /// Throws `NO_SUCH_ROOM` if the room does not exist.
  Future<void> invitationsIgnore({required String roomId}) =>
      http.send<Object?>(
        '/chat/rooms/invitations/ignore',
        body: <String, dynamic>{'roomId': roomId},
      );
}
