import 'dart:async';

import 'package:crypto/crypto.dart' as crypto;
import 'package:meta/meta.dart';

import '../../api/drive/drive_files_api.dart';
import '../../client/misskey_cancellation_token.dart';
import '../../internal/bounded_batch.dart';
import '../../models/batch/misskey_batch_result.dart';
import '../../models/drive/drive_upload_batch.dart';
import '../../models/drive/drive_upload_result.dart';

/// Uploads multiple Drive files with bounded concurrency.
@internal
Future<MisskeyBatchResult<DriveUploadInput, DriveUploadResult>>
createManyDriveFiles({
  required DriveFilesApi files,
  required List<DriveUploadInput> inputs,
  required int concurrency,
  required DriveDuplicatePolicy? deduplicate,
  required bool stopOnError,
  void Function(DriveBatchUploadProgress progress)? onProgress,
  MisskeyCancellationToken? cancellation,
}) {
  validateConcurrency(concurrency);
  if (inputs.isEmpty) {
    return Future.value(
      const MisskeyBatchResult<DriveUploadInput, DriveUploadResult>.empty(),
    );
  }
  return _createManyDriveFiles(
    files: files,
    inputs: inputs,
    concurrency: concurrency,
    deduplicate: deduplicate,
    stopOnError: stopOnError,
    onProgress: onProgress,
    cancellation: cancellation,
  );
}

Future<MisskeyBatchResult<DriveUploadInput, DriveUploadResult>>
_createManyDriveFiles({
  required DriveFilesApi files,
  required List<DriveUploadInput> inputs,
  required int concurrency,
  required DriveDuplicatePolicy? deduplicate,
  required bool stopOnError,
  void Function(DriveBatchUploadProgress progress)? onProgress,
  MisskeyCancellationToken? cancellation,
}) async {
  final hashes =
      deduplicate == null || deduplicate == DriveDuplicatePolicy.uploadAnyway
      ? null
      : [
          for (final input in inputs)
            crypto.md5.convert(input.bytes).toString(),
        ];
  final predecessors = _predecessorsFor(inputs.length, hashes);
  final completions = List.generate(
    inputs.length,
    (_) => Completer<_Completion>(),
  );
  final results =
      List<MisskeyBatchItemResult<DriveUploadInput, DriveUploadResult>?>.filled(
        inputs.length,
        null,
      );
  final lastTotals = <int, int>{};
  final stop = _BatchStop();
  cancellation?.whenCancelled.then((_) {
    stop.set(MisskeyBatchSkipReason.cancelled);
  });
  var completedItems = 0;
  var succeededItems = 0;
  var failedItems = 0;

  void emit(int index, int sent, int total) {
    onProgress?.call(
      DriveBatchUploadProgress(
        completedItems: completedItems,
        totalItems: inputs.length,
        succeededItems: succeededItems,
        failedItems: failedItems,
        itemIndex: index,
        sent: sent,
        total: total,
      ),
    );
  }

  void throwIfStopped() {
    if (cancellation?.isCancelled ?? false) {
      stop.set(MisskeyBatchSkipReason.cancelled);
    }
    if (stop.reason case final reason?) {
      throw _Stopped(reason, stop.cause);
    }
  }

  MisskeyBatchItemResult<DriveUploadInput, DriveUploadResult> logicalResult(
    MisskeyBatchItemResult<DriveUploadInput, DriveUploadResult> result,
  ) {
    if (result case MisskeyBatchFailure(
      :final input,
      :final index,
      :final error,
    ) when error is _DependencyFailed) {
      return MisskeyBatchSkipped(
        input: input,
        index: index,
        reason: MisskeyBatchSkipReason.dependencyFailed,
        cause: error.cause,
      );
    }
    if (result case MisskeyBatchFailure(
      :final input,
      :final index,
      :final error,
    ) when error is _Stopped) {
      return MisskeyBatchSkipped(
        input: input,
        index: index,
        reason: error.reason,
        cause: error.cause,
      );
    }
    return result;
  }

  await runBounded<DriveUploadInput, DriveUploadResult>(
    inputs: inputs,
    concurrency: concurrency,
    cancellation: cancellation,
    stopReasonFor: (error) {
      final rateLimitReason = stopOnRateLimit(error);
      if (rateLimitReason != null) {
        stop.set(rateLimitReason, error);
        return rateLimitReason;
      }
      if (stopOnError && error is! _DependencyFailed && error is! _Stopped) {
        stop.set(MisskeyBatchSkipReason.stoppedAfterError, error);
        return MisskeyBatchSkipReason.stoppedAfterError;
      }
      return null;
    },
    task: (input, index) async {
      try {
        final predecessor = predecessors[index];
        final value = predecessor == null
            ? await _upload(
                files: files,
                input: input,
                deduplicate: deduplicate,
                md5: hashes?[index],
                onSendProgress: (sent, total) {
                  lastTotals[index] = total;
                  emit(index, sent, total);
                },
              )
            : await _reusePredecessorResult(
                files: files,
                input: input,
                completion: await completions[predecessor].future,
                policy: deduplicate!,
                md5: hashes![index],
                throwIfStopped: throwIfStopped,
              );
        completions[index].complete(_Completion.success(value));
        return value;
      } catch (error) {
        completions[index].complete(_Completion.failure(error));
        rethrow;
      }
    },
    onResult: (result) {
      final logical = logicalResult(result);
      results[logical.index] = logical;
      completedItems++;
      if (logical is MisskeyBatchSuccess) {
        succeededItems++;
      } else if (logical is MisskeyBatchFailure) {
        failedItems++;
      }
      final total = lastTotals[logical.index] ?? 0;
      emit(logical.index, total, total);
    },
  );

  // [runBounded] の完了時には [onResult] がすべての項目を設定済み。
  assert(results.every((result) => result != null));
  return MisskeyBatchResult(
    items: results
        .cast<MisskeyBatchItemResult<DriveUploadInput, DriveUploadResult>>(),
  );
}

