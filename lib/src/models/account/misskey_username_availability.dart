import 'package:freezed_annotation/freezed_annotation.dart';

part 'misskey_username_availability.freezed.dart';
part 'misskey_username_availability.g.dart';

/// Registration availability returned by `/api/username/available`.
@freezed
@JsonSerializable()
class MisskeyUsernameAvailability with _$MisskeyUsernameAvailability {
  const MisskeyUsernameAvailability({required this.available});

  factory MisskeyUsernameAvailability.fromJson(Map<String, dynamic> json) =>
      _$MisskeyUsernameAvailabilityFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeyUsernameAvailabilityToJson(this);

  /// Whether the username can be registered.
  @override
  final bool available;
}
