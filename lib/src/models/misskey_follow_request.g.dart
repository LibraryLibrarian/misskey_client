// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'misskey_follow_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MisskeyFollowRequest _$MisskeyFollowRequestFromJson(
        Map<String, dynamic> json) =>
    MisskeyFollowRequest(
      id: json['id'] as String,
      follower: MisskeyUser.fromJson(json['follower'] as Map<String, dynamic>),
      followee: MisskeyUser.fromJson(json['followee'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MisskeyFollowRequestToJson(
        MisskeyFollowRequest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'follower': instance.follower,
      'followee': instance.followee,
    };
