import '../client/auth_mode.dart';
import '../client/misskey_http.dart';
import '../client/request_options.dart';
import '../models/meta.dart';

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
  Future<Meta> getMeta({bool refresh = false}) async {
    if (!refresh && _cached != null) return _cached!;
    final res = await http.send<Map<String, dynamic>>(
      '/meta',
      body: const <String, dynamic>{},
      options: const RequestOptions(
        authMode: AuthMode.none,
        idempotent: true,
      ),
    );
    _cached = Meta.fromJson(res);
    return _cached!;
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
