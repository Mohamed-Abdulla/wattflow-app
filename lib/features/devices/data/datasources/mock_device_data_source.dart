import '../../../../core/error/app_failure.dart';
import '../../domain/entities/device.dart';
import 'device_data_source.dart';

final class MockDeviceDataSource implements DeviceDataSource {
  MockDeviceDataSource() : _devices = _seed();
  final List<Device> _devices;

  @override
  Future<List<Device>> getDevices() async => List.unmodifiable(_devices);

  @override
  Future<Device> getDevice(String id) async => _find(id);

  @override
  Future<Device> createDevice({
    required String name,
    required DeviceType type,
    required String room,
  }) async {
    final now = DateTime.now();
    final device = Device(
      id: 'device-${now.microsecondsSinceEpoch}',
      name: name,
      type: type,
      room: room,
      isOnline: true,
      currentPower: 0,
      createdAt: now,
      updatedAt: now,
    );
    _devices.add(device);
    return device;
  }

  @override
  Future<Device> updateDevice({
    required String id,
    required String name,
    required DeviceType type,
    required String room,
  }) async {
    final current = _find(id);
    final updated = current.copyWith(
      name: name,
      type: type,
      room: room,
      updatedAt: DateTime.now(),
    );
    _devices[_devices.indexOf(current)] = updated;
    return updated;
  }

  @override
  Future<void> deleteDevice(String id) async => _devices.remove(_find(id));

  Device _find(String id) =>
      _devices.where((device) => device.id == id).firstOrNull ??
      (throw const NotFoundFailure());

  static List<Device> _seed() {
    final now = DateTime.now();
    return [
      Device(
        id: 'ac-living-room',
        name: 'Living Room AC',
        type: DeviceType.airConditioner,
        room: 'Living Room',
        isOnline: true,
        currentPower: 1.24,
        createdAt: now.subtract(const Duration(days: 30)),
        updatedAt: now,
      ),
      Device(
        id: 'fridge-kitchen',
        name: 'Kitchen Refrigerator',
        type: DeviceType.refrigerator,
        room: 'Kitchen',
        isOnline: true,
        currentPower: 0.18,
        createdAt: now.subtract(const Duration(days: 24)),
        updatedAt: now,
      ),
      Device(
        id: 'plug-office',
        name: 'Desk Smart Plug',
        type: DeviceType.smartPlug,
        room: 'Office',
        isOnline: false,
        currentPower: 0,
        createdAt: now.subtract(const Duration(days: 12)),
        updatedAt: now,
      ),
    ];
  }
}
