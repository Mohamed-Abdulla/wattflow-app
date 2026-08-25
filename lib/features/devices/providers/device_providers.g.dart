// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(appLogger)
final appLoggerProvider = AppLoggerProvider._();

final class AppLoggerProvider
    extends $FunctionalProvider<AppLogger, AppLogger, AppLogger>
    with $Provider<AppLogger> {
  AppLoggerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appLoggerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appLoggerHash();

  @$internal
  @override
  $ProviderElement<AppLogger> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AppLogger create(Ref ref) {
    return appLogger(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppLogger value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppLogger>(value),
    );
  }
}

String _$appLoggerHash() => r'4e6d7792ddbc89c5d9e4c4140a9dd35f00379c39';

@ProviderFor(deviceDataSource)
final deviceDataSourceProvider = DeviceDataSourceProvider._();

final class DeviceDataSourceProvider
    extends
        $FunctionalProvider<
          DeviceDataSource,
          DeviceDataSource,
          DeviceDataSource
        >
    with $Provider<DeviceDataSource> {
  DeviceDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deviceDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deviceDataSourceHash();

  @$internal
  @override
  $ProviderElement<DeviceDataSource> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DeviceDataSource create(Ref ref) {
    return deviceDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DeviceDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DeviceDataSource>(value),
    );
  }
}

String _$deviceDataSourceHash() => r'c4a4dc51416fd3e40d77470553e22c40eb6f5525';

@ProviderFor(deviceRepository)
final deviceRepositoryProvider = DeviceRepositoryProvider._();

final class DeviceRepositoryProvider
    extends
        $FunctionalProvider<
          DeviceRepository,
          DeviceRepository,
          DeviceRepository
        >
    with $Provider<DeviceRepository> {
  DeviceRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deviceRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deviceRepositoryHash();

  @$internal
  @override
  $ProviderElement<DeviceRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DeviceRepository create(Ref ref) {
    return deviceRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DeviceRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DeviceRepository>(value),
    );
  }
}

String _$deviceRepositoryHash() => r'a71114cb021bc01a3d57a988958020a47ba7d96a';
