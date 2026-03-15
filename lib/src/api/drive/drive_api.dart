import '../../client/misskey_http.dart';
import '../../client/request_options.dart';
import '../../models/misskey_drive_file.dart';
import 'drive_files_api.dart';
import 'drive_folders_api.dart';
import 'drive_stats_api.dart';

/// Drive関連APIのファサード
///
/// [files]・[folders]・[stats] を束ねて単一のアクセスポイントを提供し、
/// トップレベルの `/api/drive/*` エンドポイントも直接提供する。
class DriveApi {
  /// コンストラクタ
  DriveApi({required MisskeyHttp http})
      : _http = http,
        files = DriveFilesApi(http: http),
        folders = DriveFoldersApi(http: http),
        stats = DriveStatsApi(http: http);

  final MisskeyHttp _http;

  /// ドライブファイル関連API
  final DriveFilesApi files;

  /// ドライブフォルダ関連API
  final DriveFoldersApi folders;

  /// ドライブ統計情報関連API
  final DriveStatsApi stats;

  /// フォルダを問わずドライブ内の全ファイルを取得する
  /// （`/api/drive/stream`）
  ///
  /// [DriveFilesApi.list] とは異なり、フォルダ指定やソートは無く、
  /// MIMEタイプフィルタとページネーションに特化したエンドポイント。
  ///
  /// - [limit]: 取得件数（1〜100、デフォルト10）
  /// - [sinceId] / [untilId]: IDによるページング
  /// - [sinceDate] / [untilDate]: Unixタイムスタンプ（ms）によるページング
  /// - [type]: MIMEタイプパターンで絞り込む（例: `"image/*"`）
  Future<List<MisskeyDriveFile>> stream({
    int? limit,
    String? sinceId,
    String? untilId,
    int? sinceDate,
    int? untilDate,
    String? type,
  }) async {
    final body = <String, dynamic>{
      if (limit != null) 'limit': limit,
      if (sinceId != null) 'sinceId': sinceId,
      if (untilId != null) 'untilId': untilId,
      if (sinceDate != null) 'sinceDate': sinceDate,
      if (untilDate != null) 'untilDate': untilDate,
      if (type != null) 'type': type,
    };
    final res = await _http.send<List<dynamic>>(
      '/drive/stream',
      body: body,
      options: const RequestOptions(idempotent: true),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyDriveFile.fromJson)
        .toList();
  }
}
