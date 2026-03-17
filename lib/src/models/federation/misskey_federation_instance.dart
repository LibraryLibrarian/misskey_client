import 'package:json_annotation/json_annotation.dart';

part 'misskey_federation_instance.g.dart';

/// 連合インスタンス情報（`/api/federation/instances` 等のレスポンス）
@JsonSerializable()
class MisskeyFederationInstance {
  const MisskeyFederationInstance({
    required this.id,
    required this.firstRetrievedAt,
    required this.host,
    this.usersCount,
    this.notesCount,
    this.followingCount,
    this.followersCount,
    this.isNotResponding,
    this.isSuspended,
    this.isBlocked,
    this.isSilenced,
    this.softwareName,
    this.softwareVersion,
    this.openRegistrations,
    this.name,
    this.description,
    this.maintainerName,
    this.maintainerEmail,
    this.iconUrl,
    this.faviconUrl,
    this.themeColor,
    this.infoUpdatedAt,
    this.latestRequestReceivedAt,
  });

  factory MisskeyFederationInstance.fromJson(Map<String, dynamic> json) =>
      _$MisskeyFederationInstanceFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeyFederationInstanceToJson(this);

  final String id;

  /// 初回取得日時
  final DateTime firstRetrievedAt;

  /// ホスト名
  final String host;

  /// ユーザー数
  final int? usersCount;

  /// ノート数
  final int? notesCount;

  /// フォロー中の数
  final int? followingCount;

  /// フォロワー数
  final int? followersCount;

  /// 応答なし状態か
  final bool? isNotResponding;

  /// 停止中か
  final bool? isSuspended;

  /// ブロック中か
  final bool? isBlocked;

  /// サイレンス中か
  final bool? isSilenced;

  /// ソフトウェア名（例: `misskey`, `mastodon`）
  final String? softwareName;

  /// ソフトウェアバージョン
  final String? softwareVersion;

  /// ユーザー登録が開放されているか
  final bool? openRegistrations;

  /// インスタンス名
  final String? name;

  /// インスタンスの説明
  final String? description;

  /// 管理者名
  final String? maintainerName;

  /// 管理者メールアドレス
  final String? maintainerEmail;

  /// アイコンURL
  final String? iconUrl;

  /// ファビコンURL
  final String? faviconUrl;

  /// テーマカラー
  final String? themeColor;

  /// 情報最終更新日時
  final DateTime? infoUpdatedAt;

  /// 最終リクエスト受信日時
  final DateTime? latestRequestReceivedAt;
}
