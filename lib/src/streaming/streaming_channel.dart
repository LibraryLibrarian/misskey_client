/// A typed definition of an official Misskey Streaming API channel.
sealed class MisskeyStreamingChannel {
  const MisskeyStreamingChannel._({
    required _MisskeyStreamingChannelKind kind,
    String? requiredId,
    bool? withRenotes,
    bool? withReplies,
    bool? withFiles,
    List<List<String>>? hashtags,
  }) : _kind = kind,
       _requiredId = requiredId,
       _withRenotes = withRenotes,
       _withReplies = withReplies,
       _withFiles = withFiles,
       _hashtags = hashtags;

  /// Creates a subscription to the authenticated user's main channel.
  const factory MisskeyStreamingChannel.main() = _MainChannel;

  /// Creates a subscription to the authenticated user's home timeline.
  const factory MisskeyStreamingChannel.homeTimeline({
    bool? withRenotes,
    bool? withFiles,
  }) = _HomeTimelineChannel;

  /// Creates a subscription to the local timeline.
  const factory MisskeyStreamingChannel.localTimeline({
    bool? withRenotes,
    bool? withReplies,
    bool? withFiles,
  }) = _LocalTimelineChannel;

  /// Creates a subscription to the hybrid timeline.
  const factory MisskeyStreamingChannel.hybridTimeline({
    bool? withRenotes,
    bool? withReplies,
    bool? withFiles,
  }) = _HybridTimelineChannel;

  /// Creates a subscription to the global timeline.
  const factory MisskeyStreamingChannel.globalTimeline({
    bool? withRenotes,
    bool? withFiles,
  }) = _GlobalTimelineChannel;

  /// Creates a subscription to a user list timeline.
  const factory MisskeyStreamingChannel.userList({
    required String listId,
    bool? withFiles,
    bool? withRenotes,
  }) = _UserListChannel;

  /// Creates a subscription to one or more hashtag conditions.
  const factory MisskeyStreamingChannel.hashtag({
    required List<List<String>> q,
  }) = _HashtagChannel;

  /// Creates a subscription to a role timeline.
  const factory MisskeyStreamingChannel.roleTimeline({required String roleId}) =
      _RoleTimelineChannel;

  /// Creates a subscription to an antenna.
  const factory MisskeyStreamingChannel.antenna({required String antennaId}) =
      _AntennaChannel;

  /// Creates a subscription to a channel timeline.
  const factory MisskeyStreamingChannel.channel({required String channelId}) =
      _ChannelTimelineChannel;

  /// Creates a subscription to drive events.
  const factory MisskeyStreamingChannel.drive() = _DriveChannel;

  /// Creates a subscription to server statistics.
  const factory MisskeyStreamingChannel.serverStats() = _ServerStatsChannel;

  /// Creates a subscription to queue statistics.
  const factory MisskeyStreamingChannel.queueStats() = _QueueStatsChannel;

  /// Creates a subscription to administrator events.
  const factory MisskeyStreamingChannel.admin() = _AdminChannel;

  /// Creates a subscription to Reversi lobby events.
  const factory MisskeyStreamingChannel.reversi() = _ReversiChannel;

  /// Creates a subscription to a Reversi game.
  const factory MisskeyStreamingChannel.reversiGame({required String gameId}) =
      _ReversiGameChannel;

  /// Creates a subscription to direct chat events with a user.
  const factory MisskeyStreamingChannel.chatUser({required String otherId}) =
      _ChatUserChannel;

  /// Creates a subscription to chat room events.
  const factory MisskeyStreamingChannel.chatRoom({required String roomId}) =
      _ChatRoomChannel;

  final _MisskeyStreamingChannelKind _kind;
  final String? _requiredId;
  final bool? _withRenotes;
  final bool? _withReplies;
  final bool? _withFiles;
  final List<List<String>>? _hashtags;

  /// The channel name used by the Streaming API protocol.
  String get name => _kind.name;

  /// The channel parameters, excluding optional values that are `null`.
  Map<String, Object?> get params {
    final params = <String, Object?>{};
    switch (_kind) {
      case _MisskeyStreamingChannelKind.homeTimeline:
      case _MisskeyStreamingChannelKind.globalTimeline:
        _addOptional(params, 'withRenotes', _withRenotes);
        _addOptional(params, 'withFiles', _withFiles);
      case _MisskeyStreamingChannelKind.localTimeline:
      case _MisskeyStreamingChannelKind.hybridTimeline:
        _addOptional(params, 'withRenotes', _withRenotes);
        _addOptional(params, 'withReplies', _withReplies);
        _addOptional(params, 'withFiles', _withFiles);
      case _MisskeyStreamingChannelKind.userList:
        params['listId'] = _requiredId;
        _addOptional(params, 'withFiles', _withFiles);
        _addOptional(params, 'withRenotes', _withRenotes);
      case _MisskeyStreamingChannelKind.hashtag:
        params['q'] = List<List<String>>.unmodifiable(
          _hashtags!.map(List<String>.unmodifiable),
        );
      case _MisskeyStreamingChannelKind.roleTimeline:
        params['roleId'] = _requiredId;
      case _MisskeyStreamingChannelKind.antenna:
        params['antennaId'] = _requiredId;
      case _MisskeyStreamingChannelKind.channel:
        params['channelId'] = _requiredId;
      case _MisskeyStreamingChannelKind.reversiGame:
        params['gameId'] = _requiredId;
      case _MisskeyStreamingChannelKind.chatUser:
        params['otherId'] = _requiredId;
      case _MisskeyStreamingChannelKind.chatRoom:
        params['roomId'] = _requiredId;
      case _MisskeyStreamingChannelKind.main:
      case _MisskeyStreamingChannelKind.drive:
      case _MisskeyStreamingChannelKind.serverStats:
      case _MisskeyStreamingChannelKind.queueStats:
      case _MisskeyStreamingChannelKind.admin:
      case _MisskeyStreamingChannelKind.reversi:
        break;
    }
    return Map.unmodifiable(params);
  }

