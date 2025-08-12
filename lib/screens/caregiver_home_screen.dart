// lib/screens/caregiver_home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/providers.dart';
import '../models/routine.dart';

class CaregiverHomeScreen extends ConsumerWidget {
  const CaregiverHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routines = ref.watch(routinesProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Caregiver')),
      body: routines.when(
        data: (items) => ListView.builder(
          itemCount: items.length,
          itemBuilder: (_, i) {
            final r = items[i];
            return ListTile(
              title: Text(r.title),
              subtitle: Text(
                [
                  if (r.anchorText != null) r.anchorText!,
                  if (r.lastPlayedAt != null) 'Last played: ${r.lastPlayedAt}',
                ].join(' • '),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => ref.read(routineRepoProvider).delete(r.id),
              ),
              onTap: () => _editRoutine(context, ref, r),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  void _editRoutine(BuildContext context, WidgetRef ref, Routine r) {
    final titleCtrl = TextEditingController(text: r.title);
    final anchorCtrl = TextEditingController(text: r.anchorText ?? '');
    final ttsCtrl = TextEditingController(text: r.ttsPrompt ?? '');
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Edit routine'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleCtrl,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: anchorCtrl,
              decoration: const InputDecoration(labelText: 'Anchor'),
            ),
            TextField(
              controller: ttsCtrl,
              decoration: const InputDecoration(labelText: 'TTS prompt'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              r
                ..title = titleCtrl.text.trim()
                ..anchorText = anchorCtrl.text.trim().isEmpty
                    ? null
                    : anchorCtrl.text.trim()
                ..ttsPrompt = ttsCtrl.text.trim().isEmpty
                    ? null
                    : ttsCtrl.text.trim();
              await ref.read(routineRepoProvider).addOrUpdate(r);
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
