import '../client/misskey_http.dart';
import '../client/request_options.dart';
import '../models/misskey_antenna.dart';
import '../models/misskey_note.dart';

/// アンテナ関連API（`/api/antennas/*`）
///
/// カスタムタイムラインフィルター（アンテナ）の
/// 作成・更新・削除・一覧取得・ノート取得を提供する。
/// 全エンドポイントで認証必須。
class AntennasApi {
  const AntennasApi({required this.http});

  final MisskeyHttp http;

  /// アンテナを作成する（`/api/antennas/create`）
  ///
  /// - [name]: アンテナ名（1〜100文字、必須）
  /// - [src]: ソース種別（必須）
  ///   `home` / `all` / `users` / `list` / `users_blacklist`
  /// - [userListId]: ソースが `list` の場合のユーザーリストID
  /// - [keywords]: キーワード（外側OR、内側AND、必須）
  /// - [excludeKeywords]: 除外キーワード（外側OR、内側AND、必須）
  /// - [users]: 対象ユーザー名リスト（必須）
  /// - [caseSensitive]: 大文字小文字を区別するか（必須）
  /// - [localOnly]: ローカルノートのみ対象にするか
  /// - [excludeBots]: botを除外するか
  /// - [withReplies]: リプライを含めるか（必須）
  /// - [withFile]: ファイル付きのみ対象にするか（必須）
  /// - [excludeNotesInSensitiveChannel]: センシティブチャンネルを除外するか
  ///
  /// 主なエラー:
  /// - `NO_SUCH_USER_LIST`: 指定したユーザーリストが存在しない
  /// - `TOO_MANY_ANTENNAS`: アンテナ上限に達している
  /// - `EMPTY_KEYWORD`: キーワードと除外キーワードの両方が空
  Future<MisskeyAntenna> create({
    required String name,
    required String src,
    String? userListId,
    required List<List<String>> keywords,
    required List<List<String>> excludeKeywords,
    required List<String> users,
    required bool caseSensitive,
    bool? localOnly,
    bool? excludeBots,
    required bool withReplies,
    required bool withFile,
    bool? excludeNotesInSensitiveChannel,
  }) async {
    final res = await http.send<Map<String, dynamic>>(
      '/antennas/create',
      body: <String, dynamic>{
        'name': name,
        'src': src,
        'userListId': userListId,
        'keywords': keywords,
        'excludeKeywords': excludeKeywords,
        'users': users,
        'caseSensitive': caseSensitive,
        if (localOnly != null) 'localOnly': localOnly,
        if (excludeBots != null) 'excludeBots': excludeBots,
        'withReplies': withReplies,
        'withFile': withFile,
        if (excludeNotesInSensitiveChannel != null)
          'excludeNotesInSensitiveChannel': excludeNotesInSensitiveChannel,
      },
    );
    return MisskeyAntenna.fromJson(res);
  }

  /// アンテナを更新する（`/api/antennas/update`）
  ///
  /// [antennaId] のみ必須。他のパラメータは指定した項目のみ更新される。
  ///
  /// 主なエラー:
  /// - `NO_SUCH_ANTENNA`: アンテナが存在しない
  /// - `NO_SUCH_USER_LIST`: 指定したユーザーリストが存在しない
  /// - `EMPTY_KEYWORD`: キーワードと除外キーワードの両方が空
  Future<MisskeyAntenna> update({
    required String antennaId,
    String? name,
    String? src,
    String? userListId,
    List<List<String>>? keywords,
    List<List<String>>? excludeKeywords,
    List<String>? users,
    bool? caseSensitive,
    bool? localOnly,
    bool? excludeBots,
    bool? withReplies,
    bool? withFile,
    bool? excludeNotesInSensitiveChannel,
  }) async {
    final body = <String, dynamic>{
      'antennaId': antennaId,
      if (name != null) 'name': name,
      if (src != null) 'src': src,
      if (userListId != null) 'userListId': userListId,
      if (keywords != null) 'keywords': keywords,
      if (excludeKeywords != null) 'excludeKeywords': excludeKeywords,
      if (users != null) 'users': users,
      if (caseSensitive != null) 'caseSensitive': caseSensitive,
      if (localOnly != null) 'localOnly': localOnly,
      if (excludeBots != null) 'excludeBots': excludeBots,
      if (withReplies != null) 'withReplies': withReplies,
      if (withFile != null) 'withFile': withFile,
      if (excludeNotesInSensitiveChannel != null)
        'excludeNotesInSensitiveChannel': excludeNotesInSensitiveChannel,
    };
    final res = await http.send<Map<String, dynamic>>(
      '/antennas/update',
      body: body,
    );
    return MisskeyAntenna.fromJson(res);
  }

  /// アンテナを削除する（`/api/antennas/delete`）
  ///
  /// - [antennaId]: 削除対象のアンテナID（必須）
  ///
  /// 主なエラー:
  /// - `NO_SUCH_ANTENNA`: アンテナが存在しない
  Future<void> delete({required String antennaId}) => http.send<Object?>(
        '/antennas/delete',
        body: <String, dynamic>{'antennaId': antennaId},
      );

  /// アンテナの詳細を取得する（`/api/antennas/show`）
  ///
  /// - [antennaId]: 対象のアンテナID（必須）
  ///
  /// 主なエラー:
  /// - `NO_SUCH_ANTENNA`: アンテナが存在しない
  Future<MisskeyAntenna> show({required String antennaId}) async {
    final res = await http.send<Map<String, dynamic>>(
      '/antennas/show',
      body: <String, dynamic>{'antennaId': antennaId},
      options: const RequestOptions(idempotent: true),
    );
    return MisskeyAntenna.fromJson(res);
  }

  /// アンテナ一覧を取得する（`/api/antennas/list`）
  ///
  /// 認証ユーザーが所有する全アンテナを返す。
  Future<List<MisskeyAntenna>> list() async {
    final res = await http.send<List<dynamic>>(
      '/antennas/list',
      body: const <String, dynamic>{},
      options: const RequestOptions(idempotent: true),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyAntenna.fromJson)
        .toList();
  }

  /// アンテナに一致するノートを取得する（`/api/antennas/notes`）
  ///
  /// - [antennaId]: 対象のアンテナID（必須）
  /// - [limit]: 取得件数 1〜100（デフォルト10）
  /// - [sinceId] / [untilId]: IDによるページング
  /// - [sinceDate] / [untilDate]: Unixタイムスタンプ（ms）によるページング
  ///
  /// 主なエラー:
  /// - `NO_SUCH_ANTENNA`: アンテナが存在しない
  Future<List<MisskeyNote>> notes({
    required String antennaId,
    int? limit,
    String? sinceId,
    String? untilId,
    int? sinceDate,
    int? untilDate,
  }) async {
    final body = <String, dynamic>{
      'antennaId': antennaId,
      if (limit != null) 'limit': limit,
      if (sinceId != null) 'sinceId': sinceId,
      if (untilId != null) 'untilId': untilId,
      if (sinceDate != null) 'sinceDate': sinceDate,
      if (untilDate != null) 'untilDate': untilDate,
    };
    final res = await http.send<List<dynamic>>(
      '/antennas/notes',
      body: body,
      options: const RequestOptions(idempotent: true),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyNote.fromJson)
        .toList();
  }
}
