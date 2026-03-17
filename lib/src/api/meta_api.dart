import '../client/auth_mode.dart';
import '../client/misskey_http.dart';
import '../client/request_options.dart';
import '../models/meta.dart';
import '../models/misskey_custom_emoji.dart';
import '../models/misskey_user.dart';
import '../models/server/avatar_decoration.dart';
import '../models/server/emoji_detailed.dart';
import '../models/server/endpoint_info.dart';
import '../models/server/instance_stats.dart';
import '../models/server/retention_record.dart';
import '../models/server/server_info.dart';

/// サーバーメタ情報API（`/api/meta`）
///
/// 取得結果をインメモリでキャッシュし、2回目以降の呼び出しでは
/// ネットワークリクエストを省略する。
/// [supports] でサーバーの能力をドット記法キーパスで検出できる。
class MetaApi {
  /// [http] を使用してメタ情報APIを操作するインスタンスを生成する。
  MetaApi({required this.http});

  /// HTTP クライアント
  final MisskeyHttp http;

  Meta? _cached;

  /// サーバーのメタ情報を取得する（`/api/meta`）
  ///
  /// [refresh] を `true` にするとキャッシュを無視して
  /// 常に最新の情報をサーバーから取得する。
  /// デフォルトでは一度取得した結果をキャッシュし、
  /// 2回目以降はキャッシュを返す。
  ///
  /// [detail] を `false` にすると軽量な `MetaLite` 相当の
  /// レスポンスを取得する（デフォルト: `true`）。
  Future<Meta> getMeta({bool refresh = false, bool? detail}) async {
    if (!refresh && detail != false && _cached != null) return _cached!;
    final res = await http.send<Map<String, dynamic>>(
      '/meta',
      body: <String, dynamic>{
        if (detail != null) 'detail': detail,
      },
      options: const RequestOptions(
        authMode: AuthMode.none,
        idempotent: true,
      ),
    );
    final meta = Meta.fromJson(res);
    if (detail != false) _cached = meta;
    return meta;
  }

  /// サーバーのマシン情報を取得する（`/api/server-info`）
  ///
  /// CPU・メモリ・ディスクなどのサーバー技術情報を返す。
  /// サーバー側で `enableServerMachineStats` が無効の場合は
  /// プレースホルダー値が返却される。
  Future<ServerInfo> getServerInfo() async {
    final res = await http.send<Map<String, dynamic>>(
      '/server-info',
      body: const <String, dynamic>{},
      options: const RequestOptions(
        authMode: AuthMode.none,
        idempotent: true,
      ),
    );
    return ServerInfo.fromJson(res);
  }

  /// インスタンスの統計情報を取得する（`/api/stats`）
  ///
  /// ユーザー数・ノート数・連合インスタンス数・ドライブ使用量等を返す。
  Future<InstanceStats> getStats() async {
    final res = await http.send<Map<String, dynamic>>(
      '/stats',
      body: const <String, dynamic>{},
      options: const RequestOptions(
        authMode: AuthMode.none,
        idempotent: true,
      ),
    );
    return InstanceStats.fromJson(res);
  }

  /// サーバーの疎通確認を行う（`/api/ping`）
  ///
  /// 成功時はサーバーの現在時刻（Unixタイムスタンプ ms）を返す。
  Future<int> ping() async {
    final res = await http.send<Map<String, dynamic>>(
      '/ping',
      body: const <String, dynamic>{},
      options: const RequestOptions(
        authMode: AuthMode.none,
        idempotent: true,
      ),
    );
    return (res['pong'] as num).toInt();
  }

  /// 利用可能な全エンドポイント名を取得する（`/api/endpoints`）
  Future<List<String>> getEndpoints() async {
    final res = await http.send<List<dynamic>>(
      '/endpoints',
      body: const <String, dynamic>{},
      options: const RequestOptions(
        authMode: AuthMode.none,
        idempotent: true,
      ),
    );
    return res.cast<String>();
  }

