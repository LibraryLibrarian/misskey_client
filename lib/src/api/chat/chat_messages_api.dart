import '../../client/misskey_http.dart';
import '../../client/request_options.dart';
import '../../models/chat/misskey_chat_message.dart';

/// チャットメッセージ関連API（`/api/chat/messages/*`）
///
/// 1対1メッセージおよびルームメッセージの
/// 送信・削除・リアクション・タイムライン取得を提供する。
/// 全エンドポイントで認証必須。
class ChatMessagesApi {
  const ChatMessagesApi({required this.http});

  final MisskeyHttp http;

  /// ユーザーにメッセージを送信する（`/api/chat/messages/create-to-user`）
  ///
  /// - [toUserId]: 送信先ユーザーID（必須）
  /// - [text]: メッセージ本文（最大2000文字）
  /// - [fileId]: 添付ファイルのドライブファイルID
  ///
  /// [text] と [fileId] の少なくとも一方が必要。
  ///
  /// 主なエラー:
  /// - `NO_SUCH_USER`: 対象ユーザーが存在しない
  /// - `RECIPIENT_IS_YOURSELF`: 自分自身に送信しようとした
  /// - `CHAT_REJECTED`: チャット受信設定により拒否された
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

  /// ルームにメッセージを送信する（`/api/chat/messages/create-to-room`）
  ///
  /// - [toRoomId]: 送信先ルームID（必須）
  /// - [text]: メッセージ本文（最大2000文字）
  /// - [fileId]: 添付ファイルのドライブファイルID
  ///
  /// [text] と [fileId] の少なくとも一方が必要。
  ///
  /// 主なエラー:
  /// - `NO_SUCH_ROOM`: 対象ルームが存在しない
  /// - `NOT_A_MEMBER`: ルームのメンバーでない
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

  /// メッセージを削除する（`/api/chat/messages/delete`）
  ///
  /// - [messageId]: 削除対象のメッセージID（必須）
  ///
  /// 主なエラー:
  /// - `NO_SUCH_MESSAGE`: メッセージが存在しない
  Future<void> delete({required String messageId}) => http.send<Object?>(
        '/chat/messages/delete',
        body: <String, dynamic>{'messageId': messageId},
      );

  /// メッセージの詳細を取得する（`/api/chat/messages/show`）
  ///
  /// - [messageId]: 対象のメッセージID（必須）
  ///
  /// 主なエラー:
  /// - `NO_SUCH_MESSAGE`: メッセージが存在しない
  Future<MisskeyChatMessage> show({required String messageId}) async {
    final res = await http.send<Map<String, dynamic>>(
      '/chat/messages/show',
      body: <String, dynamic>{'messageId': messageId},
      options: const RequestOptions(idempotent: true),
    );
    return MisskeyChatMessage.fromJson(res);
  }

  /// メッセージにリアクションする（`/api/chat/messages/react`）
  ///
  /// - [messageId]: 対象メッセージID（必須）
  /// - [reaction]: リアクション文字列（必須）
  ///
  /// 主なエラー:
  /// - `NO_SUCH_MESSAGE`: メッセージが存在しない
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

  /// メッセージのリアクションを解除する（`/api/chat/messages/unreact`）
  ///
  /// - [messageId]: 対象メッセージID（必須）
  /// - [reaction]: 解除するリアクション文字列（必須）
  ///
  /// 主なエラー:
  /// - `NO_SUCH_MESSAGE`: メッセージが存在しない
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

  /// チャットメッセージを検索する（`/api/chat/messages/search`）
  ///
  /// - [query]: 検索文字列（必須）
  /// - [limit]: 取得件数 1〜100（デフォルト10）
  /// - [userId]: 特定ユーザーとのチャットに絞る
  /// - [roomId]: 特定ルームのチャットに絞る
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

  /// ユーザーとの1対1チャットタイムラインを取得する
  /// （`/api/chat/messages/user-timeline`）
  ///
  /// - [userId]: 対象ユーザーID（必須）
  /// - [limit]: 取得件数 1〜100（デフォルト10）
  /// - [sinceId] / [untilId]: IDによるページング
  /// - [sinceDate] / [untilDate]: Unixタイムスタンプ（ms）によるページング
  ///
  /// 主なエラー:
  /// - `NO_SUCH_USER`: 対象ユーザーが存在しない
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

  /// ルームチャットタイムラインを取得する
  /// （`/api/chat/messages/room-timeline`）
  ///
  /// - [roomId]: 対象ルームID（必須）
  /// - [limit]: 取得件数 1〜100（デフォルト10）
  /// - [sinceId] / [untilId]: IDによるページング
  /// - [sinceDate] / [untilDate]: Unixタイムスタンプ（ms）によるページング
  ///
  /// 主なエラー:
  /// - `NO_SUCH_ROOM`: 対象ルームが存在しない
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
