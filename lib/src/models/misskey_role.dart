import 'package:json_annotation/json_annotation.dart';

part 'misskey_role.g.dart';

/// ロール情報（`/api/roles/show` 等のレスポンス）
@JsonSerializable(createToJson: false)
class MisskeyRole {
  const MisskeyRole({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.name,
    required this.description,
    this.color,
    this.iconUrl,
    required this.target,
    required this.isPublic,
    required this.isExplorable,
    required this.asBadge,
    required this.canEditMembersByModerator,
    required this.displayOrder,
    required this.usersCount,
  });

  factory MisskeyRole.fromJson(Map<String, dynamic> json) =>
      _$MisskeyRoleFromJson(json);

  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;

  /// ロール名
  final String name;

  /// ロールの説明
  final String description;

  /// テーマカラー（例: `#ff0000`）
  final String? color;

  /// アイコンURL
  final String? iconUrl;

  /// 割り当て方式（`manual` / `conditional`）
  final String target;

  /// 公開ロールか
  final bool isPublic;

  /// おすすめロール一覧に表示するか
  final bool isExplorable;

  /// バッジとして表示するか
  final bool asBadge;

  /// モデレーターがメンバーを編集可能か
  final bool canEditMembersByModerator;

  /// 表示順
  final int displayOrder;

  /// 所属ユーザー数
  final int usersCount;
}
