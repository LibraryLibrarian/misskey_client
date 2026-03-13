// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'misskey_following.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MisskeyFollowing _$MisskeyFollowingFromJson(Map<String, dynamic> json) =>
    MisskeyFollowing(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      followeeId: json['followeeId'] as String,
      followerId: json['followerId'] as String,
      followee: json['followee'] == null
          ? null
          : MisskeyUser.fromJson(json['followee'] as Map<String, dynamic>),
      follower: json['follower'] == null
          ? null
          : MisskeyUser.fromJson(json['follower'] as Map<String, dynamic>),
    );
