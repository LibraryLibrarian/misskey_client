import '../../client/misskey_http.dart';
import '../../client/request_options.dart';
import '../../models/chat/misskey_chat_message.dart';
import 'chat_messages_api.dart';
import 'chat_rooms_api.dart';

/// チャット関連APIのファサード（`/api/chat/*`）
///
/// [messages] でメッセージ操作、[rooms] でルーム操作を提供し、
/// トップレベルの `/api/chat/*` エンドポイントも直接提供する。
/// 全エンドポイントで認証必須。
class ChatApi {
  ChatApi({required MisskeyHttp http})
      : _http = http,
        messages = ChatMessagesApi(http: http),
        rooms = ChatRoomsApi(http: http);

  final MisskeyHttp _http;

  /// チャットメッセージ関連API
  final ChatMessagesApi messages;

  /// チャットルーム関連API
  final ChatRoomsApi rooms;

  /// チャット履歴を取得する（`/api/chat/history`）
  ///
  /// 1対1チャット・ルームチャットの最新メッセージ履歴を返す。
  ///
  /// - [limit]: 取得件数 1〜100（デフォルト10）
  /// - [room]: `true`でルーム履歴、`false`でDM履歴（デフォルト: false）
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

  /// すべてのチャットメッセージを既読にする（`/api/chat/read-all`）
  Future<void> readAll() => _http.send<Object?>(
        '/chat/read-all',
        body: const <String, dynamic>{},
      );
}
