/// Misskey `/api/meta` レスポンスの最小モデル
///
/// 型付きフィールドとして [version]・[name] を提供しつつ、
/// 未知フィールドを含む全JSONを [raw] に保持する。
/// これにより将来のサーバー拡張にも対応でき、
/// `MetaApi.supports` による能力検出にも活用できる。
class Meta {
  /// 各フィールドを直接指定して [Meta] を生成する。
  const Meta({this.version, this.name, required this.raw});

  /// JSON マップから [Meta] を生成する
  ///
  /// [json] から [version]・[name] を抽出し、
  /// 元の JSON 全体を [raw] に保持する。
  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      version: json['version'] as String?,
      name: json['name'] as String?,
      raw: Map<String, dynamic>.from(json),
    );
  }

  /// サーバーバージョン（例: `"2024.12.0"`）
  final String? version;

  /// サーバー名（例: `"misskey.example"`）
  final String? name;

  /// レスポンス JSON の全フィールドを保持するマップ
  final Map<String, dynamic> raw;

  /// このインスタンスを JSON マップに変換する
  Map<String, dynamic> toJson() => <String, dynamic>{
        'version': version,
        'name': name,
        'raw': raw,
      };
}
