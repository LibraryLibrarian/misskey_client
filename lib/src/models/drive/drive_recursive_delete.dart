import 'package:meta/meta.dart';

import '../../internal/drive/folder_levels.dart';
import '../batch/misskey_batch_result.dart';
import '../misskey_drive_file.dart';
import '../misskey_drive_folder.dart';
import 'drive_folder_tree.dart';

/// The current phase of recursive folder deletion.
enum DriveRecursiveDeletePhase {
  /// Loading the tree and its files without changing the server.
  planning,

  /// Deleting the planned files.
  deletingFiles,

  /// Deleting folders from deepest to shallowest.
  deletingFolders,
}

/// Per-phase progress, including skipped items in [completed].
@immutable
final class DriveRecursiveDeleteProgress {
  /// Creates a progress snapshot.
  const DriveRecursiveDeleteProgress({
    required this.phase,
    required this.completed,
    required this.total,
    required this.failed,
  });

  /// The phase being reported.
  final DriveRecursiveDeletePhase phase;

  /// The number of settled items, including failures and skips.
  final int completed;

  /// The number of items in this phase.
  final int total;

  /// The number of failed items, excluding skips.
  final int failed;

  @override
  String toString() =>
      'DriveRecursiveDeleteProgress($phase, $completed/$total, failed: $failed)';
}

/// An immutable snapshot of the contents to delete, including the root folder.
@immutable
final class DriveRecursiveDeletePlan {
  /// Copies the map and each file list into unmodifiable collections.
  DriveRecursiveDeletePlan({
    required this.tree,
    required Map<String, List<MisskeyDriveFile>> filesByFolder,
  }) : assert(
         filesByFolder.keys.every(
           tree.nodes.map((node) => node.folder.id).toSet().contains,
         ),
       ),
       filesByFolder = Map.unmodifiable({
         for (final entry in filesByFolder.entries)
           entry.key: List<MisskeyDriveFile>.unmodifiable(entry.value),
       });

  /// The fully loaded tree rooted at the requested folder.
  final DriveFolderTree tree;

  /// Planned files keyed by their containing folder ID.
  ///
  /// Folders not listed before planning was cancelled have no entry.
  final Map<String, List<MisskeyDriveFile>> filesByFolder;

  /// All planned files in folder traversal order.
  List<MisskeyDriveFile> get files => List.unmodifiable([
    for (final node in tree.nodes) ...?filesByFolder[node.folder.id],
  ]);

  /// All planned folders, deepest first, including the root.
  List<MisskeyDriveFolder> get foldersDeepestFirst => List.unmodifiable([
    for (final level in driveFolderLevels(tree)) ...level,
  ]);

  /// The number of planned files.
  int get fileCount => files.length;

  /// The number of planned folders, including the root.
  int get folderCount => tree.folderCount;

  /// The total size of the planned files in bytes.
  int get totalBytes => files.fold(0, (sum, file) => sum + file.size);

  @override
  String toString() =>
      'DriveRecursiveDeletePlan(files: $fileCount, folders: $folderCount, '
      'totalBytes: $totalBytes)';
}

/// The plan and individual outcomes of recursive folder deletion.
@immutable
final class DriveRecursiveDeleteResult {
  /// Creates a recursive deletion result.
  const DriveRecursiveDeleteResult({
    required this.plan,
    required this.dryRun,
    required this.files,
    required this.folders,
  });

  /// The snapshot used for deletion.
  final DriveRecursiveDeletePlan plan;

  /// Whether only planning was performed.
  final bool dryRun;

  /// File outcomes, or an empty batch for a completed dry run.
  /// Cancelled planning returns skipped outcomes even for a dry run.
  final MisskeyBatchResult<MisskeyDriveFile, Null> files;

  /// Folder outcomes in deepest-first order, or empty for a completed dry run.
  /// Cancelled planning returns skipped outcomes even for a dry run.
  final MisskeyBatchResult<MisskeyDriveFolder, Null> folders;

  /// Whether deleting the root succeeded, including an already absent root.
  bool get rootDeleted => folders.successes.any(
    (item) => item.input.id == plan.tree.rootNode?.folder.id,
  );

  /// Whether deletion (not merely a dry run) completed successfully.
  bool get isComplete =>
      !dryRun && rootDeleted && files.isComplete && folders.isComplete;

  @override
  String toString() =>
      'DriveRecursiveDeleteResult(dryRun: $dryRun, rootDeleted: $rootDeleted, '
      'isComplete: $isComplete)';
}
