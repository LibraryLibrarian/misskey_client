import 'package:meta/meta.dart';

import '../misskey_drive_file.dart';

/// Selects how an existing file with the same content is handled.
enum DriveDuplicatePolicy {
  /// Returns an existing matching file without changing its folder.
  reuseExisting,

  /// Moves an existing matching file to the requested folder when necessary.
  moveExisting,

  /// Uploads another copy without checking for an existing matching file.
  uploadAnyway,
}

/// Describes whether a deduplicated upload transferred or reused content.
enum DriveUploadOutcome {
  /// A new file was uploaded.
  uploaded,

  /// An existing file was returned without moving it.
  reusedExisting,

  /// An existing file was moved to the requested folder.
  movedExisting,
}

/// The result of a deduplicated Drive upload.
@immutable
final class DriveUploadResult {
  /// Creates a result for a deduplicated Drive upload.
  DriveUploadResult({
    required this.file,
    required this.outcome,
    required this.md5,
    required List<MisskeyDriveFile> existingMatches,
  }) : existingMatches = List.unmodifiable(existingMatches);

  /// The uploaded, reused, or moved file.
  final MisskeyDriveFile file;

  /// How the requested upload was fulfilled.
  final DriveUploadOutcome outcome;

  /// The normalized MD5 hash used for duplicate detection.
  final String md5;

  /// All existing files returned by the hash lookup.
  final List<MisskeyDriveFile> existingMatches;
}
