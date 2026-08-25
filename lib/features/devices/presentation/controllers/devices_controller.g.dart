// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'devices_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(DevicesController)
final devicesControllerProvider = DevicesControllerProvider._();

final class DevicesControllerProvider
    extends $AsyncNotifierProvider<DevicesController, List<Device>> {
  DevicesControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'devicesControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$devicesControllerHash();

  @$internal
  @override
  DevicesController create() => DevicesController();
}

String _$devicesControllerHash() => r'4f52acdda0cf119c4d9f51e668d7e4793da9257e';

abstract class _$DevicesController extends $AsyncNotifier<List<Device>> {
  FutureOr<List<Device>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Device>>, List<Device>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Device>>, List<Device>>,
              AsyncValue<List<Device>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
