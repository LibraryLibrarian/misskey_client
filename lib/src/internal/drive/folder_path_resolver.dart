import 'package:meta/meta.dart';

import '../../exception/drive_folder_ambiguous_exception.dart';
import '../../models/drive/drive_folder_ambiguity_policy.dart';
import '../../models/drive/drive_folder_get_or_create_result.dart';
import '../../models/misskey_drive_folder.dart';

/// Resolves a sequence of folder names through `folders/find` requests.
@internal
Future<MisskeyDriveFolder?> resolveDriveFolderPath({
  required List<String> segments,
  required String? parentId,
  required DriveFolderAmbiguityPolicy onAmbiguous,
  required Future<List<MisskeyDriveFolder>> Function({
    required String name,
    String? parentId,
  })
  find,
}) async {
  final path = List<String>.of(segments);
  _validateSegments(path);

  var currentParentId = parentId;
  MisskeyDriveFolder? resolved;
  for (var index = 0; index < path.length; index++) {
    final candidates = await find(name: path[index], parentId: currentParentId);
    if (candidates.isEmpty) return null;
    resolved = _selectFolder(
      name: path[index],
      parentId: currentParentId,
      candidates: candidates,
      segmentIndex: index,
      onAmbiguous: onAmbiguous,
    );
    currentParentId = resolved.id;
  }

  return resolved;
}

/// Finds a folder or creates it when no matching folder exists.
@internal
Future<DriveFolderGetOrCreateResult> getOrCreateDriveFolder({
  required String name,
  required String? parentId,
  required DriveFolderAmbiguityPolicy onAmbiguous,
  required Future<List<MisskeyDriveFolder>> Function({
    required String name,
    String? parentId,
  })
  find,
  required Future<MisskeyDriveFolder> Function({String? name, String? parentId})
  create,
}) async {
  _validateName(name);

  final candidates = await find(name: name, parentId: parentId);
  if (candidates.isNotEmpty) {
    return DriveFolderGetOrCreateResult(
      folder: _selectFolder(
        name: name,
        parentId: parentId,
        candidates: candidates,
        segmentIndex: 0,
        onAmbiguous: onAmbiguous,
      ),
      created: false,
    );
  }

  return DriveFolderGetOrCreateResult(
    folder: await create(name: name, parentId: parentId),
    created: true,
  );
}

MisskeyDriveFolder _selectFolder({
  required String name,
  required String? parentId,
  required List<MisskeyDriveFolder> candidates,
  required int segmentIndex,
  required DriveFolderAmbiguityPolicy onAmbiguous,
}) {
  if (candidates.length == 1) return candidates.single;

  return switch (onAmbiguous) {
    DriveFolderAmbiguityPolicy.error => throw DriveFolderAmbiguousException(
      name: name,
      parentId: parentId,
      candidates: candidates,
      segmentIndex: segmentIndex,
    ),
    DriveFolderAmbiguityPolicy.oldest => candidates.reduce(_olderFolder),
    DriveFolderAmbiguityPolicy.newest => candidates.reduce(_newerFolder),
  };
}

MisskeyDriveFolder _olderFolder(
  MisskeyDriveFolder first,
  MisskeyDriveFolder second,
) => _compareFolderAge(first, second) <= 0 ? first : second;

MisskeyDriveFolder _newerFolder(
  MisskeyDriveFolder first,
  MisskeyDriveFolder second,
) => _compareFolderAge(first, second) >= 0 ? first : second;

int _compareFolderAge(MisskeyDriveFolder first, MisskeyDriveFolder second) {
  final createdAtComparison = first.createdAt.compareTo(second.createdAt);
  return createdAtComparison != 0
      ? createdAtComparison
      : first.id.compareTo(second.id);
}

void _validateSegments(List<String> segments) {
  if (segments.isEmpty) {
    throw ArgumentError.value(segments, 'segments', 'must not be empty');
  }
  for (var index = 0; index < segments.length; index++) {
    _validateName(segments[index], 'segments[$index]');
  }
}

void _validateName(String name, [String parameterName = 'name']) {
  if (name.isEmpty || name.runes.length > 200) {
    throw ArgumentError.value(
      name,
      parameterName,
      'must not be empty or exceed 200 Unicode code points',
    );
  }
}
