import 'package:freezed_annotation/freezed_annotation.dart';

part 'misskey_registry_scope.freezed.dart';
part 'misskey_registry_scope.g.dart';

/// Registry scope and domain information.
@freezed
@JsonSerializable()
class MisskeyRegistryScope with _$MisskeyRegistryScope {
  const MisskeyRegistryScope({required this.scopes, this.domain});

  factory MisskeyRegistryScope.fromJson(Map<String, dynamic> json) =>
      _$MisskeyRegistryScopeFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeyRegistryScopeToJson(this);

  /// Two-dimensional array of scopes.
  @override
  final List<List<String>> scopes;

  /// The domain, or `null` if derived from an access token.
  @override
  final String? domain;
}
