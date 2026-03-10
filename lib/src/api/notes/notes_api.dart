import '../../client/misskey_http.dart';
import '../../client/request_options.dart';

/// NoteのJSON表現
typedef NoteJson = Map<String, dynamic>;

/// ノート関連API
class NotesApi {
  const NotesApi({required this.http});

  final MisskeyHttp http;

  /// ホームタイムラインを取得（`/api/notes/timeline`）
  ///
  /// フォロー中ユーザーのノートを返す。認証必須。
  ///
  /// - [sinceDate] / [untilDate]: Unixタイムスタンプ（ms）によるページング
  /// - [allowPartial]: キャッシュが不十分な場合でも部分的な結果を返す
  /// - [includeMyRenotes]: 自分のリノートを含めるか（デフォルト: true）
  /// - [includeRenotedMyNotes]: 自分のノートのリノートを含めるか（デフォルト: true）
  /// - [includeLocalRenotes]: ローカルユーザーのリノートを含めるか（デフォルト: true）
  Future<List<NoteJson>> timelineHome({
    int limit = 30,
    String? sinceId,
    String? untilId,
    int? sinceDate,
    int? untilDate,
    bool? allowPartial,
    bool? withRenotes,
    bool? withFiles,
    bool? includeMyRenotes,
    bool? includeRenotedMyNotes,
    bool? includeLocalRenotes,
  }) =>
      _fetchTimeline(
        path: '/notes/timeline',
        limit: limit,
        sinceId: sinceId,
        untilId: untilId,
        sinceDate: sinceDate,
        untilDate: untilDate,
        allowPartial: allowPartial,
        withRenotes: withRenotes,
        withFiles: withFiles,
        includeMyRenotes: includeMyRenotes,
        includeRenotedMyNotes: includeRenotedMyNotes,
        includeLocalRenotes: includeLocalRenotes,
        authRequired: true,
      );

  /// グローバルタイムラインを取得（`/api/notes/global-timeline`）
  ///
  /// サーバー全体の公開ノートを返す。
  /// 認証不要（ロールポリシーで制限される場合あり）。
  Future<List<NoteJson>> timelineGlobal({
    int limit = 30,
    String? sinceId,
    String? untilId,
    int? sinceDate,
    int? untilDate,
    bool? withRenotes,
    bool? withFiles,
  }) =>
      _fetchTimeline(
        path: '/notes/global-timeline',
        limit: limit,
        sinceId: sinceId,
        untilId: untilId,
        sinceDate: sinceDate,
        untilDate: untilDate,
        withRenotes: withRenotes,
        withFiles: withFiles,
        authRequired: false,
      );

  /// ハイブリッドタイムラインを取得（`/api/notes/hybrid-timeline`）
  ///
  /// フォロー中ユーザーのノートとローカルの公開ノートを混合して返す。認証必須。
  ///
  /// - [withReplies]と[withFiles]は同時に`true`にできない
  Future<List<NoteJson>> timelineHybrid({
    int limit = 30,
    String? sinceId,
    String? untilId,
    int? sinceDate,
    int? untilDate,
    bool? allowPartial,
    bool? withRenotes,
    bool? withReplies,
    bool? withFiles,
    bool? includeMyRenotes,
    bool? includeRenotedMyNotes,
    bool? includeLocalRenotes,
  }) =>
      _fetchTimeline(
        path: '/notes/hybrid-timeline',
        limit: limit,
        sinceId: sinceId,
        untilId: untilId,
        sinceDate: sinceDate,
        untilDate: untilDate,
        allowPartial: allowPartial,
        withRenotes: withRenotes,
        withReplies: withReplies,
        withFiles: withFiles,
        includeMyRenotes: includeMyRenotes,
        includeRenotedMyNotes: includeRenotedMyNotes,
        includeLocalRenotes: includeLocalRenotes,
        authRequired: true,
      );

