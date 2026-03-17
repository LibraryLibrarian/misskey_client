import '../client/auth_mode.dart';
import '../client/misskey_http.dart';
import '../client/request_options.dart';
import '../models/misskey_clip.dart';
import '../models/misskey_note.dart';
import '../models/misskey_note_draft.dart';
import '../models/misskey_note_partial.dart';
import '../models/misskey_note_reaction.dart';
import '../models/misskey_note_state.dart';
import '../models/misskey_note_translation.dart';

/// ノート関連API
class NotesApi {
  const NotesApi({required this.http});

  final MisskeyHttp http;

  /// 公開ノート一覧を取得（`/api/notes`）
  ///
  /// `visibility = public` かつ `localOnly = false` のノートを返す。認証不要。
  ///
  /// - [local]: ローカル投稿のみに絞る（デフォルト: false）
  /// - [reply]: リプライのみ/除外（null=フィルタなし）
  /// - [renote]: リノートのみ/除外（null=フィルタなし）
  /// - [withFiles]: ファイル付きのみ/除外（null=フィルタなし）
  /// - [poll]: 投票付きのみ/除外（null=フィルタなし）
  /// - [limit]: 取得件数 1〜100（デフォルト: 10）
  /// - [sinceId] / [untilId]: IDによるページング
  /// - [sinceDate] / [untilDate]: Unixタイムスタンプ（ms）によるページング
  Future<List<MisskeyNote>> list({
    bool? local,
    bool? reply,
    bool? renote,
    bool? withFiles,
    bool? poll,
    int? limit,
    String? sinceId,
    String? untilId,
    int? sinceDate,
    int? untilDate,
  }) async {
    final body = <String, dynamic>{
      if (local != null) 'local': local,
      if (reply != null) 'reply': reply,
      if (renote != null) 'renote': renote,
      if (withFiles != null) 'withFiles': withFiles,
      if (poll != null) 'poll': poll,
      if (limit != null) 'limit': limit,
      if (sinceId != null) 'sinceId': sinceId,
      if (untilId != null) 'untilId': untilId,
      if (sinceDate != null) 'sinceDate': sinceDate,
      if (untilDate != null) 'untilDate': untilDate,
    };
    final res = await http.send<List<dynamic>>(
      '/notes',
      body: body,
      options: const RequestOptions(
        authMode: AuthMode.none,
        idempotent: true,
      ),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyNote.fromJson)
        .toList();
  }

