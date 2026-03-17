import '../client/misskey_http.dart';
import '../client/request_options.dart';
import '../models/misskey_notification.dart';

/// 通知関連API
class NotificationsApi {
  const NotificationsApi({required this.http});

  final MisskeyHttp http;

  /// 通知一覧を取得する（`/api/i/notifications`）
  ///
  /// - [limit]: 取得件数 1〜100
  /// - [sinceId] / [untilId]: IDによるページング
  /// - [sinceDate] / [untilDate]: Unixタイムスタンプ（ms）によるページング
  /// - [markAsRead]: 取得と同時に既読にするか（デフォルト: true）
  /// - [includeTypes]: 含める通知タイプ（空リストは結果なし）
  /// - [excludeTypes]: 除外する通知タイプ
  Future<List<MisskeyNotification>> list({
    int? limit,
    String? sinceId,
    String? untilId,
    int? sinceDate,
    int? untilDate,
    bool? markAsRead,
    List<String>? includeTypes,
    List<String>? excludeTypes,
  }) async {
    final body = <String, dynamic>{
      if (limit != null) 'limit': limit,
      if (sinceId != null) 'sinceId': sinceId,
      if (untilId != null) 'untilId': untilId,
      if (sinceDate != null) 'sinceDate': sinceDate,
      if (untilDate != null) 'untilDate': untilDate,
      if (markAsRead != null) 'markAsRead': markAsRead,
      if (includeTypes != null) 'includeTypes': includeTypes,
      if (excludeTypes != null) 'excludeTypes': excludeTypes,
    };
    // markAsRead=false のときのみ冪等として再試行可
    final idempotent = markAsRead == false;
    final res = await http.send<List<dynamic>>(
      '/i/notifications',
      body: body,
      options: RequestOptions(idempotent: idempotent),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyNotification.fromJson)
        .toList();
  }

  /// グループ化された通知一覧を取得する（`/api/i/notifications-grouped`）
  ///
  /// 同一ノートへのリアクション・リノートをまとめて1件として返す
  ///
  /// - [limit]: 取得件数 1〜100
  /// - [sinceId] / [untilId]: IDによるページング
  /// - [sinceDate] / [untilDate]: Unixタイムスタンプ（ms）によるページング
  /// - [markAsRead]: 取得と同時に既読にするか（デフォルト: true）
  /// - [includeTypes]: 含める通知タイプ（空リストは結果なし）
  /// - [excludeTypes]: 除外する通知タイプ
  Future<List<MisskeyNotification>> listGrouped({
    int? limit,
    String? sinceId,
    String? untilId,
    int? sinceDate,
    int? untilDate,
    bool? markAsRead,
    List<String>? includeTypes,
    List<String>? excludeTypes,
  }) async {
    final body = <String, dynamic>{
      if (limit != null) 'limit': limit,
      if (sinceId != null) 'sinceId': sinceId,
      if (untilId != null) 'untilId': untilId,
      if (sinceDate != null) 'sinceDate': sinceDate,
      if (untilDate != null) 'untilDate': untilDate,
      if (markAsRead != null) 'markAsRead': markAsRead,
      if (includeTypes != null) 'includeTypes': includeTypes,
      if (excludeTypes != null) 'excludeTypes': excludeTypes,
    };
    // markAsRead=false のときのみ冪等として再試行可
    final idempotent = markAsRead == false;
    final res = await http.send<List<dynamic>>(
      '/i/notifications-grouped',
      body: body,
      options: RequestOptions(idempotent: idempotent),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyNotification.fromJson)
        .toList();
  }

  /// すべての通知を削除（フラッシュ）する（`/api/notifications/flush`）
  ///
  /// 204 No Content を返す
  Future<void> flush() => http
      .send<Object?>('/notifications/flush', body: const <String, dynamic>{});

  /// すべての通知を既読にする（`/api/notifications/mark-all-as-read`）
  ///
  /// 204 No Content を返す
  Future<void> markAllAsRead() => http.send<Object?>(
        '/notifications/mark-all-as-read',
        body: const <String, dynamic>{},
      );

  /// アプリ通知を作成する（`/api/notifications/create`）
  ///
  /// アプリ（サードパーティクライアント等）からユーザーにカスタム通知を送信する。
  /// 通知タイプは `app` として作成される。
  /// 認証必須。権限: `write:notifications`。
  /// レート制限: 1分間に最大10回。
  ///
  /// - [body]: 通知本文（必須）
  /// - [header]: 通知ヘッダー（省略時はアクセストークン名が使用される）
  /// - [icon]: 通知アイコンURL（省略時はトークンのアイコンURLが使用される）
  Future<void> create({
    required String body,
    String? header,
    String? icon,
  }) =>
      http.send<Object?>(
        '/notifications/create',
        body: <String, dynamic>{
          'body': body,
          if (header != null) 'header': header,
          if (icon != null) 'icon': icon,
        },
      );

  /// テスト通知を送信する（`/api/notifications/test-notification`）
  ///
  /// 自分自身にテスト通知（タイプ `test`）を送信する。
  /// 通知の動作確認用エンドポイント。
  /// 認証必須。権限: `write:notifications`。
  /// レート制限: 1分間に最大10回。
  Future<void> testNotification() => http.send<Object?>(
        '/notifications/test-notification',
        body: const <String, dynamic>{},
      );
}
