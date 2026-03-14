import 'package:json_annotation/json_annotation.dart';

import 'json_converters.dart';

part 'misskey_signin_history.g.dart';

/// サインイン履歴
@JsonSerializable(createToJson: false)
class MisskeySigninHistory {
  const MisskeySigninHistory({
    required this.id,
    required this.createdAt,
    this.ip,
    this.headers,
    this.success,
  });

  factory MisskeySigninHistory.fromJson(Map<String, dynamic> json) =>
      _$MisskeySigninHistoryFromJson(json);

  final String id;

  @SafeDateTimeConverter()
  final DateTime createdAt;

  /// 接続元IPアドレス
  final String? ip;

  /// リクエストヘッダ
  final Map<String, dynamic>? headers;

  /// サインイン成功フラグ
  final bool? success;
}
