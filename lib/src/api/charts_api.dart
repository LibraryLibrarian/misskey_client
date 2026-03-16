import '../client/auth_mode.dart';
import '../client/misskey_http.dart';
import '../client/request_options.dart';

/// 統計チャート関連API
///
/// `/api/charts/*` エンドポイントを [MisskeyHttp] に委譲して呼び出す。
/// 各メソッドはネストされた `Map<String, dynamic>` を返し、
/// リーフ値はすべて `List<num>`（時系列データ）となる。
class ChartsApi {
  /// コンストラクタ
  const ChartsApi({required this.http});

  /// HTTPクライアント
  final MisskeyHttp http;

  /// アクティブユーザー統計を取得する（`/api/charts/active-users`）
  ///
  /// レスポンスフィールド:
  /// `readWrite`, `read`, `write`,
  /// `registeredWithinWeek`, `registeredWithinMonth`, `registeredWithinYear`,
  /// `registeredOutsideWeek`, `registeredOutsideMonth`, `registeredOutsideYear`
  ///
  /// - [span]: 集計期間（`'day'` または `'hour'`）
  /// - [limit]: 取得するデータ点数（1〜500、デフォルト30）
  /// - [offset]: データ取得開始位置のオフセット
  Future<Map<String, dynamic>> getActiveUsers({
    required String span,
    int? limit,
    int? offset,
  }) {
    return _fetchChart('/charts/active-users', span: span, limit: limit, offset: offset);
  }

  /// ActivityPubリクエスト統計を取得する（`/api/charts/ap-request`）
  ///
  /// レスポンスフィールド:
  /// `deliverFailed`, `deliverSucceeded`, `inboxReceived`
  ///
  /// - [span]: 集計期間（`'day'` または `'hour'`）
  /// - [limit]: 取得するデータ点数（1〜500、デフォルト30）
  /// - [offset]: データ取得開始位置のオフセット
  Future<Map<String, dynamic>> getApRequest({
    required String span,
    int? limit,
    int? offset,
  }) {
    return _fetchChart('/charts/ap-request', span: span, limit: limit, offset: offset);
  }

  /// 連合統計を取得する（`/api/charts/federation`）
  ///
  /// レスポンスフィールド:
  /// `deliveredInstances`, `inboxInstances`, `stalled`,
  /// `sub`, `pub`, `pubsub`, `subActive`, `pubActive`
  ///
  /// - [span]: 集計期間（`'day'` または `'hour'`）
  /// - [limit]: 取得するデータ点数（1〜500、デフォルト30）
  /// - [offset]: データ取得開始位置のオフセット
  Future<Map<String, dynamic>> getFederation({
    required String span,
    int? limit,
    int? offset,
  }) {
    return _fetchChart('/charts/federation', span: span, limit: limit, offset: offset);
  }

  /// 特定インスタンスの統計を取得する（`/api/charts/instance`）
  ///
  /// レスポンスフィールド（ネスト構造）:
  /// `requests.{failed, succeeded, received}`,
  /// `notes.{total, inc, dec, diffs.{normal, reply, renote, withFile}}`,
  /// `users.{total, inc, dec}`,
  /// `following.{total, inc, dec}`,
  /// `followers.{total, inc, dec}`,
  /// `drive.{totalFiles, incFiles, decFiles, incUsage, decUsage}`
  ///
  /// - [host]: 対象インスタンスのホスト名
  /// - [span]: 集計期間（`'day'` または `'hour'`）
  /// - [limit]: 取得するデータ点数（1〜500、デフォルト30）
  /// - [offset]: データ取得開始位置のオフセット
  Future<Map<String, dynamic>> getInstance({
    required String host,
    required String span,
    int? limit,
    int? offset,
  }) async {
    final body = <String, dynamic>{
      'host': host,
      'span': span,
      if (limit != null) 'limit': limit,
      if (offset != null) 'offset': offset,
    };
    final res = await http.send<Map<String, dynamic>>(
      '/charts/instance',
      body: body,
      options: const RequestOptions(
        authMode: AuthMode.none,
        idempotent: true,
      ),
    );
    return res;
  }

  /// ノート統計を取得する（`/api/charts/notes`）
  ///
  /// レスポンスフィールド（ネスト構造）:
  /// `local.{total, inc, dec, diffs.{normal, reply, renote, withFile}}`,
  /// `remote.{total, inc, dec, diffs.{normal, reply, renote, withFile}}`
  ///
  /// - [span]: 集計期間（`'day'` または `'hour'`）
  /// - [limit]: 取得するデータ点数（1〜500、デフォルト30）
  /// - [offset]: データ取得開始位置のオフセット
  Future<Map<String, dynamic>> getNotes({
    required String span,
    int? limit,
    int? offset,
  }) {
    return _fetchChart('/charts/notes', span: span, limit: limit, offset: offset);
  }

