import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../core/error/app_failure.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../../domain/entities/device.dart';
import '../controllers/devices_controller.dart';
import '../widgets/device_status_indicator.dart';

class DeviceDetailsPage extends ConsumerWidget {
  const DeviceDetailsPage({required this.deviceId, super.key});

  final String deviceId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final devicesState = ref.watch(devicesControllerProvider);

    return devicesState.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, _) => Scaffold(
        appBar: AppBar(),
        body: ErrorState(
          message: userFacingErrorMessage(
            error,
            fallback: 'Could not load device details. Please try again.',
          ),
          onRetry: () => ref.read(devicesControllerProvider.notifier).refresh(),
        ),
      ),
      data: (devices) {
        final device = devices.where((item) => item.id == deviceId).firstOrNull;

        if (device == null) {
          return Scaffold(
            appBar: AppBar(),
            body: ErrorState(
              message: 'This device is no longer available.',
              onRetry: () => context.pop(),
            ),
          );
        }

        return _DeviceDetailsView(device: device);
      },
    );
  }
}

class _DeviceDetailsView extends StatelessWidget {
  const _DeviceDetailsView({required this.device});

  final Device device;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Device details'),
      actions: [
        IconButton(
          onPressed: () => context.push('/devices/${device.id}/edit'),
          icon: const Icon(Icons.edit_outlined),
          tooltip: 'Edit device',
        ),
      ],
    ),
    body: ResponsiveContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(device.name, style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: AppSpacing.sm),
          Text(
            device.type.label,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.xxl),
          AppCard(
            child: Column(
              children: [
                _row(context, Icons.room_outlined, 'Room', device.room),
                _row(
                  context,
                  Icons.power_outlined,
                  'Current power',
                  '${device.currentPower.toStringAsFixed(2)} kW',
                ),
                _row(
                  context,
                  Icons.circle_outlined,
                  'Status',
                  null,
                  trailing: DeviceStatusIndicator(isOnline: device.isOnline),
                ),
                _row(
                  context,
                  Icons.schedule_outlined,
                  'Last updated',
                  _formatDate(device.updatedAt),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );

  Widget _row(
    BuildContext context,
    IconData icon,
    String label,
    String? value, {
    Widget? trailing,
  }) => Padding(
    padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
    child: Row(
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: AppSpacing.lg),
        Expanded(child: Text(label)),
        trailing ?? Text(value ?? ''),
      ],
    ),
  );

  String _formatDate(DateTime date) => '${date.day}/${date.month}/${date.year}';
}
