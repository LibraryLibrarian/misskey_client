import 'package:json_annotation/json_annotation.dart';

part 'misskey_registry_scope.g.dart';

/// レジストリのスコープ・ドメイン情報
@JsonSerializable(createToJson: false)
class MisskeyRegistryScope {
  const MisskeyRegistryScope({
    required this.scopes,
    this.domain,
  });

  factory MisskeyRegistryScope.fromJson(Map<String, dynamic> json) =>
      _$MisskeyRegistryScopeFromJson(json);

  /// スコープの二次元配列
  final List<List<String>> scopes;

  /// ドメイン（アクセストークン由来の場合はnull）
  final String? domain;
}
