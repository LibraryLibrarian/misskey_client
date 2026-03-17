import '../../client/misskey_http.dart';
import '../../client/request_options.dart';
import '../../models/account/misskey_registry_detail.dart';
import '../../models/account/misskey_registry_scope.dart';

/// レジストリ関連API（`/api/i/registry/*`）
///
/// クライアント設定等のキー・バリューストアを操作する。
/// 全エンドポイントで認証必須。
class RegistryApi {
  const RegistryApi({required this.http});

  final MisskeyHttp http;

  /// 特定キーの値を取得する（`/api/i/registry/get`）
  ///
  /// - [key]: レジストリキー名（必須）
  /// - [scope]: スコープ配列（デフォルト空配列）
  /// - [domain]: ドメイン（省略時はアクセストークンに紐づく）
  ///
  /// キーが存在しない場合はサーバーが `NO_SUCH_KEY` エラーを返す。
  Future<dynamic> get({
    required String key,
    List<String> scope = const <String>[],
    String? domain,
  }) =>
      http.send<dynamic>(
        '/i/registry/get',
        body: <String, dynamic>{
          'key': key,
          'scope': scope,
          if (domain != null) 'domain': domain,
        },
        options: const RequestOptions(idempotent: true),
      );

  /// スコープ内の全キー・値を取得する（`/api/i/registry/get-all`）
  ///
  /// - [scope]: スコープ配列（デフォルト空配列）
  /// - [domain]: ドメイン（省略時はアクセストークンに紐づく）
  ///
  /// キー名をキー、レジストリ値をバリューとする Map を返す。
  Future<Map<String, dynamic>> getAll({
    List<String> scope = const <String>[],
    String? domain,
  }) async {
    final res = await http.send<Map<String, dynamic>>(
      '/i/registry/get-all',
      body: <String, dynamic>{
        'scope': scope,
        if (domain != null) 'domain': domain,
      },
      options: const RequestOptions(idempotent: true),
    );
    return res;
  }

  /// 特定キーの詳細情報を取得する（`/api/i/registry/get-detail`）
  ///
  /// 値に加えて最終更新日時も返す。
  ///
  /// - [key]: レジストリキー名（必須）
  /// - [scope]: スコープ配列（デフォルト空配列）
  /// - [domain]: ドメイン（省略時はアクセストークンに紐づく）
  ///
  /// キーが存在しない場合はサーバーが `NO_SUCH_KEY` エラーを返す。
  Future<MisskeyRegistryDetail> getDetail({
    required String key,
    List<String> scope = const <String>[],
    String? domain,
  }) async {
    final res = await http.send<Map<String, dynamic>>(
      '/i/registry/get-detail',
      body: <String, dynamic>{
        'key': key,
        'scope': scope,
        if (domain != null) 'domain': domain,
      },
      options: const RequestOptions(idempotent: true),
    );
    return MisskeyRegistryDetail.fromJson(res);
  }

  /// スコープ内のキー名一覧を取得する（`/api/i/registry/keys`）
  ///
  /// - [scope]: スコープ配列（デフォルト空配列）
  /// - [domain]: ドメイン（省略時はアクセストークンに紐づく）
  Future<List<String>> keys({
    List<String> scope = const <String>[],
    String? domain,
  }) async {
    final res = await http.send<List<dynamic>>(
      '/i/registry/keys',
      body: <String, dynamic>{
        'scope': scope,
        if (domain != null) 'domain': domain,
      },
      options: const RequestOptions(idempotent: true),
    );
    return res.cast<String>();
  }

  /// スコープ内のキー名一覧を型情報付きで取得する（`/api/i/registry/keys-with-type`）
  ///
  /// 返り値の Map はキー名をキー、型名（`'null'`/`'array'`/`'number'`/
  /// `'string'`/`'boolean'`/`'object'`）をバリューとする。
  ///
  /// - [scope]: スコープ配列（デフォルト空配列）
  /// - [domain]: ドメイン（省略時はアクセストークンに紐づく）
  Future<Map<String, String>> keysWithType({
    List<String> scope = const <String>[],
    String? domain,
  }) async {
    final res = await http.send<Map<String, dynamic>>(
      '/i/registry/keys-with-type',
      body: <String, dynamic>{
        'scope': scope,
        if (domain != null) 'domain': domain,
      },
      options: const RequestOptions(idempotent: true),
    );
    return res.map((k, v) => MapEntry(k, v.toString()));
  }

  /// キー・値を設定する（`/api/i/registry/set`）
  ///
  /// キーが存在しない場合は新規作成、存在する場合は上書きする。
  ///
  /// - [key]: レジストリキー名（必須、1文字以上）
  /// - [value]: 格納する値（必須、任意の型）
  /// - [scope]: スコープ配列（デフォルト空配列）
  /// - [domain]: ドメイン（省略時はアクセストークンに紐づく）
  Future<void> set({
    required String key,
    required dynamic value,
    List<String> scope = const <String>[],
    String? domain,
  }) =>
      http.send<Object?>(
        '/i/registry/set',
        body: <String, dynamic>{
          'key': key,
          'value': value,
          'scope': scope,
          if (domain != null) 'domain': domain,
        },
      );

  /// キーを削除する（`/api/i/registry/remove`）
  ///
  /// - [key]: 削除対象のレジストリキー名（必須）
  /// - [scope]: スコープ配列（デフォルト空配列）
  /// - [domain]: ドメイン（省略時はアクセストークンに紐づく）
  ///
  /// キーが存在しない場合はサーバーが `NO_SUCH_KEY` エラーを返す。
  Future<void> remove({
    required String key,
    List<String> scope = const <String>[],
    String? domain,
  }) =>
      http.send<Object?>(
        '/i/registry/remove',
        body: <String, dynamic>{
          'key': key,
          'scope': scope,
          if (domain != null) 'domain': domain,
        },
      );

  /// 全スコープ・ドメイン一覧を取得する（`/api/i/registry/scopes-with-domain`）
  ///
  /// パラメータなし。ユーザーが保持する全レジストリのスコープと
  /// ドメインの組み合わせを返す。
  Future<List<MisskeyRegistryScope>> scopesWithDomain() async {
    final res = await http.send<List<dynamic>>(
      '/i/registry/scopes-with-domain',
      body: const <String, dynamic>{},
      options: const RequestOptions(idempotent: true),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyRegistryScope.fromJson)
        .toList();
  }
}
