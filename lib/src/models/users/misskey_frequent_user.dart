import 'package:json_annotation/json_annotation.dart';

import '../misskey_user.dart';

part 'misskey_frequent_user.g.dart';

/// よくリプライするユーザー（`/api/users/get-frequently-replied-users` のレスポンス要素）
@JsonSerializable(createToJson: false)
class MisskeyFrequentUser {
  const MisskeyFrequentUser({
    required this.user,
    required this.weight,
  });

  factory MisskeyFrequentUser.fromJson(Map<String, dynamic> json) =>
      _$MisskeyFrequentUserFromJson(json);

  /// ユーザー情報
  final MisskeyUser user;

  /// リプライ頻度の重み（0.0〜1.0）
  final double weight;
}
