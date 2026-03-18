// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'misskey_user_list_membership.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MisskeyUserListMembership _$MisskeyUserListMembershipFromJson(
        Map<String, dynamic> json) =>
    MisskeyUserListMembership(
      id: json['id'] as String,
      createdAt:
          const SafeDateTimeConverter().fromJson(json['createdAt'] as String?),
      userId: json['userId'] as String,
      user: json['user'] == null
          ? null
          : MisskeyUser.fromJson(json['user'] as Map<String, dynamic>),
      withReplies: json['withReplies'] as bool? ?? false,
    );

Map<String, dynamic> _$MisskeyUserListMembershipToJson(
        MisskeyUserListMembership instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdAt': const SafeDateTimeConverter().toJson(instance.createdAt),
      'userId': instance.userId,
      'user': instance.user?.toJson(),
      'withReplies': instance.withReplies,
    };
