import '../../client/misskey_http.dart';
import '../../client/request_options.dart';
import '../../models/chat/misskey_chat_message.dart';

/// Provides chat message operations (`/api/chat/messages/*`).
///
/// Handles sending, deleting, reacting, and retrieving timelines for
/// both direct (1-on-1) and room messages.
/// All endpoints require authentication.
class ChatMessagesApi {
  const ChatMessagesApi({required this.http});

  final MisskeyHttp http;

  /// Sends a message to a user (`/api/chat/messages/create-to-user`).
  ///
  /// [toUserId] is the recipient user ID. [text] is the message body (up to
  /// 2000 characters) and [fileId] is an optional Drive file ID to attach.
  /// At least one of [text] or [fileId] is required.
  ///
  /// Throws `NO_SUCH_USER` if the target user does not exist,
  /// `RECIPIENT_IS_YOURSELF` if attempting to message yourself, or
  /// `CHAT_REJECTED` if rejected by the recipient's chat settings.
  Future<MisskeyChatMessage> createToUser({
    required String toUserId,
    String? text,
    String? fileId,
  }) async {
    final res = await http.send<Map<String, dynamic>>(
      '/chat/messages/create-to-user',
      body: <String, dynamic>{
        'toUserId': toUserId,
        if (text != null) 'text': text,
        if (fileId != null) 'fileId': fileId,
      },
    );
    return MisskeyChatMessage.fromJson(res);
  }

  /// Sends a message to a room (`/api/chat/messages/create-to-room`).
  ///
  /// [toRoomId] is the target room ID. [text] is the message body (up to
  /// 2000 characters) and [fileId] is an optional Drive file ID to attach.
  /// At least one of [text] or [fileId] is required.
  ///
  /// Throws `NO_SUCH_ROOM` if the target room does not exist, or
  /// `NOT_A_MEMBER` if the user is not a member of the room.
  Future<MisskeyChatMessage> createToRoom({
    required String toRoomId,
    String? text,
    String? fileId,
  }) async {
    final res = await http.send<Map<String, dynamic>>(
      '/chat/messages/create-to-room',
      body: <String, dynamic>{
        'toRoomId': toRoomId,
        if (text != null) 'text': text,
        if (fileId != null) 'fileId': fileId,
      },
    );
    return MisskeyChatMessage.fromJson(res);
  }

  /// Deletes a message (`/api/chat/messages/delete`).
  ///
  /// [messageId] is the ID of the message to delete.
  /// Throws `NO_SUCH_MESSAGE` if the message does not exist.
  Future<void> delete({required String messageId}) => http.send<Object?>(
        '/chat/messages/delete',
        body: <String, dynamic>{'messageId': messageId},
      );

  /// Retrieves the details of a message (`/api/chat/messages/show`).
  ///
  /// [messageId] is the target message ID.
  /// Throws `NO_SUCH_MESSAGE` if the message does not exist.
  Future<MisskeyChatMessage> show({required String messageId}) async {
    final res = await http.send<Map<String, dynamic>>(
      '/chat/messages/show',
      body: <String, dynamic>{'messageId': messageId},
      options: const RequestOptions(idempotent: true),
    );
    return MisskeyChatMessage.fromJson(res);
  }

  /// Adds a reaction to a message (`/api/chat/messages/react`).
  ///
  /// [messageId] is the target message ID and [reaction] is the reaction
  /// string to add. Throws `NO_SUCH_MESSAGE` if the message does not exist.
  Future<void> react({
    required String messageId,
    required String reaction,
  }) =>
      http.send<Object?>(
        '/chat/messages/react',
        body: <String, dynamic>{
          'messageId': messageId,
          'reaction': reaction,
        },
      );

  /// Removes a reaction from a message (`/api/chat/messages/unreact`).
  ///
  /// [messageId] is the target message ID and [reaction] is the reaction
  /// string to remove. Throws `NO_SUCH_MESSAGE` if the message does not
  /// exist.
  Future<void> unreact({
    required String messageId,
    required String reaction,
  }) =>
      http.send<Object?>(
        '/chat/messages/unreact',
        body: <String, dynamic>{
          'messageId': messageId,
          'reaction': reaction,
        },
      );

  /// Searches chat messages (`/api/chat/messages/search`).
  ///
  /// [query] is the search string. [limit] caps the number of results
  /// (1-100, default 10). Pass [userId] to filter to chats with a specific
  /// user, or [roomId] to filter to chats in a specific room.
  Future<List<MisskeyChatMessage>> search({
    required String query,
    int? limit,
    String? userId,
    String? roomId,
  }) async {
    final body = <String, dynamic>{
      'query': query,
      if (limit != null) 'limit': limit,
      if (userId != null) 'userId': userId,
      if (roomId != null) 'roomId': roomId,
    };
    final res = await http.send<List<dynamic>>(
      '/chat/messages/search',
      body: body,
      options: const RequestOptions(idempotent: true),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyChatMessage.fromJson)
        .toList();
  }

  /// Retrieves the direct chat timeline with a user
  /// (`/api/chat/messages/user-timeline`).
  ///
  /// [userId] is the target user ID. [limit] caps the number of results
  /// (1-100, default 10). Use [sinceId] and [untilId] to paginate by ID, or
  /// [sinceDate] and [untilDate] to paginate by Unix timestamp in milliseconds.
  ///
  /// Throws `NO_SUCH_USER` if the target user does not exist.
  Future<List<MisskeyChatMessage>> userTimeline({
    required String userId,
    int? limit,
    String? sinceId,
    String? untilId,
    int? sinceDate,
    int? untilDate,
  }) async {
    final body = <String, dynamic>{
      'userId': userId,
      if (limit != null) 'limit': limit,
      if (sinceId != null) 'sinceId': sinceId,
      if (untilId != null) 'untilId': untilId,
      if (sinceDate != null) 'sinceDate': sinceDate,
      if (untilDate != null) 'untilDate': untilDate,
    };
    final res = await http.send<List<dynamic>>(
      '/chat/messages/user-timeline',
      body: body,
      options: const RequestOptions(idempotent: true),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyChatMessage.fromJson)
        .toList();
  }

  /// Retrieves the chat timeline for a room
  /// (`/api/chat/messages/room-timeline`).
  ///
  /// [roomId] is the target room ID. [limit] caps the number of results
  /// (1-100, default 10). Use [sinceId] and [untilId] to paginate by ID, or
  /// [sinceDate] and [untilDate] to paginate by Unix timestamp in milliseconds.
  ///
  /// Throws `NO_SUCH_ROOM` if the target room does not exist.
  Future<List<MisskeyChatMessage>> roomTimeline({
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
      '/chat/messages/room-timeline',
      body: body,
      options: const RequestOptions(idempotent: true),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyChatMessage.fromJson)
        .toList();
  }
}
