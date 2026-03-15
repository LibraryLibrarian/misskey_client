import '../client/auth_mode.dart';
import '../client/misskey_http.dart';
import '../client/request_options.dart';
import '../models/misskey_note.dart';
import '../models/misskey_role.dart';
import '../models/misskey_role_user.dart';

/// ロール関連API（`/api/roles/*`）
///
/// 公開ロールの一覧・詳細・ノート・ユーザー取得を提供する。
class RolesApi {
  const RolesApi({required this.http});

  final MisskeyHttp http;

  /// 公開ロール一覧を取得する（`/api/roles/list`）
  ///
  /// `isPublic` かつ `isExplorable` なロールのみ返される。
  /// 認証必須。パラメータなし。
  Future<List<MisskeyRole>> list() async {
    final res = await http.send<List<dynamic>>(
      '/roles/list',
      body: const <String, dynamic>{},
      options: const RequestOptions(idempotent: true),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyRole.fromJson)
        .toList();
  }

  /// ロールの詳細情報を取得する（`/api/roles/show`）
  ///
  /// 公開ロールのみ取得可能。認証不要。
  ///
  /// - [roleId]: ロールID（必須）
  ///
  /// 主なエラー:
  /// - `NO_SUCH_ROLE`: 指定したロールが存在しないか非公開
  Future<MisskeyRole> show({required String roleId}) async {
    final res = await http.send<Map<String, dynamic>>(
      '/roles/show',
      body: <String, dynamic>{'roleId': roleId},
      options: const RequestOptions(
        authMode: AuthMode.none,
        idempotent: true,
      ),
    );
    return MisskeyRole.fromJson(res);
  }

  /// ロールのタイムライン（ノート一覧）を取得する（`/api/roles/notes`）
  ///
  /// 指定ロールに所属するユーザーのノートを返す。認証必須。
  ///
  /// - [roleId]: ロールID（必須）
  /// - [limit]: 取得件数 1〜100（デフォルト: 10）
  /// - [sinceId] / [untilId]: IDによるページング
  /// - [sinceDate] / [untilDate]: Unixタイムスタンプ（ms）によるページング
  ///
  /// 主なエラー:
  /// - `NO_SUCH_ROLE`: 指定したロールが存在しない
  Future<List<MisskeyNote>> notes({
    required String roleId,
    int? limit,
    String? sinceId,
    String? untilId,
    int? sinceDate,
    int? untilDate,
  }) async {
    final body = <String, dynamic>{
      'roleId': roleId,
      if (limit != null) 'limit': limit,
      if (sinceId != null) 'sinceId': sinceId,
      if (untilId != null) 'untilId': untilId,
      if (sinceDate != null) 'sinceDate': sinceDate,
      if (untilDate != null) 'untilDate': untilDate,
    };
    final res = await http.send<List<dynamic>>(
      '/roles/notes',
      body: body,
      options: const RequestOptions(idempotent: true),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyNote.fromJson)
        .toList();
  }

  /// ロールに所属するユーザー一覧を取得する（`/api/roles/users`）
  ///
  /// 公開かつ探索可能なロールのユーザーのみ返される。認証不要。
  ///
  /// - [roleId]: ロールID（必須）
  /// - [limit]: 取得件数 1〜100（デフォルト: 10）
  /// - [sinceId] / [untilId]: IDによるページング
  /// - [sinceDate] / [untilDate]: Unixタイムスタンプ（ms）によるページング
  ///
  /// 主なエラー:
  /// - `NO_SUCH_ROLE`: 指定したロールが存在しないか非公開
  Future<List<MisskeyRoleUser>> users({
    required String roleId,
    int? limit,
    String? sinceId,
    String? untilId,
    int? sinceDate,
    int? untilDate,
  }) async {
    final body = <String, dynamic>{
      'roleId': roleId,
      if (limit != null) 'limit': limit,
      if (sinceId != null) 'sinceId': sinceId,
      if (untilId != null) 'untilId': untilId,
      if (sinceDate != null) 'sinceDate': sinceDate,
      if (untilDate != null) 'untilDate': untilDate,
    };
    final res = await http.send<List<dynamic>>(
      '/roles/users',
      body: body,
      options: const RequestOptions(
        authMode: AuthMode.none,
        idempotent: true,
      ),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyRoleUser.fromJson)
        .toList();
  }
}
