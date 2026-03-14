// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'misskey_registry_scope.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MisskeyRegistryScope _$MisskeyRegistryScopeFromJson(
        Map<String, dynamic> json) =>
    MisskeyRegistryScope(
      scopes: (json['scopes'] as List<dynamic>)
          .map((e) => (e as List<dynamic>).map((e) => e as String).toList())
          .toList(),
      domain: json['domain'] as String?,
    );
