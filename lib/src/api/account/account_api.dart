import '../../client/misskey_http.dart';
import '../../client/request_options.dart';
import '../../internal/optional.dart';
import '../../models/account/misskey_signin_history.dart';
import '../../models/gallery/misskey_gallery_like.dart';
import '../../models/gallery/misskey_gallery_post.dart';
import '../../models/misskey_note_favorite.dart';
import '../../models/misskey_user.dart';
import 'registry_api.dart';
import 'two_factor_api.dart';
import 'webhooks_api.dart';

/// Provides APIs for the currently authenticated user (`/api/i/*`).
class AccountApi {
  AccountApi({required this.http})
      : registry = RegistryApi(http: http),
        twoFactor = TwoFactorApi(http: http),
        webhooks = WebhooksApi(http: http);

  final MisskeyHttp http;

  /// Provides registry (client settings storage) APIs.
  final RegistryApi registry;

  /// Provides two-factor authentication (2FA) APIs.
  final TwoFactorApi twoFactor;

  /// Provides webhook management APIs.
  final WebhooksApi webhooks;

  /// Retrieves the details of the currently authenticated user (`/api/i`).
  ///
  /// Returns detailed user information (MeDetailed) associated with the
  /// authentication token.
  Future<MisskeyUser> i() async {
    final res = await http.send<Map<String, dynamic>>(
      '/i',
      body: const <String, dynamic>{},
    );
    return MisskeyUser.fromJson(res);
  }

