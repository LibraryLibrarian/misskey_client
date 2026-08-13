import '../../client/auth_mode.dart';
import '../../client/misskey_http.dart';
import '../../client/request_options.dart';
import '../../internal/optional.dart';
import '../../internal/request_body.dart';
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
        'description': ?description,
        'bannerId': ?bannerId,
        'color': ?color,
        'isSensitive': ?isSensitive,
        'allowRenoteToExternal': ?allowRenoteToExternal,
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
  ///
  /// Omitted parameters keep their current value. For [description] and
  /// [bannerId], use the [Optional] type: pass `Optional('value')` to set and
  /// `Optional.null_()` to clear.
  ///
  /// Beware that clearing [bannerId] does not work on Misskey 2026.5.1: the
  /// server builds its update object with `banner ? { bannerId: banner.id }
  /// : {}`, so an explicit `null` is dropped. Passing `Optional.null_()` on
  /// its own leaves the update object empty and the server responds with a
  /// 500 (`INTERNAL_ERROR`); combined with another parameter the call
  /// succeeds but the banner is left in place. `Optional.null_()` is still
  /// the correct way to express the intent and will take effect once the
  /// server is fixed.
  Future<MisskeyChannel> update({
    required String channelId,
    String? name,
    Optional<String>? description,
    Optional<String>? bannerId,
    bool? isArchived,
    List<String>? pinnedNoteIds,
    String? color,
    bool? isSensitive,
    bool? allowRenoteToExternal,
  }) async {
    final body = <String, dynamic>{
      'channelId': channelId,
      'name': ?name,
      'isArchived': ?isArchived,
      'pinnedNoteIds': ?pinnedNoteIds,
      'color': ?color,
      'isSensitive': ?isSensitive,
      'allowRenoteToExternal': ?allowRenoteToExternal,
    };
    putOptional(body, 'description', description);
    putOptional(body, 'bannerId', bannerId);
    final res = await _http.send<Map<String, dynamic>>(
      '/channels/update',
      body: body,
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
      'limit': ?limit,
      'sinceId': ?sinceId,
      'untilId': ?untilId,
      'sinceDate': ?sinceDate,
      'untilDate': ?untilDate,
      'allowPartial': ?allowPartial,
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
      'limit': ?limit,
      'sinceId': ?sinceId,
      'untilId': ?untilId,
      'sinceDate': ?sinceDate,
      'untilDate': ?untilDate,
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
      'limit': ?limit,
      'sinceId': ?sinceId,
      'untilId': ?untilId,
      'sinceDate': ?sinceDate,
      'untilDate': ?untilDate,
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
      'limit': ?limit,
      'type': ?type,
      'sinceId': ?sinceId,
      'untilId': ?untilId,
      'sinceDate': ?sinceDate,
      'untilDate': ?untilDate,
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
