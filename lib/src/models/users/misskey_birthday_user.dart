import 'package:json_annotation/json_annotation.dart';

import '../misskey_user.dart';

part 'misskey_birthday_user.g.dart';

/// A birthday user entry from `/api/users/get-following-users-by-birthday`.
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

  /// The user ID.
  final String id;

  /// The birthday in `YYYY-MM-DD` format.
  final String birthday;

  /// The user information.
  final MisskeyUser? user;
}