  /// ローカルタイムラインを取得（`/api/notes/local-timeline`）
  ///
  /// このサーバーのローカルユーザーの公開ノートを返す。
  /// 認証不要（ロールポリシーで制限される場合あり）。
  ///
  /// - [withReplies]と[withFiles]は同時に`true`にできない
  Future<List<NoteJson>> timelineLocal({
    int limit = 30,
    String? sinceId,
    String? untilId,
    int? sinceDate,
    int? untilDate,
    bool? allowPartial,
    bool? withRenotes,
    bool? withReplies,
    bool? withFiles,
  }) =>
      _fetchTimeline(
        path: '/notes/local-timeline',
        limit: limit,
        sinceId: sinceId,
        untilId: untilId,
        sinceDate: sinceDate,
        untilDate: untilDate,
        allowPartial: allowPartial,
        withRenotes: withRenotes,
        withReplies: withReplies,
        withFiles: withFiles,
        authRequired: false,
      );

  /// 単一ノートを取得（`/api/notes/show`）
  ///
  /// 指定した [noteId] のノート詳細を返す。認証不要。
  ///
  /// - 可視性制限は認証状態とサーバー設定によって適用される
  Future<NoteJson> show({required String noteId}) async {
    final res = await http.send<Map<dynamic, dynamic>>(
      '/notes/show',
      body: <String, dynamic>{'noteId': noteId},
      options: const RequestOptions(idempotent: true),
    );
    return res.cast<String, dynamic>();
  }

  /// ノートへの返信一覧を取得（`/api/notes/replies`）
  ///
  /// 指定した[noteId]に対する返信ノートを返す。認証不要。
  ///
  /// - [limit]: 取得件数 1〜100、デフォルト10
  /// - [sinceId] / [untilId]: IDによるページング
  /// - [sinceDate] / [untilDate]: Unixタイムスタンプ（ms）によるページング
  Future<List<NoteJson>> replies({
    required String noteId,
    int limit = 10,
    String? sinceId,
    String? untilId,
    int? sinceDate,
    int? untilDate,
  }) async {
    final body = <String, dynamic>{
      'noteId': noteId,
      'limit': limit,
      if (sinceId != null) 'sinceId': sinceId,
      if (untilId != null) 'untilId': untilId,
      if (sinceDate != null) 'sinceDate': sinceDate,
      if (untilDate != null) 'untilDate': untilDate,
    };
    final res = await http.send<List<dynamic>>(
      '/notes/replies',
      body: body,
      options: const RequestOptions(idempotent: true),
    );
    return res
        .whereType<Map<dynamic, dynamic>>()
        .map((e) => e.cast<String, dynamic>())
        .toList();
  }

  /// ノートのリノート一覧を取得（`/api/notes/renotes`）
  ///
  /// 指定した [noteId] をリノートしたノートの一覧を返す。認証不要。
  ///
  /// - [limit]: 取得件数 1〜100、デフォルト10
  /// - [sinceId] / [untilId]: IDによるページング
  /// - [sinceDate] / [untilDate]: Unixタイムスタンプ（ms）によるページング
  Future<List<NoteJson>> renotes({
    required String noteId,
    int limit = 10,
    String? sinceId,
    String? untilId,
    int? sinceDate,
    int? untilDate,
  }) async {
    final body = <String, dynamic>{
      'noteId': noteId,
      'limit': limit,
      if (sinceId != null) 'sinceId': sinceId,
      if (untilId != null) 'untilId': untilId,
      if (sinceDate != null) 'sinceDate': sinceDate,
      if (untilDate != null) 'untilDate': untilDate,
    };
    final res = await http.send<List<dynamic>>(
      '/notes/renotes',
      body: body,
      options: const RequestOptions(idempotent: true),
    );
    return res
        .whereType<Map<dynamic, dynamic>>()
        .map((e) => e.cast<String, dynamic>())
        .toList();
  }

