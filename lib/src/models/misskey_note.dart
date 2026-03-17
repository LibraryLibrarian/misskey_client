import 'package:json_annotation/json_annotation.dart';

import 'json_converters.dart';
import 'misskey_drive_file.dart';
import 'misskey_poll.dart';
import 'misskey_user.dart';

part 'misskey_note.g.dart';

/// ノートの公開範囲
@JsonEnum()
enum MisskeyNoteVisibility {
  public,
  home,
  followers,
  specified,
}

/// リアクション受入設定
@JsonEnum()
enum MisskeyReactionAcceptance {
  /// null means accept all (we represent this as a default)
  likeOnlyForRemote,
  nonSensitiveOnly,
  nonSensitiveOnlyForLocalLikeOnlyForRemote,
  likeOnly,
}

/// Misskey のノート（投稿）
@JsonSerializable(createToJson: false)
class MisskeyNote {
  const MisskeyNote({
    required this.id,
    required this.createdAt,
    required this.userId,
    required this.user,
    this.text,
    this.cw,
    this.visibility,
    this.localOnly,
    this.reactionAcceptance,
    this.renoteCount,
    this.repliesCount,
    this.reactionCount,
    this.reactions,
    this.emojis,
    this.fileIds,
    this.files,
    this.replyId,
    this.renoteId,
    this.reply,
    this.renote,
    this.uri,
    this.url,
    this.channelId,
    this.channel,
    this.mentions,
    this.visibleUserIds,
    this.tags,
    this.poll,
    this.myReaction,
    this.clippedCount,
    this.deletedAt,
    this.isHidden,
    this.reactionEmojis,
    this.reactionAndUserPairCache,
  });

  factory MisskeyNote.fromJson(Map<String, dynamic> json) =>
      _$MisskeyNoteFromJson(json);

  final String id;
  final DateTime createdAt;
  final String userId;
  final MisskeyUser user;

  /// 本文（MFM形式）。リノートのみの場合は null
  final String? text;

  /// コンテンツ警告（CW）テキスト
  final String? cw;

  @JsonKey(unknownEnumValue: MisskeyNoteVisibility.public)
  final MisskeyNoteVisibility? visibility;

  @JsonKey(defaultValue: false)
  final bool? localOnly;

  final MisskeyReactionAcceptance? reactionAcceptance;

  @JsonKey(defaultValue: 0)
  final int? renoteCount;

  @JsonKey(defaultValue: 0)
  final int? repliesCount;

  @JsonKey(defaultValue: 0)
  final int? reactionCount;

  /// リアクションのマップ {emoji: count}
  @JsonKey(defaultValue: <String, int>{})
  final Map<String, int>? reactions;

  /// ノートで使われているカスタム絵文字 {shortcode: url}
  @JsonKey(defaultValue: <String, String>{})
  final Map<String, String>? emojis;

  @JsonKey(defaultValue: <String>[])
  final List<String>? fileIds;

  @JsonKey(defaultValue: <MisskeyDriveFile>[])
  final List<MisskeyDriveFile>? files;

  /// 返信先ノートID
  final String? replyId;

  /// リノート元ノートID
  final String? renoteId;

  /// 返信先ノート
  final MisskeyNote? reply;

  /// リノート元ノート
  final MisskeyNote? renote;

  /// ActivityPub URI
  final String? uri;

  /// ノートのURL
  final String? url;

  /// チャンネルID
  final String? channelId;

  /// チャンネル情報
  final MisskeyNoteChannel? channel;

  /// メンション先ユーザーIDリスト
  final List<String>? mentions;

  /// 指定可視性の対象ユーザーIDリスト
  final List<String>? visibleUserIds;

  /// ハッシュタグリスト
  final List<String>? tags;

  /// 投票
  final MisskeyPoll? poll;

  /// 自分のリアクション（認証時のみ）
  final String? myReaction;

  /// クリップ数
  @JsonKey(defaultValue: 0)
  final int? clippedCount;

  /// 削除日時
  @SafeDateTimeConverter()
  final DateTime? deletedAt;

  /// 非表示フラグ
  @JsonKey(defaultValue: false)
  final bool? isHidden;

  /// リアクション絵文字マップ {shortcode: url}
  @JsonKey(defaultValue: <String, String>{})
  final Map<String, String>? reactionEmojis;

  /// リアクションとユーザーのペアキャッシュ
  final List<String>? reactionAndUserPairCache;
}

/// ノートに含まれるチャンネル情報（軽量版）
@JsonSerializable(createToJson: false)
class MisskeyNoteChannel {
  const MisskeyNoteChannel({
    required this.id,
    this.name,
    this.color,
    this.isSensitive,
    this.allowRenoteToExternal,
    this.userId,
  });

  factory MisskeyNoteChannel.fromJson(Map<String, dynamic> json) =>
      _$MisskeyNoteChannelFromJson(json);

  final String id;
  final String? name;
  final String? color;
  final bool? isSensitive;
  final bool? allowRenoteToExternal;
  final String? userId;
}
