// lib/screens/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/providers.dart';
import '../models/settings.dart';
import '../services/db.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<AppSettings>(
      future: ref.read(settingsProvider.future),
      builder: (context, snap) {
        if (!snap.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final s = snap.data!;
        return Scaffold(
          appBar: AppBar(title: const Text('Settings')),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _SliderTile(
                label: 'Text size',
                value: s.textScale,
                min: 0.8,
                max: 1.6,
                divisions: 8,
                onChanged: (v) => _save(s..textScale = v),
              ),
              SwitchListTile(
                title: const Text('High contrast'),
                value: s.highContrast,
                onChanged: (v) => _save(s..highContrast = v),
              ),
              const Divider(),
              _SliderTile(
                label: 'TTS rate',
                value: s.ttsRate,
                min: 0.2,
                max: 0.9,
                divisions: 7,
                onChanged: (v) => _save(s..ttsRate = v),
              ),
              _SliderTile(
                label: 'TTS pitch',
                value: s.ttsPitch,
                min: 0.7,
                max: 1.3,
                divisions: 6,
                onChanged: (v) => _save(s..ttsPitch = v),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _save(AppSettings s) async {
    final isar = await DB.instance();
    await isar.writeTxn(() => isar.appSettings.put(s));
  }
}

class _SliderTile extends StatelessWidget {
  final String label;
  final double value, min, max;
  final int divisions;
  final ValueChanged<double> onChanged;
  const _SliderTile({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.onChanged,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text(label), Text(value.toStringAsFixed(2))],
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: divisions,
          onChanged: onChanged,
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
