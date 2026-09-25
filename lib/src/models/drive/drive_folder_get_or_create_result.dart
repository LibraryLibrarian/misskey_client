import 'package:meta/meta.dart';

import '../misskey_drive_folder.dart';

/// The result of finding or creating a Drive folder.
@immutable
final class DriveFolderGetOrCreateResult {
  /// Creates a result for a found or newly created folder.
  const DriveFolderGetOrCreateResult({
    required this.folder,
    required this.created,
  });

  /// The found or newly created folder.
  final MisskeyDriveFolder folder;

  /// Whether [folder] was created by the operation.
  final bool created;
}
