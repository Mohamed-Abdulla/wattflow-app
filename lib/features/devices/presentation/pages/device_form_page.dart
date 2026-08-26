import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/error/app_failure.dart';
import '../../../../core/widgets/app_feedback.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../../domain/entities/device.dart';
import '../controllers/devices_controller.dart';

class DeviceFormPage extends ConsumerWidget {
  const DeviceFormPage({this.deviceId, super.key});

  final String? deviceId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (deviceId == null) {
      return const _DeviceFormView();
    }

    final devicesState = ref.watch(devicesControllerProvider);
    return devicesState.when(
      loading: () => Scaffold(
        appBar: AppBar(title: const Text('Edit device')),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Scaffold(
        appBar: AppBar(title: const Text('Edit device')),
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
            appBar: AppBar(title: const Text('Edit device')),
            body: ErrorState(
              message: 'This device is no longer available.',
              onRetry: () => context.pop(),
            ),
          );
        }
        return _DeviceFormView(device: device);
      },
    );
  }
}

class _DeviceFormView extends ConsumerStatefulWidget {
  const _DeviceFormView({this.device});

  final Device? device;

  @override
  ConsumerState<_DeviceFormView> createState() => _DeviceFormViewState();
}

class _DeviceFormViewState extends ConsumerState<_DeviceFormView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _room;
  late DeviceType? _type;
  bool _saving = false;

  bool get _isEditing => widget.device != null;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.device?.name);
    _room = TextEditingController(text: widget.device?.room);
    _type = widget.device?.type;
  }

  @override
  void dispose() {
    _name.dispose();
    _room.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(_isEditing ? 'Edit device' : 'Add device')),
    body: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: ListView(
              shrinkWrap: true,
              children: [
                Text(
                  _isEditing ? 'Update device details' : 'Connect a device',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _name,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(labelText: 'Name'),
                  validator: _required,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<DeviceType>(
                  initialValue: _type,
                  decoration: const InputDecoration(labelText: 'Type'),
                  items: DeviceType.values
                      .map(
                        (type) => DropdownMenuItem(
                          value: type,
                          child: Text(type.label),
                        ),
                      )
                      .toList(),
                  onChanged: (value) => setState(() => _type = value),
                  validator: (value) => value == null ? 'Select a type' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _room,
                  textInputAction: TextInputAction.done,
                  decoration: const InputDecoration(labelText: 'Room'),
                  validator: _required,
                  onFieldSubmitted: (_) => _save(),
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: _saving ? null : _save,
                  icon: _saving
                      ? const SizedBox.square(
                          dimension: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.check),
                  label: Text(_saving ? 'Saving…' : 'Save device'),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );

  String? _required(String? value) =>
      value == null || value.trim().isEmpty ? 'This field is required' : null;

  Future<void> _save() async {
    if (!_formKey.currentState!.validate() || _type == null) return;

    setState(() => _saving = true);
    final controller = ref.read(devicesControllerProvider.notifier);
    try {
      if (_isEditing) {
        await controller.updateDevice(
          id: widget.device!.id,
          name: _name.text.trim(),
          type: _type!,
          room: _room.text.trim(),
        );
      } else {
        await controller.add(
          name: _name.text.trim(),
          type: _type!,
          room: _room.text.trim(),
        );
      }
      if (mounted) context.pop();
    } catch (error) {
      if (mounted) {
        AppSnackBar.showError(context, error);
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }
}