  /// Updates the profile information (`/api/i/update`).
  ///
  /// Only the specified fields are updated; omitted fields remain unchanged.
  /// Returns the updated user information (MeDetailed).
  ///
  /// Fields that accept `null` on the server side use the [Optional] type:
  /// passing `Optional('value')` sets the field, passing `Optional.null_()`
  /// sends `null` to clear it, and omitting the parameter (default `null`)
  /// leaves the field unchanged.
  ///
  /// [name] sets the display name and [description] sets the bio text.
  /// [location] and [birthday] (in `YYYY-MM-DD` format) update the
  /// corresponding profile fields. [lang] sets the language code.
  ///
  /// [avatarId] and [bannerId] are Drive file IDs for the avatar and banner
  /// images respectively. [avatarDecorations] accepts up to 16 decoration
  /// objects, each with `{id: String, angle: double?, flipH: bool?,
  /// offsetX: double?, offsetY: double?}`. [fields] sets profile fields
  /// (up to 16 entries, each `{name, value}`).
  ///
  /// [isLocked] controls whether follow approval is required.
  /// [isExplorable] controls whether the account appears in recommended users.
  /// [hideOnlineStatus] hides the online status when true.
  /// [publicReactions] makes reactions public when true.
  /// [carefulBot] requires approval for follows from bots when true.
  /// [autoAcceptFollowed] automatically accepts follow requests from users
  /// the account already follows. [noCrawle] refuses search engine indexing.
  /// [preventAiLearning] refuses AI learning. [isBot] marks the account as
  /// a bot and [isCat] marks it as a cat account.
  /// [injectFeaturedNote] injects featured notes into the timeline.
  /// [receiveAnnouncementEmail] controls announcement emails.
  /// [alwaysMarkNsfw] always marks content as NSFW.
  /// [autoSensitive] enables automatic sensitive detection.
  ///
  /// [followingVisibility] and [followersVisibility] each accept
  /// `public`, `followers`, or `private`.
  /// [chatScope] sets the chat reception scope and accepts `everyone`,
  /// `followers`, `following`, `mutual`, or `none`.
  /// [requireSigninToViewContents] restricts content to signed-in users.
  ///
  /// [makeNotesFollowersOnlyBefore] makes notes created before the given
  /// Unix timestamp (ms) followers-only. [makeNotesHiddenBefore] hides notes
  /// before that timestamp. [pinnedPageId] pins the specified page ID.
  ///
  /// [mutedWords] is a list where each element is either an AND-condition
  /// string list or a regex string. [hardMutedWords] works similarly for
  /// hard mutes. [mutedInstances] is a list of hostnames to mute.
  /// [alsoKnownAs] holds URIs of alternate accounts (migration source,
  /// up to 10). [followedMessage] sets the message shown when followed
  /// (use `Optional.null_()` to clear it).
  ///
  /// [notificationRecieveConfig] maps notification type names
  /// (`note`, `follow`, `mention`, `reply`, `renote`, `quote`, `reaction`,
  /// `pollEnded`, `scheduledNotePosted`, `scheduledNotePostFailed`,
  /// `receiveFollowRequest`, `followRequestAccepted`, `roleAssigned`,
  /// `chatRoomInvitationReceived`, `achievementEarned`, `app`, `test`) to
  /// reception settings of the form `{"type": "all"|"following"|"follower"|
  /// "mutualFollow"|"followingOrFollower"|"never"}` or
  /// `{"type": "list", "userListId": "<id>"}`.
  /// [emailNotificationTypes] lists the notification types to receive by
  /// email.
  Future<MisskeyUser> update({
    Optional<String>? name,
    Optional<String>? description,
    Optional<String>? location,
    Optional<String>? birthday,
    Optional<String>? lang,
    Optional<String>? avatarId,
    List<Map<String, dynamic>>? avatarDecorations,
    Optional<String>? bannerId,
    List<Map<String, String>>? fields,
    bool? isLocked,
    bool? isExplorable,
    bool? hideOnlineStatus,
    bool? publicReactions,
    bool? carefulBot,
    bool? autoAcceptFollowed,
    bool? noCrawle,
    bool? preventAiLearning,
    bool? isBot,
    bool? isCat,
    bool? injectFeaturedNote,
    bool? receiveAnnouncementEmail,
    bool? alwaysMarkNsfw,
    bool? autoSensitive,
    String? followingVisibility,
    String? followersVisibility,
    String? chatScope,
    bool? requireSigninToViewContents,
    Optional<int>? makeNotesFollowersOnlyBefore,
    Optional<int>? makeNotesHiddenBefore,
    Optional<String>? pinnedPageId,
    List<dynamic>? mutedWords,
    List<dynamic>? hardMutedWords,
    List<String>? mutedInstances,
    Map<String, Map<String, dynamic>>? notificationRecieveConfig,
    List<String>? emailNotificationTypes,
    List<String>? alsoKnownAs,
    Optional<String>? followedMessage,
  }) async {
    final body = <String, dynamic>{};
    _putOptional(body, 'name', name);
    _putOptional(body, 'description', description);
    _putOptional(body, 'location', location);
    _putOptional(body, 'birthday', birthday);
    _putOptional(body, 'lang', lang);
    _putOptional(body, 'avatarId', avatarId);
    if (avatarDecorations != null) {
      body['avatarDecorations'] = avatarDecorations;
    }
    _putOptional(body, 'bannerId', bannerId);
    if (fields != null) body['fields'] = fields;
    if (isLocked != null) body['isLocked'] = isLocked;
    if (isExplorable != null) body['isExplorable'] = isExplorable;
    if (hideOnlineStatus != null) body['hideOnlineStatus'] = hideOnlineStatus;
    if (publicReactions != null) body['publicReactions'] = publicReactions;
    if (carefulBot != null) body['carefulBot'] = carefulBot;
    if (autoAcceptFollowed != null) {
      body['autoAcceptFollowed'] = autoAcceptFollowed;
    }
    if (noCrawle != null) body['noCrawle'] = noCrawle;
    if (preventAiLearning != null) {
      body['preventAiLearning'] = preventAiLearning;
    }
    if (isBot != null) body['isBot'] = isBot;
    if (isCat != null) body['isCat'] = isCat;
    if (injectFeaturedNote != null) {
      body['injectFeaturedNote'] = injectFeaturedNote;
    }
    if (receiveAnnouncementEmail != null) {
      body['receiveAnnouncementEmail'] = receiveAnnouncementEmail;
    }
    if (alwaysMarkNsfw != null) body['alwaysMarkNsfw'] = alwaysMarkNsfw;
    if (autoSensitive != null) body['autoSensitive'] = autoSensitive;
    if (followingVisibility != null) {
      body['followingVisibility'] = followingVisibility;
    }
    if (followersVisibility != null) {
      body['followersVisibility'] = followersVisibility;
    }
    if (chatScope != null) body['chatScope'] = chatScope;
    if (requireSigninToViewContents != null) {
      body['requireSigninToViewContents'] = requireSigninToViewContents;
    }
    _putOptional(
        body, 'makeNotesFollowersOnlyBefore', makeNotesFollowersOnlyBefore);
    _putOptional(body, 'makeNotesHiddenBefore', makeNotesHiddenBefore);
    _putOptional(body, 'pinnedPageId', pinnedPageId);
    if (mutedWords != null) body['mutedWords'] = mutedWords;
    if (hardMutedWords != null) body['hardMutedWords'] = hardMutedWords;
    if (mutedInstances != null) body['mutedInstances'] = mutedInstances;
    if (notificationRecieveConfig != null) {
      body['notificationRecieveConfig'] = notificationRecieveConfig;
    }
    if (emailNotificationTypes != null) {
      body['emailNotificationTypes'] = emailNotificationTypes;
    }
    if (alsoKnownAs != null) body['alsoKnownAs'] = alsoKnownAs;
    _putOptional(body, 'followedMessage', followedMessage);
    final res = await http.send<Map<String, dynamic>>(
      '/i/update',
      body: body,
    );
    return MisskeyUser.fromJson(res);
  }