  /// ノートのリアクション一覧を取得（`/api/notes/reactions`）
  ///
  /// 指定した [noteId] に付与されたリアクションの一覧を返す。認証不要。
  /// レスポンスはサーバー側で60秒キャッシュされる。
  ///
  /// - [type]: リアクション種別でフィルタリング（例: `'👍'`, `':like:'`）
  /// - [limit]: 取得件数 1〜100、デフォルト10
  /// - [sinceId] / [untilId]: IDによるページング
  /// - [sinceDate] / [untilDate]: Unixタイムスタンプ（ms）によるページング
  Future<List<Map<String, dynamic>>> reactions({
    required String noteId,
    String? type,
    int limit = 10,
    String? sinceId,
    String? untilId,
    int? sinceDate,
    int? untilDate,
  }) async {
    final body = <String, dynamic>{
      'noteId': noteId,
      'limit': limit,
      if (type != null) 'type': type,
      if (sinceId != null) 'sinceId': sinceId,
      if (untilId != null) 'untilId': untilId,
      if (sinceDate != null) 'sinceDate': sinceDate,
      if (untilDate != null) 'untilDate': untilDate,
    };
    final res = await http.send<List<dynamic>>(
      '/notes/reactions',
      body: body,
      options: const RequestOptions(idempotent: true),
    );
    return res
        .whereType<Map<dynamic, dynamic>>()
        .map((e) => e.cast<String, dynamic>())
        .toList();
  }

  /// ノートを作成する（`/api/notes/create`）
  ///
  /// テキスト投稿・返信・リノート・引用リノートを兼用する。
  /// [channelId] を指定した場合、[visibility]・[localOnly]・
  /// [visibleUserIds] はサーバーで無視される為、
  /// リクエストボディから省略される。
  ///
  /// [pollChoices]（最小2件・最大10件）を渡すと投票を添付できる。
  /// [pollMultiple] を`true`にすると複数選択が可能になる。
  /// 投票期限は [pollExpiresAt]（絶対エポックms）か
  /// [pollExpiredAfter]（現在時刻からの相対ms、最小1）の
  /// どちらか一方のみ指定する。
  ///
  /// レスポンスオブジェクトは作成されたノートを
  /// `createdNote`キーに格納して返す。
  Future<NoteJson> create({
    String? text,
    String? cw,
    String? visibility,
    List<String>? visibleUserIds,
    bool? localOnly,
    String? reactionAcceptance,
    bool? noExtractMentions,
    bool? noExtractHashtags,
    bool? noExtractEmojis,
    String? replyId,
    String? renoteId,
    String? channelId,
    List<String>? fileIds,
    List<String>? mediaIds,
    // Poll parameters
    List<String>? pollChoices,
    bool? pollMultiple,
    int? pollExpiresAt,
    int? pollExpiredAfter,
  }) async {
    final body = <String, dynamic>{
      if (text != null) 'text': text,
      if (cw != null) 'cw': cw,
      if (replyId != null) 'replyId': replyId,
      if (renoteId != null) 'renoteId': renoteId,
      if (channelId != null) 'channelId': channelId,
      if (reactionAcceptance != null) 'reactionAcceptance': reactionAcceptance,
      if (noExtractMentions != null) 'noExtractMentions': noExtractMentions,
      if (noExtractHashtags != null) 'noExtractHashtags': noExtractHashtags,
      if (noExtractEmojis != null) 'noExtractEmojis': noExtractEmojis,
    };

    if (channelId == null) {
      if (visibility != null) body['visibility'] = visibility;
      if (localOnly != null) body['localOnly'] = localOnly;
      if (visibleUserIds != null && visibleUserIds.isNotEmpty) {
        body['visibleUserIds'] = visibleUserIds;
      }
    }

    if (fileIds != null && fileIds.isNotEmpty) {
      body['fileIds'] = fileIds;
    }
    if (mediaIds != null && mediaIds.isNotEmpty) {
      body['mediaIds'] = mediaIds;
    }

    if (pollChoices != null && pollChoices.isNotEmpty) {
      final poll = <String, dynamic>{'choices': pollChoices};
      if (pollMultiple != null) poll['multiple'] = pollMultiple;
      if (pollExpiresAt != null) poll['expiresAt'] = pollExpiresAt;
      if (pollExpiredAfter != null) poll['expiredAfter'] = pollExpiredAfter;
      body['poll'] = poll;
    }

    final res = await http.send<Map<dynamic, dynamic>>(
      '/notes/create',
      body: body,
    );
    final raw = (res['createdNote'] is Map)
        ? res['createdNote'] as Map<dynamic, dynamic>
        : res;
    return raw.cast<String, dynamic>();
  }

