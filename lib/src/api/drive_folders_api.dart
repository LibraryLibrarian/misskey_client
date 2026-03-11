import '../client/misskey_http.dart';
import '../client/request_options.dart';

/// DriveFolderのJSON表現
typedef DriveFolderJson = Map<String, dynamic>;

/// Driveフォルダ関連API（`/api/drive/folders/*`）
///
/// `/api/drive/folders` 系エンドポイントを [MisskeyHttp] に委譲して呼び出す。
/// 認証はすべて [MisskeyHttp] のインターセプタに委ねる。
class DriveFoldersApi {
  /// コンストラクタ
  const DriveFoldersApi({required this.http});

  /// HTTPクライアント
  final MisskeyHttp http;

  /// Driveフォルダの一覧を取得する（`/api/drive/folders`）
  ///
  /// - [limit]: 取得件数（1〜100、デフォルト10）
  /// - [sinceId] / [untilId]: IDによるページング
  /// - [sinceDate] / [untilDate]: Unixタイムスタンプ（ms）によるページング
  /// - [folderId]: 親フォルダIDで絞り込む（`null`でルート）
  Future<List<DriveFolderJson>> list({
    int? limit,
    String? sinceId,
    String? untilId,
    int? sinceDate,
    int? untilDate,
    String? folderId,
  }) async {
    final body = <String, dynamic>{
      if (limit != null) 'limit': limit,
      if (sinceId != null) 'sinceId': sinceId,
      if (untilId != null) 'untilId': untilId,
      if (sinceDate != null) 'sinceDate': sinceDate,
      if (untilDate != null) 'untilDate': untilDate,
      if (folderId != null) 'folderId': folderId,
    };
    final res = await http.send<List<dynamic>>(
      '/drive/folders',
      body: body,
      options: const RequestOptions(idempotent: true),
    );
    return res
        .whereType<Map<dynamic, dynamic>>()
        .map((e) => e.cast<String, dynamic>())
        .toList();
  }

  /// Driveフォルダを作成する（`/api/drive/folders/create`）
  ///
  /// - [name]: フォルダ名（最大200文字、デフォルト`'Untitled'`）
  /// - [parentId]: 親フォルダID（`null`でルートに作成）
  Future<DriveFolderJson> create({
    String? name,
    String? parentId,
  }) async {
    final body = <String, dynamic>{
      if (name != null) 'name': name,
      if (parentId != null) 'parentId': parentId,
    };
    final res = await http.send<Map<dynamic, dynamic>>(
      '/drive/folders/create',
      body: body,
    );
    return res.cast<String, dynamic>();
  }

  /// Driveフォルダの詳細を取得する（`/api/drive/folders/show`）
  ///
  /// - [folderId]: 取得対象のフォルダID（必須）
  Future<DriveFolderJson> show({required String folderId}) async {
    final res = await http.send<Map<dynamic, dynamic>>(
      '/drive/folders/show',
      body: <String, dynamic>{'folderId': folderId},
      options: const RequestOptions(idempotent: true),
    );
    return res.cast<String, dynamic>();
  }

  /// Driveフォルダのメタ情報を更新する（`/api/drive/folders/update`）
  ///
  /// - [folderId]: 更新対象のフォルダID（必須）
  /// - [name]: 新しいフォルダ名（最大200文字）
  /// - [parentId]: 移動先の親フォルダID（`null`でルートへ移動）
  Future<DriveFolderJson> update({
    required String folderId,
    String? name,
    String? parentId,
  }) async {
    final body = <String, dynamic>{
      'folderId': folderId,
      if (name != null) 'name': name,
      if (parentId != null) 'parentId': parentId,
    };
    final res = await http.send<Map<dynamic, dynamic>>(
      '/drive/folders/update',
      body: body,
    );
    return res.cast<String, dynamic>();
  }

  /// Driveフォルダを削除する（`/api/drive/folders/delete`）
  ///
  /// フォルダに子ファイルまたはサブフォルダが存在する場合はエラーになる。
  ///
  /// - [folderId]: 削除対象のフォルダID（必須）
  Future<void> delete({required String folderId}) =>
      http.send<Object?>(
        '/drive/folders/delete',
        body: <String, dynamic>{'folderId': folderId},
      );

  /// フォルダ名でDrive内を検索する（`/api/drive/folders/find`）
  ///
  /// - [name]: 検索するフォルダ名（必須）
  /// - [parentId]: 検索対象の親フォルダID（`null`でルート）
  Future<List<DriveFolderJson>> find({
    required String name,
    String? parentId,
  }) async {
    final body = <String, dynamic>{
      'name': name,
      if (parentId != null) 'parentId': parentId,
    };
    final res = await http.send<List<dynamic>>(
      '/drive/folders/find',
      body: body,
      options: const RequestOptions(idempotent: true),
    );
    return res
        .whereType<Map<dynamic, dynamic>>()
        .map((e) => e.cast<String, dynamic>())
        .toList();
  }
}
