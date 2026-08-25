import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/device.dart';
import '../controllers/devices_controller.dart';

class DeviceFormPage extends ConsumerStatefulWidget {
  const DeviceFormPage({this.deviceId, super.key});
  final String? deviceId;
  @override
  ConsumerState<DeviceFormPage> createState() => _DeviceFormPageState();
}

class _DeviceFormPageState extends ConsumerState<DeviceFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _room;
  DeviceType? _type;
  bool _saving = false;
  @override
  void initState() {
    super.initState();
    final devicesState = ref.read(devicesControllerProvider);
    final devices = devicesState is AsyncData<List<Device>>
        ? devicesState.value
        : null;
    final device = devices
        ?.where((item) => item.id == widget.deviceId)
        .firstOrNull;
    _name = TextEditingController(text: device?.name);
    _room = TextEditingController(text: device?.room);
    _type = device?.type;
  }

  @override
  void dispose() {
    _name.dispose();
    _room.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(widget.deviceId == null ? 'Add device' : 'Edit device'),
    ),
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
                  widget.deviceId == null
                      ? 'Connect a device'
                      : 'Update device details',
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
      if (widget.deviceId == null) {
        await controller.add(
          name: _name.text.trim(),
          type: _type!,
          room: _room.text.trim(),
        );
      } else {
        await controller.updateDevice(
          id: widget.deviceId!,
          name: _name.text.trim(),
          type: _type!,
          room: _room.text.trim(),
        );
      }
      if (mounted) Navigator.pop(context);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not save the device.')),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }
}
