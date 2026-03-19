import '../../client/auth_mode.dart';
import '../../client/misskey_http.dart';
import '../../client/request_options.dart';
import '../../models/drive/drive_capacity_info.dart';

/// Provides Drive statistics operations.
///
/// Delegates to `/api/drive`, `/api/charts/drive`, and
/// `/api/charts/user/drive` endpoints via [MisskeyHttp].
class DriveStatsApi {
  /// Creates a [DriveStatsApi] instance.
  const DriveStatsApi({required this.http});

  /// The HTTP client used for requests.
  final MisskeyHttp http;

  /// Retrieves the Drive capacity information for the authenticated user
  /// (`/api/drive`).
  ///
  /// Returns the Drive capacity limit and current usage.
  Future<DriveCapacityInfo> getCapacity() async {
    final res = await http.send<Map<String, dynamic>>(
      '/drive',
      body: <String, dynamic>{},
      options: const RequestOptions(idempotent: true),
    );
    return DriveCapacityInfo.fromJson(res);
  }

  /// Retrieves the instance-wide Drive statistics chart
  /// (`/api/charts/drive`).
  ///
  /// Returns time-series data on local/remote file changes. Use [span] to
  /// set the aggregation period (`'day'` or `'hour'`), [limit] to cap the
  /// number of data points (1-500, default 30), and [offset] to shift the
  /// retrieval start position.
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
        authMode: AuthMode.none,
        idempotent: true,
      ),
    );
    return res;
  }

  /// Retrieves Drive statistics for a specific user
  /// (`/api/charts/user/drive`).
  ///
  /// Returns statistics about files owned by the user identified by [userId].
  /// Use [span] to set the aggregation period (`'day'` or `'hour'`), [limit]
  /// to cap the number of data points (1-500, default 30), and [offset] to
  /// shift the retrieval start position.
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
        authMode: AuthMode.none,
        idempotent: true,
      ),
    );
    return res;
  }
}
