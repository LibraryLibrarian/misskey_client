// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'misskey_relay.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MisskeyRelay _$MisskeyRelayFromJson(Map<String, dynamic> json) => MisskeyRelay(
  id: json['id'] as String,
  inbox: json['inbox'] as String,
  status: $enumDecode(
    _$MisskeyRelayStatusEnumMap,
    json['status'],
    unknownValue: MisskeyRelayStatus.requesting,
  ),
);

Map<String, dynamic> _$MisskeyRelayToJson(MisskeyRelay instance) =>
    <String, dynamic>{
      'id': instance.id,
      'inbox': instance.inbox,
      'status': _$MisskeyRelayStatusEnumMap[instance.status]!,
    };

const _$MisskeyRelayStatusEnumMap = {
  MisskeyRelayStatus.requesting: 'requesting',
  MisskeyRelayStatus.accepted: 'accepted',
  MisskeyRelayStatus.rejected: 'rejected',
};
