import '../../client/auth_mode.dart';
import '../../client/misskey_http.dart';
import '../../client/request_options.dart';
import '../../models/misskey_channel.dart';
import '../../models/misskey_note.dart';
import 'channel_mute_api.dart';

/// チャンネル関連API
///
/// `channels/*` の各エンドポイントを提供する。
/// ミュート操作は [mute] サブAPIを使用する。
class ChannelsApi {
  ChannelsApi({required MisskeyHttp http})
      : _http = http,
        mute = ChannelMuteApi(http: http);

  final MisskeyHttp _http;

  /// チャンネルミュート関連API
  final ChannelMuteApi mute;

  /// チャンネルを作成
  ///
  /// [name] はチャンネル名（1〜128文字、必須）。
  /// [description] はチャンネルの説明文（最大2048文字）。
  /// [bannerId] はバナー画像のドライブファイルID。
  /// [color] はチャンネルのテーマカラー（1〜16文字）。
  /// [isSensitive] はセンシティブチャンネルかどうか。
  /// [allowRenoteToExternal] はチャンネル外へのリノートを許可するか。
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

  /// チャンネルを更新
  ///
  /// [channelId] で対象チャンネルを指定する（必須）。
  /// [name] はチャンネル名（1〜128文字）。
  /// [description] はチャンネルの説明文（最大2048文字）。
  /// [bannerId] はバナー画像のドライブファイルID。
  /// [isArchived] はアーカイブ状態にするかどうか。
  /// [pinnedNoteIds] はピン留めするノートIDのリスト。
  /// [color] はチャンネルのテーマカラー（1〜16文字）。
  /// [isSensitive] はセンシティブチャンネルかどうか。
  /// [allowRenoteToExternal] はチャンネル外へのリノートを許可するか。
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

  /// お気に入り登録済みのチャンネル一覧を取得
  ///
  /// 認証ユーザーがお気に入り登録したチャンネルをすべて返す。
  /// スキーマに入力パラメータはない。
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

  /// 指定チャンネルの詳細情報を取得
  ///
  /// [channelId] で対象チャンネルを指定する。
  /// チャンネルが存在しない場合はエラーになる。
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

  /// 指定チャンネルのタイムラインを取得
  ///
  /// [channelId] で対象チャンネルを指定する。
  /// [sinceId] / [untilId] はIDによるページング、
  /// [sinceDate] / [untilDate] はUnixタイムスタンプ（ms）によるページング。
  /// [allowPartial] を`true`にすると部分的な結果を許容する。
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

  /// 注目（フィーチャー）チャンネル一覧を取得
  ///
  /// スキーマに入力パラメータはない。
  /// 最近投稿があったチャンネルを最大10件返す。
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

  /// フォロー中のチャンネル一覧を取得
  ///
  /// [sinceId] / [untilId] はIDによるページング、
  /// [sinceDate] / [untilDate] はUnixタイムスタンプ（ms）によるページング。
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

  /// 自分が所有するチャンネル一覧を取得
  ///
  /// [sinceId] / [untilId] はIDによるページング、
  /// [sinceDate] / [untilDate] はUnixタイムスタンプ（ms）によるページング。
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

  /// キーワードでチャンネルを検索
  ///
  /// [query] に検索語を指定する（必須）。
  /// [type] で検索対象を`'nameAndDescription'`（デフォルト）か
  /// `'nameOnly'`のいずれかに指定できる。
  /// [sinceId] / [untilId] はIDによるページング、
  /// [sinceDate] / [untilDate] はUnixタイムスタンプ（ms）によるページング。
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

  /// チャンネルをフォロー
  ///
  /// [channelId] で対象チャンネルを指定
  Future<void> follow({required String channelId}) => _http.send<Object?>(
        '/channels/follow',
        body: <String, dynamic>{'channelId': channelId},
      );

  /// チャンネルのフォローを解除
  ///
  /// [channelId] で対象チャンネルを指定
  Future<void> unfollow({required String channelId}) => _http.send<Object?>(
        '/channels/unfollow',
        body: <String, dynamic>{'channelId': channelId},
      );

  /// チャンネルをお気に入り登録
  ///
  /// [channelId] で対象チャンネルを指定
  Future<void> favorite({required String channelId}) => _http.send<Object?>(
        '/channels/favorite',
        body: <String, dynamic>{'channelId': channelId},
      );

  /// チャンネルのお気に入りを解除
  ///
  /// [channelId] で対象チャンネルを指定
  Future<void> unfavorite({required String channelId}) => _http.send<Object?>(
        '/channels/unfavorite',
        body: <String, dynamic>{'channelId': channelId},
      );
}
