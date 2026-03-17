// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'misskey_user_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MisskeyUserList _$MisskeyUserListFromJson(Map<String, dynamic> json) =>
    MisskeyUserList(
      id: json['id'] as String,
      createdAt:
          const SafeDateTimeConverter().fromJson(json['createdAt'] as String?),
      name: json['name'] as String,
      userIds: (json['userIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      isPublic: json['isPublic'] as bool? ?? false,
      likedCount: (json['likedCount'] as num?)?.toInt(),
      isLiked: json['isLiked'] as bool?,
    );

Map<String, dynamic> _$MisskeyUserListToJson(MisskeyUserList instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdAt': const SafeDateTimeConverter().toJson(instance.createdAt),
      'name': instance.name,
      'userIds': instance.userIds,
      'isPublic': instance.isPublic,
      'likedCount': instance.likedCount,
      'isLiked': instance.isLiked,
    };
