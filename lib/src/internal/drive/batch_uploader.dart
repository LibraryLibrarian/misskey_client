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
  final hashes = deduplicate == null
      ? null
      : [
          for (final input in inputs)
            crypto.md5.convert(input.bytes).toString(),
        ];
  final leaders = _leadersFor(inputs.length, hashes, deduplicate);
  final completions = <int, Completer<_LeaderCompletion>>{
    for (var index = 0; index < inputs.length; index++)
      if (leaders[index] == index) index: Completer<_LeaderCompletion>(),
  };
  final results =
      List<MisskeyBatchItemResult<DriveUploadInput, DriveUploadResult>?>.filled(
        inputs.length,
        null,
      );
  final lastTotals = <int, int>{};
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
    final leader = leaders[result.index];
    if (leader != result.index && result is MisskeyBatchSkipped) {
      final leaderResult = results[leader];
      if (leaderResult is! MisskeyBatchSuccess) {
        return MisskeyBatchSkipped(
          input: result.input,
          index: result.index,
          reason: MisskeyBatchSkipReason.dependencyFailed,
          cause: switch (leaderResult) {
            MisskeyBatchFailure(:final error) => error,
            MisskeyBatchSkipped(:final cause) => cause,
            _ => null,
          },
        );
      }
    }
    return result;
  }

  await runBounded<DriveUploadInput, DriveUploadResult>(
    inputs: inputs,
    concurrency: concurrency,
    cancellation: cancellation,
    stopReasonFor: (error) {
      final rateLimitReason = stopOnRateLimit(error);
      if (rateLimitReason != null) return rateLimitReason;
      return stopOnError && error is! _DependencyFailed
          ? MisskeyBatchSkipReason.stoppedAfterError
          : null;
    },
    task: (input, index) async {
      final leader = leaders[index];
      if (leader != index) {
        final completion = await completions[leader]!.future;
        if (completion case _LeaderFailure(:final error)) {
          throw _DependencyFailed(error);
        }
        return _reuseLeaderResult(
          files: files,
          input: input,
          result: (completion as _LeaderSuccess).value,
          policy: deduplicate!,
          md5: hashes![index],
        );
      }

      try {
        final value = await _upload(
          files: files,
          input: input,
          deduplicate: deduplicate,
          md5: hashes?[index],
          onSendProgress: (sent, total) {
            lastTotals[index] = total;
            emit(index, sent, total);
          },
        );
        completions[index]!.complete(_LeaderSuccess(value));
        return value;
      } catch (error, stackTrace) {
        completions[index]!.complete(_LeaderFailure(error, stackTrace));
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
      final total =
          lastTotals[logical.index] ?? inputs[logical.index].bytes.length;
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

List<int> _leadersFor(
  int length,
  List<String>? hashes,
  DriveDuplicatePolicy? policy,
) {
  if (hashes == null || policy == DriveDuplicatePolicy.uploadAnyway) {
    return List<int>.generate(length, (index) => index);
  }
  final firstByHash = <String, int>{};
  return List<int>.generate(
    length,
    (index) => firstByHash.putIfAbsent(hashes[index], () => index),
  );
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

Future<DriveUploadResult> _reuseLeaderResult({
  required DriveFilesApi files,
  required DriveUploadInput input,
  required DriveUploadResult result,
  required DriveDuplicatePolicy policy,
  required String md5,
}) async {
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

sealed class _LeaderCompletion {
  const _LeaderCompletion();
}

final class _LeaderSuccess extends _LeaderCompletion {
  const _LeaderSuccess(this.value);

  final DriveUploadResult value;
}

final class _LeaderFailure extends _LeaderCompletion {
  const _LeaderFailure(this.error, this.stackTrace);

  final Object error;
  final StackTrace stackTrace;
}

final class _DependencyFailed implements Exception {
  const _DependencyFailed(this.cause);

  final Object cause;
}
