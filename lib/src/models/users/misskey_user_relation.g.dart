// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'misskey_user_relation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MisskeyUserRelation _$MisskeyUserRelationFromJson(Map<String, dynamic> json) =>
    MisskeyUserRelation(
      id: json['id'] as String,
      isFollowing: json['isFollowing'] as bool? ?? false,
      hasPendingFollowRequestFromYou:
          json['hasPendingFollowRequestFromYou'] as bool? ?? false,
      hasPendingFollowRequestToYou:
          json['hasPendingFollowRequestToYou'] as bool? ?? false,
      isFollowed: json['isFollowed'] as bool? ?? false,
      isBlocking: json['isBlocking'] as bool? ?? false,
      isBlocked: json['isBlocked'] as bool? ?? false,
      isMuted: json['isMuted'] as bool? ?? false,
      isRenoteMuted: json['isRenoteMuted'] as bool? ?? false,
    );
