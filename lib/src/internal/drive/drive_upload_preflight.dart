import 'package:meta/meta.dart';

import '../../api/account/account_api.dart';
import '../../api/drive/drive_stats_api.dart';
import '../../client/misskey_http.dart';
import '../../models/drive/drive_capacity_info.dart';
import '../../models/drive/drive_upload_preflight.dart';
import '../../models/meta.dart';
import '../../models/misskey_user.dart';

/// Fetches the data required to check a Drive upload.
@internal
Future<DriveUploadPreflight> getDriveUploadPreflight({
  required MisskeyHttp http,
  required DriveStatsApi stats,
  Meta? meta,
}) async {
  final results = await Future.wait<Object>([
    AccountApi(http: http).i(),
    stats.getCapacity(),
  ], eagerError: true);
  final user = results[0] as MisskeyUser;
  final capacity = results[1] as DriveCapacityInfo;
  return DriveUploadPreflight(
    policies: user.policies,
    capacity: capacity,
    bypassesPolicyLimits: user.isModerator == true || user.isAdmin == true,
    instanceMaxFileSize: meta?.maxFileSize,
  );
}
