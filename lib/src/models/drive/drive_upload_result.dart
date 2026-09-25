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

/// A best-effort classification of a deduplicated upload result.
///
/// Classifications do not indicate whether bytes were transferred: a detected
/// raced reuse can have transferred bytes, while an undetectable raced reuse is
/// reported as [uploaded].
enum DriveUploadOutcome {
  /// No existing-file reuse was detected.
  uploaded,

  /// An existing file was selected or detected without moving it.
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

  /// The best-effort classification of how the request was fulfilled.
  final DriveUploadOutcome outcome;

  /// The normalized supplied MD5 or locally computed MD5 used for deduplication.
  ///
  /// For [DriveDuplicatePolicy.uploadAnyway], this is the normalized supplied
  /// value or the returned [file]'s MD5 from the server.
  final String md5;

  /// All existing files returned by the hash lookup.
  final List<MisskeyDriveFile> existingMatches;
}
