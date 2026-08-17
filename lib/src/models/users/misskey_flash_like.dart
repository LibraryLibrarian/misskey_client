import 'package:freezed_annotation/freezed_annotation.dart';

import 'misskey_flash.dart';

part 'misskey_flash_like.freezed.dart';
part 'misskey_flash_like.g.dart';

/// A Flash (Play) like entry from the `/api/flash/my-likes` response.
@freezed
@JsonSerializable()
class MisskeyFlashLike with _$MisskeyFlashLike {
  const MisskeyFlashLike({required this.id, required this.flash});

  factory MisskeyFlashLike.fromJson(Map<String, dynamic> json) =>
      _$MisskeyFlashLikeFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeyFlashLikeToJson(this);

  /// The like ID.
  @override
  final String id;

  /// The liked Flash.
  @override
  final MisskeyFlash flash;
}
