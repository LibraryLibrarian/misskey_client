import '../../client/misskey_http.dart';
import '../../client/request_options.dart';
import '../../models/misskey_drive_folder.dart';

/// Provides Drive folder operations (`/api/drive/folders/*`).
///
/// Delegates `/api/drive/folders` endpoint calls to [MisskeyHttp].
/// Authentication is handled by [MisskeyHttp]'s interceptor.
class DriveFoldersApi {
  /// Creates a [DriveFoldersApi] instance.
  const DriveFoldersApi({required this.http});

  /// The HTTP client used for requests.
  final MisskeyHttp http;

  /// Retrieves a list of Drive folders (`/api/drive/folders`).
  ///
  /// Use [limit] to cap the number of results (1-100, default 10).
  /// Paginate by ID with [sinceId] and [untilId], or by Unix timestamp (ms)
  /// with [sinceDate] and [untilDate]. Pass [folderId] to filter by parent
  /// folder, or omit it to list root-level folders.
  Future<List<MisskeyDriveFolder>> list({
    int? limit,
    String? sinceId,
    String? untilId,
    int? sinceDate,
    int? untilDate,
    String? folderId,
  }) async {
    final body = <String, dynamic>{
      if (limit != null) 'limit': limit,
      if (sinceId != null) 'sinceId': sinceId,
      if (untilId != null) 'untilId': untilId,
      if (sinceDate != null) 'sinceDate': sinceDate,
      if (untilDate != null) 'untilDate': untilDate,
      if (folderId != null) 'folderId': folderId,
    };
    final res = await http.send<List<dynamic>>(
      '/drive/folders',
      body: body,
      options: const RequestOptions(idempotent: true),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyDriveFolder.fromJson)
        .toList();
  }

  /// Creates a Drive folder (`/api/drive/folders/create`).
  ///
  /// Use [name] to set the folder name (up to 200 characters, default
  /// `'Untitled'`). Pass [parentId] to create the folder inside an existing
  /// folder, or omit it to create at root.
  Future<MisskeyDriveFolder> create({
    String? name,
    String? parentId,
  }) async {
    final body = <String, dynamic>{
      if (name != null) 'name': name,
      if (parentId != null) 'parentId': parentId,
    };
    final res = await http.send<Map<String, dynamic>>(
      '/drive/folders/create',
      body: body,
    );
    return MisskeyDriveFolder.fromJson(res);
  }

  /// Retrieves the details of a Drive folder (`/api/drive/folders/show`).
  ///
  /// Pass the target folder's ID as [folderId].
  Future<MisskeyDriveFolder> show({required String folderId}) async {
    final res = await http.send<Map<String, dynamic>>(
      '/drive/folders/show',
      body: <String, dynamic>{'folderId': folderId},
      options: const RequestOptions(idempotent: true),
    );
    return MisskeyDriveFolder.fromJson(res);
  }

  /// Updates the metadata of a Drive folder (`/api/drive/folders/update`).
  ///
  /// [folderId] is required. Use [name] to rename the folder (up to 200
  /// characters) and [parentId] to move it to a different parent. Set
  /// [moveToRoot] to `true` to move the folder to root, which sends
  /// `parentId: null` explicitly.
  Future<MisskeyDriveFolder> update({
    required String folderId,
    String? name,
    String? parentId,
    bool moveToRoot = false,
  }) async {
    final body = <String, dynamic>{
      'folderId': folderId,
      if (name != null) 'name': name,
      if (moveToRoot)
        'parentId': null
      else if (parentId != null)
        'parentId': parentId,
    };
    final res = await http.send<Map<String, dynamic>>(
      '/drive/folders/update',
      body: body,
    );
    return MisskeyDriveFolder.fromJson(res);
  }

  /// Deletes a Drive folder (`/api/drive/folders/delete`).
  ///
  /// Pass the target folder's ID as [folderId]. Fails if the folder contains
  /// child files or subfolders.
  Future<void> delete({required String folderId}) => http.send<Object?>(
        '/drive/folders/delete',
        body: <String, dynamic>{'folderId': folderId},
      );

  /// Searches the Drive by folder name (`/api/drive/folders/find`).
  ///
  /// Pass the folder name to search for as [name]. Use [parentId] to restrict
  /// the search to a specific parent folder, or omit it to search at root.
  Future<List<MisskeyDriveFolder>> find({
    required String name,
    String? parentId,
  }) async {
    final body = <String, dynamic>{
      'name': name,
      if (parentId != null) 'parentId': parentId,
    };
    final res = await http.send<List<dynamic>>(
      '/drive/folders/find',
      body: body,
      options: const RequestOptions(idempotent: true),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyDriveFolder.fromJson)
        .toList();
  }
}
