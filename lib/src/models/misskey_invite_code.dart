import 'package:json_annotation/json_annotation.dart';

import 'json_converters.dart';
import 'misskey_user.dart';

part 'misskey_invite_code.g.dart';

/// 招待コード（`/api/invite/*` のレスポンス要素）
@JsonSerializable()
class MisskeyInviteCode {
  const MisskeyInviteCode({
    required this.id,
    required this.code,
    required this.createdAt,
    required this.used,
    this.expiresAt,
    this.createdBy,
    this.usedBy,
    this.usedAt,
  });

  factory MisskeyInviteCode.fromJson(Map<String, dynamic> json) =>
      _$MisskeyInviteCodeFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeyInviteCodeToJson(this);

  final String id;

  /// 招待コード文字列
  final String code;

  /// 有効期限
  @SafeDateTimeConverter()
  final DateTime? expiresAt;

  @SafeDateTimeConverter()
  final DateTime createdAt;

  /// 作成者
  final MisskeyUser? createdBy;

  /// 使用者
  final MisskeyUser? usedBy;

  /// 使用日時
  @SafeDateTimeConverter()
  final DateTime? usedAt;

  /// 使用済みか
  final bool used;
}
