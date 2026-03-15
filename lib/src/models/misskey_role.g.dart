// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'misskey_role.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MisskeyRole _$MisskeyRoleFromJson(Map<String, dynamic> json) => MisskeyRole(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      name: json['name'] as String,
      description: json['description'] as String,
      color: json['color'] as String?,
      iconUrl: json['iconUrl'] as String?,
      target: json['target'] as String,
      isPublic: json['isPublic'] as bool,
      isExplorable: json['isExplorable'] as bool,
      asBadge: json['asBadge'] as bool,
      canEditMembersByModerator: json['canEditMembersByModerator'] as bool,
      displayOrder: (json['displayOrder'] as num).toInt(),
      usersCount: (json['usersCount'] as num).toInt(),
    );
