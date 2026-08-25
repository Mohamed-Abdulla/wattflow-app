import '../../domain/entities/device.dart';

abstract interface class DeviceDataSource {
  Future<List<Device>> getDevices();
  Future<Device> getDevice(String id);
  Future<Device> createDevice({
    required String name,
    required DeviceType type,
    required String room,
  });
  Future<Device> updateDevice({
    required String id,
    required String name,
    required DeviceType type,
    required String room,
  });
  Future<void> deleteDevice(String id);
}
