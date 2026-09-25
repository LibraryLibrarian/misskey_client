import 'package:meta/meta.dart';

import '../misskey_drive_folder.dart';

/// File count and byte total for a group of Drive files.
@immutable
final class DriveUsageStats {
  /// Creates usage statistics.
  const DriveUsageStats({this.fileCount = 0, this.totalBytes = 0});

  /// Empty usage statistics.
  static const zero = DriveUsageStats();

  /// The number of files in the group.
  final int fileCount;

  /// The combined size of the files in bytes.
  final int totalBytes;

  /// Combines this value with [other].
  DriveUsageStats operator +(DriveUsageStats other) => DriveUsageStats(
    fileCount: fileCount + other.fileCount,
    totalBytes: totalBytes + other.totalBytes,
  );

  @override
  bool operator ==(Object other) =>
      other is DriveUsageStats &&
      other.fileCount == fileCount &&
      other.totalBytes == totalBytes;

  @override
  int get hashCode => Object.hash(fileCount, totalBytes);

  @override
  String toString() =>
      'DriveUsageStats(fileCount: $fileCount, totalBytes: $totalBytes)';
}

/// Usage statistics for a Drive folder and its descendants.
@immutable
final class DriveFolderUsage {
  /// Creates folder usage with an unmodifiable copy of [children].
  DriveFolderUsage({
    required this.folder,
    required this.depth,
    required this.direct,
    required this.recursive,
    required List<DriveFolderUsage> children,
  }) : children = List.unmodifiable(children);

  /// The folder represented by this usage entry.
  final MisskeyDriveFolder folder;

  /// The folder depth relative to the Drive root; top-level folders have depth 1.
  final int depth;

  /// Usage from files directly inside [folder].
  final DriveUsageStats direct;

  /// Usage from files inside [folder] and all descendant folders.
  final DriveUsageStats recursive;

  /// Usage entries for direct child folders.
  final List<DriveFolderUsage> children;

  @override
  String toString() =>
      'DriveFolderUsage(${folder.id}, direct: $direct, recursive: $recursive)';
}

/// Aggregated usage statistics for a complete Drive scan.
@immutable
final class DriveUsageSummary {
  /// Creates a summary with unmodifiable copies of [folders] and [byMimeType].
  DriveUsageSummary({
    required this.total,
    required this.root,
    required this.unassigned,
    required List<DriveFolderUsage> folders,
    required Map<String, DriveUsageStats> byMimeType,
  }) : folders = List.unmodifiable(folders),
       byMimeType = Map.unmodifiable(byMimeType);

  /// Usage from every scanned file.
  final DriveUsageStats total;

  /// Usage from files directly in the Drive root.
  final DriveUsageStats root;

  /// Usage from files assigned to folders absent from the folder tree.
  final DriveUsageStats unassigned;

  /// Usage for folders directly in the Drive root.
  final List<DriveFolderUsage> folders;

  /// Usage grouped by exact MIME type.
  final Map<String, DriveUsageStats> byMimeType;

  /// All folder usage entries in pre-order.
  Iterable<DriveFolderUsage> get allFolders sync* {
    final stack = <DriveFolderUsage>[...folders.reversed];
    while (stack.isNotEmpty) {
      final folder = stack.removeLast();
      yield folder;
      stack.addAll(folder.children.reversed);
    }
  }

  late final Map<String, DriveFolderUsage> _folderUsageById = {
    for (final usage in allFolders) usage.folder.id: usage,
  };

  /// Returns usage for [folderId], or `null` when it is absent from the tree.
  DriveFolderUsage? folderUsage(String folderId) => _folderUsageById[folderId];

  @override
  String toString() =>
      'DriveUsageSummary(total: $total, folders: ${folders.length}, '
      'mimeTypes: ${byMimeType.length})';
}
