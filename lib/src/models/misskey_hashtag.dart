import 'package:json_annotation/json_annotation.dart';

part 'misskey_hashtag.g.dart';

/// ハッシュタグ情報（`/api/hashtags/show` 等のレスポンス）
@JsonSerializable()
class MisskeyHashtag {
  const MisskeyHashtag({
    required this.tag,
    required this.mentionedUsersCount,
    required this.mentionedLocalUsersCount,
    required this.mentionedRemoteUsersCount,
    required this.attachedUsersCount,
    required this.attachedLocalUsersCount,
    required this.attachedRemoteUsersCount,
  });

  factory MisskeyHashtag.fromJson(Map<String, dynamic> json) =>
      _$MisskeyHashtagFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeyHashtagToJson(this);

  /// ハッシュタグ文字列
  final String tag;

  /// メンションしたユーザー数（全体）
  final int mentionedUsersCount;

  /// メンションしたローカルユーザー数
  final int mentionedLocalUsersCount;

  /// メンションしたリモートユーザー数
  final int mentionedRemoteUsersCount;

  /// プロフィールに設定しているユーザー数（全体）
  final int attachedUsersCount;

  /// プロフィールに設定しているローカルユーザー数
  final int attachedLocalUsersCount;

  /// プロフィールに設定しているリモートユーザー数
  final int attachedRemoteUsersCount;
}
