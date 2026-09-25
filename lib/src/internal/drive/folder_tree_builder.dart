import 'dart:async';

import 'package:meta/meta.dart';

import '../../client/misskey_cancellation_token.dart';
import '../../models/batch/misskey_batch_result.dart';
import '../../models/drive/drive_folder_tree.dart';
import '../../models/misskey_drive_folder.dart';
import '../bounded_batch.dart';

/// Validates arguments accepted by the public folder-tree API.
@internal
void validateDriveFolderTreeArgs({
  required int? maxDepth,
  required int concurrency,
}) {
  if (maxDepth != null && maxDepth < 0) {
    throw ArgumentError.value(maxDepth, 'maxDepth', 'must not be negative');
  }
  validateConcurrency(concurrency);
}

/// Builds a Drive folder tree by loading each level concurrently.
@internal
Future<DriveFolderTree> buildDriveFolderTree({
  required Future<MisskeyDriveFolder> Function(String folderId) show,
  required Stream<MisskeyDriveFolder> Function(String? folderId) listAll,
  required String? rootFolderId,
  required int? maxDepth,
  required int concurrency,
  MisskeyCancellationToken? cancellation,
}) async {
  final foldersById = <String, MisskeyDriveFolder>{};
  final childIdsByParent = <String?, List<String>>{};
  final depthById = <String, int>{};
  final childrenLoadedById = <String, bool>{};
  final visited = <String>{};
  var rootChildrenLoaded = true;

  if (rootFolderId != null) {
    final rootFolder = await show(rootFolderId);
    foldersById[rootFolder.id] = rootFolder;
    depthById[rootFolder.id] = 0;
    visited.add(rootFolder.id);
  }

  var frontier = <String?>[rootFolderId];
  var depth = 1;
  while (frontier.isNotEmpty &&
      (maxDepth == null || depth <= maxDepth) &&
      !(cancellation?.isCancelled ?? false)) {
    final batch = await runBounded<String?, List<MisskeyDriveFolder>>(
      inputs: frontier,
      task: (parentId, _) =>
          _collectFolders(listAll(parentId), cancellation: cancellation),
      concurrency: concurrency,
      cancellation: cancellation,
      stopReasonFor: (_) => MisskeyBatchSkipReason.stoppedAfterError,
    );
    for (final item in batch.items) {
      if (item case MisskeyBatchFailure<String?, List<MisskeyDriveFolder>>()) {
        Error.throwWithStackTrace(item.error, item.stackTrace);
      }
    }

    final nextFrontier = <String?>[];
    for (final item in batch.successes) {
      final parentId = item.input;
      final childIds = childIdsByParent.putIfAbsent(parentId, () => []);
      if (parentId == null) {
        rootChildrenLoaded = true;
      } else {
        childrenLoadedById[parentId] = true;
      }
      for (final child in item.value) {
        if (!visited.add(child.id)) continue;
        foldersById[child.id] = child;
        depthById[child.id] = depth;
        childIds.add(child.id);
        nextFrontier.add(child.id);
      }
    }
    frontier = nextFrontier;
    depth++;
    if (cancellation?.isCancelled ?? false) break;
  }

  if (cancellation?.isCancelled ?? false) {
    rootChildrenLoaded = false;
  }
  if (frontier.isNotEmpty) {
    for (final folderId in frontier) {
      if (folderId == null) {
        rootChildrenLoaded = false;
      } else {
        childrenLoadedById[folderId] = false;
      }
    }
  }

  final nodesById = <String, DriveFolderNode>{};
  final folderIds = foldersById.keys.toList();
  for (final folderId in folderIds.reversed) {
    final children = [
      for (final childId in childIdsByParent[folderId] ?? const <String>[])
        nodesById[childId]!,
    ];
    nodesById[folderId] = DriveFolderNode(
      folder: foldersById[folderId]!,
      children: children,
      depth: depthById[folderId]!,
      childrenLoaded: childrenLoadedById[folderId] ?? false,
    );
  }

  final rootNode = rootFolderId == null ? null : nodesById[rootFolderId];
  final children =
      rootNode?.children ??
      [
        for (final childId in childIdsByParent[null] ?? const <String>[])
          nodesById[childId]!,
      ];
  return DriveFolderTree(
    rootNode: rootNode,
    children: children,
    maxDepth: maxDepth,
    rootChildrenLoaded: rootChildrenLoaded,
  );
}

Future<List<MisskeyDriveFolder>> _collectFolders(
  Stream<MisskeyDriveFolder> folders, {
  MisskeyCancellationToken? cancellation,
}) {
  final collected = <MisskeyDriveFolder>[];
  final result = Completer<List<MisskeyDriveFolder>>();
  late final StreamSubscription<MisskeyDriveFolder> subscription;

  Future<void> stop() async {
    if (!result.isCompleted) result.complete(collected);
    await subscription.cancel();
  }

  subscription = folders.listen(
    (folder) {
      if (cancellation?.isCancelled ?? false) return;
      collected.add(folder);
    },
    onError: (Object error, StackTrace stackTrace) {
      if (!result.isCompleted) result.completeError(error, stackTrace);
    },
    onDone: () {
      if (!result.isCompleted) result.complete(collected);
    },
    cancelOnError: true,
  );
  if (cancellation?.isCancelled ?? false) {
    unawaited(stop());
  } else {
    cancellation?.whenCancelled.then((_) => unawaited(stop()));
  }
  return result.future;
}
