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
    final previousState = state;
    try {
      await mutation();
      state = AsyncData(await _repository.getDevices());
    } catch (error, stackTrace) {
      // Mutations do not replace the visible list with an error screen. The
      // caller can show the error while the last successful data stays visible.
      state = previousState;
      Error.throwWithStackTrace(error, stackTrace);
    }
  }
}
