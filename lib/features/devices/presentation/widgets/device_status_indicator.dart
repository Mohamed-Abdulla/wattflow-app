import 'package:flutter/material.dart';

import '../../../../app/theme/app_sizes.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/wattflow_colors.dart';

class DeviceStatusIndicator extends StatelessWidget {
  const DeviceStatusIndicator({required this.isOnline, super.key});
  final bool isOnline;
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<WattFlowColors>()!;
    final statusColor = isOnline ? colors.online : colors.offline;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: AppSizes.statusDot,
          height: AppSizes.statusDot,
          decoration: BoxDecoration(shape: BoxShape.circle, color: statusColor),
        ),
        const SizedBox(width: AppSpacing.sm),
        Text(
          isOnline ? 'Online' : 'Offline',
          style: TextStyle(color: statusColor, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
