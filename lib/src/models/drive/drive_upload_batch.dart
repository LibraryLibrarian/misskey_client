import 'package:meta/meta.dart';

/// Describes one file to upload in a batch.
@immutable
final class DriveUploadInput {
  /// Creates a batch upload input.
  ///
  /// [bytes] is not copied, so callers must not modify it until the batch
  /// completes.
  const DriveUploadInput({
    required this.bytes,
    required this.filename,
    this.name,
    this.folderId,
    this.comment,
    this.isSensitive,
  });

  /// The file content to upload.
  final List<int> bytes;

  /// The file name used in the multipart upload.
  final String filename;

  /// The name to store on the server.
  final String? name;

  /// The destination folder, or `null` for the root folder.
  final String? folderId;

  /// An optional file comment.
  final String? comment;

  /// Whether to mark the file as sensitive.
  final bool? isSensitive;

  @override
  String toString() =>
      'DriveUploadInput(filename: $filename, bytes: ${bytes.length})';
}

/// Reports upload progress for one item in a batch.
@immutable
final class DriveBatchUploadProgress {
  /// Creates a batch upload progress event.
  const DriveBatchUploadProgress({
    required this.completedItems,
    required this.totalItems,
    required this.succeededItems,
    required this.failedItems,
    required this.itemIndex,
    required this.sent,
    required this.total,
  });

  /// The number of items that have completed.
  final int completedItems;

  /// The total number of input items.
  final int totalItems;

  /// The number of items that completed successfully.
  final int succeededItems;

  /// The number of items that failed.
  final int failedItems;

  /// The index of the item that triggered this event.
  final int itemIndex;

  /// The raw per-item byte count reported by Dio.
  final int sent;

  /// The raw per-item total reported by Dio.
  final int total;

  @override
  String toString() =>
      'DriveBatchUploadProgress(completedItems: $completedItems, '
      'totalItems: $totalItems, itemIndex: $itemIndex, sent: $sent, '
      'total: $total)';
}
