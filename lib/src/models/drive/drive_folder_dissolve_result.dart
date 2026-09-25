import 'package:meta/meta.dart';

import '../batch/misskey_batch_result.dart';
import '../misskey_drive_folder.dart';
import 'drive_move_bulk_result.dart';

/// The outcome of dissolving a Drive folder into its parent or the root.
@immutable
final class DriveFolderDissolveResult {
  /// Creates a result containing the outcomes of each dissolve operation.
  const DriveFolderDissolveResult({
    required this.folder,
    required this.targetFolderId,
    required this.files,
    required this.subfolders,
    required this.deletion,
  });

  /// The folder that was dissolved.
  final MisskeyDriveFolder folder;

  /// The parent folder that received the contents, or `null` for the root.
  final String? targetFolderId;

  /// The outcomes of moving the folder's direct files.
  final DriveMoveBulkResult files;

  /// The outcomes of moving the folder's direct subfolders.
  final MisskeyBatchResult<MisskeyDriveFolder, MisskeyDriveFolder> subfolders;

  /// The outcome of deleting the now-empty folder.
  final MisskeyBatchItemResult<MisskeyDriveFolder, Null> deletion;

  /// Whether the source folder was deleted.
  bool get isComplete => deletion.isSuccess;

  @override
  String toString() =>
      'DriveFolderDissolveResult(folderId: ${folder.id}, targetFolderId: '
      '$targetFolderId, isComplete: $isComplete)';
}