  /// ノートに添付された投票に回答する（`/api/notes/polls/vote`）
  ///
  /// [noteId] は投票を含むノートのIDを指定する。
  /// [choice] は0始まりの選択肢インデックスを指定する。
  Future<void> pollsVote({
    required String noteId,
    required int choice,
  }) =>
      http.send<Object?>(
        '/notes/polls/vote',
        body: <String, dynamic>{'noteId': noteId, 'choice': choice},
      );

  /// ノートにリアクションを追加する（`/api/notes/reactions/create`）
  ///
  /// [reaction] にはUnicode絵文字（例: `'👍'`）または
  /// ショートコード（例: `':like:'`）を指定する。
  Future<void> reactionsCreate({
    required String noteId,
    required String reaction,
  }) =>
      http.send<Object?>(
        '/notes/reactions/create',
        body: <String, dynamic>{
          'noteId': noteId,
          'reaction': reaction,
        },
      );

  /// 認証ユーザーのリアクションをノートから削除する（`/api/notes/reactions/delete`）
  Future<void> reactionsDelete({required String noteId}) => http.send<Object?>(
        '/notes/reactions/delete',
        body: <String, dynamic>{'noteId': noteId},
      );

  /// ユーザー名トークンのリストをユーザーIDに解決する
  ///
  /// 各トークンは`'librarian'`・`'librarian@misskey.io'`・
  /// `'@librarian@misskey.io'`のいずれの形式でも受け付ける。
  /// 解決できないトークンは黙って読み飛ばされ、解決失敗時は
  /// [MisskeyHttp.logger] を通じてデバッグレベルのログが記録される。
  Future<List<String>> resolveUsernamesToIds(List<String> tokens) async {
    final results = <String>[];
    for (final raw in tokens) {
      final trimmed = raw.trim();
      if (trimmed.isEmpty) continue;

      var username = trimmed.startsWith('@') ? trimmed.substring(1) : trimmed;
      String? host;
      if (username.contains('@')) {
        final parts = username.split('@');
        username = parts.first;
        host = parts.sublist(1).join('@');
      }

      try {
        final res = await http.send<List<dynamic>>(
          '/users/search-by-username-and-host',
          body: <String, dynamic>{
            'username': username,
            if (host != null && host.isNotEmpty) 'host': host,
            'limit': 1,
          },
        );
        if (res.isNotEmpty && res.first is Map) {
          final user =
              (res.first as Map<dynamic, dynamic>).cast<String, dynamic>();
          final id = (user['id'] ?? '').toString();
          if (id.isNotEmpty) results.add(id);
        }
      } on Exception catch (e) {
        if (http.config.enableLog) {
          http.logger.debug(
            'resolveUsernamesToIds: failed to resolve'
            ' token="$trimmed": $e',
          );
        }
      }
    }
    return results;
  }

  Future<List<NoteJson>> _fetchTimeline({
    required String path,
    required int limit,
    required bool authRequired,
    String? sinceId,
    String? untilId,
    int? sinceDate,
    int? untilDate,
    bool? allowPartial,
    bool? withRenotes,
    bool? withReplies,
    bool? withFiles,
    bool? includeMyRenotes,
    bool? includeRenotedMyNotes,
    bool? includeLocalRenotes,
  }) async {
    final body = <String, dynamic>{
      'limit': limit,
      if (sinceId != null) 'sinceId': sinceId,
      if (untilId != null) 'untilId': untilId,
      if (sinceDate != null) 'sinceDate': sinceDate,
      if (untilDate != null) 'untilDate': untilDate,
      if (allowPartial != null) 'allowPartial': allowPartial,
      if (withRenotes != null) 'withRenotes': withRenotes,
      if (withReplies != null) 'withReplies': withReplies,
      if (withFiles != null) 'withFiles': withFiles,
      if (includeMyRenotes != null) 'includeMyRenotes': includeMyRenotes,
      if (includeRenotedMyNotes != null)
        'includeRenotedMyNotes': includeRenotedMyNotes,
      if (includeLocalRenotes != null)
        'includeLocalRenotes': includeLocalRenotes,
    };

    final res = await http.send<List<dynamic>>(
      path,
      body: body,
      options: RequestOptions(authRequired: authRequired, idempotent: true),
    );

    return res
        .whereType<Map<dynamic, dynamic>>()
        .map((e) => e.cast<String, dynamic>())
        .toList();
  }
}
