import '../../client/misskey_http.dart';
import 'drive_files_api.dart';
import 'drive_folders_api.dart';
import 'drive_stats_api.dart';

/// Drive関連APIのファサード
///
/// [files]・[folders]・[stats] を束ねて単一のアクセスポイントを提供
class DriveApi {
  /// コンストラクタ
  DriveApi({required MisskeyHttp http})
      : files = DriveFilesApi(http: http),
        folders = DriveFoldersApi(http: http),
        stats = DriveStatsApi(http: http);

  /// ドライブファイル関連API
  final DriveFilesApi files;

  /// ドライブフォルダ関連API
  final DriveFoldersApi folders;

  /// ドライブ統計情報関連API
  final DriveStatsApi stats;
}
