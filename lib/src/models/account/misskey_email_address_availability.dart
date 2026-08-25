import 'package:freezed_annotation/freezed_annotation.dart';

part 'misskey_email_address_availability.freezed.dart';
part 'misskey_email_address_availability.g.dart';

/// Registration availability returned by `/api/email-address/available`.
@freezed
@JsonSerializable()
class MisskeyEmailAddressAvailability with _$MisskeyEmailAddressAvailability {
  const MisskeyEmailAddressAvailability({
    required this.available,
    required this.reason,
  });

  factory MisskeyEmailAddressAvailability.fromJson(Map<String, dynamic> json) =>
      _$MisskeyEmailAddressAvailabilityFromJson(json);

  Map<String, dynamic> toJson() =>
      _$MisskeyEmailAddressAvailabilityToJson(this);

  /// Whether the email address can be registered.
  @override
  final bool available;

  /// The server-defined reason for unavailability, or `null` when available.
  ///
  /// Known upstream values are `used`, `format`, `disposable`, `mx`, `smtp`,
  /// `banned`, `network`, and `blacklist`. Unknown fork-specific values are
  /// preserved as-is.
  @override
  final String? reason;
}
