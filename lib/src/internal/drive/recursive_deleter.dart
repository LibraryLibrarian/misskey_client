import 'package:meta/meta.dart';

import '../../api/drive/drive_files_api.dart';
import '../../api/drive/drive_folders_api.dart';
import '../../client/misskey_cancellation_token.dart';
import '../../exception/misskey_client_exception.dart';
import '../../models/batch/misskey_batch_result.dart';
import '../../models/drive/drive_recursive_delete.dart';
import '../../models/misskey_drive_file.dart';
import '../../models/misskey_drive_folder.dart';
import '../bounded_batch.dart';

/// Plans and performs recursive deletion. [delay] allows deterministic tests.
@internal
Future<DriveRecursiveDeleteResult> deleteDriveFolderRecursive({
  required DriveFilesApi files,
  required DriveFoldersApi folders,
  required String folderId,
  bool dryRun = false,
  int concurrency = 4,
  void Function(DriveRecursiveDeleteProgress progress)? onProgress,
  MisskeyCancellationToken? cancellation,
  Future<void> Function(Duration duration) delay = Future<void>.delayed,
}) async {
  validateConcurrency(concurrency);
  final tree = await folders.getTree(
    rootFolderId: folderId,
    concurrency: concurrency,
  );
  var phase = DriveRecursiveDeletePhase.planning;
  var total = tree.folderCount;
  var completed = 0;
  var failed = 0;
  void notify() => onProgress?.call(
    DriveRecursiveDeleteProgress(
      phase: phase,
      completed: completed,
      total: total,
      failed: failed,
    ),
  );

  void record<I, T>(MisskeyBatchItemResult<I, T> item) {
    completed++;
    if (item is MisskeyBatchFailure<I, T>) failed++;
    notify();
  }

  notify();
  final listing = await runBounded<MisskeyDriveFolder, List<MisskeyDriveFile>>(
    inputs: [for (final node in tree.nodes) node.folder],
    task: (folder, _) => files.listAll(folderId: folder.id).toList(),
    concurrency: concurrency,
    stopReasonFor: (_) => MisskeyBatchSkipReason.stoppedAfterError,
    onResult: record,
  );
  for (final failure in listing.failures) {
    Error.throwWithStackTrace(failure.error, failure.stackTrace);
  }
  final plan = DriveRecursiveDeletePlan(
    tree: tree,
    filesByFolder: {
      for (final item in listing.successes) item.input.id: item.value,
    },
  );
  if (dryRun) {
    return DriveRecursiveDeleteResult(
      plan: plan,
      dryRun: true,
      files: const MisskeyBatchResult.empty(),
      folders: const MisskeyBatchResult.empty(),
    );
  }

  MisskeyBatchSkipReason? stopReason;
  Object? stopCause;
  void checkCancellation() {
    if (stopReason == null && (cancellation?.isCancelled ?? false)) {
      stopReason = MisskeyBatchSkipReason.cancelled;
    }
  }

  MisskeyBatchSkipReason? stopFor(Object error) {
    checkCancellation();
    final reason = stopOnRateLimit(error);
    if (stopReason == null && reason != null) {
      stopReason = reason;
      stopCause = error;
    }
    return reason;
  }

  phase = DriveRecursiveDeletePhase.deletingFiles;
  total = plan.fileCount;
  completed = 0;
  failed = 0;
  notify();
  final fileResults = await runBounded<MisskeyDriveFile, Null>(
    inputs: plan.files,
    task: (file, _) async {
      try {
        await files.delete(fileId: file.id);
      } on MisskeyApiException catch (error) {
        if (error.code != 'NO_SUCH_FILE') rethrow;
      }
      return null;
    },
    concurrency: concurrency,
    cancellation: cancellation,
    stopReasonFor: stopFor,
    onResult: record,
  );
  final successfulFiles = {
    for (final item in fileResults.successes) item.input.id,
  };
  final orderedFolders = plan.foldersDeepestFirst;
  final indexById = {
    for (var i = 0; i < orderedFolders.length; i++) orderedFolders[i].id: i,
  };
  final nodesById = {for (final node in tree.nodes) node.folder.id: node};
  final outcomes = <String, MisskeyBatchItemResult<MisskeyDriveFolder, Null>>{};
  final levels = <int, List<MisskeyDriveFolder>>{};
  for (final folder in orderedFolders) {
    levels.putIfAbsent(nodesById[folder.id]!.depth, () => []).add(folder);
  }
  phase = DriveRecursiveDeletePhase.deletingFolders;
  total = plan.folderCount;
  completed = 0;
  failed = 0;
  notify();

  void save(MisskeyBatchItemResult<MisskeyDriveFolder, Null> item) {
    outcomes[item.input.id] = item;
    record(item);
  }

  for (final level in levels.values) {
    checkCancellation();
    final ready = <MisskeyDriveFolder>[];
    for (final folder in level) {
      final node = nodesById[folder.id]!;
      final blocked =
          plan.filesByFolder[folder.id]!.any(
            (file) => !successfulFiles.contains(file.id),
          ) ||
          node.children.any(
            (child) => !(outcomes[child.folder.id]?.isSuccess ?? false),
          );
      if (blocked || stopReason != null) {
        save(
          MisskeyBatchSkipped(
            input: folder,
            index: indexById[folder.id]!,
            reason: blocked
                ? MisskeyBatchSkipReason.dependencyFailed
                : stopReason!,
            cause: blocked ? null : stopCause,
          ),
        );
      } else {
        ready.add(folder);
      }
    }
    await runBounded<MisskeyDriveFolder, Null>(
      inputs: ready,
      concurrency: concurrency,
      cancellation: cancellation,
      stopReasonFor: stopFor,
      task: (folder, _) async {
        for (var attempt = 0; ; attempt++) {
          checkCancellation();
          if (stopReason != null) throw _DeleteStopped(stopReason!, stopCause);
          try {
            await folders.delete(folderId: folder.id);
            return null;
          } on MisskeyApiException catch (error) {
            if (error.code == 'NO_SUCH_FOLDER') return null;
            // Misskey は削除応答後にファイルの DB 行を消すため、反映を待つ。
            if (error.code != 'HAS_CHILD_FILES_OR_FOLDERS' || attempt >= 4) {
              rethrow;
            }
            await delay(Duration(milliseconds: 200 * (1 << attempt)));
          }
        }
      },
      onResult: (item) {
        final index = indexById[item.input.id]!;
        final result = switch (item) {
          MisskeyBatchSuccess() =>
            MisskeyBatchSuccess<MisskeyDriveFolder, Null>(
              input: item.input,
              index: index,
              value: null,
            ),
          MisskeyBatchFailure(error: final _DeleteStopped stopped) =>
            MisskeyBatchSkipped<MisskeyDriveFolder, Null>(
              input: item.input,
              index: index,
              reason: stopped.reason,
              cause: stopped.cause,
            ),
          MisskeyBatchFailure() =>
            MisskeyBatchFailure<MisskeyDriveFolder, Null>(
              input: item.input,
              index: index,
              error: item.error,
              stackTrace: item.stackTrace,
            ),
          MisskeyBatchSkipped() =>
            MisskeyBatchSkipped<MisskeyDriveFolder, Null>(
              input: item.input,
              index: index,
              reason: item.reason,
              cause: item.cause,
            ),
        };
        save(result);
      },
    );
  }
  return DriveRecursiveDeleteResult(
    plan: plan,
    dryRun: false,
    files: fileResults,
    folders: MisskeyBatchResult(
      items: [for (final folder in orderedFolders) outcomes[folder.id]!],
    ),
  );
}

class _DeleteStopped implements Exception {
  const _DeleteStopped(this.reason, this.cause);

  final MisskeyBatchSkipReason reason;
  final Object? cause;
}
