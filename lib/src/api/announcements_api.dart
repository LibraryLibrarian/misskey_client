import '../client/auth_mode.dart';
import '../client/misskey_http.dart';
import '../client/request_options.dart';
import '../models/misskey_announcement.dart';

/// お知らせ関連API（`/api/announcements`）
///
/// サーバーのお知らせ一覧を取得する。
/// 既読処理は `AccountApi.readAnnouncement` を使用する。
class AnnouncementsApi {
  const AnnouncementsApi({required this.http});

  final MisskeyHttp http;

  /// お知らせ一覧を取得する（`/api/announcements`）
  ///
  /// 認証不要だが、認証時は `isRead` フィールドが含まれる。
  ///
  /// - [limit]: 取得件数 1〜100（デフォルト10）
  /// - [sinceId] / [untilId]: IDによるページング
  /// - [sinceDate] / [untilDate]: Unixタイムスタンプ（ms）によるページング
  /// - [isActive]: アクティブなお知らせのみ取得するか（デフォルト: true）
  Future<List<MisskeyAnnouncement>> list({
    int? limit,
    String? sinceId,
    String? untilId,
    int? sinceDate,
    int? untilDate,
    bool? isActive,
  }) async {
    final body = <String, dynamic>{
      if (limit != null) 'limit': limit,
      if (sinceId != null) 'sinceId': sinceId,
      if (untilId != null) 'untilId': untilId,
      if (sinceDate != null) 'sinceDate': sinceDate,
      if (untilDate != null) 'untilDate': untilDate,
      if (isActive != null) 'isActive': isActive,
    };
    final res = await http.send<List<dynamic>>(
      '/announcements',
      body: body,
      options: const RequestOptions(
        authMode: AuthMode.optional,
        idempotent: true,
      ),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyAnnouncement.fromJson)
        .toList();
  }

  /// お知らせの詳細を取得する（`/api/announcements/show`）
  ///
  /// 認証不要。
  ///
  /// - [announcementId]: 対象のお知らせID（必須）
  ///
  /// 主なエラー:
  /// - `NO_SUCH_ANNOUNCEMENT`: 指定したお知らせが存在しない
  Future<MisskeyAnnouncement> show({
    required String announcementId,
  }) async {
    final res = await http.send<Map<String, dynamic>>(
      '/announcements/show',
      body: <String, dynamic>{'announcementId': announcementId},
      options: const RequestOptions(
        authMode: AuthMode.optional,
        idempotent: true,
      ),
    );
    return MisskeyAnnouncement.fromJson(res);
  }
}
