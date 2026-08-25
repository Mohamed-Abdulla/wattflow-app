import 'package:freezed_annotation/freezed_annotation.dart';

part 'device.freezed.dart';
part 'device.g.dart';

enum DeviceType {
  airConditioner,
  refrigerator,
  washingMachine,
  waterHeater,
  smartPlug,
}

extension DeviceTypeLabel on DeviceType {
  String get label => switch (this) {
    DeviceType.airConditioner => 'Air Conditioner',
    DeviceType.refrigerator => 'Refrigerator',
    DeviceType.washingMachine => 'Washing Machine',
    DeviceType.waterHeater => 'Water Heater',
    DeviceType.smartPlug => 'Smart Plug',
  };
}

@freezed
abstract class Device with _$Device {
  const factory Device({
    required String id,
    required String name,
    required DeviceType type,
    required String room,
    required bool isOnline,
    required double currentPower,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Device;
  const Device._();
  factory Device.fromJson(Map<String, dynamic> json) => _$DeviceFromJson(json);
}