  static void _addOptional(
    Map<String, Object?> params,
    String key,
    Object? value,
  ) {
    if (value != null) {
      params[key] = value;
    }
  }
}

final class _MainChannel extends MisskeyStreamingChannel {
  const _MainChannel() : super._(kind: _MisskeyStreamingChannelKind.main);
}

final class _HomeTimelineChannel extends MisskeyStreamingChannel {
  const _HomeTimelineChannel({super.withRenotes, super.withFiles})
    : super._(kind: _MisskeyStreamingChannelKind.homeTimeline);
}

final class _LocalTimelineChannel extends MisskeyStreamingChannel {
  const _LocalTimelineChannel({
    super.withRenotes,
    super.withReplies,
    super.withFiles,
  }) : super._(kind: _MisskeyStreamingChannelKind.localTimeline);
}

final class _HybridTimelineChannel extends MisskeyStreamingChannel {
  const _HybridTimelineChannel({
    super.withRenotes,
    super.withReplies,
    super.withFiles,
  }) : super._(kind: _MisskeyStreamingChannelKind.hybridTimeline);
}

final class _GlobalTimelineChannel extends MisskeyStreamingChannel {
  const _GlobalTimelineChannel({super.withRenotes, super.withFiles})
    : super._(kind: _MisskeyStreamingChannelKind.globalTimeline);
}

final class _UserListChannel extends MisskeyStreamingChannel {
  const _UserListChannel({
    required String listId,
    super.withFiles,
    super.withRenotes,
  }) : super._(kind: _MisskeyStreamingChannelKind.userList, requiredId: listId);
}

final class _HashtagChannel extends MisskeyStreamingChannel {
  const _HashtagChannel({required List<List<String>> q})
    : super._(kind: _MisskeyStreamingChannelKind.hashtag, hashtags: q);
}

final class _RoleTimelineChannel extends MisskeyStreamingChannel {
  const _RoleTimelineChannel({required String roleId})
    : super._(
        kind: _MisskeyStreamingChannelKind.roleTimeline,
        requiredId: roleId,
      );
}

final class _AntennaChannel extends MisskeyStreamingChannel {
  const _AntennaChannel({required String antennaId})
    : super._(
        kind: _MisskeyStreamingChannelKind.antenna,
        requiredId: antennaId,
      );
}

final class _ChannelTimelineChannel extends MisskeyStreamingChannel {
  const _ChannelTimelineChannel({required String channelId})
    : super._(
        kind: _MisskeyStreamingChannelKind.channel,
        requiredId: channelId,
      );
}

final class _DriveChannel extends MisskeyStreamingChannel {
  const _DriveChannel() : super._(kind: _MisskeyStreamingChannelKind.drive);
}

final class _ServerStatsChannel extends MisskeyStreamingChannel {
  const _ServerStatsChannel()
    : super._(kind: _MisskeyStreamingChannelKind.serverStats);
}

final class _QueueStatsChannel extends MisskeyStreamingChannel {
  const _QueueStatsChannel()
    : super._(kind: _MisskeyStreamingChannelKind.queueStats);
}

final class _AdminChannel extends MisskeyStreamingChannel {
  const _AdminChannel() : super._(kind: _MisskeyStreamingChannelKind.admin);
}

final class _ReversiChannel extends MisskeyStreamingChannel {
  const _ReversiChannel() : super._(kind: _MisskeyStreamingChannelKind.reversi);
}

final class _ReversiGameChannel extends MisskeyStreamingChannel {
  const _ReversiGameChannel({required String gameId})
    : super._(
        kind: _MisskeyStreamingChannelKind.reversiGame,
        requiredId: gameId,
      );
}

final class _ChatUserChannel extends MisskeyStreamingChannel {
  const _ChatUserChannel({required String otherId})
    : super._(kind: _MisskeyStreamingChannelKind.chatUser, requiredId: otherId);
}

final class _ChatRoomChannel extends MisskeyStreamingChannel {
  const _ChatRoomChannel({required String roomId})
    : super._(kind: _MisskeyStreamingChannelKind.chatRoom, requiredId: roomId);
}

enum _MisskeyStreamingChannelKind {
  main('main'),
  homeTimeline('homeTimeline'),
  localTimeline('localTimeline'),
  hybridTimeline('hybridTimeline'),
  globalTimeline('globalTimeline'),
  userList('userList'),
  hashtag('hashtag'),
  roleTimeline('roleTimeline'),
  antenna('antenna'),
  channel('channel'),
  drive('drive'),
  serverStats('serverStats'),
  queueStats('queueStats'),
  admin('admin'),
  reversi('reversi'),
  reversiGame('reversiGame'),
  chatUser('chatUser'),
  chatRoom('chatRoom');

  const _MisskeyStreamingChannelKind(this.name);

  final String name;
}
