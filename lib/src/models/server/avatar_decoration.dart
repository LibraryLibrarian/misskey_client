import 'package:freezed_annotation/freezed_annotation.dart';

part 'avatar_decoration.freezed.dart';
part 'avatar_decoration.g.dart';

/// An avatar decoration returned by `/api/get-avatar-decorations`.
@freezed
@JsonSerializable()
class AvatarDecoration with _$AvatarDecoration {
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
  @override
  final String id;

  /// The decoration name.
  @override
  final String name;

  /// The description of this decoration.
  @override
  final String description;

  /// The image URL.
  @override
  final String url;

  /// The list of role IDs that can use this decoration.
  @override
  final List<String> roleIdsThatCanBeUsedThisDecoration;
}
