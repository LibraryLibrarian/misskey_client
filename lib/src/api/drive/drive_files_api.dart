import 'package:dio/dio.dart' show FormData, MultipartFile;

import '../../client/misskey_http.dart';
import '../../client/request_options.dart';
import '../../models/chat/misskey_chat_message.dart';
import '../../models/misskey_drive_file.dart';
import '../../models/misskey_note.dart';

/// Driveファイル関連API（`/api/drive/files/*`）
///
/// `/api/drive/files` 系エンドポイントを [MisskeyHttp] に委譲して呼び出す。
/// 認証はすべて [MisskeyHttp] のインターセプタに委ねる。
class DriveFilesApi {
  /// コンストラクタ
  const DriveFilesApi({required this.http});

  /// HTTPクライアント
  final MisskeyHttp http;

  /// ドライブファイルの一覧を取得する（`/api/drive/files`）
  ///
  /// - [limit]: 取得件数（1〜100）
  /// - [sinceId] / [untilId]: IDによるページング
  /// - [sinceDate] / [untilDate]: Unixタイムスタンプ（ms）によるページング
  /// - [folderId]: フォルダーIDで絞り込む（`null`でルート）
  /// - [type]: MIMEタイプパターンで絞り込む（例: `"image/*"`）
  /// - [sort]: ソート順（`+createdAt` / `-createdAt` / `+name` / `-name` /
  ///   `+size` / `-size`）
  Future<List<MisskeyDriveFile>> list({
    int? limit,
    String? sinceId,
    String? untilId,
    int? sinceDate,
    int? untilDate,
    String? folderId,
    String? type,
    String? sort,
  }) async {
    final body = <String, dynamic>{
      if (limit != null) 'limit': limit,
      if (sinceId != null) 'sinceId': sinceId,
      if (untilId != null) 'untilId': untilId,
      if (sinceDate != null) 'sinceDate': sinceDate,
      if (untilDate != null) 'untilDate': untilDate,
      if (folderId != null) 'folderId': folderId,
      if (type != null) 'type': type,
      if (sort != null) 'sort': sort,
    };
    final res = await http.send<List<dynamic>>(
      '/drive/files',
      body: body,
      options: const RequestOptions(idempotent: true),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyDriveFile.fromJson)
        .toList();
  }

  /// ファイルIDを指定してドライブファイルの詳細を取得する
  /// （`/api/drive/files/show`）
  Future<MisskeyDriveFile> showByFileId(String fileId) async {
    final res = await http.send<Map<String, dynamic>>(
      '/drive/files/show',
      body: <String, dynamic>{'fileId': fileId},
      options: const RequestOptions(idempotent: true),
    );
    return MisskeyDriveFile.fromJson(res);
  }

  /// URLを指定してドライブファイルの詳細を取得する
  /// （`/api/drive/files/show`）
  Future<MisskeyDriveFile> showByUrl(String url) async {
    final res = await http.send<Map<String, dynamic>>(
      '/drive/files/show',
      body: <String, dynamic>{'url': url},
      options: const RequestOptions(idempotent: true),
    );
    return MisskeyDriveFile.fromJson(res);
  }

  /// ファイルをアップロードする（`/api/drive/files/create`）
  ///
  /// ファイル本体は [bytes] と [filename] で指定する。
  /// 認証トークンは [MisskeyHttp] のインターセプタが `FormData` に注入する。
  ///
  /// - [bytes]: アップロードするバイト列
  /// - [filename]: ファイル名
  /// - [folderId]: 保存先フォルダーID
  /// - [comment]: コメント（`DB_MAX_IMAGE_COMMENT_LENGTH` 以内）
  /// - [isSensitive]: センシティブコンテンツとしてマークするか
  /// - [force]: 同名ファイルが存在しても強制アップロードするか
  /// - [onSendProgress]: アップロード進捗コールバック
  Future<MisskeyDriveFile> create({
    required List<int> bytes,
    required String filename,
    String? folderId,
    String? comment,
    bool? isSensitive,
    bool? force,
    void Function(int sent, int total)? onSendProgress,
  }) async {
    final form = FormData();
    form.files.add(
      MapEntry('file', MultipartFile.fromBytes(bytes, filename: filename)),
    );
    if (folderId != null) form.fields.add(MapEntry('folderId', folderId));
    if (comment != null) form.fields.add(MapEntry('comment', comment));
    if (isSensitive != null) {
      form.fields.add(MapEntry('isSensitive', isSensitive.toString()));
    }
    if (force != null) {
      form.fields.add(MapEntry('force', force.toString()));
    }

    final res = await http.send<Map<String, dynamic>>(
      '/drive/files/create',
      body: form,
      onSendProgress: onSendProgress,
    );
    return MisskeyDriveFile.fromJson(res);
  }

