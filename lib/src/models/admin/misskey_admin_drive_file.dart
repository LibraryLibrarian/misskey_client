import 'package:freezed_annotation/freezed_annotation.dart';

import '../json_converters.dart';
import '../misskey_drive_file.dart';

part 'misskey_admin_drive_file.freezed.dart';
part 'misskey_admin_drive_file.g.dart';

/// File details from the `/api/admin/drive/show-file` response.
@freezed
@JsonSerializable()
class MisskeyAdminDriveFile with _$MisskeyAdminDriveFile {
  const MisskeyAdminDriveFile({
    required this.id,
    required this.createdAt,
    required this.md5,
    required this.name,
    required this.type,
    required this.size,
    required this.properties,
    required this.isSensitive,
    required this.isLink,
    required this.maybeSensitive,
    required this.maybePorn,
    this.userId,
    this.userHost,
    this.comment,
    this.blurhash,
    this.storedInternal,
    this.url,
    this.thumbnailUrl,
    this.webpublicUrl,
    this.webpublicType,
    this.accessKey,
    this.thumbnailAccessKey,
    this.webpublicAccessKey,
    this.uri,
    this.src,
    this.folderId,
    this.requestIp,
    this.requestHeaders,
  });

  factory MisskeyAdminDriveFile.fromJson(Map<String, dynamic> json) =>
      _$MisskeyAdminDriveFileFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeyAdminDriveFileToJson(this);

  /// The file ID.
  @override
  final String id;

  /// The upload date and time.
  @SafeDateTimeConverter()
  @override
  final DateTime createdAt;

  /// The MD5 hash of the file.
  @override
  final String md5;

  /// The file name.
  @override
  final String name;

  /// The MIME type.
  @override
  final String type;

  /// The file size in bytes.
  @override
  final int size;

  /// The image properties, including dimensions and orientation when available.
  @override
  final MisskeyDriveFileProperties properties;

  /// Whether the file is marked as sensitive.
  @override
  final bool isSensitive;

  /// Whether the file directly links to a remote URL.
  @override
  final bool isLink;

  /// Whether the file is predicted to contain sensitive content.
  @override
  final bool maybeSensitive;

  /// Whether the file is predicted to contain pornography.
  @override
  final bool maybePorn;

  /// The owner user's ID, or null if the owner no longer exists.
  @override
  final String? userId;

  /// The owner's host, or null for local users.
  @override
  final String? userHost;

  /// The user-provided comment or caption.
  @override
  final String? comment;

  /// The blurhash string for image previews.
  @override
  final String? blurhash;

  /// Whether the file is stored internally, when available.
  @override
  final bool? storedInternal;

  /// The file URL, when available.
  @override
  final String? url;

  /// The thumbnail URL.
  @override
  final String? thumbnailUrl;

  /// The URL of the web-optimized file.
  @override
  final String? webpublicUrl;

  /// The MIME type of the web-optimized file.
  @override
  final String? webpublicType;

  /// The storage access key for the original file.
  @override
  final String? accessKey;

  /// The storage access key for the thumbnail.
  @override
  final String? thumbnailAccessKey;

  /// The storage access key for the web-optimized file.
  @override
  final String? webpublicAccessKey;

  /// The remote file URI, or null for local files.
  @override
  final String? uri;

  /// The original source URL.
  @override
  final String? src;

  /// The parent folder ID, or null for the root folder.
  @override
  final String? folderId;

  /// The upload request's IP address, or `null` when none was recorded for
  /// the file.
  @override
  final String? requestIp;

  /// The upload request's headers, as recorded by the server.
  ///
  /// `null` when no headers were recorded for the file or the file owner is a
  /// moderator.
  /// Values are usually strings, but a header sent more than once, such as
  /// `set-cookie`, is a list of strings.
  @override
  final Map<String, dynamic>? requestHeaders;
}
