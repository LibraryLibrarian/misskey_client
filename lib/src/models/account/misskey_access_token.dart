import 'package:freezed_annotation/freezed_annotation.dart';

import '../json_converters.dart';

part 'misskey_access_token.freezed.dart';
part 'misskey_access_token.g.dart';

/// An access token entry from the `/api/i/apps` response.
@freezed
@JsonSerializable()
class MisskeyAccessToken with _$MisskeyAccessToken {
  const MisskeyAccessToken({
    required this.id,
    required this.createdAt,
    required this.permission,
    this.name,
    this.lastUsedAt,
    this.iconUrl,
    this.description,
  });

  factory MisskeyAccessToken.fromJson(Map<String, dynamic> json) =>
      _$MisskeyAccessTokenFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeyAccessTokenToJson(this);

  /// The token record ID, usable with `AccountApi.revokeTokenById`.
  @override
  final String id;

  /// The creation date and time.
  @SafeDateTimeConverter()
  @override
  final DateTime createdAt;

  /// The permissions granted to the token or its application.
  @override
  final List<String> permission;

  /// The token name or its application's name, when available.
  @override
  final String? name;

  /// The last use date and time, omitted for unused tokens.
  @SafeDateTimeConverter()
  @override
  final DateTime? lastUsedAt;

  /// The token icon URL, when available.
  @override
  final String? iconUrl;

  /// The token description or its application's description.
  @override
  final String? description;
}
