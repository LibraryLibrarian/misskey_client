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

Map<String, dynamic> _$MisskeyDriveFileToJson(MisskeyDriveFile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt.toIso8601String(),
      'name': instance.name,
      'type': instance.type,
      'size': instance.size,
      'md5': instance.md5,
      'url': instance.url,
      'thumbnailUrl': instance.thumbnailUrl,
      'comment': instance.comment,
      'folderId': instance.folderId,
      'folder': instance.folder?.toJson(),
      'userId': instance.userId,
      'user': instance.user?.toJson(),
      'isSensitive': instance.isSensitive,
      'blurhash': instance.blurhash,
      'properties': instance.properties?.toJson(),
    };

MisskeyDriveFileProperties _$MisskeyDriveFilePropertiesFromJson(
        Map<String, dynamic> json) =>
    MisskeyDriveFileProperties(
      width: (json['width'] as num?)?.toInt(),
      height: (json['height'] as num?)?.toInt(),
      orientation: (json['orientation'] as num?)?.toInt(),
      avgColor: json['avgColor'] as String?,
    );

Map<String, dynamic> _$MisskeyDriveFilePropertiesToJson(
        MisskeyDriveFileProperties instance) =>
    <String, dynamic>{
      'width': instance.width,
      'height': instance.height,
      'orientation': instance.orientation,
      'avgColor': instance.avgColor,
    };
