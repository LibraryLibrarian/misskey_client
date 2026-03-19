import 'package:json_annotation/json_annotation.dart';

import 'misskey_drive_folder.dart';
import 'misskey_user.dart';

part 'misskey_drive_file.g.dart';

/// A Misskey drive file.
@JsonSerializable()
class MisskeyDriveFile {
  const MisskeyDriveFile({
    required this.id,
    required this.createdAt,
    required this.name,
    required this.type,
    required this.size,
    required this.md5,
    required this.url,
    this.thumbnailUrl,
    this.comment,
    this.folderId,
    this.folder,
    this.userId,
    this.user,
    this.isSensitive,
    this.blurhash,
    this.properties,
  });

  factory MisskeyDriveFile.fromJson(Map<String, dynamic> json) =>
      _$MisskeyDriveFileFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeyDriveFileToJson(this);

  /// The file ID.
  final String id;

  /// The upload timestamp.
  final DateTime createdAt;

  /// The file name.
  final String name;

  /// The MIME type.
  final String type;

  /// The file size in bytes.
  final int size;

  /// The MD5 hash of the file.
  final String md5;

  /// The file URL.
  final String url;

  /// The thumbnail URL.
  final String? thumbnailUrl;

  /// The user-provided comment or caption.
  final String? comment;

  /// The parent folder ID.
  final String? folderId;

  /// The parent folder.
  final MisskeyDriveFolder? folder;

  /// The owner user's ID.
  final String? userId;

  /// The owner user.
  final MisskeyUser? user;

  /// Whether the file is marked as sensitive.
  @JsonKey(defaultValue: false)
  final bool? isSensitive;

  /// The blurhash string for image previews.
  final String? blurhash;

  /// The image properties (width, height, etc.).
  final MisskeyDriveFileProperties? properties;
}

/// Properties of a drive file (image dimensions, etc.).
@JsonSerializable()
class MisskeyDriveFileProperties {
  const MisskeyDriveFileProperties({
    this.width,
    this.height,
    this.orientation,
    this.avgColor,
  });

  factory MisskeyDriveFileProperties.fromJson(Map<String, dynamic> json) =>
      _$MisskeyDriveFilePropertiesFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeyDriveFilePropertiesToJson(this);

  /// The image width in pixels.
  final int? width;

  /// The image height in pixels.
  final int? height;

  /// The EXIF orientation value.
  final int? orientation;

  /// The average color of the image.
  final String? avgColor;
}
