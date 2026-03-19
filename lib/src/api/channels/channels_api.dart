import '../../client/auth_mode.dart';
import '../../client/misskey_http.dart';
import '../../client/request_options.dart';
import '../../models/misskey_channel.dart';
import '../../models/misskey_note.dart';
import 'channel_mute_api.dart';

/// Provides channel APIs.
///
/// Offers endpoints under `channels/*`.
/// Use the [mute] sub-API for mute operations.
class ChannelsApi {
  ChannelsApi({required MisskeyHttp http})
      : _http = http,
        mute = ChannelMuteApi(http: http);

  final MisskeyHttp _http;

  /// Provides channel mute APIs.
  final ChannelMuteApi mute;

  /// Creates a channel.
  ///
  /// [name] is the channel name (1-128 characters, required).
  /// [description] is the channel description (up to 2048 characters).
  /// [bannerId] is the drive file ID for the banner image.
  /// [color] is the channel theme color (1-16 characters).
  /// [isSensitive] indicates whether the channel is sensitive.
  /// [allowRenoteToExternal] indicates whether renotes outside the channel
  /// are allowed.
  Future<MisskeyChannel> create({
    required String name,
    String? description,
    String? bannerId,
    String? color,
    bool? isSensitive,
    bool? allowRenoteToExternal,
  }) async {
    final res = await _http.send<Map<String, dynamic>>(
      '/channels/create',
      body: <String, dynamic>{
        'name': name,
        if (description != null) 'description': description,
        if (bannerId != null) 'bannerId': bannerId,
        if (color != null) 'color': color,
        if (isSensitive != null) 'isSensitive': isSensitive,
        if (allowRenoteToExternal != null)
          'allowRenoteToExternal': allowRenoteToExternal,
      },
    );
    return MisskeyChannel.fromJson(res);
  }

  /// Updates a channel.
  ///
  /// Specify the target channel with [channelId] (required).
  /// [name] is the channel name (1-128 characters).
  /// [description] is the channel description (up to 2048 characters).
  /// [bannerId] is the drive file ID for the banner image.
  /// [isArchived] indicates whether to archive the channel.
  /// [pinnedNoteIds] is the list of note IDs to pin.
  /// [color] is the channel theme color (1-16 characters).
  /// [isSensitive] indicates whether the channel is sensitive.
  /// [allowRenoteToExternal] indicates whether renotes outside the channel
  /// are allowed.
  Future<MisskeyChannel> update({
    required String channelId,
    String? name,
    String? description,
    String? bannerId,
    bool? isArchived,
    List<String>? pinnedNoteIds,
    String? color,
    bool? isSensitive,
    bool? allowRenoteToExternal,
  }) async {
    final res = await _http.send<Map<String, dynamic>>(
      '/channels/update',
      body: <String, dynamic>{
        'channelId': channelId,
        if (name != null) 'name': name,
        if (description != null) 'description': description,
        if (bannerId != null) 'bannerId': bannerId,
        if (isArchived != null) 'isArchived': isArchived,
        if (pinnedNoteIds != null) 'pinnedNoteIds': pinnedNoteIds,
        if (color != null) 'color': color,
        if (isSensitive != null) 'isSensitive': isSensitive,
        if (allowRenoteToExternal != null)
          'allowRenoteToExternal': allowRenoteToExternal,
      },
    );
    return MisskeyChannel.fromJson(res);
  }

  /// Retrieves the list of favorited channels.
  ///
  /// Returns all channels favorited by the authenticated user.
  /// No input parameters.
  Future<List<MisskeyChannel>> myFavorites() async {
    final res = await _http.send<List<dynamic>>(
      '/channels/my-favorites',
      body: const <String, dynamic>{},
      options: const RequestOptions(idempotent: true),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyChannel.fromJson)
        .toList();
  }

  /// Retrieves the details of a channel.
  ///
  /// Specify the target channel with [channelId].
  /// Throws an error if the channel does not exist.
  Future<MisskeyChannel> show({required String channelId}) async {
    final res = await _http.send<Map<String, dynamic>>(
      '/channels/show',
      body: <String, dynamic>{'channelId': channelId},
      options: const RequestOptions(
        authMode: AuthMode.optional,
        idempotent: true,
      ),
    );
    return MisskeyChannel.fromJson(res);
  }

  /// Retrieves the timeline of a channel.
  ///
  /// Specify the target channel with [channelId].
  /// [sinceId] / [untilId] provide pagination by ID.
  /// [sinceDate] / [untilDate] provide pagination by Unix timestamp (ms).
  /// Set [allowPartial] to `true` to allow partial results.
  Future<List<MisskeyNote>> timeline({
    required String channelId,
    int? limit,
    String? sinceId,
    String? untilId,
    int? sinceDate,
    int? untilDate,
    bool? allowPartial,
  }) async {
    final body = <String, dynamic>{
      'channelId': channelId,
      if (limit != null) 'limit': limit,
      if (sinceId != null) 'sinceId': sinceId,
      if (untilId != null) 'untilId': untilId,
      if (sinceDate != null) 'sinceDate': sinceDate,
      if (untilDate != null) 'untilDate': untilDate,
      if (allowPartial != null) 'allowPartial': allowPartial,
    };
    final res = await _http.send<List<dynamic>>(
      '/channels/timeline',
      body: body,
      options: const RequestOptions(
        authMode: AuthMode.optional,
        idempotent: true,
      ),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyNote.fromJson)
        .toList();
  }