List<int?> _predecessorsFor(int length, List<String>? hashes) {
  if (hashes == null) return List<int?>.filled(length, null);
  final lastByHash = <String, int>{};
  return List<int?>.generate(length, (index) {
    final predecessor = lastByHash[hashes[index]];
    lastByHash[hashes[index]] = index;
    return predecessor;
  });
}

Future<DriveUploadResult> _upload({
  required DriveFilesApi files,
  required DriveUploadInput input,
  required DriveDuplicatePolicy? deduplicate,
  required String? md5,
  required void Function(int sent, int total) onSendProgress,
}) async {
  if (deduplicate != null) {
    return files.createDeduplicated(
      bytes: input.bytes,
      filename: input.filename,
      name: input.name,
      folderId: input.folderId,
      comment: input.comment,
      isSensitive: input.isSensitive,
      md5: md5,
      onDuplicate: deduplicate,
      onSendProgress: onSendProgress,
    );
  }
  final file = await files.create(
    bytes: input.bytes,
    filename: input.filename,
    name: input.name,
    folderId: input.folderId,
    comment: input.comment,
    isSensitive: input.isSensitive,
    onSendProgress: onSendProgress,
  );
  return DriveUploadResult(
    file: file,
    outcome: DriveUploadOutcome.uploaded,
    md5: file.md5,
    existingMatches: const [],
  );
}

Future<DriveUploadResult> _reusePredecessorResult({
  required DriveFilesApi files,
  required DriveUploadInput input,
  required _Completion completion,
  required DriveDuplicatePolicy policy,
  required String md5,
  required void Function() throwIfStopped,
}) async {
  if (completion case _CompletionFailure(:final error)) {
    throw _DependencyFailed(_dependencyCause(error));
  }
  final result = (completion as _CompletionSuccess).value;
  throwIfStopped();
  final upgradeSensitivity =
      input.isSensitive == true && result.file.isSensitive != true;
  if (policy == DriveDuplicatePolicy.moveExisting &&
      result.file.folderId != input.folderId) {
    final moved = await files.update(
      fileId: result.file.id,
      folderId: input.folderId,
      moveToRoot: input.folderId == null,
      isSensitive: upgradeSensitivity ? true : null,
    );
    return DriveUploadResult(
      file: moved,
      outcome: DriveUploadOutcome.movedExisting,
      md5: md5,
      existingMatches: result.existingMatches,
    );
  }
  final file = upgradeSensitivity
      ? await files.update(fileId: result.file.id, isSensitive: true)
      : result.file;
  return DriveUploadResult(
    file: file,
    outcome: DriveUploadOutcome.reusedExisting,
    md5: md5,
    existingMatches: result.existingMatches,
  );
}

Object? _dependencyCause(Object error) => switch (error) {
  _Stopped(:final cause) => cause,
  _DependencyFailed(:final cause) => cause,
  _ => error,
};

final class _BatchStop {
  MisskeyBatchSkipReason? reason;
  Object? cause;

  void set(MisskeyBatchSkipReason value, [Object? valueCause]) {
    if (reason != null) return;
    reason = value;
    cause = valueCause;
  }
}

sealed class _Completion {
  const _Completion();

  factory _Completion.success(DriveUploadResult value) = _CompletionSuccess;
  factory _Completion.failure(Object error) = _CompletionFailure;
}

final class _CompletionSuccess extends _Completion {
  const _CompletionSuccess(this.value);

  final DriveUploadResult value;
}

final class _CompletionFailure extends _Completion {
  const _CompletionFailure(this.error);

  final Object error;
}

final class _Stopped implements Exception {
  const _Stopped(this.reason, this.cause);

  final MisskeyBatchSkipReason reason;
  final Object? cause;
}

final class _DependencyFailed implements Exception {
  const _DependencyFailed(this.cause);

  final Object? cause;
}
