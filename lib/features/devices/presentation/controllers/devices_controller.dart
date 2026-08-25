import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/device.dart';
import '../../domain/repositories/device_repository.dart';
import '../../providers/device_providers.dart';

part 'devices_controller.g.dart';

@Riverpod(keepAlive: true)
class DevicesController extends _$DevicesController {
  DeviceRepository get _repository => ref.read(deviceRepositoryProvider);

  @override
  Future<List<Device>> build() => _repository.getDevices();

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_repository.getDevices);
  }

  Future<void> add({
    required String name,
    required DeviceType type,
    required String room,
  }) async {
    await _runMutation(
      () => _repository.createDevice(name: name, type: type, room: room),
    );
  }

  Future<void> updateDevice({
    required String id,
    required String name,
    required DeviceType type,
    required String room,
  }) async {
    await _runMutation(
      () =>
          _repository.updateDevice(id: id, name: name, type: type, room: room),
    );
  }

  Future<void> delete(String id) async {
    await _runMutation(() => _repository.deleteDevice(id));
  }

  Future<void> _runMutation(Future<Object?> Function() mutation) async {
    final previous = state is AsyncData<List<Device>>
        ? (state as AsyncData<List<Device>>).value
        : null;
    state = const AsyncLoading<List<Device>>();
    try {
      await mutation();
      state = AsyncData(await _repository.getDevices());
    } catch (error, stackTrace) {
      state = AsyncError<List<Device>>(error, stackTrace);
      if (previous != null) {
        state = AsyncError<List<Device>>(error, stackTrace);
      }
    }
  }
}
