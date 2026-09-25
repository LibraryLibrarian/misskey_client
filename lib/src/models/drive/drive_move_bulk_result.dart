import 'package:meta/meta.dart';

import '../batch/misskey_batch_result.dart';

/// The outcome of moving all requested Drive files in bulk.
@immutable
final class DriveMoveBulkResult {
  /// Creates a result from the original request and its chunk outcomes.
  DriveMoveBulkResult({
    required this.folderId,
    required this.requestedCount,
    required Iterable<String> uniqueFileIds,
    required this.chunks,
  }) : uniqueFileIds = List.unmodifiable(uniqueFileIds);

  /// The requested destination folder, or `null` for the root folder.
  final String? folderId;

  /// The number of IDs supplied before duplicate IDs were removed.
  final int requestedCount;

  /// The distinct requested IDs in first-occurrence order.
  final List<String> uniqueFileIds;

  /// The outcome of each 100-file chunk in order.
  final MisskeyBatchResult<List<String>, Null> chunks;

  /// Whether every chunk was accepted by the server.
  bool get isComplete => chunks.isComplete;

  /// IDs in chunks that failed or were not started.
  List<String> get unconfirmedFileIds => List.unmodifiable([
    for (final chunk in chunks.items)
      if (!chunk.isSuccess) ...chunk.input,
  ]);

  @override
  String toString() =>
      'DriveMoveBulkResult(folderId: $folderId, requestedCount: '
      '$requestedCount, uniqueFileCount: ${uniqueFileIds.length}, '
      'isComplete: $isComplete)';
}
