import 'package:meta/meta.dart';

import '../misskey_drive_folder.dart';

/// A folder and its loaded child folders in a Drive folder tree.
@immutable
final class DriveFolderNode {
  /// Creates a node with an unmodifiable copy of [children].
  DriveFolderNode({
    required this.folder,
    required List<DriveFolderNode> children,
    required this.depth,
    required this.childrenLoaded,
  }) : children = List.unmodifiable(children);

  /// The folder represented by this node.
  final MisskeyDriveFolder folder;

  /// Child folders in the server's newest-first order.
  final List<DriveFolderNode> children;

  /// The depth relative to the requested root.
  final int depth;

  /// Whether this node's children were loaded.
  final bool childrenLoaded;

  @override
  String toString() =>
      'DriveFolderNode(${folder.id}, children: ${children.length}, '
      'depth: $depth, childrenLoaded: $childrenLoaded)';
}

/// An immutable hierarchy of Drive folders.
@immutable
final class DriveFolderTree {
  /// Creates a tree with unmodifiable top-level [children].
  DriveFolderTree({
    required this.rootNode,
    required List<DriveFolderNode> children,
    required this.maxDepth,
    bool rootChildrenLoaded = true,
  }) : children = List.unmodifiable(children),
       _rootChildrenLoaded = rootChildrenLoaded;

  /// The requested root folder, or `null` when rooted at the Drive root.
  final DriveFolderNode? rootNode;

  /// The root node's children, or the folders directly in the Drive root.
  final List<DriveFolderNode> children;

  /// The maximum included depth, or `null` when traversal was unlimited.
  final int? maxDepth;

  final bool _rootChildrenLoaded;

  /// Whether traversal stopped before all children were loaded.
  bool get isTruncated =>
      !_rootChildrenLoaded || nodes.any((node) => !node.childrenLoaded);

  /// All included nodes in pre-order, including [rootNode] when present.
  Iterable<DriveFolderNode> get nodes sync* {
    final roots = rootNode == null ? children : [rootNode!];
    final stack = <DriveFolderNode>[...roots.reversed];
    while (stack.isNotEmpty) {
      final node = stack.removeLast();
      yield node;
      stack.addAll(node.children.reversed);
    }
  }

  /// The number of folders included in this tree.
  int get folderCount => nodes.length;

  @override
  String toString() =>
      'DriveFolderTree(folderCount: $folderCount, maxDepth: $maxDepth, '
      'isTruncated: $isTruncated)';
}
