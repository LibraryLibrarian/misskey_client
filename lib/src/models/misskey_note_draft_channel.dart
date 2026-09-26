import 'package:freezed_annotation/freezed_annotation.dart';

part 'misskey_note_draft_channel.freezed.dart';
part 'misskey_note_draft_channel.g.dart';

/// The partial channel information embedded in a note draft.
///
/// Unlike a full channel response, a draft does not include fields such as
/// the channel creation timestamp.
@freezed
@JsonSerializable()
class MisskeyNoteDraftChannel with _$MisskeyNoteDraftChannel {
  const MisskeyNoteDraftChannel({
    required this.id,
    required this.name,
    required this.color,
    required this.isSensitive,
    required this.allowRenoteToExternal,
    this.userId,
  });

  factory MisskeyNoteDraftChannel.fromJson(Map<String, dynamic> json) =>
      _$MisskeyNoteDraftChannelFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeyNoteDraftChannelToJson(this);

  /// The channel ID.
  @override
  final String id;

  /// The channel name.
  @override
  final String name;

  /// The channel theme color.
  @override
  final String color;

  /// Whether the channel is marked as sensitive.
  @override
  final bool isSensitive;

  /// Whether renotes to external channels are allowed.
  @override
  final bool allowRenoteToExternal;

  /// The owner user's ID.
  @override
  final String? userId;
}
