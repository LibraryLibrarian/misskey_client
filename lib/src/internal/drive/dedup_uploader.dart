import 'package:crypto/crypto.dart' as crypto;
import 'package:meta/meta.dart';

import '../../api/drive/drive_files_api.dart';
import '../../client/request_options.dart';
import '../../models/drive/drive_upload_result.dart';
import '../../models/misskey_drive_file.dart';

/// Performs a Drive upload after checking for files with the same MD5 hash.
@internal
Future<DriveUploadResult> createDeduplicatedDriveFile({
  required DriveFilesApi files,
  required List<int> bytes,
  required String filename,
  String? name,
  String? folderId,
  String? comment,
  bool? isSensitive,
  String? md5,
  DriveDuplicatePolicy onDuplicate = DriveDuplicatePolicy.reuseExisting,
  void Function(int sent, int total)? onSendProgress,
  bool retryLookup = true,
}) async {
  final suppliedMd5 = _normalizedMd5(md5);

  if (onDuplicate == DriveDuplicatePolicy.uploadAnyway) {
    final file = await files.create(
      bytes: bytes,
      filename: filename,
      name: name,
      folderId: folderId,
      comment: comment,
      isSensitive: isSensitive,
      force: true,
      onSendProgress: onSendProgress,
    );
    return DriveUploadResult(
      file: file,
      outcome: DriveUploadOutcome.uploaded,
      md5: suppliedMd5 ?? file.md5,
      existingMatches: const [],
    );
  }

  final hash = suppliedMd5 ?? crypto.md5.convert(bytes).toString();
  final existingMatches = retryLookup
      ? await files.findByHash(md5: hash)
      : await _findByHashWithoutRetry(files, hash);
  if (existingMatches.isNotEmpty) {
    final existing = _selectExisting(existingMatches, folderId);
    return _handleExisting(
      files: files,
      file: existing,
      requestedFolderId: folderId,
      isSensitive: isSensitive,
      onDuplicate: onDuplicate,
      md5: hash,
      existingMatches: existingMatches,
    );
  }

  final file = await files.create(
    bytes: bytes,
    filename: filename,
    name: name,
    folderId: folderId,
    comment: comment,
    isSensitive: isSensitive,
    force: false,
    onSendProgress: onSendProgress,
  );
  if (_wasDeduplicatedByServer(
    file: file,
    requestedFolderId: folderId,
    requestedName: name,
    requestedComment: comment,
  )) {
    return _handleExisting(
      files: files,
      file: file,
      requestedFolderId: folderId,
      isSensitive: isSensitive,
      onDuplicate: onDuplicate,
      md5: hash,
      existingMatches: existingMatches,
    );
  }
  return DriveUploadResult(
    file: file,
    outcome: DriveUploadOutcome.uploaded,
    md5: hash,
    existingMatches: existingMatches,
  );
}

Future<List<MisskeyDriveFile>> _findByHashWithoutRetry(
  DriveFilesApi files,
  String md5,
) async {
  final response = await files.http.send<List<dynamic>>(
    '/drive/files/find-by-hash',
    body: <String, dynamic>{'md5': md5},
    options: const RequestOptions(idempotent: false),
  );
  return response
      .whereType<Map<String, dynamic>>()
      .map(MisskeyDriveFile.fromJson)
      .toList();
}

Future<DriveUploadResult> _handleExisting({
  required DriveFilesApi files,
  required MisskeyDriveFile file,
  required String? requestedFolderId,
  required bool? isSensitive,
  required DriveDuplicatePolicy onDuplicate,
  required String md5,
  required List<MisskeyDriveFile> existingMatches,
}) async {
  final shouldUpgradeSensitivity =
      isSensitive == true && file.isSensitive != true;
  if (onDuplicate == DriveDuplicatePolicy.moveExisting &&
      file.folderId != requestedFolderId) {
    final moved = await files.update(
      fileId: file.id,
      folderId: requestedFolderId,
      moveToRoot: requestedFolderId == null,
      isSensitive: shouldUpgradeSensitivity ? true : null,
    );
    return DriveUploadResult(
      file: moved,
      outcome: DriveUploadOutcome.movedExisting,
      md5: md5,
      existingMatches: existingMatches,
    );
  }

  final result = shouldUpgradeSensitivity
      ? await files.update(fileId: file.id, isSensitive: true)
      : file;
  return DriveUploadResult(
    file: result,
    outcome: DriveUploadOutcome.reusedExisting,
    md5: md5,
    existingMatches: existingMatches,
  );
}

bool _wasDeduplicatedByServer({
  required MisskeyDriveFile file,
  required String? requestedFolderId,
  required String? requestedName,
  required String? requestedComment,
}) {
  if (file.folderId != requestedFolderId) return true;
  if (requestedComment != null && file.comment != requestedComment) return true;

  final trimmedName = requestedName?.trim();
  return trimmedName != null &&
      trimmedName.isNotEmpty &&
      trimmedName != 'blob' &&
      file.name != trimmedName;
}

MisskeyDriveFile _selectExisting(
  List<MisskeyDriveFile> matches,
  String? requestedFolderId,
) {
  final inRequestedFolder = matches
      .where((file) => file.folderId == requestedFolderId)
      .toList();
  final candidates = inRequestedFolder.isEmpty ? matches : inRequestedFolder;
  return candidates.reduce((oldest, file) {
    final byCreatedAt = file.createdAt.compareTo(oldest.createdAt);
    if (byCreatedAt != 0) return byCreatedAt < 0 ? file : oldest;
    return file.id.compareTo(oldest.id) < 0 ? file : oldest;
  });
}

String? _normalizedMd5(String? value) {
  if (value == null) return null;
  if (!RegExp(r'^[0-9a-fA-F]{32}$').hasMatch(value)) {
    throw ArgumentError.value(value, 'md5', 'must be a 32-character hex MD5');
  }
  return value.toLowerCase();
}
