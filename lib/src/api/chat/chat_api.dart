import '../../client/misskey_http.dart';
import '../../client/request_options.dart';
import '../../models/chat/misskey_chat_message.dart';
import 'chat_messages_api.dart';
import 'chat_rooms_api.dart';

/// Provides a facade for chat APIs (`/api/chat/*`).
///
/// Offers message operations via [messages], room operations via [rooms],
/// and top-level `/api/chat/*` endpoints directly.
/// All endpoints require authentication.
class ChatApi {
  ChatApi({required MisskeyHttp http})
      : _http = http,
        messages = ChatMessagesApi(http: http),
        rooms = ChatRoomsApi(http: http);

  final MisskeyHttp _http;

  /// Provides chat message APIs.
  final ChatMessagesApi messages;

  /// Provides chat room APIs.
  final ChatRoomsApi rooms;

  /// Retrieves chat history (`/api/chat/history`).
  ///
  /// Returns the latest message history for both direct messages and room
  /// chats.
  ///
  /// [limit] controls how many items to fetch (1-100, default 10). Set [room]
  /// to `true` for room history or `false` for DM history (default false).
  Future<List<MisskeyChatMessage>> history({
    int? limit,
    bool? room,
  }) async {
    final body = <String, dynamic>{
      if (limit != null) 'limit': limit,
      if (room != null) 'room': room,
    };
    final res = await _http.send<List<dynamic>>(
      '/chat/history',
      body: body,
      options: const RequestOptions(idempotent: true),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyChatMessage.fromJson)
        .toList();
  }

  /// Marks all chat messages as read (`/api/chat/read-all`).
  Future<void> readAll() => _http.send<Object?>(
        '/chat/read-all',
        body: const <String, dynamic>{},
      );
}
