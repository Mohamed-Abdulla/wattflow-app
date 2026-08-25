import 'package:flutter/material.dart';

class DeviceStatusIndicator extends StatelessWidget {
  const DeviceStatusIndicator({required this.isOnline, super.key});
  final bool isOnline;
  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: 9,
        height: 9,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isOnline
              ? Colors.green
              : Theme.of(context).colorScheme.outline,
        ),
      ),
      const SizedBox(width: 8),
      Text(
        isOnline ? 'Online' : 'Offline',
        style: TextStyle(
          color: isOnline ? Colors.green.shade700 : null,
          fontWeight: FontWeight.w600,
        ),
      ),
    ],
  );
}
