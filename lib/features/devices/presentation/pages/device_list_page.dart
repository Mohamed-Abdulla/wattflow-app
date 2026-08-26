import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_breakpoints.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/error/app_failure.dart';
import '../../../../core/widgets/app_feedback.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../../domain/entities/device.dart';
import '../controllers/devices_controller.dart';
import '../widgets/device_card.dart';

class DeviceListPage extends ConsumerStatefulWidget {
  const DeviceListPage({super.key});
  @override
  ConsumerState<DeviceListPage> createState() => _DeviceListPageState();
}

class _DeviceListPageState extends ConsumerState<DeviceListPage> {
  final _searchController = TextEditingController();
  String _filter = 'all';
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final devices = ref.watch(devicesControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Devices'),
        actions: [
          IconButton(
            onPressed: () =>
                ref.read(devicesControllerProvider.notifier).refresh(),
            tooltip: 'Refresh devices',
            icon: const Icon(Icons.refresh),
          ),
          const SizedBox(width: AppSpacing.sm),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/devices/new'),
        icon: const Icon(Icons.add),
        label: const Text('Add device'),
      ),
      body: ResponsiveContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Manage your energy devices',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Monitor status and keep device details up to date.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: AppSpacing.xxl),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (_) => setState(() {}),
                    decoration: const InputDecoration(
                      labelText: 'Search devices',
                      prefixIcon: Icon(Icons.search),
                      suffixIcon: Tooltip(
                        message: 'Search by name, type, or room',
                        child: Icon(Icons.info_outline),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                DropdownButton<String>(
                  value: _filter,
                  items: const [
                    DropdownMenuItem(value: 'all', child: Text('All devices')),
                    DropdownMenuItem(value: 'online', child: Text('Online')),
                    DropdownMenuItem(value: 'offline', child: Text('Offline')),
                  ],
                  onChanged: (value) =>
                      setState(() => _filter = value ?? 'all'),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xxl),
            Expanded(
              child: devices.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => ErrorState(
                  message: userFacingErrorMessage(error),
                  onRetry: () =>
                      ref.read(devicesControllerProvider.notifier).refresh(),
                ),
                data: (items) {
                  final filtered = items.where(_matches).toList();
                  if (items.isEmpty) {
                    return EmptyState(
                      title: 'No devices yet',
                      message:
                          'Add your first device to start monitoring energy.',
                      action: FilledButton.icon(
                        onPressed: () => context.push('/devices/new'),
                        icon: const Icon(Icons.add),
                        label: const Text('Add device'),
                      ),
                    );
                  }
                  if (filtered.isEmpty) {
                    return const EmptyState(
                      title: 'No matching devices',
                      message: 'Try a different search or filter.',
                    );
                  }
                  return LayoutBuilder(
                    builder: (context, constraints) {
                      final columns =
                          constraints.maxWidth >= AppBreakpoints.desktop
                          ? 3
                          : constraints.maxWidth >= AppBreakpoints.tablet
                          ? 2
                          : 1;
                      return RefreshIndicator(
                        onRefresh: () => ref
                            .read(devicesControllerProvider.notifier)
                            .refresh(),
                        child: GridView.builder(
                          padding: const EdgeInsets.only(
                            bottom: AppSpacing.section,
                          ),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: columns,
                                crossAxisSpacing: AppSpacing.lg,
                                mainAxisSpacing: AppSpacing.lg,
                                childAspectRatio: columns == 1 ? 2.2 : 1.45,
                              ),
                          itemCount: filtered.length,
                          itemBuilder: (_, index) {
                            final device = filtered[index];
                            return DeviceCard(
                              device: device,
                              onTap: () =>
                                  context.push('/devices/${device.id}'),
                              onEdit: () =>
                                  context.push('/devices/${device.id}/edit'),
                              onDelete: () => _confirmDelete(device),
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _matches(Device device) {
    final query = _searchController.text.trim().toLowerCase();
    final matchesQuery =
        query.isEmpty ||
        device.name.toLowerCase().contains(query) ||
        device.room.toLowerCase().contains(query) ||
        device.type.label.toLowerCase().contains(query);
    final matchesFilter =
        _filter == 'all' ||
        (_filter == 'online' && device.isOnline) ||
        (_filter == 'offline' && !device.isOnline);
    return matchesQuery && matchesFilter;
  }

  Future<void> _confirmDelete(Device device) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete device?'),
        content: Text('Remove “${device.name}” from WattFlow?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      try {
        await ref.read(devicesControllerProvider.notifier).delete(device.id);
      } catch (error) {
        if (mounted) {
          AppSnackBar.showError(context, error);
        }
      }
    }
  }
}
