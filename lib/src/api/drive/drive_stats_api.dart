import '../../client/misskey_http.dart';
import '../../client/request_options.dart';
import '../../models/drive/drive_capacity_info.dart';

/// Driveの統計情報関連API
///
/// `/api/drive`、`/api/charts/drive`、`/api/charts/user/drive`
/// エンドポイントを [MisskeyHttp] に委譲して呼び出す
class DriveStatsApi {
  /// コンストラクタ
  const DriveStatsApi({required this.http});

  /// HTTPクライアント
  final MisskeyHttp http;

  /// ユーザーのドライブ容量情報を取得する（`/api/drive`）
  ///
  /// 現在認証中のユーザーのドライブ容量（上限と使用量）を返す。
  Future<DriveCapacityInfo> getCapacity() async {
    final res = await http.send<Map<String, dynamic>>(
      '/drive',
      body: <String, dynamic>{},
      options: const RequestOptions(idempotent: true),
    );
    return DriveCapacityInfo.fromJson(res);
  }

  /// インスタンス全体のドライブ統計情報を取得する
  /// （`/api/charts/drive`）
  ///
  /// ローカル・リモートファイルの増減に関する時系列データを返す
  ///
  /// - [span]: 集計期間（`'day'` または `'hour'`）
  /// - [limit]: 取得するデータ点数（1〜500、デフォルト30）
  /// - [offset]: データ取得開始位置のオフセット
  Future<Map<String, dynamic>> getInstanceDriveChart({
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
      '/charts/drive',
      body: body,
      options: const RequestOptions(
        authRequired: false,
        idempotent: true,
      ),
    );
    return res;
  }

  /// 指定ユーザーのドライブ統計情報を取得する
  /// （`/api/charts/user/drive`）
  ///
  /// 指定したユーザーが所有するファイルの統計情報を返す
  ///
  /// - [userId]: 対象ユーザーのID
  /// - [span]: 集計期間（`'day'` または `'hour'`）
  /// - [limit]: 取得するデータ点数（1〜500、デフォルト30）
  /// - [offset]: データ取得開始位置のオフセット
  Future<Map<String, dynamic>> getUserDriveChart({
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
      '/charts/user/drive',
      body: body,
      options: const RequestOptions(
        authRequired: false,
        idempotent: true,
      ),
    );
    return res;
  }
}
