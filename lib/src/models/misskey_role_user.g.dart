// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'misskey_role_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MisskeyRoleUser _$MisskeyRoleUserFromJson(Map<String, dynamic> json) =>
    MisskeyRoleUser(
      id: json['id'] as String,
      user: MisskeyUser.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MisskeyRoleUserToJson(MisskeyRoleUser instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user': instance.user.toJson(),
    };
