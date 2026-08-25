import '../../../../core/error/app_failure.dart';
import '../../domain/entities/device.dart';
import '../../domain/repositories/device_repository.dart';
import '../datasources/device_data_source.dart';

final class DeviceRepositoryImpl implements DeviceRepository {
  DeviceRepositoryImpl(this._dataSource);
  final DeviceDataSource _dataSource;
  List<Device>? _memoryCache;

  @override
  Future<List<Device>> getDevices() async =>
      _memoryCache ??= await _dataSource.getDevices();
  @override
  Future<Device> getDevice(String id) async {
    final cached = _memoryCache?.where((device) => device.id == id).firstOrNull;
    return cached ?? await _dataSource.getDevice(id);
  }

  @override
  Future<Device> createDevice({
    required String name,
    required DeviceType type,
    required String room,
  }) async {
    try {
      final device = await _dataSource.createDevice(
        name: name,
        type: type,
        room: room,
      );
      _memoryCache = [...await getDevices(), device];
      return device;
    } catch (error) {
      throw _map(error);
    }
  }

  @override
  Future<Device> updateDevice({
    required String id,
    required String name,
    required DeviceType type,
    required String room,
  }) async {
    try {
      final device = await _dataSource.updateDevice(
        id: id,
        name: name,
        type: type,
        room: room,
      );
      _memoryCache = _memoryCache
          ?.map((item) => item.id == id ? device : item)
          .toList();
      return device;
    } catch (error) {
      throw _map(error);
    }
  }

  @override
  Future<void> deleteDevice(String id) async {
    try {
      await _dataSource.deleteDevice(id);
      _memoryCache = _memoryCache?.where((item) => item.id != id).toList();
    } catch (error) {
      throw _map(error);
    }
  }

  AppFailure _map(Object error) =>
      error is AppFailure ? error : UnexpectedFailure(error.toString());
}
