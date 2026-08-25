// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'misskey_email_address_availability.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MisskeyEmailAddressAvailability _$MisskeyEmailAddressAvailabilityFromJson(
  Map<String, dynamic> json,
) => MisskeyEmailAddressAvailability(
  available: json['available'] as bool,
  reason: json['reason'] as String?,
);

Map<String, dynamic> _$MisskeyEmailAddressAvailabilityToJson(
  MisskeyEmailAddressAvailability instance,
) => <String, dynamic>{
  'available': instance.available,
  'reason': instance.reason,
};
