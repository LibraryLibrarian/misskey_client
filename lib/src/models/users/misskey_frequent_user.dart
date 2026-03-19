import 'package:json_annotation/json_annotation.dart';

import '../misskey_user.dart';

part 'misskey_frequent_user.g.dart';

/// A frequently replied-to user from `/api/users/get-frequently-replied-users`.
@JsonSerializable()
class MisskeyFrequentUser {
  const MisskeyFrequentUser({
    required this.user,
    required this.weight,
  });

  factory MisskeyFrequentUser.fromJson(Map<String, dynamic> json) =>
      _$MisskeyFrequentUserFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeyFrequentUserToJson(this);

  /// The user information.
  final MisskeyUser user;

  /// The reply frequency weight (0.0 to 1.0).
  final double weight;
}
