import 'package:json_annotation/json_annotation.dart';

import '../misskey_user.dart';

part 'misskey_birthday_user.g.dart';

/// 誕生日ユーザー情報（`/api/users/get-following-users-by-birthday` のレスポンス要素）
@JsonSerializable()
class MisskeyBirthdayUser {
  const MisskeyBirthdayUser({
    required this.id,
    required this.birthday,
    this.user,
  });

  factory MisskeyBirthdayUser.fromJson(Map<String, dynamic> json) =>
      _$MisskeyBirthdayUserFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeyBirthdayUserToJson(this);

  /// ユーザーID
  final String id;

  /// 誕生日（YYYY-MM-DD形式）
  final String birthday;

  /// ユーザー情報
  final MisskeyUser? user;
}
