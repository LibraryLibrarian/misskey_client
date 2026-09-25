import '../../exception/drive_folder_ambiguous_exception.dart';

/// Determines how to resolve same-named Drive folders.
///
/// Misskey allows same-named sibling folders, and `folders/find` has no
/// ordering guarantee, so this does not provide a "first" option. [oldest]
/// and [newest] compare folders by `createdAt` and then by `id`.
enum DriveFolderAmbiguityPolicy {
  /// Throws [DriveFolderAmbiguousException] for multiple matches.
  error,

  /// Selects the match with the earliest creation time and then lowest ID.
  oldest,

  /// Selects the match with the latest creation time and then highest ID.
  newest,
}
