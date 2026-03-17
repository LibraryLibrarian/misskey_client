import 'package:json_annotation/json_annotation.dart';

import 'misskey_user.dart';

part 'misskey_muting.g.dart';

/// ミュート関係（`/api/mute/list` のレスポンス要素）
@JsonSerializable(createToJson: false)
class MisskeyMuting {
  const MisskeyMuting({
    required this.id,
    required this.createdAt,
    this.expiresAt,
    required this.muteeId,
    this.mutee,
  });

  factory MisskeyMuting.fromJson(Map<String, dynamic> json) =>
      _$MisskeyMutingFromJson(json);

  final String id;
  final DateTime createdAt;

  /// ミュートの有効期限。nullの場合は無期限
  final DateTime? expiresAt;

  final String muteeId;
  final MisskeyUser? mutee;
}
