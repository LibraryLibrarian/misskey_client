import 'package:freezed_annotation/freezed_annotation.dart';

import '../misskey_user.dart';

part 'misskey_frequent_user.freezed.dart';
part 'misskey_frequent_user.g.dart';

/// A frequently replied-to user from `/api/users/get-frequently-replied-users`.
@freezed
@JsonSerializable()
class MisskeyFrequentUser with _$MisskeyFrequentUser {
  const MisskeyFrequentUser({required this.user, required this.weight});

  factory MisskeyFrequentUser.fromJson(Map<String, dynamic> json) =>
      _$MisskeyFrequentUserFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeyFrequentUserToJson(this);

  /// The user information.
  @override
  final MisskeyUser user;

  /// The reply frequency weight (0.0 to 1.0).
  @override
  final double weight;
}
