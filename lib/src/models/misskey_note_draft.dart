import 'package:json_annotation/json_annotation.dart';

import 'json_converters.dart';
import 'misskey_poll.dart';

part 'misskey_note_draft.g.dart';

/// ノート下書き（`/api/notes/drafts/*`）
@JsonSerializable()
class MisskeyNoteDraft {
  const MisskeyNoteDraft({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
    this.visibility,
    this.visibleUserIds,
    this.cw,
    this.hashtag,
    this.localOnly,
    this.reactionAcceptance,
    this.replyId,
    this.renoteId,
    this.channelId,
    this.text,
    this.fileIds,
    this.poll,
    this.scheduledAt,
    this.isActuallyScheduled,
  });

  factory MisskeyNoteDraft.fromJson(Map<String, dynamic> json) =>
      _$MisskeyNoteDraftFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeyNoteDraftToJson(this);

  final String id;
  final DateTime createdAt;

  @SafeDateTimeConverter()
  final DateTime? updatedAt;

  final String userId;

  /// 公開範囲（`public` / `home` / `followers` / `specified`）
  final String? visibility;

  /// 指定可視性の対象ユーザーIDリスト
  @JsonKey(defaultValue: <String>[])
  final List<String>? visibleUserIds;

  /// コンテンツ警告テキスト
  final String? cw;

  /// ハッシュタグ
  final String? hashtag;

  /// ローカルのみ
  @JsonKey(defaultValue: false)
  final bool? localOnly;

  /// リアクション受入設定
  final String? reactionAcceptance;

  /// 返信先ノートID
  final String? replyId;

  /// リノート元ノートID
  final String? renoteId;

  /// チャンネルID
  final String? channelId;

  /// 本文
  final String? text;

  /// 添付ファイルIDリスト
  @JsonKey(defaultValue: <String>[])
  final List<String>? fileIds;

  /// 投票
  final MisskeyPoll? poll;

  /// 予約投稿日時（Unixタイムスタンプms）
  final int? scheduledAt;

  /// 予約投稿が有効かどうか
  @JsonKey(defaultValue: false)
  final bool? isActuallyScheduled;
}
