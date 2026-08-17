import 'package:freezed_annotation/freezed_annotation.dart';

import '../misskey_user.dart';

part 'misskey_birthday_user.freezed.dart';
part 'misskey_birthday_user.g.dart';

/// A birthday user entry from `/api/users/get-following-users-by-birthday`.
@freezed
@JsonSerializable()
class MisskeyBirthdayUser with _$MisskeyBirthdayUser {
  const MisskeyBirthdayUser({
    required this.id,
    required this.birthday,
    this.user,
  });

  factory MisskeyBirthdayUser.fromJson(Map<String, dynamic> json) =>
      _$MisskeyBirthdayUserFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeyBirthdayUserToJson(this);

  /// The user ID.
  @override
  final String id;

  /// The birthday in `YYYY-MM-DD` format.
  @override
  final String birthday;

  /// The user information.
  @override
  final MisskeyUser? user;
}