  /// ユーザー統計を取得する（`/api/charts/users`）
  ///
  /// レスポンスフィールド（ネスト構造）:
  /// `local.{total, inc, dec}`,
  /// `remote.{total, inc, dec}`
  ///
  /// - [span]: 集計期間（`'day'` または `'hour'`）
  /// - [limit]: 取得するデータ点数（1〜500、デフォルト30）
  /// - [offset]: データ取得開始位置のオフセット
  Future<Map<String, dynamic>> getUsers({
    required String span,
    int? limit,
    int? offset,
  }) {
    return _fetchChart('/charts/users', span: span, limit: limit, offset: offset);
  }

  /// 指定ユーザーのフォロー統計を取得する（`/api/charts/user/following`）
  ///
  /// レスポンスフィールド（ネスト構造）:
  /// `local.followings.{total, inc, dec}`,
  /// `local.followers.{total, inc, dec}`,
  /// `remote.followings.{total, inc, dec}`,
  /// `remote.followers.{total, inc, dec}`
  ///
  /// - [userId]: 対象ユーザーのID
  /// - [span]: 集計期間（`'day'` または `'hour'`）
  /// - [limit]: 取得するデータ点数（1〜500、デフォルト30）
  /// - [offset]: データ取得開始位置のオフセット
  Future<Map<String, dynamic>> getUserFollowing({
    required String userId,
    required String span,
    int? limit,
    int? offset,
  }) {
    return _fetchUserChart('/charts/user/following', userId: userId, span: span, limit: limit, offset: offset);
  }

  /// 指定ユーザーのノート統計を取得する（`/api/charts/user/notes`）
  ///
  /// レスポンスフィールド（ネスト構造）:
  /// `total`, `inc`, `dec`,
  /// `diffs.{normal, reply, renote, withFile}`
  ///
  /// - [userId]: 対象ユーザーのID
  /// - [span]: 集計期間（`'day'` または `'hour'`）
  /// - [limit]: 取得するデータ点数（1〜500、デフォルト30）
  /// - [offset]: データ取得開始位置のオフセット
  Future<Map<String, dynamic>> getUserNotes({
    required String userId,
    required String span,
    int? limit,
    int? offset,
  }) {
    return _fetchUserChart('/charts/user/notes', userId: userId, span: span, limit: limit, offset: offset);
  }

  /// 指定ユーザーのページビュー統計を取得する（`/api/charts/user/pv`）
  ///
  /// レスポンスフィールド（ネスト構造）:
  /// `upv.{user, visitor}`,
  /// `pv.{user, visitor}`
  ///
  /// - [userId]: 対象ユーザーのID
  /// - [span]: 集計期間（`'day'` または `'hour'`）
  /// - [limit]: 取得するデータ点数（1〜500、デフォルト30）
  /// - [offset]: データ取得開始位置のオフセット
  Future<Map<String, dynamic>> getUserPv({
    required String userId,
    required String span,
    int? limit,
    int? offset,
  }) {
    return _fetchUserChart('/charts/user/pv', userId: userId, span: span, limit: limit, offset: offset);
  }

  /// 指定ユーザーのリアクション統計を取得する（`/api/charts/user/reactions`）
  ///
  /// レスポンスフィールド（ネスト構造）:
  /// `local.{count}`,
  /// `remote.{count}`
  ///
  /// - [userId]: 対象ユーザーのID
  /// - [span]: 集計期間（`'day'` または `'hour'`）
  /// - [limit]: 取得するデータ点数（1〜500、デフォルト30）
  /// - [offset]: データ取得開始位置のオフセット
  Future<Map<String, dynamic>> getUserReactions({
    required String userId,
    required String span,
    int? limit,
    int? offset,
  }) {
    return _fetchUserChart('/charts/user/reactions', userId: userId, span: span, limit: limit, offset: offset);
  }

  /// 共通のチャートデータ取得処理（サーバー全体用）
  Future<Map<String, dynamic>> _fetchChart(
    String path, {
    required String span,
    int? limit,
    int? offset,
  }) async {
    final body = <String, dynamic>{
      'span': span,
      if (limit != null) 'limit': limit,
      if (offset != null) 'offset': offset,
    };
    final res = await http.send<Map<String, dynamic>>(
      path,
      body: body,
      options: const RequestOptions(
        authMode: AuthMode.none,
        idempotent: true,
      ),
    );
    return res;
  }

  /// 共通のチャートデータ取得処理（ユーザー別用）
  Future<Map<String, dynamic>> _fetchUserChart(
    String path, {
    required String userId,
    required String span,
    int? limit,
    int? offset,
  }) async {
    final body = <String, dynamic>{
      'userId': userId,
      'span': span,
      if (limit != null) 'limit': limit,
      if (offset != null) 'offset': offset,
    };
    final res = await http.send<Map<String, dynamic>>(
      path,
      body: body,
      options: const RequestOptions(
        authMode: AuthMode.none,
        idempotent: true,
      ),
    );
    return res;
  }
}
