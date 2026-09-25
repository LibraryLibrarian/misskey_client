import 'package:meta/meta.dart';

import '../../models/drive/drive_folder_tree.dart';
import '../../models/misskey_drive_folder.dart';

/// Groups folders deepest-first, preserving traversal order within each level.
@internal
List<List<MisskeyDriveFolder>> driveFolderLevels(DriveFolderTree tree) {
  final levels = <int, List<MisskeyDriveFolder>>{};
  for (final node in tree.nodes) {
    levels.putIfAbsent(node.depth, () => []).add(node.folder);
  }
  final depths = levels.keys.toList()..sort((a, b) => b.compareTo(a));
  return [for (final depth in depths) levels[depth]!];
}