  /// ホームタイムラインを取得（`/api/notes/timeline`）
  ///
  /// フォロー中ユーザーのノートを返す。認証必須。
  ///
  /// - [sinceDate] / [untilDate]: Unixタイムスタンプ（ms）によるページング
  /// - [allowPartial]: キャッシュが不十分な場合でも部分的な結果を返す
  /// - [includeMyRenotes]: 自分のリノートを含めるか（デフォルト: true）
  /// - [includeRenotedMyNotes]: 自分のノートのリノートを含めるか（デフォルト: true）
  /// - [includeLocalRenotes]: ローカルユーザーのリノートを含めるか（デフォルト: true）
  Future<List<MisskeyNote>> timelineHome({
    int? limit,
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
        authMode: AuthMode.required,
      );

  /// グローバルタイムラインを取得（`/api/notes/global-timeline`）
  ///
  /// サーバー全体の公開ノートを返す。
  /// 認証不要（ロールポリシーで制限される場合あり）。
  Future<List<MisskeyNote>> timelineGlobal({
    int? limit,
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
        authMode: AuthMode.optional,
      );

  /// ハイブリッドタイムラインを取得（`/api/notes/hybrid-timeline`）
  ///
  /// フォロー中ユーザーのノートとローカルの公開ノートを混合して返す。認証必須。
  ///
  /// - [withReplies]と[withFiles]は同時に`true`にできない
  Future<List<MisskeyNote>> timelineHybrid({
    int? limit,
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
        authMode: AuthMode.required,
      );

  /// ローカルタイムラインを取得（`/api/notes/local-timeline`）
  ///
  /// このサーバーのローカルユーザーの公開ノートを返す。
  /// 認証不要（ロールポリシーで制限される場合あり）。
  ///
  /// - [withReplies]と[withFiles]は同時に`true`にできない
  Future<List<MisskeyNote>> timelineLocal({
    int? limit,
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
        authMode: AuthMode.optional,
      );

  /// 単一ノートを取得（`/api/notes/show`）
  ///
  /// 指定した [noteId] のノート詳細を返す。認証不要。
  ///
  /// - 可視性制限は認証状態とサーバー設定によって適用される
  Future<MisskeyNote> show({required String noteId}) async {
    final res = await http.send<Map<String, dynamic>>(
      '/notes/show',
      body: <String, dynamic>{'noteId': noteId},
      options: const RequestOptions(
        authMode: AuthMode.optional,
        idempotent: true,
      ),
    );
    return MisskeyNote.fromJson(res);
  }

  /// ノートへの返信一覧を取得（`/api/notes/replies`）
  ///
  /// 指定した[noteId]に対する返信ノートを返す。認証不要。
  ///
  /// - [limit]: 取得件数 1〜100
  /// - [sinceId] / [untilId]: IDによるページング
  /// - [sinceDate] / [untilDate]: Unixタイムスタンプ（ms）によるページング
  Future<List<MisskeyNote>> replies({
    required String noteId,
    int? limit,
    String? sinceId,
    String? untilId,
    int? sinceDate,
    int? untilDate,
  }) async {
    final body = <String, dynamic>{
      'noteId': noteId,
      if (limit != null) 'limit': limit,
      if (sinceId != null) 'sinceId': sinceId,
      if (untilId != null) 'untilId': untilId,
      if (sinceDate != null) 'sinceDate': sinceDate,
      if (untilDate != null) 'untilDate': untilDate,
    };
    final res = await http.send<List<dynamic>>(
      '/notes/replies',
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

  /// ノートのリノート一覧を取得（`/api/notes/renotes`）
  ///
  /// 指定した [noteId] をリノートしたノートの一覧を返す。認証不要。
  ///
  /// - [limit]: 取得件数 1〜100
  /// - [sinceId] / [untilId]: IDによるページング
  /// - [sinceDate] / [untilDate]: Unixタイムスタンプ（ms）によるページング
  Future<List<MisskeyNote>> renotes({
    required String noteId,
    int? limit,
    String? sinceId,
    String? untilId,
    int? sinceDate,
    int? untilDate,
  }) async {
    final body = <String, dynamic>{
      'noteId': noteId,
      if (limit != null) 'limit': limit,
      if (sinceId != null) 'sinceId': sinceId,
      if (untilId != null) 'untilId': untilId,
      if (sinceDate != null) 'sinceDate': sinceDate,
      if (untilDate != null) 'untilDate': untilDate,
    };
    final res = await http.send<List<dynamic>>(
      '/notes/renotes',
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

  /// ノートのリアクション一覧を取得（`/api/notes/reactions`）
  ///
  /// 指定した [noteId] に付与されたリアクションの一覧を返す。認証不要。
  /// レスポンスはサーバー側で60秒キャッシュされる。
  ///
  /// - [type]: リアクション種別でフィルタリング（例: `'👍'`, `':like:'`）
  /// - [limit]: 取得件数 1〜100
  /// - [sinceId] / [untilId]: IDによるページング
  /// - [sinceDate] / [untilDate]: Unixタイムスタンプ（ms）によるページング
  Future<List<MisskeyNoteReaction>> reactions({
    required String noteId,
    String? type,
    int? limit,
    String? sinceId,
    String? untilId,
    int? sinceDate,
    int? untilDate,
  }) async {
    final body = <String, dynamic>{
      'noteId': noteId,
      if (limit != null) 'limit': limit,
      if (type != null) 'type': type,
      if (sinceId != null) 'sinceId': sinceId,
      if (untilId != null) 'untilId': untilId,
      if (sinceDate != null) 'sinceDate': sinceDate,
      if (untilDate != null) 'untilDate': untilDate,
    };
    final res = await http.send<List<dynamic>>(
      '/notes/reactions',
      body: body,
      options: const RequestOptions(
        authMode: AuthMode.optional,
        idempotent: true,
      ),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyNoteReaction.fromJson)
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
  Future<MisskeyNote> create({
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
    final hasContent = text != null ||
        renoteId != null ||
        (fileIds != null && fileIds.isNotEmpty) ||
        (mediaIds != null && mediaIds.isNotEmpty) ||
        (pollChoices != null && pollChoices.isNotEmpty);
    if (!hasContent) {
      throw ArgumentError(
        'text, renoteId, fileIds, mediaIds, pollChoices の'
        'いずれかを指定してください',
      );
    }

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

    final res = await http.send<Map<String, dynamic>>(
      '/notes/create',
      body: body,
    );
    final raw = (res['createdNote'] is Map<String, dynamic>)
        ? res['createdNote'] as Map<String, dynamic>
        : res;
    return MisskeyNote.fromJson(raw);
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

  /// ノートを削除する（`/api/notes/delete`）
  ///
  /// 自分のノート、またはモデレーター権限で他者のノートを削除する。認証必須。
  Future<void> delete({required String noteId}) => http.send<Object?>(
        '/notes/delete',
        body: <String, dynamic>{'noteId': noteId},
      );

  /// ノートのリノートを取り消す（`/api/notes/unrenote`）
  ///
  /// 指定した [noteId] に対する認証ユーザーのリノートをすべて削除する。
  /// 認証必須。レート制限: 300回/時、最小間隔1秒。
  Future<void> unrenote({required String noteId}) => http.send<Object?>(
        '/notes/unrenote',
        body: <String, dynamic>{'noteId': noteId},
      );

  /// ノートの子ノート（返信・引用リノート）を取得（`/api/notes/children`）
  ///
  /// [noteId] に対する返信と引用リノートを返す。認証任意。
  ///
  /// - [limit]: 取得件数 1〜100（デフォルト: 10）
  /// - [sinceId] / [untilId]: IDによるページング
  /// - [sinceDate] / [untilDate]: Unixタイムスタンプ（ms）によるページング
  Future<List<MisskeyNote>> children({
    required String noteId,
    int? limit,
    String? sinceId,
    String? untilId,
    int? sinceDate,
    int? untilDate,
  }) async {
    final body = <String, dynamic>{
      'noteId': noteId,
      if (limit != null) 'limit': limit,
      if (sinceId != null) 'sinceId': sinceId,
      if (untilId != null) 'untilId': untilId,
      if (sinceDate != null) 'sinceDate': sinceDate,
      if (untilDate != null) 'untilDate': untilDate,
    };
    final res = await http.send<List<dynamic>>(
      '/notes/children',
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

  /// ノートを含む公開クリップ一覧を取得（`/api/notes/clips`）
  ///
  /// 指定した [noteId] を含む公開クリップを返す。認証任意。
  Future<List<MisskeyClip>> clips({required String noteId}) async {
    final res = await http.send<List<dynamic>>(
      '/notes/clips',
      body: <String, dynamic>{'noteId': noteId},
      options: const RequestOptions(
        authMode: AuthMode.optional,
        idempotent: true,
      ),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyClip.fromJson)
        .toList();
  }

  /// リプライチェーンを遡ってスレッドを取得（`/api/notes/conversation`）
  ///
  /// 指定した [noteId] の親ノートを再帰的に取得する。認証任意。
  ///
  /// - [limit]: 取得件数 1〜100（デフォルト: 10）
  /// - [offset]: スキップ件数（デフォルト: 0）
  Future<List<MisskeyNote>> conversation({
    required String noteId,
    int? limit,
    int? offset,
  }) async {
    final body = <String, dynamic>{
      'noteId': noteId,
      if (limit != null) 'limit': limit,
      if (offset != null) 'offset': offset,
    };
    final res = await http.send<List<dynamic>>(
      '/notes/conversation',
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

  /// トレンド（注目）ノートを取得（`/api/notes/featured`）
  ///
  /// ランキングされた注目ノートを返す。認証任意。
  ///
  /// - [limit]: 取得件数 1〜100（デフォルト: 10）
  /// - [untilId]: IDによるページング
  /// - [channelId]: チャンネルでフィルタリング（nullable）
  Future<List<MisskeyNote>> featured({
    int? limit,
    String? untilId,
    String? channelId,
  }) async {
    final body = <String, dynamic>{
      if (limit != null) 'limit': limit,
      if (untilId != null) 'untilId': untilId,
      if (channelId != null) 'channelId': channelId,
    };
    final res = await http.send<List<dynamic>>(
      '/notes/featured',
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

  /// 自分へのメンションを取得（`/api/notes/mentions`）
  ///
  /// 認証ユーザーがメンションされたノートを返す。認証必須。
  ///
  /// - [following]: フォロー中ユーザーのみに絞るか（デフォルト: false）
  /// - [visibility]: 公開範囲でフィルタリング
  /// - [limit]: 取得件数 1〜100（デフォルト: 10）
  Future<List<MisskeyNote>> mentions({
    bool? following,
    String? visibility,
    int? limit,
    String? sinceId,
    String? untilId,
    int? sinceDate,
    int? untilDate,
  }) async {
    final body = <String, dynamic>{
      if (following != null) 'following': following,
      if (visibility != null) 'visibility': visibility,
      if (limit != null) 'limit': limit,
      if (sinceId != null) 'sinceId': sinceId,
      if (untilId != null) 'untilId': untilId,
      if (sinceDate != null) 'sinceDate': sinceDate,
      if (untilDate != null) 'untilDate': untilDate,
    };
    final res = await http.send<List<dynamic>>(
      '/notes/mentions',
      body: body,
      options: const RequestOptions(idempotent: true),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyNote.fromJson)
        .toList();
  }

  /// ノートを全文検索する（`/api/notes/search`）
  ///
  /// [query] に一致するノートを返す。認証任意。
  ///
  /// - [host]: ホストでフィルタリング（`"."` でローカル）
  /// - [userId]: ユーザーでフィルタリング
  /// - [channelId]: チャンネルでフィルタリング
  /// - [offset]: スキップ件数（デフォルト: 0）
  Future<List<MisskeyNote>> search({
    required String query,
    int? limit,
    int? offset,
    String? sinceId,
    String? untilId,
    int? sinceDate,
    int? untilDate,
    String? host,
    String? userId,
    String? channelId,
  }) async {
    final body = <String, dynamic>{
      'query': query,
      if (limit != null) 'limit': limit,
      if (offset != null) 'offset': offset,
      if (sinceId != null) 'sinceId': sinceId,
      if (untilId != null) 'untilId': untilId,
      if (sinceDate != null) 'sinceDate': sinceDate,
      if (untilDate != null) 'untilDate': untilDate,
      if (host != null) 'host': host,
      if (userId != null) 'userId': userId,
      if (channelId != null) 'channelId': channelId,
    };
    final res = await http.send<List<dynamic>>(
      '/notes/search',
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

  /// ハッシュタグでノートを検索する（`/api/notes/search-by-tag`）
  ///
  /// [tag] か [queryTags] のいずれかを指定する。
  /// [queryTags] は二重配列で、外側がOR結合、内側がAND結合。
  /// 認証任意。
  ///
  /// - [reply]: リプライのみ/除外（null=フィルタなし）
  /// - [renote]: リノートのみ/除外（null=フィルタなし）
  /// - [withFiles]: ファイル付きのみ（デフォルト: false）
  /// - [poll]: 投票付きのみ/除外（null=フィルタなし）
  Future<List<MisskeyNote>> searchByTag({
    String? tag,
    List<List<String>>? queryTags,
    bool? reply,
    bool? renote,
    bool? withFiles,
    bool? poll,
    int? limit,
    String? sinceId,
    String? untilId,
    int? sinceDate,
    int? untilDate,
  }) async {
    assert(
      tag != null || queryTags != null,
      'tag か queryTags のいずれかを指定してください',
    );
    final body = <String, dynamic>{
      if (tag != null) 'tag': tag,
      if (queryTags != null) 'query': queryTags,
      if (reply != null) 'reply': reply,
      if (renote != null) 'renote': renote,
      if (withFiles != null) 'withFiles': withFiles,
      if (poll != null) 'poll': poll,
      if (limit != null) 'limit': limit,
      if (sinceId != null) 'sinceId': sinceId,
      if (untilId != null) 'untilId': untilId,
      if (sinceDate != null) 'sinceDate': sinceDate,
      if (untilDate != null) 'untilDate': untilDate,
    };
    final res = await http.send<List<dynamic>>(
      '/notes/search-by-tag',
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

  /// 複数ノートのリアクション情報を一括取得（`/api/notes/show-partial-bulk`）
  ///
  /// 各ノートのリアクション数と絵文字情報のみを返す軽量エンドポイント。
  /// 認証不要。
  ///
  /// - [noteIds]: 対象ノートIDリスト（1〜100件）
  Future<List<MisskeyNotePartial>> showPartialBulk({
    required List<String> noteIds,
  }) async {
    final res = await http.send<List<dynamic>>(
      '/notes/show-partial-bulk',
      body: <String, dynamic>{'noteIds': noteIds},
      options: const RequestOptions(
        authMode: AuthMode.none,
        idempotent: true,
      ),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyNotePartial.fromJson)
        .toList();
  }

  /// ノートの状態を取得（`/api/notes/state`）
  ///
  /// 認証ユーザーの当該ノートに対する状態（お気に入り済み、
  /// スレッドミュート済み）を返す。認証必須。
  Future<MisskeyNoteState> state({required String noteId}) async {
    final res = await http.send<Map<String, dynamic>>(
      '/notes/state',
      body: <String, dynamic>{'noteId': noteId},
      options: const RequestOptions(idempotent: true),
    );
    return MisskeyNoteState.fromJson(res);
  }

  /// ノートを翻訳する（`/api/notes/translate`）
  ///
  /// DeepL等の翻訳サービスを使用してノートのテキストを翻訳する。認証必須。
  /// サーバーで翻訳サービスが有効でない場合や、ユーザーに
  /// `canUseTranslator` 権限がない場合はエラーになる。
  ///
  /// - [noteId]: 翻訳対象のノートID
  /// - [targetLang]: 翻訳先の言語コード（例: `'ja'`, `'en'`）
  Future<MisskeyNoteTranslation> translate({
    required String noteId,
    required String targetLang,
  }) async {
    final res = await http.send<Map<String, dynamic>>(
      '/notes/translate',
      body: <String, dynamic>{
        'noteId': noteId,
        'targetLang': targetLang,
      },
      options: const RequestOptions(idempotent: true),
    );
    return MisskeyNoteTranslation.fromJson(res);
  }

  /// ユーザーリストのタイムラインを取得（`/api/notes/user-list-timeline`）
  ///
  /// 指定した [listId] に含まれるユーザーのノートを返す。認証必須。
  ///
  /// - [withRenotes]: リノートを含めるか（デフォルト: true）
  /// - [withFiles]: ファイル付きノートのみ（デフォルト: false）
  /// - [includeMyRenotes]: 自分のリノートを含めるか（デフォルト: true）
  /// - [includeRenotedMyNotes]: 自分のノートのリノートを含めるか（デフォルト: true）
  /// - [includeLocalRenotes]: ローカルユーザーのリノートを含めるか（デフォルト: true）
  Future<List<MisskeyNote>> timelineUserList({
    required String listId,
    int? limit,
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
  }) async {
    final body = <String, dynamic>{
      'listId': listId,
      if (limit != null) 'limit': limit,
      if (sinceId != null) 'sinceId': sinceId,
      if (untilId != null) 'untilId': untilId,
      if (sinceDate != null) 'sinceDate': sinceDate,
      if (untilDate != null) 'untilDate': untilDate,
      if (allowPartial != null) 'allowPartial': allowPartial,
      if (withRenotes != null) 'withRenotes': withRenotes,
      if (withFiles != null) 'withFiles': withFiles,
      if (includeMyRenotes != null) 'includeMyRenotes': includeMyRenotes,
      if (includeRenotedMyNotes != null)
        'includeRenotedMyNotes': includeRenotedMyNotes,
      if (includeLocalRenotes != null)
        'includeLocalRenotes': includeLocalRenotes,
    };
    final res = await http.send<List<dynamic>>(
      '/notes/user-list-timeline',
      body: body,
      options: const RequestOptions(idempotent: true),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyNote.fromJson)
        .toList();
  }

  /// ノートをお気に入りに追加する（`/api/notes/favorites/create`）
  ///
  /// 認証必須。レート制限: 20回/時。
  Future<void> favoritesCreate({required String noteId}) => http.send<Object?>(
        '/notes/favorites/create',
        body: <String, dynamic>{'noteId': noteId},
      );

  /// ノートのお気に入りを解除する（`/api/notes/favorites/delete`）
  ///
  /// 認証必須。
  Future<void> favoritesDelete({required String noteId}) => http.send<Object?>(
        '/notes/favorites/delete',
        body: <String, dynamic>{'noteId': noteId},
      );

  /// おすすめの投票を取得する（`/api/notes/polls/recommendation`）
  ///
  /// まだ投票していない公開投票を返す。認証必須。
  ///
  /// - [limit]: 取得件数 1〜100（デフォルト: 10）
  /// - [offset]: スキップ件数（デフォルト: 0）
  /// - [excludeChannels]: チャンネル内の投票を除外するか（デフォルト: false）
  Future<List<MisskeyNote>> pollsRecommendation({
    int? limit,
    int? offset,
    bool? excludeChannels,
  }) async {
    final body = <String, dynamic>{
      if (limit != null) 'limit': limit,
      if (offset != null) 'offset': offset,
      if (excludeChannels != null) 'excludeChannels': excludeChannels,
    };
    final res = await http.send<List<dynamic>>(
      '/notes/polls/recommendation',
      body: body,
      options: const RequestOptions(idempotent: true),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyNote.fromJson)
        .toList();
  }

  /// スレッドをミュートする（`/api/notes/thread-muting/create`）
  ///
  /// 指定した [noteId] のスレッドからの通知を停止する。
  /// 認証必須。レート制限: 10回/時。
  Future<void> threadMutingCreate({required String noteId}) =>
      http.send<Object?>(
        '/notes/thread-muting/create',
        body: <String, dynamic>{'noteId': noteId},
      );

  /// スレッドのミュートを解除する（`/api/notes/thread-muting/delete`）
  ///
  /// 認証必須。
  Future<void> threadMutingDelete({required String noteId}) =>
      http.send<Object?>(
        '/notes/thread-muting/delete',
        body: <String, dynamic>{'noteId': noteId},
      );

  /// 下書きの件数を取得する（`/api/notes/drafts/count`）
  ///
  /// 認証必須。
  Future<int> draftsCount() async {
    final res = await http.send<int>(
      '/notes/drafts/count',
      body: const <String, dynamic>{},
      options: const RequestOptions(idempotent: true),
    );
    return res;
  }

  /// 下書き一覧を取得する（`/api/notes/drafts/list`）
  ///
  /// 認証必須。
  ///
  /// - [limit]: 取得件数 1〜100（デフォルト: 30）
  /// - [scheduled]: 予約投稿の下書きのみ取得（null=フィルタなし）
  Future<List<MisskeyNoteDraft>> draftsList({
    int? limit,
    String? sinceId,
    String? untilId,
    int? sinceDate,
    int? untilDate,
    bool? scheduled,
  }) async {
    final body = <String, dynamic>{
      if (limit != null) 'limit': limit,
      if (sinceId != null) 'sinceId': sinceId,
      if (untilId != null) 'untilId': untilId,
      if (sinceDate != null) 'sinceDate': sinceDate,
      if (untilDate != null) 'untilDate': untilDate,
      if (scheduled != null) 'scheduled': scheduled,
    };
    final res = await http.send<List<dynamic>>(
      '/notes/drafts/list',
      body: body,
      options: const RequestOptions(idempotent: true),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyNoteDraft.fromJson)
        .toList();
  }

  /// 下書きを作成する（`/api/notes/drafts/create`）
  ///
  /// 認証必須。レート制限: 300回/時。
  ///
  /// - [visibility]: 公開範囲（デフォルト: `public`）
  /// - [visibleUserIds]: 指定可視性の対象ユーザーID
  /// - [cw]: コンテンツ警告テキスト（最大100文字）
  /// - [hashtag]: ハッシュタグ（最大200文字）
  /// - [localOnly]: ローカルのみ（デフォルト: false）
  /// - [reactionAcceptance]: リアクション受入設定
  /// - [replyId]: 返信先ノートID
  /// - [renoteId]: リノート元ノートID
  /// - [channelId]: チャンネルID
  /// - [text]: 本文
  /// - [fileIds]: 添付ファイルIDリスト（最大16件）
  /// - [pollChoices]: 投票の選択肢（最大10件）
  /// - [pollMultiple]: 投票の複数選択を許可するか
  /// - [pollExpiresAt]: 投票期限（絶対エポックms）
  /// - [pollExpiredAfter]: 投票期限（相対ms、最小1）
  /// - [scheduledAt]: 予約投稿日時（Unixタイムスタンプms）
  /// - [isActuallyScheduled]: 予約投稿を有効にするか（デフォルト: false）
  Future<MisskeyNoteDraft> draftsCreate({
    String? visibility,
    List<String>? visibleUserIds,
    String? cw,
    String? hashtag,
    bool? localOnly,
    String? reactionAcceptance,
    String? replyId,
    String? renoteId,
    String? channelId,
    String? text,
    List<String>? fileIds,
    List<String>? pollChoices,
    bool? pollMultiple,
    int? pollExpiresAt,
    int? pollExpiredAfter,
    int? scheduledAt,
    bool? isActuallyScheduled,
  }) async {
    final body = <String, dynamic>{
      if (visibility != null) 'visibility': visibility,
      if (visibleUserIds != null) 'visibleUserIds': visibleUserIds,
      if (cw != null) 'cw': cw,
      if (hashtag != null) 'hashtag': hashtag,
      if (localOnly != null) 'localOnly': localOnly,
      if (reactionAcceptance != null) 'reactionAcceptance': reactionAcceptance,
      if (replyId != null) 'replyId': replyId,
      if (renoteId != null) 'renoteId': renoteId,
      if (channelId != null) 'channelId': channelId,
      if (text != null) 'text': text,
      if (fileIds != null) 'fileIds': fileIds,
      if (scheduledAt != null) 'scheduledAt': scheduledAt,
      if (isActuallyScheduled != null)
        'isActuallyScheduled': isActuallyScheduled,
    };
    if (pollChoices != null && pollChoices.isNotEmpty) {
      final poll = <String, dynamic>{'choices': pollChoices};
      if (pollMultiple != null) poll['multiple'] = pollMultiple;
      if (pollExpiresAt != null) poll['expiresAt'] = pollExpiresAt;
      if (pollExpiredAfter != null) poll['expiredAfter'] = pollExpiredAfter;
      body['poll'] = poll;
    }
    final res = await http.send<Map<String, dynamic>>(
      '/notes/drafts/create',
      body: body,
    );
    final raw = (res['createdDraft'] is Map<String, dynamic>)
        ? res['createdDraft'] as Map<String, dynamic>
        : res;
    return MisskeyNoteDraft.fromJson(raw);
  }

  /// 下書きを更新する（`/api/notes/drafts/update`）
  ///
  /// 認証必須。指定しなかったフィールドは変更されない。
  ///
  /// - [draftId]: 更新対象の下書きID（必須）
  /// - その他パラメータは [draftsCreate] と同様
  Future<MisskeyNoteDraft> draftsUpdate({
    required String draftId,
    String? visibility,
    List<String>? visibleUserIds,
    String? cw,
    String? hashtag,
    bool? localOnly,
    String? reactionAcceptance,
    String? replyId,
    String? renoteId,
    String? channelId,
    String? text,
    List<String>? fileIds,
    List<String>? pollChoices,
    bool? pollMultiple,
    int? pollExpiresAt,
    int? pollExpiredAfter,
    int? scheduledAt,
    bool? isActuallyScheduled,
  }) async {
    final body = <String, dynamic>{
      'draftId': draftId,
      if (visibility != null) 'visibility': visibility,
      if (visibleUserIds != null) 'visibleUserIds': visibleUserIds,
      if (cw != null) 'cw': cw,
      if (hashtag != null) 'hashtag': hashtag,
      if (localOnly != null) 'localOnly': localOnly,
      if (reactionAcceptance != null) 'reactionAcceptance': reactionAcceptance,
      if (replyId != null) 'replyId': replyId,
      if (renoteId != null) 'renoteId': renoteId,
      if (channelId != null) 'channelId': channelId,
      if (text != null) 'text': text,
      if (fileIds != null) 'fileIds': fileIds,
      if (scheduledAt != null) 'scheduledAt': scheduledAt,
      if (isActuallyScheduled != null)
        'isActuallyScheduled': isActuallyScheduled,
    };
    if (pollChoices != null && pollChoices.isNotEmpty) {
      final poll = <String, dynamic>{'choices': pollChoices};
      if (pollMultiple != null) poll['multiple'] = pollMultiple;
      if (pollExpiresAt != null) poll['expiresAt'] = pollExpiresAt;
      if (pollExpiredAfter != null) poll['expiredAfter'] = pollExpiredAfter;
      body['poll'] = poll;
    }
    final res = await http.send<Map<String, dynamic>>(
      '/notes/drafts/update',
      body: body,
    );
    final raw = (res['updatedDraft'] is Map<String, dynamic>)
        ? res['updatedDraft'] as Map<String, dynamic>
        : res;
    return MisskeyNoteDraft.fromJson(raw);
  }

  /// 下書きを削除する（`/api/notes/drafts/delete`）
  ///
  /// 認証必須。
  Future<void> draftsDelete({required String draftId}) => http.send<Object?>(
        '/notes/drafts/delete',
        body: <String, dynamic>{'draftId': draftId},
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
          options: const RequestOptions(
            authMode: AuthMode.optional,
            idempotent: true,
          ),
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

  Future<List<MisskeyNote>> _fetchTimeline({
    required String path,
    int? limit,
    required AuthMode authMode,
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
      if (limit != null) 'limit': limit,
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
      options: RequestOptions(authMode: authMode, idempotent: true),
    );

    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyNote.fromJson)
        .toList();
  }
}
