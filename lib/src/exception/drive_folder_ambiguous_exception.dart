import 'package:meta/meta.dart';

import '../models/misskey_drive_folder.dart';

/// Thrown when a path segment matches multiple sibling folders.
///
/// This is not a subtype of the sealed `MisskeyClientException`, so handlers
/// for that type do not catch it.
@immutable
final class DriveFolderAmbiguousException implements Exception {
  /// Creates an exception for multiple folders matching a path segment.
  DriveFolderAmbiguousException({
    required this.name,
    required this.parentId,
    required List<MisskeyDriveFolder> candidates,
    required this.segmentIndex,
  }) : candidates = List.unmodifiable(candidates);

  /// The ambiguous folder name.
  final String name;

  /// The ID of the parent folder containing the candidates, if any.
  final String? parentId;

  /// The immutable list of matching folders.
  final List<MisskeyDriveFolder> candidates;

  /// The zero-based index of the ambiguous path segment.
  final int segmentIndex;

  @override
  String toString() =>
      'DriveFolderAmbiguousException: multiple folders named "$name" '
      'under parentId=$parentId at segmentIndex=$segmentIndex '
      '(${candidates.length} candidates)';
}
