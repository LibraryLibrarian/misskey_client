import 'package:meta/meta.dart';

import '../../client/misskey_http.dart';
import '../../client/request_options.dart';
import '../../internal/drive/folder_tree_builder.dart';
import '../../internal/id_paginator.dart';
import '../../models/drive/drive_folder_tree.dart';
import '../../models/misskey_drive_folder.dart';

/// Provides Drive folder operations (`/api/drive/folders/*`).
///
/// Delegates `/api/drive/folders` endpoint calls to [MisskeyHttp].
/// Authentication is handled by [MisskeyHttp]'s interceptor.
class DriveFoldersApi {
  /// Creates a [DriveFoldersApi] instance.
  const DriveFoldersApi({required this.http});

  /// The HTTP client used for requests.
  @internal
  final MisskeyHttp http;

  /// Lazily retrieves all folders in newest-first ID order.
  ///
  /// Only ID order is supported: the server applies `untilId` as an ID filter
  /// even when sorting by name or size, causing pages to skip or repeat items.
  /// Collect the results and sort locally for other orders. This is not a
  /// snapshot; changes on the server during pagination may affect results.
  ///
  /// [folderId] selects the parent folder; omit it for root-level items.
  /// [pageSize] must be 1-100 and [maxItems] must be non-negative, or an
  /// [ArgumentError] is thrown synchronously. A zero [maxItems] sends no request.
  ///
  /// Each call returns a cold, single-subscription stream: requests start only
  /// when listened to. API errors are delivered as stream errors after any
  /// already-yielded items.
  Stream<MisskeyDriveFolder> listAll({
    String? folderId,
    int pageSize = 100,
    int? maxItems,
  }) {
    validatePageArgs(pageSize, maxItems);
    return paginateById(
      fetchPage: (limit, untilId) =>
          list(limit: limit, untilId: untilId, folderId: folderId),
      idOf: (item) => item.id,
      pageSize: pageSize,
      maxItems: maxItems,
    );
  }

  /// Retrieves an immutable hierarchy of Drive folders.
  ///
  /// This makes one or more list requests for each visited folder. It is
  /// read-only, so any request failure aborts traversal and is rethrown. The
  /// result is not a snapshot; folder changes during traversal may be reflected
  /// inconsistently.
  ///
  /// Set [rootFolderId] to start at that folder, or omit it to start at the
  /// Drive root. [maxDepth] must be non-negative when specified. At the depth
  /// limit, folders remain in the result but have [DriveFolderNode.childrenLoaded]
  /// set to `false`. [concurrency] must be at least one. Invalid arguments throw
  /// [ArgumentError] before a request is made.
  Future<DriveFolderTree> getTree({
    String? rootFolderId,
    int? maxDepth,
    int concurrency = 4,
  }) {
    validateDriveFolderTreeArgs(maxDepth: maxDepth, concurrency: concurrency);
    return buildDriveFolderTree(
      show: (folderId) => show(folderId: folderId),
      listAll: (folderId) => listAll(folderId: folderId),
      rootFolderId: rootFolderId,
      maxDepth: maxDepth,
      concurrency: concurrency,
    );
  }

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
      'limit': ?limit,
      'sinceId': ?sinceId,
      'untilId': ?untilId,
      'sinceDate': ?sinceDate,
      'untilDate': ?untilDate,
      'folderId': ?folderId,
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
  Future<MisskeyDriveFolder> create({String? name, String? parentId}) async {
    final body = <String, dynamic>{'name': ?name, 'parentId': ?parentId};
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
      'name': ?name,
      if (moveToRoot) 'parentId': null else 'parentId': ?parentId,
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
    final body = <String, dynamic>{'name': name, 'parentId': ?parentId};
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
