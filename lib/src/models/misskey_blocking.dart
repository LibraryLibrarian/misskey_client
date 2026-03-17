import 'package:json_annotation/json_annotation.dart';

import 'misskey_user.dart';

part 'misskey_blocking.g.dart';

/// ブロック関係（`/api/blocking/list` のレスポンス要素）
@JsonSerializable(createToJson: false)
class MisskeyBlocking {
  const MisskeyBlocking({
    required this.id,
    required this.createdAt,
    required this.blockeeId,
    this.blockee,
  });

  factory MisskeyBlocking.fromJson(Map<String, dynamic> json) =>
      _$MisskeyBlockingFromJson(json);

  final String id;
  final DateTime createdAt;
  final String blockeeId;
  final MisskeyUser? blockee;
}
