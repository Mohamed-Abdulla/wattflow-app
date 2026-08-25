// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Device _$DeviceFromJson(Map<String, dynamic> json) => _Device(
  id: json['id'] as String,
  name: json['name'] as String,
  type: $enumDecode(_$DeviceTypeEnumMap, json['type']),
  room: json['room'] as String,
  isOnline: json['isOnline'] as bool,
  currentPower: (json['currentPower'] as num).toDouble(),
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$DeviceToJson(_Device instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'type': _$DeviceTypeEnumMap[instance.type]!,
  'room': instance.room,
  'isOnline': instance.isOnline,
  'currentPower': instance.currentPower,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
};

const _$DeviceTypeEnumMap = {
  DeviceType.airConditioner: 'airConditioner',
  DeviceType.refrigerator: 'refrigerator',
  DeviceType.washingMachine: 'washingMachine',
  DeviceType.waterHeater: 'waterHeater',
  DeviceType.smartPlug: 'smartPlug',
};
