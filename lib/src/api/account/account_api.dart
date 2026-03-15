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

/// 現在ログイン中ユーザー（自分）のAPI（`/api/i/*`）
class AccountApi {
  AccountApi({required this.http})
      : registry = RegistryApi(http: http),
        twoFactor = TwoFactorApi(http: http),
        webhooks = WebhooksApi(http: http);

  final MisskeyHttp http;

  /// レジストリ（クライアント設定保存領域）関連API
  final RegistryApi registry;

  /// 二要素認証（2FA）関連API
  final TwoFactorApi twoFactor;

  /// Webhook管理API
  final WebhooksApi webhooks;

  /// 現在ログイン中ユーザーの詳細を取得（`/api/i`）
  ///
  /// 認証トークンに紐づくユーザー（自分）の詳細情報（MeDetailed）を返す。
  Future<MisskeyUser> i() async {
    final res = await http.send<Map<String, dynamic>>(
      '/i',
      body: const <String, dynamic>{},
    );
    return MisskeyUser.fromJson(res);
  }

  /// プロフィール情報を更新する（`/api/i/update`）
  ///
  /// 更新対象のフィールドのみ指定する。指定しないフィールドは変更されない。
  /// 更新後のユーザー情報（MeDetailed）を返す。
  ///
  /// サーバー側で`null`を受け付ける項目は[Optional]型で受け取る。
  /// - `Optional('値')` → 値をセット
  /// - `Optional.null_()` → `null`を送信してクリア
  /// - 省略（デフォルト`null`）→ 変更なし
  ///
  /// - [name]: 表示名
  /// - [description]: 自己紹介文
  /// - [location]: 所在地
  /// - [birthday]: 誕生日（`YYYY-MM-DD`形式）
  /// - [lang]: 言語コード
  /// - [avatarId]: アバター画像のドライブファイルID
  /// - [bannerId]: バナー画像のドライブファイルID
  /// - [fields]: プロフィールフィールド（最大16件、各 `{name, value}`）
  /// - [isLocked]: フォロー承認制にするか
  /// - [isExplorable]: おすすめユーザーに表示するか
  /// - [hideOnlineStatus]: オンライン状態を隠すか
  /// - [publicReactions]: リアクション一覧を公開するか
  /// - [carefulBot]: botからのフォローを承認制にするか
  /// - [autoAcceptFollowed]: フォロー中ユーザーからのフォローリクエストを自動承認するか
  /// - [noCrawle]: 検索エンジンのインデックスを拒否するか
  /// - [preventAiLearning]: AI学習を拒否するか
  /// - [isBot]: botアカウントか
  /// - [isCat]: 猫か
  /// - [injectFeaturedNote]: 注目ノートをTLに挿入するか
  /// - [receiveAnnouncementEmail]: お知らせをメールで受信するか
  /// - [alwaysMarkNsfw]: 常にNSFWマークを付けるか
  /// - [autoSensitive]: 自動センシティブ判定を有効にするか
  /// - [followingVisibility]: フォロー一覧の公開範囲（`public`/`followers`/`private`）
  /// - [followersVisibility]: フォロワー一覧の公開範囲（`public`/`followers`/`private`）
  /// - [requireSigninToViewContents]: コンテンツ閲覧にサインインを必須にするか
  /// - [makeNotesFollowersOnlyBefore]: 指定時刻以前のノートをフォロワー限定にする（ms）
  /// - [makeNotesHiddenBefore]: 指定時刻以前のノートを非公開にする（ms）
  /// - [pinnedPageId]: ピン留めするページID
  /// - [mutedWords]: ミュートワード（各要素は AND 条件の文字列リストまたは正規表現文字列）
  /// - [hardMutedWords]: ハードミュートワード
  /// - [mutedInstances]: ミュートするインスタンスのホスト名リスト
  /// - [alsoKnownAs]: 別アカウント（引っ越し元）のURI（最大10件）
  /// - [followedMessage]: フォローされた時に表示するメッセージ
  /// - [avatarDecorations]: アバターデコレーション（最大16件）。
  ///   各要素は `{id: String, angle: double?,
  ///   flipH: bool?, offsetX: double?, offsetY: double?}`
  /// - [chatScope]: チャットの受信範囲（`everyone`/`followers`/`following`/`mutual`/`none`）
  /// - [notificationRecieveConfig]: 通知タイプ別の受信設定。
  ///   各キーは通知タイプ名（`note`/`follow`/`mention`/`reply`/`renote`/
  ///   `quote`/`reaction`/`pollEnded`/`scheduledNotePosted`/
  ///   `scheduledNotePostFailed`/`receiveFollowRequest`/
  ///   `followRequestAccepted`/`roleAssigned`/
  ///   `chatRoomInvitationReceived`/`achievementEarned`/`app`/`test`）。
  ///   値は `{"type": "all"|"following"|"follower"|
  ///   "mutualFollow"|"followingOrFollower"|"never"}`
  ///   または `{"type": "list", "userListId": "<id>"}` のいずれか。
  /// - [emailNotificationTypes]: メール通知を受け取る通知タイプのリスト
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
    String? followedMessage,
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
    if (followedMessage != null) body['followedMessage'] = followedMessage;
    final res = await http.send<Map<String, dynamic>>(
      '/i/update',
      body: body,
    );
    return MisskeyUser.fromJson(res);
  }

  /// ノートをプロフィールにピン留めする（`/api/i/pin`）
  ///
  /// [noteId] で対象ノートを指定する。
  /// ピン留め後のユーザー情報（MeDetailed）を返す。
  Future<MisskeyUser> pin({required String noteId}) async {
    final res = await http.send<Map<String, dynamic>>(
      '/i/pin',
      body: <String, dynamic>{'noteId': noteId},
    );
    return MisskeyUser.fromJson(res);
  }

  /// ノートのピン留めを解除する（`/api/i/unpin`）
  ///
  /// [noteId] で対象ノートを指定する。
  /// ピン留め解除後のユーザー情報（MeDetailed）を返す。
  Future<MisskeyUser> unpin({required String noteId}) async {
    final res = await http.send<Map<String, dynamic>>(
      '/i/unpin',
      body: <String, dynamic>{'noteId': noteId},
    );
    return MisskeyUser.fromJson(res);
  }

  /// 自分のお気に入りノート一覧を取得する（`/api/i/favorites`）
  ///
  /// - [limit]: 取得件数 1〜100（デフォルト10）
  /// - [sinceId] / [untilId]: IDによるページング
  /// - [sinceDate] / [untilDate]: Unixタイムスタンプ（ms）によるページング
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

  /// サーバーのお知らせを既読にする（`/api/i/read-announcement`）
  ///
  /// [announcementId] で対象のお知らせIDを指定する。
  Future<void> readAnnouncement({required String announcementId}) =>
      http.send<Object?>(
        '/i/read-announcement',
        body: <String, dynamic>{'announcementId': announcementId},
      );

  /// 実績（アチーブメント）を獲得する（`/api/i/claim-achievement`）
  ///
  /// [name] にはサーバーが定義する実績名を指定する。
  Future<void> claimAchievement({required String name}) => http.send<Object?>(
        '/i/claim-achievement',
        body: <String, dynamic>{'name': name},
      );

  /// 自分が作成したPages一覧を取得する（`/api/i/pages`）
  ///
  /// - [limit]: 取得件数 1〜100（デフォルト10）
  /// - [sinceId] / [untilId]: IDによるページング
  /// - [sinceDate] / [untilDate]: Unixタイムスタンプ（ms）によるページング
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

  /// 自分がいいねしたPages一覧を取得する（`/api/i/page-likes`）
  ///
  /// - [limit]: 取得件数 1〜100（デフォルト10）
  /// - [sinceId] / [untilId]: IDによるページング
  /// - [sinceDate] / [untilDate]: Unixタイムスタンプ（ms）によるページング
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

  /// パスワードを変更する（`/api/i/change-password`）
  ///
  /// - [currentPassword]: 現在のパスワード（必須）
  /// - [newPassword]: 新しいパスワード（必須、1文字以上）
  /// - [token]: 二要素認証が有効な場合のTOTPトークン
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

  /// メールアドレスを変更する（`/api/i/update-email`）
  ///
  /// - [password]: 現在のパスワード（必須）
  /// - [email]: 新しいメールアドレス（`Optional.null_()`で解除）
  /// - [token]: 二要素認証が有効な場合のTOTPトークン
  ///
  /// 更新後のユーザー情報（MeDetailed）を返す。
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

  /// APIトークンを再生成する（`/api/i/regenerate-token`）
  ///
  /// 実行後、現在のトークンは無効化される。
  /// - [password]: 現在のパスワード（必須）
  Future<void> regenerateToken({required String password}) =>
      http.send<Object?>(
        '/i/regenerate-token',
        body: <String, dynamic>{'password': password},
      );

  /// トークンIDを指定して認可済みトークンを取り消す（`/api/i/revoke-token`）
  Future<void> revokeTokenById(String tokenId) => http.send<Object?>(
        '/i/revoke-token',
        body: <String, dynamic>{'tokenId': tokenId},
      );

  /// トークン文字列を指定して認可済みトークンを取り消す（`/api/i/revoke-token`）
  Future<void> revokeTokenByToken(String token) => http.send<Object?>(
        '/i/revoke-token',
        body: <String, dynamic>{'token': token},
      );

  /// アカウントを削除する（`/api/i/delete-account`）
  ///
  /// - [password]: パスワード（必須）
  /// - [token]: 二要素認証が有効な場合のTOTPトークン
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

  /// 自分が作成したアクセストークン一覧を取得する（`/api/i/apps`）
  ///
  /// - [sort]: ソート順（`+createdAt`/`-createdAt`/`+lastUsedAt`/`-lastUsedAt`）
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

  /// 自分が認可したアプリ一覧を取得する（`/api/i/authorized-apps`）
  ///
  /// - [limit]: 取得件数 1〜100（デフォルト10）
  /// - [offset]: オフセット（デフォルト0）
  /// - [sort]: ソート順（`desc`/`asc`、デフォルト`desc`）
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

  /// サインイン履歴を取得する（`/api/i/signin-history`）
  ///
  /// - [limit]: 取得件数 1〜100（デフォルト10）
  /// - [sinceId] / [untilId]: IDによるページング
  /// - [sinceDate] / [untilDate]: Unixタイムスタンプ（ms）によるページング
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

  /// アカウントを別インスタンスへ引っ越す（`/api/i/move`）
  ///
  /// 引っ越し先のアカウントが `alsoKnownAs` で移動元を指定済みである必要がある。
  /// ルートユーザーや既に移動済みのアカウントでは実行不可。
  ///
  /// - [moveToAccount]: 引っ越し先アカウント（`@user@host` 形式）
  Future<MisskeyUser> move({required String moveToAccount}) async {
    final res = await http.send<Map<String, dynamic>>(
      '/i/move',
      body: <String, dynamic>{'moveToAccount': moveToAccount},
    );
    return MisskeyUser.fromJson(res);
  }

  /// ノートをエクスポートする（`/api/i/export-notes`）
  ///
  /// 非同期ジョブとしてキューに追加される。完了時に通知が届く。
  Future<void> exportNotes() => http.send<Object?>(
        '/i/export-notes',
        body: const <String, dynamic>{},
      );

  /// フォロー一覧をエクスポートする（`/api/i/export-following`）
  ///
  /// - [excludeMuting]: ミュート中のユーザーを除外するか（デフォルト: false）
  /// - [excludeInactive]: 非アクティブなユーザーを除外するか（デフォルト: false）
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

  /// ブロック一覧をエクスポートする（`/api/i/export-blocking`）
  Future<void> exportBlocking() => http.send<Object?>(
        '/i/export-blocking',
        body: const <String, dynamic>{},
      );

  /// ミュート一覧をエクスポートする（`/api/i/export-mute`）
  Future<void> exportMute() => http.send<Object?>(
        '/i/export-mute',
        body: const <String, dynamic>{},
      );

  /// お気に入りをエクスポートする（`/api/i/export-favorites`）
  Future<void> exportFavorites() => http.send<Object?>(
        '/i/export-favorites',
        body: const <String, dynamic>{},
      );

  /// アンテナ設定をエクスポートする（`/api/i/export-antennas`）
  Future<void> exportAntennas() => http.send<Object?>(
        '/i/export-antennas',
        body: const <String, dynamic>{},
      );

  /// クリップをエクスポートする（`/api/i/export-clips`）
  Future<void> exportClips() => http.send<Object?>(
        '/i/export-clips',
        body: const <String, dynamic>{},
      );

  /// ユーザーリストをエクスポートする（`/api/i/export-user-lists`）
  Future<void> exportUserLists() => http.send<Object?>(
        '/i/export-user-lists',
        body: const <String, dynamic>{},
      );

  /// フォロー一覧をインポートする（`/api/i/import-following`）
  ///
  /// - [fileId]: インポートファイルのドライブファイルID（必須）
  /// - [withReplies]: リプライ付きでフォローするか
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

  /// ブロック一覧をインポートする（`/api/i/import-blocking`）
  ///
  /// - [fileId]: インポートファイルのドライブファイルID（必須）
  Future<void> importBlocking({required String fileId}) => http.send<Object?>(
        '/i/import-blocking',
        body: <String, dynamic>{'fileId': fileId},
      );

  /// ミュート一覧をインポートする（`/api/i/import-muting`）
  ///
  /// - [fileId]: インポートファイルのドライブファイルID（必須）
  Future<void> importMuting({required String fileId}) => http.send<Object?>(
        '/i/import-muting',
        body: <String, dynamic>{'fileId': fileId},
      );

  /// アンテナ設定をインポートする（`/api/i/import-antennas`）
  ///
  /// - [fileId]: インポートファイルのドライブファイルID（必須）
  Future<void> importAntennas({required String fileId}) => http.send<Object?>(
        '/i/import-antennas',
        body: <String, dynamic>{'fileId': fileId},
      );

  /// ユーザーリストをインポートする（`/api/i/import-user-lists`）
  ///
  /// - [fileId]: インポートファイルのドライブファイルID（必須）
  Future<void> importUserLists({required String fileId}) => http.send<Object?>(
        '/i/import-user-lists',
        body: <String, dynamic>{'fileId': fileId},
      );

  /// 自分のギャラリー投稿一覧を取得する（`/api/i/gallery/posts`）
  ///
  /// - [limit]: 取得件数 1〜100（デフォルト10）
  /// - [sinceId] / [untilId]: IDによるページング
  /// - [sinceDate] / [untilDate]: Unixタイムスタンプ（ms）によるページング
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

  /// 自分がいいねしたギャラリー投稿一覧を取得する（`/api/i/gallery/likes`）
  ///
  /// - [limit]: 取得件数 1〜100（デフォルト10）
  /// - [sinceId] / [untilId]: IDによるページング
  /// - [sinceDate] / [untilDate]: Unixタイムスタンプ（ms）によるページング
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

/// [Optional]で包まれた値をリクエストボディに追加するヘルパー
///
/// - `opt`が`null`（未指定）→ 何もしない
/// - `opt`が[Some] → `body[key]`に値をセット（`Some.null_()`の場合は`null`）
void _putOptional<T>(
  Map<String, dynamic> body,
  String key,
  Optional<T>? opt,
) {
  if (opt case Some<T>(:final value)) {
    body[key] = value;
  }
}
