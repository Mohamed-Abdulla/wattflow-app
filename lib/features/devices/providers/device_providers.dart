import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/logging/app_logger.dart';
import '../data/datasources/device_data_source.dart';
import '../data/datasources/mock_device_data_source.dart';
import '../data/repositories/device_repository_impl.dart';
import '../domain/repositories/device_repository.dart';

part 'device_providers.g.dart';

@riverpod
AppLogger appLogger(Ref ref) => const DevelopmentLogger();

@riverpod
DeviceDataSource deviceDataSource(Ref ref) => MockDeviceDataSource();

@riverpod
DeviceRepository deviceRepository(Ref ref) =>
    DeviceRepositoryImpl(ref.watch(deviceDataSourceProvider));