  /// Pins a note to the profile (`/api/i/pin`).
  ///
  /// Specify the target note with [noteId].
  /// Returns the updated user information (MeDetailed).
  Future<MisskeyUser> pin({required String noteId}) async {
    final res = await http.send<Map<String, dynamic>>(
      '/i/pin',
      body: <String, dynamic>{'noteId': noteId},
    );
    return MisskeyUser.fromJson(res);
  }

  /// Unpins a note from the profile (`/api/i/unpin`).
  ///
  /// Specify the target note with [noteId].
  /// Returns the updated user information (MeDetailed).
  Future<MisskeyUser> unpin({required String noteId}) async {
    final res = await http.send<Map<String, dynamic>>(
      '/i/unpin',
      body: <String, dynamic>{'noteId': noteId},
    );
    return MisskeyUser.fromJson(res);
  }

  /// Retrieves the list of favorited notes (`/api/i/favorites`).
  ///
  /// [limit] controls how many items are returned (1–100, default 10).
  /// Use [sinceId] and [untilId] to paginate by ID, or [sinceDate] and
  /// [untilDate] to paginate by Unix timestamp (ms).
  Future<List<MisskeyNoteFavorite>> favorites({
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
    final res = await http.send<List<dynamic>>(
      '/i/favorites',
      body: body,
      options: const RequestOptions(idempotent: true),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyNoteFavorite.fromJson)
        .toList();
  }

  /// Marks a server announcement as read (`/api/i/read-announcement`).
  ///
  /// Specify the target announcement with [announcementId].
  Future<void> readAnnouncement({required String announcementId}) =>
      http.send<Object?>(
        '/i/read-announcement',
        body: <String, dynamic>{'announcementId': announcementId},
      );

  /// Claims an achievement (`/api/i/claim-achievement`).
  ///
  /// Specify the server-defined achievement name with [name].
  Future<void> claimAchievement({required String name}) => http.send<Object?>(
        '/i/claim-achievement',
        body: <String, dynamic>{'name': name},
      );

  /// Retrieves the list of Pages created by the current user (`/api/i/pages`).
  ///
  /// [limit] controls how many items are returned (1–100, default 10).
  /// Use [sinceId] and [untilId] to paginate by ID, or [sinceDate] and
  /// [untilDate] to paginate by Unix timestamp (ms).
  Future<List<Map<String, dynamic>>> pages({
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
    final res = await http.send<List<dynamic>>(
      '/i/pages',
      body: body,
      options: const RequestOptions(idempotent: true),
    );
    return res.whereType<Map<String, dynamic>>().toList();
  }

  /// Retrieves the list of Pages liked by the current user
  /// (`/api/i/page-likes`).
  ///
  /// [limit] controls how many items are returned (1–100, default 10).
  /// Use [sinceId] and [untilId] to paginate by ID, or [sinceDate] and
  /// [untilDate] to paginate by Unix timestamp (ms).
  Future<List<Map<String, dynamic>>> pageLikes({
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
    final res = await http.send<List<dynamic>>(
      '/i/page-likes',
      body: body,
      options: const RequestOptions(idempotent: true),
    );
    return res.whereType<Map<String, dynamic>>().toList();
  }

  /// Changes the account password (`/api/i/change-password`).
  ///
  /// [currentPassword] is the current password and [newPassword] is the
  /// replacement (at least 1 character). If two-factor authentication is
  /// enabled, supply the current TOTP code as [token].
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    String? token,
  }) =>
      http.send<Object?>(
        '/i/change-password',
        body: <String, dynamic>{
          'currentPassword': currentPassword,
          'newPassword': newPassword,
          if (token != null) 'token': token,
        },
      );

  /// Updates the email address (`/api/i/update-email`).
  ///
  /// [password] is the current account password. [email] sets the new address;
  /// pass `Optional.null_()` to unset it. If two-factor authentication is
  /// enabled, supply the current TOTP code as [token].
  ///
  /// Returns the updated user information (MeDetailed).
  Future<MisskeyUser> updateEmail({
    required String password,
    Optional<String>? email,
    String? token,
  }) async {
    final body = <String, dynamic>{
      'password': password,
      if (token != null) 'token': token,
    };
    _putOptional(body, 'email', email);
    final res = await http.send<Map<String, dynamic>>(
      '/i/update-email',
      body: body,
    );
    return MisskeyUser.fromJson(res);
  }

  /// Regenerates the API token (`/api/i/regenerate-token`).
  ///
  /// The current token is invalidated after execution. [password] is the
  /// current account password and is required.
  Future<void> regenerateToken({required String password}) =>
      http.send<Object?>(
        '/i/regenerate-token',
        body: <String, dynamic>{'password': password},
      );

  /// Revokes an authorized token by token ID (`/api/i/revoke-token`).
  Future<void> revokeTokenById(String tokenId) => http.send<Object?>(
        '/i/revoke-token',
        body: <String, dynamic>{'tokenId': tokenId},
      );

  /// Revokes an authorized token by token string (`/api/i/revoke-token`).
  Future<void> revokeTokenByToken(String token) => http.send<Object?>(
        '/i/revoke-token',
        body: <String, dynamic>{'token': token},
      );

  /// Deletes the account (`/api/i/delete-account`).
  ///
  /// [password] is the account password and is required. If two-factor
  /// authentication is enabled, supply the current TOTP code as [token].
  Future<void> deleteAccount({
    required String password,
    String? token,
  }) =>
      http.send<Object?>(
        '/i/delete-account',
        body: <String, dynamic>{
          'password': password,
          if (token != null) 'token': token,
        },
      );

  /// Retrieves the list of access tokens created by the current user
  /// (`/api/i/apps`).
  ///
  /// [sort] controls the ordering and accepts `+createdAt`, `-createdAt`,
  /// `+lastUsedAt`, or `-lastUsedAt`.
  Future<List<Map<String, dynamic>>> apps({String? sort}) async {
    final body = <String, dynamic>{
      if (sort != null) 'sort': sort,
    };
    final res = await http.send<List<dynamic>>(
      '/i/apps',
      body: body,
      options: const RequestOptions(idempotent: true),
    );
    return res.whereType<Map<String, dynamic>>().toList();
  }

  /// Retrieves the list of authorized applications (`/api/i/authorized-apps`).
  ///
  /// [limit] controls how many items are returned (1–100, default 10).
  /// [offset] sets the starting position (default 0). [sort] controls the
  /// ordering and accepts `desc` or `asc` (default `desc`).
  Future<List<Map<String, dynamic>>> authorizedApps({
    int? limit,
    int? offset,
    String? sort,
  }) async {
    final body = <String, dynamic>{
      if (limit != null) 'limit': limit,
      if (offset != null) 'offset': offset,
      if (sort != null) 'sort': sort,
    };
    final res = await http.send<List<dynamic>>(
      '/i/authorized-apps',
      body: body,
      options: const RequestOptions(idempotent: true),
    );
    return res.whereType<Map<String, dynamic>>().toList();
  }

  /// Retrieves the sign-in history (`/api/i/signin-history`).
  ///
  /// [limit] controls how many items are returned (1–100, default 10).
  /// Use [sinceId] and [untilId] to paginate by ID, or [sinceDate] and
  /// [untilDate] to paginate by Unix timestamp (ms).
  Future<List<MisskeySigninHistory>> signinHistory({
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
    final res = await http.send<List<dynamic>>(
      '/i/signin-history',
      body: body,
      options: const RequestOptions(idempotent: true),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeySigninHistory.fromJson)
        .toList();
  }

  /// Moves the account to another instance (`/api/i/move`).
  ///
  /// The destination account must have already set `alsoKnownAs` to reference
  /// the source account. Cannot be executed by root users or accounts that
  /// have already moved. [moveToAccount] identifies the destination in
  /// `@user@host` format.
  Future<MisskeyUser> move({required String moveToAccount}) async {
    final res = await http.send<Map<String, dynamic>>(
      '/i/move',
      body: <String, dynamic>{'moveToAccount': moveToAccount},
    );
    return MisskeyUser.fromJson(res);
  }

  /// Exports notes (`/api/i/export-notes`).
  ///
  /// Queued as an asynchronous job. A notification is sent upon completion.
  Future<void> exportNotes() => http.send<Object?>(
        '/i/export-notes',
        body: const <String, dynamic>{},
      );

  /// Exports the following list (`/api/i/export-following`).
  ///
  /// When [excludeMuting] is true, muted users are omitted from the export
  /// (default false). When [excludeInactive] is true, inactive users are
  /// omitted (default false).
  Future<void> exportFollowing({
    bool? excludeMuting,
    bool? excludeInactive,
  }) =>
      http.send<Object?>(
        '/i/export-following',
        body: <String, dynamic>{
          if (excludeMuting != null) 'excludeMuting': excludeMuting,
          if (excludeInactive != null) 'excludeInactive': excludeInactive,
        },
      );

  /// Exports the block list (`/api/i/export-blocking`).
  Future<void> exportBlocking() => http.send<Object?>(
        '/i/export-blocking',
        body: const <String, dynamic>{},
      );

  /// Exports the mute list (`/api/i/export-mute`).
  Future<void> exportMute() => http.send<Object?>(
        '/i/export-mute',
        body: const <String, dynamic>{},
      );

  /// Exports favorites (`/api/i/export-favorites`).
  Future<void> exportFavorites() => http.send<Object?>(
        '/i/export-favorites',
        body: const <String, dynamic>{},
      );

  /// Exports antenna settings (`/api/i/export-antennas`).
  Future<void> exportAntennas() => http.send<Object?>(
        '/i/export-antennas',
        body: const <String, dynamic>{},
      );

  /// Exports clips (`/api/i/export-clips`).
  Future<void> exportClips() => http.send<Object?>(
        '/i/export-clips',
        body: const <String, dynamic>{},
      );

  /// Exports user lists (`/api/i/export-user-lists`).
  Future<void> exportUserLists() => http.send<Object?>(
        '/i/export-user-lists',
        body: const <String, dynamic>{},
      );

  /// Imports a following list (`/api/i/import-following`).
  ///
  /// [fileId] is the Drive file ID of the import file. When [withReplies] is
  /// true, followed accounts are followed with replies enabled.
  Future<void> importFollowing({
    required String fileId,
    bool? withReplies,
  }) =>
      http.send<Object?>(
        '/i/import-following',
        body: <String, dynamic>{
          'fileId': fileId,
          if (withReplies != null) 'withReplies': withReplies,
        },
      );

  /// Imports a block list (`/api/i/import-blocking`).
  ///
  /// [fileId] is the Drive file ID of the import file.
  Future<void> importBlocking({required String fileId}) => http.send<Object?>(
        '/i/import-blocking',
        body: <String, dynamic>{'fileId': fileId},
      );

  /// Imports a mute list (`/api/i/import-muting`).
  ///
  /// [fileId] is the Drive file ID of the import file.
  Future<void> importMuting({required String fileId}) => http.send<Object?>(
        '/i/import-muting',
        body: <String, dynamic>{'fileId': fileId},
      );

  /// Imports antenna settings (`/api/i/import-antennas`).
  ///
  /// [fileId] is the Drive file ID of the import file.
  Future<void> importAntennas({required String fileId}) => http.send<Object?>(
        '/i/import-antennas',
        body: <String, dynamic>{'fileId': fileId},
      );

  /// Imports user lists (`/api/i/import-user-lists`).
  ///
  /// [fileId] is the Drive file ID of the import file.
  Future<void> importUserLists({required String fileId}) => http.send<Object?>(
        '/i/import-user-lists',
        body: <String, dynamic>{'fileId': fileId},
      );

  /// Retrieves the list of gallery posts by the current user
  /// (`/api/i/gallery/posts`).
  ///
  /// [limit] controls how many items are returned (1–100, default 10).
  /// Use [sinceId] and [untilId] to paginate by ID, or [sinceDate] and
  /// [untilDate] to paginate by Unix timestamp (ms).
  Future<List<MisskeyGalleryPost>> galleryPosts({
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
    final res = await http.send<List<dynamic>>(
      '/i/gallery/posts',
      body: body,
      options: const RequestOptions(idempotent: true),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyGalleryPost.fromJson)
        .toList();
  }

  /// Retrieves the list of gallery posts liked by the current user
  /// (`/api/i/gallery/likes`).
  ///
  /// [limit] controls how many items are returned (1–100, default 10).
  /// Use [sinceId] and [untilId] to paginate by ID, or [sinceDate] and
  /// [untilDate] to paginate by Unix timestamp (ms).
  Future<List<MisskeyGalleryLike>> galleryLikes({
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
    final res = await http.send<List<dynamic>>(
      '/i/gallery/likes',
      body: body,
      options: const RequestOptions(idempotent: true),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyGalleryLike.fromJson)
        .toList();
  }
}

/// Adds an [Optional]-wrapped value to the request body.
///
/// When [opt] is `null` (unspecified) the function does nothing. When [opt]
/// is a [Some] instance, `body[key]` is set to the wrapped value, which is
/// `null` for `Some.null_()`.
void _putOptional<T>(
  Map<String, dynamic> body,
  String key,
  Optional<T>? opt,
) {
  if (opt case Some<T>(:final value)) {
    body[key] = value;
  }
}
