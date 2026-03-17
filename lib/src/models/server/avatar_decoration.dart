import 'package:json_annotation/json_annotation.dart';

part 'avatar_decoration.g.dart';

/// アバターデコレーション情報（`/api/get-avatar-decorations`）
@JsonSerializable(createToJson: false)
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

  /// デコレーションID
  final String id;

  /// デコレーション名
  final String name;

  /// 説明文
  final String description;

  /// 画像URL
  final String url;

  /// このデコレーションを使用可能なロールIDのリスト
  final List<String> roleIdsThatCanBeUsedThisDecoration;
}
