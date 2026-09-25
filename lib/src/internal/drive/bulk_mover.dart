import 'dart:collection';

import 'package:meta/meta.dart';

import '../../api/drive/drive_folders_api.dart';
import '../../client/misskey_http.dart';
import '../../models/batch/misskey_batch_result.dart';
import '../../models/drive/drive_move_bulk_result.dart';
import '../bounded_batch.dart';

const _moveBulkChunkSize = 100;

@internal
Future<DriveMoveBulkResult> moveBulkAll({
  required MisskeyHttp http,
  required Iterable<String> fileIds,
  required String? folderId,
  required Future<void> Function({
    required List<String> fileIds,
    String? folderId,
  })
  moveBulk,
}) async {
  final requestedIds = fileIds.toList();
  final uniqueFileIds = LinkedHashSet<String>.from(requestedIds).toList();
  if (uniqueFileIds.isEmpty) {
    return DriveMoveBulkResult(
      folderId: folderId,
      requestedCount: requestedIds.length,
      uniqueFileIds: uniqueFileIds,
      chunks: const MisskeyBatchResult.empty(),
    );
  }

  if (folderId != null) {
    await DriveFoldersApi(http: http).show(folderId: folderId);
  }

  final chunks = <List<String>>[
    for (
      var offset = 0;
      offset < uniqueFileIds.length;
      offset += _moveBulkChunkSize
    )
      List.unmodifiable(
        uniqueFileIds.sublist(
          offset,
          offset + _moveBulkChunkSize < uniqueFileIds.length
              ? offset + _moveBulkChunkSize
              : uniqueFileIds.length,
        ),
      ),
  ];
  final results = await runBounded<List<String>, Null>(
    inputs: chunks,
    concurrency: 1,
    stopReasonFor: (_) => MisskeyBatchSkipReason.stoppedAfterError,
    task: (chunk, _) async {
      await moveBulk(fileIds: chunk, folderId: folderId);
      return null;
    },
  );
  return DriveMoveBulkResult(
    folderId: folderId,
    requestedCount: requestedIds.length,
    uniqueFileIds: uniqueFileIds,
    chunks: results,
  );
}
