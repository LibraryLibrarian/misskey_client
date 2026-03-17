import '../client/misskey_http.dart';
import '../client/request_options.dart';
import '../models/misskey_follow_request.dart';
import '../models/misskey_user.dart';

/// フォローリクエスト関連API（`/api/following/requests/*`）
///
/// 受信したフォローリクエストの承認・拒否、
/// 送信済みリクエストの確認・キャンセルを提供する。
class FollowingRequestsApi {
  const FollowingRequestsApi({required this.http});

  final MisskeyHttp http;

  /// 受信したフォローリクエスト一覧を取得する（`/api/following/requests/list`）
  ///
  /// - [limit]: 取得件数 1〜100（デフォルト10）
  /// - [sinceId] / [untilId]: IDによるページング
  /// - [sinceDate] / [untilDate]: Unixタイムスタンプ（ms）によるページング
  Future<List<MisskeyFollowRequest>> list({
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
      '/following/requests/list',
      body: body,
      options: const RequestOptions(idempotent: true),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyFollowRequest.fromJson)
        .toList();
  }

  /// フォローリクエストを承認する（`/api/following/requests/accept`）
  ///
  /// - [userId]: リクエスト送信者のユーザーID（必須）
  ///
  /// 主なエラー:
  /// - `NO_SUCH_USER`: 対象ユーザーが存在しない
  /// - `NO_FOLLOW_REQUEST`: フォローリクエストが存在しない
  Future<void> accept({required String userId}) => http.send<Object?>(
        '/following/requests/accept',
        body: <String, dynamic>{'userId': userId},
      );

  /// フォローリクエストを拒否する（`/api/following/requests/reject`）
  ///
  /// - [userId]: リクエスト送信者のユーザーID（必須）
  ///
  /// 主なエラー:
  /// - `NO_SUCH_USER`: 対象ユーザーが存在しない
  Future<void> reject({required String userId}) => http.send<Object?>(
        '/following/requests/reject',
        body: <String, dynamic>{'userId': userId},
      );

  /// 送信済みフォローリクエストをキャンセルする（`/api/following/requests/cancel`）
  ///
  /// - [userId]: リクエスト送信先のユーザーID（必須）
  ///
  /// 主なエラー:
  /// - `NO_SUCH_USER`: 対象ユーザーが存在しない
  /// - `FOLLOW_REQUEST_NOT_FOUND`: フォローリクエストが存在しない
  Future<MisskeyUser> cancel({required String userId}) async {
    final res = await http.send<Map<String, dynamic>>(
      '/following/requests/cancel',
      body: <String, dynamic>{'userId': userId},
    );
    return MisskeyUser.fromJson(res);
  }

  /// 送信済みフォローリクエスト一覧を取得する（`/api/following/requests/sent`）
  ///
  /// - [limit]: 取得件数 1〜100（デフォルト10）
  /// - [sinceId] / [untilId]: IDによるページング
  /// - [sinceDate] / [untilDate]: Unixタイムスタンプ（ms）によるページング
  Future<List<MisskeyFollowRequest>> sent({
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
      '/following/requests/sent',
      body: body,
      options: const RequestOptions(idempotent: true),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyFollowRequest.fromJson)
        .toList();
  }
}
