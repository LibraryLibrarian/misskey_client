import 'package:json_annotation/json_annotation.dart';

part 'misskey_antenna.g.dart';

/// Misskey のアンテナ（カスタムタイムラインフィルター）
@JsonSerializable()
class MisskeyAntenna {
  const MisskeyAntenna({
    required this.id,
    required this.createdAt,
    required this.name,
    required this.keywords,
    required this.excludeKeywords,
    required this.src,
    this.userListId,
    required this.users,
    required this.caseSensitive,
    required this.localOnly,
    required this.excludeBots,
    required this.withReplies,
    required this.withFile,
    required this.excludeNotesInSensitiveChannel,
    required this.isActive,
    this.hasUnreadNote = false,
    this.notify = false,
  });

  factory MisskeyAntenna.fromJson(Map<String, dynamic> json) =>
      _$MisskeyAntennaFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeyAntennaToJson(this);

  final String id;
  final DateTime createdAt;

  /// アンテナ名（1〜100文字）
  final String name;

  /// キーワード（外側OR、内側AND）
  final List<List<String>> keywords;

  /// 除外キーワード（外側OR、内側AND）
  final List<List<String>> excludeKeywords;

  /// ソース種別（`home` / `all` / `users` / `list` / `users_blacklist`）
  final String src;

  /// ソースが `list` の場合のユーザーリストID
  final String? userListId;

  /// ソースが `users` / `users_blacklist` の場合の対象ユーザー名リスト
  final List<String> users;

  /// 大文字小文字を区別するか
  final bool caseSensitive;

  /// ローカルノートのみ対象にするか
  final bool localOnly;

  /// botアカウントを除外するか
  final bool excludeBots;

  /// リプライを含めるか
  final bool withReplies;

  /// ファイル付きノートのみ対象にするか
  final bool withFile;

  /// センシティブチャンネルのノートを除外するか
  final bool excludeNotesInSensitiveChannel;

  /// アンテナがアクティブかどうか
  final bool isActive;

  /// 未読ノートがあるか
  @JsonKey(defaultValue: false)
  final bool hasUnreadNote;

  /// 通知を有効にするか
  @JsonKey(defaultValue: false)
  final bool notify;
}
