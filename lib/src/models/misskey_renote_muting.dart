import 'package:json_annotation/json_annotation.dart';

import 'misskey_user.dart';

part 'misskey_renote_muting.g.dart';

/// リノートミュート関係（`/api/renote-mute/list` のレスポンス要素）
@JsonSerializable(createToJson: false)
class MisskeyRenoteMuting {
  const MisskeyRenoteMuting({
    required this.id,
    required this.createdAt,
    required this.muteeId,
    this.mutee,
  });

  factory MisskeyRenoteMuting.fromJson(Map<String, dynamic> json) =>
      _$MisskeyRenoteMutingFromJson(json);

  final String id;
  final DateTime createdAt;
  final String muteeId;
  final MisskeyUser? mutee;
}
