import 'package:json_annotation/json_annotation.dart';

import 'misskey_flash.dart';

part 'misskey_flash_like.g.dart';

/// A Flash (Play) like entry from the `/api/flash/my-likes` response.
@JsonSerializable()
class MisskeyFlashLike {
  const MisskeyFlashLike({
    required this.id,
    required this.flash,
  });

  factory MisskeyFlashLike.fromJson(Map<String, dynamic> json) =>
      _$MisskeyFlashLikeFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeyFlashLikeToJson(this);

  /// The like ID.
  final String id;

  /// The liked Flash.
  final MisskeyFlash flash;
}
