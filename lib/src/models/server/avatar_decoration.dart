import 'package:json_annotation/json_annotation.dart';

part 'avatar_decoration.g.dart';

/// An avatar decoration returned by `/api/get-avatar-decorations`.
@JsonSerializable()
class AvatarDecoration {
  const AvatarDecoration({
    required this.id,
    required this.name,
    required this.description,
    required this.url,
    required this.roleIdsThatCanBeUsedThisDecoration,
  });

  factory AvatarDecoration.fromJson(Map<String, dynamic> json) =>
      _$AvatarDecorationFromJson(json);

  Map<String, dynamic> toJson() => _$AvatarDecorationToJson(this);

  /// The decoration ID.
  final String id;

  /// The decoration name.
  final String name;

  /// The description of this decoration.
  final String description;

  /// The image URL.
  final String url;

  /// The list of role IDs that can use this decoration.
  final List<String> roleIdsThatCanBeUsedThisDecoration;
}