  /// ドライブファイルのメタ情報を更新する（`/api/drive/files/update`）
  ///
  /// - [fileId]: 更新対象のファイルID（必須）
  /// - [name]: 新しいファイル名
  /// - [folderId]: 移動先フォルダーID
  /// - [moveToRoot]: `true` にするとルートフォルダへ移動する
  ///   （`folderId: null` を明示送信する）
  /// - [comment]: コメント（最大512文字）
  /// - [isSensitive]: センシティブコンテンツとしてマークするか
  Future<MisskeyDriveFile> update({
    required String fileId,
    String? name,
    String? folderId,
    bool moveToRoot = false,
    String? comment,
    bool? isSensitive,
  }) async {
    final body = <String, dynamic>{
      'fileId': fileId,
      if (name != null) 'name': name,
      if (moveToRoot)
        'folderId': null
      else if (folderId != null)
        'folderId': folderId,
      if (comment != null) 'comment': comment,
      if (isSensitive != null) 'isSensitive': isSensitive,
    };
    final res = await http.send<Map<String, dynamic>>(
      '/drive/files/update',
      body: body,
    );
    return MisskeyDriveFile.fromJson(res);
  }

  /// ドライブファイルを削除する（`/api/drive/files/delete`）
  ///
  /// - [fileId]: 削除対象のファイルID（必須）
  Future<void> delete({required String fileId}) => http.send<Object?>(
        '/drive/files/delete',
        body: <String, dynamic>{'fileId': fileId},
      );

  /// ファイル名でドライブ内を検索する（`/api/drive/files/find`）
  ///
  /// - [name]: 検索するファイル名（必須）
  /// - [folderId]: 検索対象フォルダーID（`null`でルート）
  Future<List<MisskeyDriveFile>> find({
    required String name,
    String? folderId,
  }) async {
    final body = <String, dynamic>{
      'name': name,
      if (folderId != null) 'folderId': folderId,
    };
    final res = await http.send<List<dynamic>>(
      '/drive/files/find',
      body: body,
      options: const RequestOptions(idempotent: true),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyDriveFile.fromJson)
        .toList();
  }

  /// 指定したMD5ハッシュを持つファイルがドライブに存在するか確認する
  /// （`/api/drive/files/check-existence`）
  ///
  /// - [md5]: 確認対象ファイルのMD5ハッシュ（必須）
  Future<bool> checkExistence({required String md5}) => http.send<bool>(
        '/drive/files/check-existence',
        body: <String, dynamic>{'md5': md5},
        options: const RequestOptions(idempotent: true),
      );

  /// URLを指定してドライブにファイルをアップロードする
  /// （`/api/drive/files/upload-from-url`）
  ///
  /// このエンドポイントはリクエスト完了後、非同期でアップロードを実行し
  /// ストリームイベント（`urlUploadFinished`）で結果を通知する。
  ///
  /// - [url]: ダウンロード元URL（必須）
  /// - [folderId]: 保存先フォルダーID
  /// - [isSensitive]: センシティブコンテンツとしてマークするか
  /// - [comment]: コメント（最大512文字）
  /// - [marker]: 追跡用マーカー文字列（ストリームイベントに付与される）
  /// - [force]: 同名ファイルが存在しても強制アップロードするか
  Future<void> uploadFromUrl({
    required String url,
    String? folderId,
    bool? isSensitive,
    String? comment,
    String? marker,
    bool? force,
  }) =>
      http.send<Object?>(
        '/drive/files/upload-from-url',
        body: <String, dynamic>{
          'url': url,
          if (folderId != null) 'folderId': folderId,
          if (isSensitive != null) 'isSensitive': isSensitive,
          if (comment != null) 'comment': comment,
          if (marker != null) 'marker': marker,
          if (force != null) 'force': force,
        },
      );