  /// Retrieves the list of featured channels.
  ///
  /// No input parameters.
  /// Returns up to 10 channels with recent posts.
  Future<List<MisskeyChannel>> featured() async {
    final res = await _http.send<List<dynamic>>(
      '/channels/featured',
      body: const <String, dynamic>{},
      options: const RequestOptions(
        authMode: AuthMode.optional,
        idempotent: true,
      ),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyChannel.fromJson)
        .toList();
  }

  /// Retrieves the list of followed channels.
  ///
  /// [sinceId] / [untilId] provide pagination by ID.
  /// [sinceDate] / [untilDate] provide pagination by Unix timestamp (ms).
  Future<List<MisskeyChannel>> followed({
    int? limit,
    String? sinceId,
    String? untilId,
    int? sinceDate,
    int? untilDate,
  }) async {
    final body = <String, dynamic>{
      if (limit != null) 'limit': limit,
      if (sinceId != null) 'sinceId': sinceId,
      if (untilId != null) 'untilId': untilId,
      if (sinceDate != null) 'sinceDate': sinceDate,
      if (untilDate != null) 'untilDate': untilDate,
    };
    final res = await _http.send<List<dynamic>>(
      '/channels/followed',
      body: body,
      options: const RequestOptions(idempotent: true),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyChannel.fromJson)
        .toList();
  }

  /// Retrieves the list of owned channels.
  ///
  /// [sinceId] / [untilId] provide pagination by ID.
  /// [sinceDate] / [untilDate] provide pagination by Unix timestamp (ms).
  Future<List<MisskeyChannel>> owned({
    int? limit,
    String? sinceId,
    String? untilId,
    int? sinceDate,
    int? untilDate,
  }) async {
    final body = <String, dynamic>{
      if (limit != null) 'limit': limit,
      if (sinceId != null) 'sinceId': sinceId,
      if (untilId != null) 'untilId': untilId,
      if (sinceDate != null) 'sinceDate': sinceDate,
      if (untilDate != null) 'untilDate': untilDate,
    };
    final res = await _http.send<List<dynamic>>(
      '/channels/owned',
      body: body,
      options: const RequestOptions(idempotent: true),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyChannel.fromJson)
        .toList();
  }

  /// Searches channels by keyword.
  ///
  /// Specify the search term with [query] (required).
  /// [type] sets the search target to `'nameAndDescription'` (default) or
  /// `'nameOnly'`.
  /// [sinceId] / [untilId] provide pagination by ID.
  /// [sinceDate] / [untilDate] provide pagination by Unix timestamp (ms).
  Future<List<MisskeyChannel>> search({
    required String query,
    int? limit,
    String? type,
    String? sinceId,
    String? untilId,
    int? sinceDate,
    int? untilDate,
  }) async {
    final body = <String, dynamic>{
      'query': query,
      if (limit != null) 'limit': limit,
      if (type != null) 'type': type,
      if (sinceId != null) 'sinceId': sinceId,
      if (untilId != null) 'untilId': untilId,
      if (sinceDate != null) 'sinceDate': sinceDate,
      if (untilDate != null) 'untilDate': untilDate,
    };
    final res = await _http.send<List<dynamic>>(
      '/channels/search',
      body: body,
      options: const RequestOptions(
        authMode: AuthMode.optional,
        idempotent: true,
      ),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyChannel.fromJson)
        .toList();
  }

  /// Follows a channel.
  ///
  /// Specify the target channel with [channelId].
  Future<void> follow({required String channelId}) => _http.send<Object?>(
        '/channels/follow',
        body: <String, dynamic>{'channelId': channelId},
      );

  /// Unfollows a channel.
  ///
  /// Specify the target channel with [channelId].
  Future<void> unfollow({required String channelId}) => _http.send<Object?>(
        '/channels/unfollow',
        body: <String, dynamic>{'channelId': channelId},
      );

  /// Favorites a channel.
  ///
  /// Specify the target channel with [channelId].
  Future<void> favorite({required String channelId}) => _http.send<Object?>(
        '/channels/favorite',
        body: <String, dynamic>{'channelId': channelId},
      );

  /// Unfavorites a channel.
  ///
  /// Specify the target channel with [channelId].
  Future<void> unfavorite({required String channelId}) => _http.send<Object?>(
        '/channels/unfavorite',
        body: <String, dynamic>{'channelId': channelId},
      );
}
