// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'misskey_drive_folder.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MisskeyDriveFolder _$MisskeyDriveFolderFromJson(Map<String, dynamic> json) =>
    MisskeyDriveFolder(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      name: json['name'] as String,
      parentId: json['parentId'] as String?,
      parent: json['parent'] == null
          ? null
          : MisskeyDriveFolder.fromJson(json['parent'] as Map<String, dynamic>),
      foldersCount: (json['foldersCount'] as num?)?.toInt() ?? 0,
      filesCount: (json['filesCount'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$MisskeyDriveFolderToJson(MisskeyDriveFolder instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt.toIso8601String(),
      'name': instance.name,
      'parentId': instance.parentId,
      'parent': instance.parent?.toJson(),
      'foldersCount': instance.foldersCount,
      'filesCount': instance.filesCount,
    };
