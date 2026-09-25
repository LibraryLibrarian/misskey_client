import 'dart:async';

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
  final files = streamAll();
  final scan = _DriveUsageScanner(files, onProgress: onProgress);
  late final Future<DriveFolderTree> tree;
  try {
    tree = getTree();
  } catch (error, stackTrace) {
    await _stopScan(scan);
    Error.throwWithStackTrace(error, stackTrace);
  }

  late final List<Object> results;
  try {
    results = await Future.wait<Object>([tree, scan.result], eagerError: true);
  } catch (error, stackTrace) {
    await _stopScan(scan);
    Error.throwWithStackTrace(error, stackTrace);
  }
  final folderTree = results[0] as DriveFolderTree;
  final fileScan = results[1] as _DriveUsageScan;
  final folderIds = folderTree.nodes.map((node) => node.folder.id).toSet();

  DriveUsageStats usageFor(String? folderId) =>
      fileScan.byFolderId[folderId] ?? DriveUsageStats.zero;

  final usagesByFolderId = <String, DriveFolderUsage>{};
  final nodes = folderTree.nodes.toList();
  for (final node in nodes.reversed) {
    final children = [
      for (final child in node.children) usagesByFolderId[child.folder.id]!,
    ];
    final recursive = children.fold(
      usageFor(node.folder.id),
      (total, child) => total + child.recursive,
    );
    usagesByFolderId[node.folder.id] = DriveFolderUsage(
      folder: node.folder,
      depth: node.depth,
      direct: usageFor(node.folder.id),
      recursive: recursive,
      children: children,
    );
  }

  final folders = [
    for (final node in folderTree.children) usagesByFolderId[node.folder.id]!,
  ];
  final unassigned = fileScan.byFolderId.entries
      .where((entry) => entry.key != null && !folderIds.contains(entry.key))
      .fold<DriveUsageStats>(
        DriveUsageStats.zero,
        (total, entry) => total + entry.value,
      );

  return DriveUsageSummary(
    total: fileScan.total,
    root: usageFor(null),
    unassigned: unassigned,
    folders: folders,
    byMimeType: fileScan.byMimeType,
  );
}

Future<void> _stopScan(_DriveUsageScanner scan) async {
  try {
    await scan.cancel();
  } catch (_) {}
  try {
    await scan.result;
  } catch (_) {}
}

final class _DriveUsageScanner {
  _DriveUsageScanner(Stream<MisskeyDriveFile> files, {this.onProgress}) {
    _subscription = files.listen(
      _onFile,
      onError: _onError,
      onDone: _onDone,
      cancelOnError: true,
    );
  }

  final void Function(int filesScanned)? onProgress;
  final _result = Completer<_DriveUsageScan>();
  late final StreamSubscription<MisskeyDriveFile> _subscription;
  Future<void>? _cancellation;
  var _stopped = false;
  var _total = DriveUsageStats.zero;
  final _byFolderId = <String?, DriveUsageStats>{};
  final _byMimeType = <String, DriveUsageStats>{};

  Future<_DriveUsageScan> get result => _result.future;

  void _onFile(MisskeyDriveFile file) {
    if (_stopped) return;
    final usage = DriveUsageStats(fileCount: 1, totalBytes: file.size);
    _total = _total + usage;
    _byFolderId[file.folderId] =
        (_byFolderId[file.folderId] ?? DriveUsageStats.zero) + usage;
    _byMimeType[file.type] =
        (_byMimeType[file.type] ?? DriveUsageStats.zero) + usage;
    try {
      onProgress?.call(_total.fileCount);
    } catch (error, stackTrace) {
      _completeError(error, stackTrace);
    }
  }

  void _onError(Object error, StackTrace stackTrace) {
    _completeError(error, stackTrace);
  }

  void _onDone() {
    if (_stopped || _result.isCompleted) return;
    _result.complete(
      _DriveUsageScan(
        total: _total,
        byFolderId: _byFolderId,
        byMimeType: _byMimeType,
      ),
    );
  }

  void _completeError(Object error, StackTrace stackTrace) {
    if (_stopped || _result.isCompleted) return;
    _stopped = true;
    _result.completeError(error, stackTrace);
  }

  Future<void> cancel() {
    _stopped = true;
    if (!_result.isCompleted) {
      _result.complete(
        _DriveUsageScan(
          total: _total,
          byFolderId: _byFolderId,
          byMimeType: _byMimeType,
        ),
      );
    }
    return _cancellation ??= _subscription.cancel();
  }
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
