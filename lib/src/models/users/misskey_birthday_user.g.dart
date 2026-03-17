// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'misskey_birthday_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MisskeyBirthdayUser _$MisskeyBirthdayUserFromJson(Map<String, dynamic> json) =>
    MisskeyBirthdayUser(
      id: json['id'] as String,
      birthday: json['birthday'] as String,
      user: json['user'] == null
          ? null
          : MisskeyUser.fromJson(json['user'] as Map<String, dynamic>),
    );
