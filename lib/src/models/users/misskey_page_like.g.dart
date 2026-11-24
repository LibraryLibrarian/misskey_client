// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'misskey_page_like.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MisskeyPageLike _$MisskeyPageLikeFromJson(Map<String, dynamic> json) =>
    MisskeyPageLike(
      id: json['id'] as String,
      page: MisskeyPage.fromJson(json['page'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MisskeyPageLikeToJson(MisskeyPageLike instance) =>
    <String, dynamic>{'id': instance.id, 'page': instance.page.toJson()};
