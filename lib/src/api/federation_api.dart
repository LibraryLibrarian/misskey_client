import '../client/auth_mode.dart';
import '../client/misskey_http.dart';
import '../client/request_options.dart';
import '../models/federation/misskey_federation_instance.dart';
import '../models/federation/misskey_federation_stats.dart';
import '../models/misskey_following.dart';
import '../models/misskey_user.dart';

/// 連合（フェデレーション）関連API（`/api/federation/*`）
///
/// 連合インスタンスの一覧・詳細・フォロー関係・統計情報の取得を提供する。
class FederationApi {
  const FederationApi({required this.http});

  final MisskeyHttp http;

  /// 連合インスタンス一覧を取得する（`/api/federation/instances`）
  ///
  /// 認証不要。レスポンスは3600秒間キャッシュされる。
  ///
  /// - [host]: ホスト名でフィルタ（`null`でフィルタなし）
  /// - [blocked]: ブロック状態でフィルタ
  /// - [notResponding]: 応答なし状態でフィルタ
  /// - [suspended]: 停止状態でフィルタ
  /// - [silenced]: サイレンス状態でフィルタ
  /// - [federating]: 連合中かどうかでフィルタ
  /// - [subscribing]: 購読中かどうかでフィルタ
  /// - [publishing]: 配信中かどうかでフィルタ
  /// - [limit]: 取得件数 1〜100（デフォルト: 30）
  /// - [offset]: スキップ件数（デフォルト: 0）
  /// - [sort]: ソート順。以下のいずれかを指定:
  ///   `+pubSub` / `-pubSub` / `+notes` / `-notes` /
  ///   `+users` / `-users` / `+following` / `-following` /
  ///   `+followers` / `-followers` /
  ///   `+firstRetrievedAt` / `-firstRetrievedAt` /
  ///   `+latestRequestReceivedAt` / `-latestRequestReceivedAt`
  Future<List<MisskeyFederationInstance>> instances({
    String? host,
    bool? blocked,
    bool? notResponding,
    bool? suspended,
    bool? silenced,
    bool? federating,
    bool? subscribing,
    bool? publishing,
    int? limit,
    int? offset,
    String? sort,
  }) async {
    final body = <String, dynamic>{
      if (host != null) 'host': host,
      if (blocked != null) 'blocked': blocked,
      if (notResponding != null) 'notResponding': notResponding,
      if (suspended != null) 'suspended': suspended,
      if (silenced != null) 'silenced': silenced,
      if (federating != null) 'federating': federating,
      if (subscribing != null) 'subscribing': subscribing,
      if (publishing != null) 'publishing': publishing,
      if (limit != null) 'limit': limit,
      if (offset != null) 'offset': offset,
      if (sort != null) 'sort': sort,
    };
    final res = await http.send<List<dynamic>>(
      '/federation/instances',
      body: body,
      options: const RequestOptions(
        authMode: AuthMode.none,
        idempotent: true,
      ),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyFederationInstance.fromJson)
        .toList();
  }

  /// 連合インスタンスの詳細情報を取得する（`/api/federation/show-instance`）
  ///
  /// 認証不要。インスタンスが未知の場合は `null` を返す。
  ///
  /// - [host]: ホスト名（必須）
  Future<MisskeyFederationInstance?> showInstance({
    required String host,
  }) async {
    final res = await http.send<Map<String, dynamic>?>(
      '/federation/show-instance',
      body: <String, dynamic>{'host': host},
      options: const RequestOptions(
        authMode: AuthMode.none,
        idempotent: true,
      ),
    );
    if (res == null) return null;
    return MisskeyFederationInstance.fromJson(res);
  }

