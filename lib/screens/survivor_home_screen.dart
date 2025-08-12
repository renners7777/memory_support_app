import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memory_support_app/models/routine.dart';
import 'package:memory_support_app/providers/providers.dart';
import 'package:memory_support_app/services/tts_service.dart';

class SurvivorHomeScreen extends ConsumerWidget {
  const SurvivorHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routinesAsync = ref.watch(routinesProvider);
    final tts = ref.read(ttsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My routines'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          ),
        ],
      ),
      body: routinesAsync.when(
        data: (items) => ListView.separated(
          itemCount: items.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (_, i) {
            final r = items[i];
            return ListTile(
              title: Text(r.title),
              subtitle: r.anchorText != null ? Text(r.anchorText!) : null,
              trailing: IconButton(
                icon: const Icon(Icons.volume_up),
                onPressed: () => _playRoutine(context, ref, r, tts),
              ),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddRoutine(context, ref),
        label: const Text('Add'),
        icon: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _playRoutine(
    BuildContext context,
    WidgetRef ref,
    Routine r,
    TtsService tts,
  ) async {
    final prompt = r.ttsPrompt ?? '${r.title}.${r.anchorText ?? ''}';
    await tts.speak(prompt);
    if (!context.mounted) return;
    await ref.read(routineRepoProvider).markPlayed(r);
  }

  void _showAddRoutine(BuildContext context, WidgetRef ref) {
    final titleCtrl = TextEditingController();
    final anchorCtrl = TextEditingController();
    final ttsCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: 16 + MediaQuery.of(context).viewInsets.bottom,
          top: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleCtrl,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: anchorCtrl,
              decoration: const InputDecoration(labelText: 'Anchor (optional)'),
            ),
            TextField(
              controller: ttsCtrl,
              decoration: const InputDecoration(
                labelText: 'TTS prompt (optional)',
              ),
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () =>
                  _saveRoutine(context, ref, titleCtrl, anchorCtrl, ttsCtrl),
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveRoutine(
    BuildContext context,
    WidgetRef ref,
    TextEditingController titleCtrl,
    TextEditingController anchorCtrl,
    TextEditingController ttsCtrl,
  ) async {
    final r = Routine()
      ..title = titleCtrl.text.trim().isEmpty
          ? 'Untitled'
          : titleCtrl.text.trim()
      ..anchorText = anchorCtrl.text.trim().isEmpty
          ? null
          : anchorCtrl.text.trim()
      ..ttsPrompt = ttsCtrl.text.trim().isEmpty ? null : ttsCtrl.text.trim();

    await ref.read(routineRepoProvider).addOrUpdate(r);
    if (!context.mounted) return;
    Navigator.pop(context);
  }
}
