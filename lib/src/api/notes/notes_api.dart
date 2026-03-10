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
