import 'package:json_annotation/json_annotation.dart';

part 'misskey_registry_scope.g.dart';

/// Registry scope and domain information.
@JsonSerializable()
class MisskeyRegistryScope {
  const MisskeyRegistryScope({
    required this.scopes,
    this.domain,
  });

  factory MisskeyRegistryScope.fromJson(Map<String, dynamic> json) =>
      _$MisskeyRegistryScopeFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeyRegistryScopeToJson(this);

  /// Two-dimensional array of scopes.
  final List<List<String>> scopes;

  /// The domain, or `null` if derived from an access token.
  final String? domain;
}
