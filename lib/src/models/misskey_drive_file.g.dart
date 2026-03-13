// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'misskey_drive_file.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MisskeyDriveFile _$MisskeyDriveFileFromJson(Map<String, dynamic> json) =>
    MisskeyDriveFile(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      name: json['name'] as String,
      type: json['type'] as String,
      size: (json['size'] as num).toInt(),
      md5: json['md5'] as String,
      url: json['url'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      comment: json['comment'] as String?,
      folderId: json['folderId'] as String?,
      folder: json['folder'] == null
          ? null
          : MisskeyDriveFolder.fromJson(json['folder'] as Map<String, dynamic>),
      userId: json['userId'] as String?,
      user: json['user'] == null
          ? null
          : MisskeyUser.fromJson(json['user'] as Map<String, dynamic>),
      isSensitive: json['isSensitive'] as bool? ?? false,
      blurhash: json['blurhash'] as String?,
      properties: json['properties'] == null
          ? null
          : MisskeyDriveFileProperties.fromJson(
              json['properties'] as Map<String, dynamic>),
    );

MisskeyDriveFileProperties _$MisskeyDriveFilePropertiesFromJson(
        Map<String, dynamic> json) =>
    MisskeyDriveFileProperties(
      width: (json['width'] as num?)?.toInt(),
      height: (json['height'] as num?)?.toInt(),
      orientation: (json['orientation'] as num?)?.toInt(),
      avgColor: json['avgColor'] as String?,
    );
