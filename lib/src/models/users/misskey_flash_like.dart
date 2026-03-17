import 'package:json_annotation/json_annotation.dart';

import 'misskey_flash.dart';

part 'misskey_flash_like.g.dart';

/// Flash（Play）へのいいね情報（`/api/flash/my-likes` のレスポンス要素）
@JsonSerializable(createToJson: false)
class MisskeyFlashLike {
  const MisskeyFlashLike({
    required this.id,
    required this.flash,
  });

  factory MisskeyFlashLike.fromJson(Map<String, dynamic> json) =>
      _$MisskeyFlashLikeFromJson(json);

  final String id;

  /// いいね対象のFlash
  final MisskeyFlash flash;
}
