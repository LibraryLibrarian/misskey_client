import 'package:meta/meta.dart';

import '../../api/drive/drive_files_api.dart';
import '../../api/drive/drive_folders_api.dart';
import '../../models/batch/misskey_batch_result.dart';
import '../../models/drive/drive_folder_dissolve_result.dart';
import '../../models/misskey_drive_folder.dart';
import '../bounded_batch.dart';

@internal
Future<DriveFolderDissolveResult> dissolveFolder({
  required String folderId,
  required int concurrency,
  required DriveFilesApi files,
  required DriveFoldersApi folders,
}) async {
  validateConcurrency(concurrency);

  final folder = await folders.show(folderId: folderId);
  final targetFolderId = folder.parentId;
  final fileIds = await files
      .listAll(folderId: folderId)
      .map((file) => file.id)
      .toList();
  final subfolderInputs = await folders.listAll(folderId: folderId).toList();

  final fileResults = await files.moveBulkAll(
    fileIds: fileIds,
    folderId: targetFolderId,
  );
  final subfolderResults = fileResults.isComplete
      ? await runBounded<MisskeyDriveFolder, MisskeyDriveFolder>(
          inputs: subfolderInputs,
          concurrency: concurrency,
          stopReasonFor: stopOnRateLimit,
          task: (subfolder, _) => targetFolderId == null
              ? folders.update(folderId: subfolder.id, moveToRoot: true)
              : folders.update(
                  folderId: subfolder.id,
                  parentId: targetFolderId,
                ),
        )
      : MisskeyBatchResult<MisskeyDriveFolder, MisskeyDriveFolder>(
          items: [
            for (var index = 0; index < subfolderInputs.length; index++)
              MisskeyBatchSkipped(
                input: subfolderInputs[index],
                index: index,
                reason: MisskeyBatchSkipReason.dependencyFailed,
              ),
          ],
        );

  late final MisskeyBatchItemResult<MisskeyDriveFolder, Null> deletion;
  if (fileResults.isComplete && subfolderResults.isComplete) {
    try {
      await folders.delete(folderId: folderId);
      deletion = MisskeyBatchSuccess(input: folder, index: 0, value: null);
    } catch (error, stackTrace) {
      deletion = MisskeyBatchFailure(
        input: folder,
        index: 0,
        error: error,
        stackTrace: stackTrace,
      );
    }
  } else {
    deletion = MisskeyBatchSkipped(
      input: folder,
      index: 0,
      reason: MisskeyBatchSkipReason.dependencyFailed,
    );
  }

  return DriveFolderDissolveResult(
    folder: folder,
    targetFolderId: targetFolderId,
    files: fileResults,
    subfolders: subfolderResults,
    deletion: deletion,
  );
}