  /// 指定エンドポイントのパラメーター情報を取得する（`/api/endpoint`）
  ///
  /// [endpoint] に対象エンドポイント名を指定する。
  /// エンドポイントが存在しない場合は `null` を返す。
  Future<EndpointInfo?> getEndpoint({required String endpoint}) async {
    final res = await http.send<Map<String, dynamic>?>(
      '/endpoint',
      body: <String, dynamic>{'endpoint': endpoint},
      options: const RequestOptions(
        authMode: AuthMode.none,
        idempotent: true,
      ),
    );
    if (res == null) return null;
    return EndpointInfo.fromJson(res);
  }

  /// ローカルカスタム絵文字の一覧を取得する（`/api/emojis`）
  ///
  /// カテゴリ・名前順でソートされたローカル絵文字を返す。
  Future<List<MisskeyCustomEmoji>> getEmojis() async {
    final res = await http.send<Map<String, dynamic>>(
      '/emojis',
      body: const <String, dynamic>{},
      options: const RequestOptions(
        authMode: AuthMode.none,
        idempotent: true,
      ),
    );
    final list = res['emojis'] as List<dynamic>;
    return list
        .map((e) => MisskeyCustomEmoji.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// 指定名のカスタム絵文字の詳細情報を取得する（`/api/emoji`）
  ///
  /// [name] に絵文字のショートコードを指定する。
  Future<EmojiDetailed> getEmoji({required String name}) async {
    final res = await http.send<Map<String, dynamic>>(
      '/emoji',
      body: <String, dynamic>{'name': name},
      options: const RequestOptions(
        authMode: AuthMode.none,
        idempotent: true,
      ),
    );
    return EmojiDetailed.fromJson(res);
  }

  /// 管理者が設定したピン留めユーザー一覧を取得する（`/api/pinned-users`）
  ///
  /// 認証不要。
  Future<List<MisskeyUser>> getPinnedUsers() async {
    final res = await http.send<List<dynamic>>(
      '/pinned-users',
      body: const <String, dynamic>{},
      options: const RequestOptions(
        authMode: AuthMode.none,
        idempotent: true,
      ),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyUser.fromJson)
        .toList();
  }

  /// オンラインユーザー数を取得する（`/api/get-online-users-count`）
  ///
  /// 認証不要。レスポンスは60秒キャッシュされる。
  Future<int> getOnlineUsersCount() async {
    final res = await http.send<Map<String, dynamic>>(
      '/get-online-users-count',
      body: const <String, dynamic>{},
      options: const RequestOptions(
        authMode: AuthMode.none,
        idempotent: true,
      ),
    );
    return (res['count'] as num).toInt();
  }

  /// 利用可能なアバターデコレーション一覧を取得する
  /// （`/api/get-avatar-decorations`）
  ///
  /// 認証不要。
  Future<List<AvatarDecoration>> getAvatarDecorations() async {
    final res = await http.send<List<dynamic>>(
      '/get-avatar-decorations',
      body: const <String, dynamic>{},
      options: const RequestOptions(
        authMode: AuthMode.none,
        idempotent: true,
      ),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(AvatarDecoration.fromJson)
        .toList();
  }

  /// ユーザーリテンション（定着率）統計を取得する（`/api/retention`）
  ///
  /// 認証不要。レスポンスは3600秒キャッシュされる。
  /// 直近30件の日次リテンションデータを返す。
  Future<List<RetentionRecord>> getRetention() async {
    final res = await http.send<List<dynamic>>(
      '/retention',
      body: const <String, dynamic>{},
      options: const RequestOptions(
        authMode: AuthMode.none,
        idempotent: true,
      ),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(RetentionRecord.fromJson)
        .toList();
  }

  /// キャッシュ済みメタ情報に対する簡易な能力検出
  ///
  /// [keyPath] にドット区切りのキーパス（例: `"features.miauth"`）を
  /// 指定し、そのキーが [Meta.raw] 内に存在すれば `true` を返す。
  /// [getMeta] を一度も呼んでいない場合は常に `false` を返す。
  bool supports(String keyPath) {
    final meta = _cached;
    if (meta == null) return false;
    final parts = keyPath.split('.');
    dynamic cursor = meta.raw;
    for (final p in parts) {
      if (cursor is Map && cursor.containsKey(p)) {
        cursor = cursor[p];
      } else {
        return false;
      }
    }
    return true;
  }
}
