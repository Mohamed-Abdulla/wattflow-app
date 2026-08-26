import 'package:flutter/material.dart';

import '../../../../app/theme/app_sizes.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../domain/entities/device.dart';
import 'device_status_indicator.dart';

class DeviceCard extends StatelessWidget {
  const DeviceCard({
    required this.device,
    required this.onEdit,
    required this.onDelete,
    required this.onTap,
    super.key,
  });
  final Device device;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Card(
    child: InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(child: Icon(_icon(device.type))),
                const SizedBox(width: AppSpacing.xl),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        device.name,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        device.type.label,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  tooltip: 'Device actions',
                  onSelected: (value) {
                    if (value == 'edit') onEdit();
                    if (value == 'delete') onDelete();
                  },
                  itemBuilder: (_) => const [
                    PopupMenuItem(value: 'edit', child: Text('Edit')),
                    PopupMenuItem(value: 'delete', child: Text('Delete')),
                  ],
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xxl),
            Row(
              children: [
                Expanded(
                  child: DeviceStatusIndicator(isOnline: device.isOnline),
                ),
                Text(
                  '${device.currentPower.toStringAsFixed(2)} kW',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Icon(
                  Icons.room_outlined,
                  size: AppSizes.iconSm,
                  color: Theme.of(context).colorScheme.outline,
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(device.room),
              ],
            ),
          ],
        ),
      ),
    ),
  );
  IconData _icon(DeviceType type) => switch (type) {
    DeviceType.airConditioner => Icons.ac_unit,
    DeviceType.refrigerator => Icons.kitchen_outlined,
    DeviceType.washingMachine => Icons.local_laundry_service_outlined,
    DeviceType.waterHeater => Icons.water_drop_outlined,
    DeviceType.smartPlug => Icons.power_outlined,
  };
}
