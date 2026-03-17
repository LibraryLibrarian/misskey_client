import 'package:json_annotation/json_annotation.dart';

part 'misskey_registry_scope.g.dart';

/// レジストリのスコープ・ドメイン情報
@JsonSerializable()
class MisskeyRegistryScope {
  const MisskeyRegistryScope({
    required this.scopes,
    this.domain,
  });

  factory MisskeyRegistryScope.fromJson(Map<String, dynamic> json) =>
      _$MisskeyRegistryScopeFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeyRegistryScopeToJson(this);

  /// スコープの二次元配列
  final List<List<String>> scopes;

  /// ドメイン（アクセストークン由来の場合はnull）
  final String? domain;
}
