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
}