  /// MD5ハッシュでドライブファイルを検索する
  /// （`/api/drive/files/find-by-hash`）
  ///
  /// [checkExistence] とは異なり、ファイル情報のリストを返す。
  /// 自分が所有するファイルのみが検索対象。
  ///
  /// - [md5]: 検索対象ファイルのMD5ハッシュ（必須）
  Future<List<MisskeyDriveFile>> findByHash({required String md5}) async {
    final res = await http.send<List<dynamic>>(
      '/drive/files/find-by-hash',
      body: <String, dynamic>{'md5': md5},
      options: const RequestOptions(idempotent: true),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyDriveFile.fromJson)
        .toList();
  }

  /// 複数ファイルを一括でフォルダ移動する
  /// （`/api/drive/files/move-bulk`）
  ///
  /// - [fileIds]: 移動対象のファイルIDリスト（必須、1〜100件、重複不可）
  /// - [folderId]: 移動先フォルダーID（`null`でルートフォルダへ移動）
  Future<void> moveBulk({
    required List<String> fileIds,
    String? folderId,
  }) =>
      http.send<Object?>(
        '/drive/files/move-bulk',
        body: <String, dynamic>{
          'fileIds': fileIds,
          'folderId': folderId,
        },
      );

  /// 指定ファイルが添付されているチャットメッセージ一覧を取得する
  /// （`/api/drive/files/attached-chat-messages`）
  ///
  /// - [fileId]: 対象ファイルID（必須）
  /// - [limit]: 取得件数（1〜100、デフォルト10）
  /// - [sinceId] / [untilId]: IDによるページング
  /// - [sinceDate] / [untilDate]: Unixタイムスタンプ（ms）によるページング
  Future<List<MisskeyChatMessage>> attachedChatMessages({
    required String fileId,
    int? limit,
    String? sinceId,
    String? untilId,
    int? sinceDate,
    int? untilDate,
  }) async {
    final body = <String, dynamic>{
      'fileId': fileId,
      if (limit != null) 'limit': limit,
      if (sinceId != null) 'sinceId': sinceId,
      if (untilId != null) 'untilId': untilId,
      if (sinceDate != null) 'sinceDate': sinceDate,
      if (untilDate != null) 'untilDate': untilDate,
    };
    final res = await http.send<List<dynamic>>(
      '/drive/files/attached-chat-messages',
      body: body,
      options: const RequestOptions(idempotent: true),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyChatMessage.fromJson)
        .toList();
  }

  /// 指定ファイルが添付されているノート一覧を取得する
  /// （`/api/drive/files/attached-notes`）
  ///
  /// - [fileId]: 対象ファイルID（必須）
  /// - [limit]: 取得件数（1〜100）
  /// - [sinceId] / [untilId]: IDによるページング
  /// - [sinceDate] / [untilDate]: Unixタイムスタンプ（ms）によるページング
  Future<List<MisskeyNote>> attachedNotes({
    required String fileId,
    int? limit,
    String? sinceId,
    String? untilId,
    int? sinceDate,
    int? untilDate,
  }) async {
    final body = <String, dynamic>{
      'fileId': fileId,
      if (limit != null) 'limit': limit,
      if (sinceId != null) 'sinceId': sinceId,
      if (untilId != null) 'untilId': untilId,
      if (sinceDate != null) 'sinceDate': sinceDate,
      if (untilDate != null) 'untilDate': untilDate,
    };
    final res = await http.send<List<dynamic>>(
      '/drive/files/attached-notes',
      body: body,
      options: const RequestOptions(idempotent: true),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyNote.fromJson)
        .toList();
  }
}
