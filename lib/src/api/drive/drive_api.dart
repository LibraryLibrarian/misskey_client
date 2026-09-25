import '../../client/misskey_http.dart';
import '../../client/request_options.dart';
import '../../exception/misskey_client_exception.dart';
import '../../internal/drive/url_upload_waiter.dart' as url_upload_waiter;
import '../../models/misskey_drive_file.dart';
import '../../streaming/misskey_streaming.dart';
import '../../streaming/streaming_subscription.dart';
import 'drive_files_api.dart';
import 'drive_folders_api.dart';
import 'drive_stats_api.dart';

/// Serves as a facade for Drive-related APIs.
///
/// Aggregates [files], [folders], and [stats] into a single access point,
/// and also provides top-level `/api/drive/*` endpoints directly.
class DriveApi {
  /// Creates a [DriveApi] instance.
  DriveApi({required MisskeyHttp http, MisskeyStreaming Function()? streaming})
    : _http = http,
      _streaming = streaming,
      files = DriveFilesApi(http: http),
      folders = DriveFoldersApi(http: http),
      stats = DriveStatsApi(http: http);

  final MisskeyHttp _http;
  final MisskeyStreaming Function()? _streaming;

  /// Provides Drive file operations.
  final DriveFilesApi files;

  /// Provides Drive folder operations.
  final DriveFoldersApi folders;

  /// Provides Drive statistics operations.
  final DriveStatsApi stats;

  /// Uploads the file at [url] to the Drive and waits for its
  /// `urlUploadFinished` event.
  ///
  /// Requires `write:drive` and `read:account`. Before calling, subscribe to
  /// `MisskeyStreamingChannel.main()` and connect the streaming client. Uses
  /// [mainSubscription] when supplied, otherwise the first registered main
  /// subscription. Never subscribes, connects, or disconnects automatically.
  ///
  /// The server sends no event on upload failure, so server-side failures
  /// surface only as a timeout. A timeout does not cancel the server-side
  /// upload. The [timeout] starts after the upload-from-url request completes.
  /// Events arriving during reconnect are lost.
  ///
  /// A caller-supplied [marker] must be non-empty and unique for each upload.
  /// Otherwise a secure random marker is generated. Server deduplication may
  /// return an existing file located in another folder.
  ///
  /// Throws [StateError] if no main subscription is available, it is inactive,
  /// or its owning streaming client is not connected; [ArgumentError] for a
  /// non-main subscription or empty marker; [MisskeyStreamingTimeoutException]
  /// when the wait times out; [MisskeyStreamingSubscriptionException] if the
  /// subscription closes while waiting; and [MisskeyStreamingProtocolException]
  /// if the matching event cannot be decoded.
  Future<MisskeyDriveFile> uploadFromUrlAndWait({
    required String url,
    String? folderId,
    bool? isSensitive,
    String? comment,
    bool? force,
    String? marker,
    MisskeyStreamingSubscription? mainSubscription,
    Duration timeout = const Duration(minutes: 2),
  }) => url_upload_waiter.uploadFromUrlAndWait(
    files: files,
    streaming: _streaming,
    url: url,
    folderId: folderId,
    isSensitive: isSensitive,
    comment: comment,
    force: force,
    marker: marker,
    mainSubscription: mainSubscription,
    timeout: timeout,
  );

  /// Retrieves all files in the Drive regardless of folder
  /// (`/api/drive/stream`).
  ///
  /// Unlike [DriveFilesApi.list], this endpoint does not support folder
  /// filtering or sorting, and is specialized for MIME type filtering
  /// and pagination.
  ///
  /// [limit] caps the number of results (1-100, default 10). Use [sinceId]
  /// and [untilId] to paginate by ID, or [sinceDate] and [untilDate] to
  /// paginate by Unix timestamp in milliseconds. Pass [type] to filter by MIME
  /// type pattern (e.g., `"image/*"`).
  Future<List<MisskeyDriveFile>> stream({
    int? limit,
    String? sinceId,
    String? untilId,
    int? sinceDate,
    int? untilDate,
    String? type,
  }) async {
    final body = <String, dynamic>{
      'limit': ?limit,
      'sinceId': ?sinceId,
      'untilId': ?untilId,
      'sinceDate': ?sinceDate,
      'untilDate': ?untilDate,
      'type': ?type,
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
