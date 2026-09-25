import 'package:meta/meta.dart';

import '../../models/drive/drive_folder_tree.dart';
import '../../models/drive/drive_usage_summary.dart';
import '../../models/misskey_drive_file.dart';

/// Aggregates a folder tree and a full file stream into Drive usage statistics.
@internal
Future<DriveUsageSummary> aggregateDriveUsage({
  required Future<DriveFolderTree> Function() getTree,
  required Stream<MisskeyDriveFile> Function() streamAll,
  void Function(int filesScanned)? onProgress,
}) async {
  final results = await Future.wait<Object>([
    getTree(),
    _scanFiles(streamAll(), onProgress: onProgress),
  ], eagerError: true);
  final tree = results[0] as DriveFolderTree;
  final scan = results[1] as _DriveUsageScan;
  final folderIds = tree.nodes.map((node) => node.folder.id).toSet();

  DriveUsageStats usageFor(String? folderId) =>
      scan.byFolderId[folderId] ?? DriveUsageStats.zero;

  DriveFolderUsage buildUsage(DriveFolderNode node) {
    final children = [for (final child in node.children) buildUsage(child)];
    final recursive = children.fold(
      usageFor(node.folder.id),
      (total, child) => total + child.recursive,
    );
    return DriveFolderUsage(
      folder: node.folder,
      depth: node.depth,
      direct: usageFor(node.folder.id),
      recursive: recursive,
      children: children,
    );
  }

  final folders = [for (final node in tree.children) buildUsage(node)];
  final unassigned = scan.byFolderId.entries
      .where((entry) => entry.key != null && !folderIds.contains(entry.key))
      .fold<DriveUsageStats>(
        DriveUsageStats.zero,
        (total, entry) => total + entry.value,
      );

  return DriveUsageSummary(
    total: scan.total,
    root: usageFor(null),
    unassigned: unassigned,
    folders: folders,
    byMimeType: scan.byMimeType,
  );
}

Future<_DriveUsageScan> _scanFiles(
  Stream<MisskeyDriveFile> files, {
  void Function(int filesScanned)? onProgress,
}) async {
  var total = DriveUsageStats.zero;
  final byFolderId = <String?, DriveUsageStats>{};
  final byMimeType = <String, DriveUsageStats>{};

  await for (final file in files) {
    const oneFile = 1;
    final usage = DriveUsageStats(fileCount: oneFile, totalBytes: file.size);
    total = total + usage;
    byFolderId[file.folderId] =
        (byFolderId[file.folderId] ?? DriveUsageStats.zero) + usage;
    byMimeType[file.type] =
        (byMimeType[file.type] ?? DriveUsageStats.zero) + usage;
    onProgress?.call(total.fileCount);
  }

  return _DriveUsageScan(
    total: total,
    byFolderId: byFolderId,
    byMimeType: byMimeType,
  );
}

final class _DriveUsageScan {
  const _DriveUsageScan({
    required this.total,
    required this.byFolderId,
    required this.byMimeType,
  });

  final DriveUsageStats total;
  final Map<String?, DriveUsageStats> byFolderId;
  final Map<String, DriveUsageStats> byMimeType;
}
