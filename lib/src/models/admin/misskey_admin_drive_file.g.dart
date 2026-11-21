// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'misskey_admin_drive_file.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MisskeyAdminDriveFile _$MisskeyAdminDriveFileFromJson(
  Map<String, dynamic> json,
) => MisskeyAdminDriveFile(
  id: json['id'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  md5: json['md5'] as String,
  name: json['name'] as String,
  type: json['type'] as String,
  size: (json['size'] as num).toInt(),
  properties: MisskeyDriveFileProperties.fromJson(
    json['properties'] as Map<String, dynamic>,
  ),
  isSensitive: json['isSensitive'] as bool,
  isLink: json['isLink'] as bool,
  maybeSensitive: json['maybeSensitive'] as bool,
  maybePorn: json['maybePorn'] as bool,
  userId: json['userId'] as String?,
  userHost: json['userHost'] as String?,
  comment: json['comment'] as String?,
  blurhash: json['blurhash'] as String?,
  storedInternal: json['storedInternal'] as bool?,
  url: json['url'] as String?,
  thumbnailUrl: json['thumbnailUrl'] as String?,
  webpublicUrl: json['webpublicUrl'] as String?,
  webpublicType: json['webpublicType'] as String?,
  accessKey: json['accessKey'] as String?,
  thumbnailAccessKey: json['thumbnailAccessKey'] as String?,
  webpublicAccessKey: json['webpublicAccessKey'] as String?,
  uri: json['uri'] as String?,
  src: json['src'] as String?,
  folderId: json['folderId'] as String?,
  requestIp: json['requestIp'] as String?,
  requestHeaders: (json['requestHeaders'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(k, e as String),
  ),
);

Map<String, dynamic> _$MisskeyAdminDriveFileToJson(
  MisskeyAdminDriveFile instance,
) => <String, dynamic>{
  'id': instance.id,
  'createdAt': instance.createdAt.toIso8601String(),
  'md5': instance.md5,
  'name': instance.name,
  'type': instance.type,
  'size': instance.size,
  'properties': instance.properties.toJson(),
  'isSensitive': instance.isSensitive,
  'isLink': instance.isLink,
  'maybeSensitive': instance.maybeSensitive,
  'maybePorn': instance.maybePorn,
  'userId': instance.userId,
  'userHost': instance.userHost,
  'comment': instance.comment,
  'blurhash': instance.blurhash,
  'storedInternal': instance.storedInternal,
  'url': instance.url,
  'thumbnailUrl': instance.thumbnailUrl,
  'webpublicUrl': instance.webpublicUrl,
  'webpublicType': instance.webpublicType,
  'accessKey': instance.accessKey,
  'thumbnailAccessKey': instance.thumbnailAccessKey,
  'webpublicAccessKey': instance.webpublicAccessKey,
  'uri': instance.uri,
  'src': instance.src,
  'folderId': instance.folderId,
  'requestIp': instance.requestIp,
  'requestHeaders': instance.requestHeaders,
};