  /// 指定インスタンスからのフォロワー一覧を取得する（`/api/federation/followers`）
  ///
  /// 認証不要。
  ///
  /// - [host]: ホスト名（必須）
  /// - [limit]: 取得件数 1〜100（デフォルト: 10）
  /// - [sinceId] / [untilId]: IDによるページング
  /// - [sinceDate] / [untilDate]: Unixタイムスタンプ（ms）によるページング
  Future<List<MisskeyFollowing>> followers({
    required String host,
    int? limit,
    String? sinceId,
    String? untilId,
    int? sinceDate,
    int? untilDate,
  }) async {
    final body = <String, dynamic>{
      'host': host,
      if (limit != null) 'limit': limit,
      if (sinceId != null) 'sinceId': sinceId,
      if (untilId != null) 'untilId': untilId,
      if (sinceDate != null) 'sinceDate': sinceDate,
      if (untilDate != null) 'untilDate': untilDate,
    };
    final res = await http.send<List<dynamic>>(
      '/federation/followers',
      body: body,
      options: const RequestOptions(
        authMode: AuthMode.none,
        idempotent: true,
      ),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyFollowing.fromJson)
        .toList();
  }

  /// 指定インスタンスへのフォロー一覧を取得する（`/api/federation/following`）
  ///
  /// 認証不要。
  ///
  /// - [host]: ホスト名（必須）
  /// - [limit]: 取得件数 1〜100（デフォルト: 10）
  /// - [sinceId] / [untilId]: IDによるページング
  /// - [sinceDate] / [untilDate]: Unixタイムスタンプ（ms）によるページング
  Future<List<MisskeyFollowing>> following({
    required String host,
    int? limit,
    String? sinceId,
    String? untilId,
    int? sinceDate,
    int? untilDate,
  }) async {
    final body = <String, dynamic>{
      'host': host,
      if (limit != null) 'limit': limit,
      if (sinceId != null) 'sinceId': sinceId,
      if (untilId != null) 'untilId': untilId,
      if (sinceDate != null) 'sinceDate': sinceDate,
      if (untilDate != null) 'untilDate': untilDate,
    };
    final res = await http.send<List<dynamic>>(
      '/federation/following',
      body: body,
      options: const RequestOptions(
        authMode: AuthMode.none,
        idempotent: true,
      ),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyFollowing.fromJson)
        .toList();
  }

  /// 指定インスタンスのユーザー一覧を取得する（`/api/federation/users`）
  ///
  /// 認証不要。
  ///
  /// - [host]: ホスト名（必須）
  /// - [limit]: 取得件数 1〜100（デフォルト: 10）
  /// - [sinceId] / [untilId]: IDによるページング
  /// - [sinceDate] / [untilDate]: Unixタイムスタンプ（ms）によるページング
  Future<List<MisskeyUser>> users({
    required String host,
    int? limit,
    String? sinceId,
    String? untilId,
    int? sinceDate,
    int? untilDate,
  }) async {
    final body = <String, dynamic>{
      'host': host,
      if (limit != null) 'limit': limit,
      if (sinceId != null) 'sinceId': sinceId,
      if (untilId != null) 'untilId': untilId,
      if (sinceDate != null) 'sinceDate': sinceDate,
      if (untilDate != null) 'untilDate': untilDate,
    };
    final res = await http.send<List<dynamic>>(
      '/federation/users',
      body: body,
      options: const RequestOptions(
        authMode: AuthMode.none,
        idempotent: true,
      ),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyUser.fromJson)
        .toList();
  }

  /// 連合の統計情報を取得する（`/api/federation/stats`）
  ///
  /// フォロワー数/フォロー数上位のインスタンスとその合計を返す。認証不要。
  ///
  /// - [limit]: 上位インスタンスの取得件数 1〜100（デフォルト: 10）
  Future<MisskeyFederationStats> stats({int? limit}) async {
    final body = <String, dynamic>{
      if (limit != null) 'limit': limit,
    };
    final res = await http.send<Map<String, dynamic>>(
      '/federation/stats',
      body: body,
      options: const RequestOptions(
        authMode: AuthMode.none,
        idempotent: true,
      ),
    );
    return MisskeyFederationStats.fromJson(res);
  }

  /// リモートユーザーの情報を再取得する（`/api/federation/update-remote-user`）
  ///
  /// 指定したリモートユーザーのActivityPub情報を再フェッチする。認証必須。
  ///
  /// - [userId]: 更新対象のユーザーID（必須）
  Future<void> updateRemoteUser({required String userId}) =>
      http.send<Object?>(
        '/federation/update-remote-user',
        body: <String, dynamic>{'userId': userId},
      );
}
