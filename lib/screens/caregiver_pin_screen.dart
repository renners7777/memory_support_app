// lib/screens/caregiver_pin_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/providers.dart';

class CaregiverPinScreen extends ConsumerStatefulWidget {
  const CaregiverPinScreen({super.key});
  @override
  ConsumerState<CaregiverPinScreen> createState() => _State();
}

class _State extends ConsumerState<CaregiverPinScreen> {
  final ctrl = TextEditingController();
  bool setMode = false;
  String? error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(setMode ? 'Set PIN' : 'Enter PIN')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: ctrl,
              keyboardType: TextInputType.number,
              obscureText: true,
              maxLength: 6,
              decoration: const InputDecoration(labelText: 'PIN'),
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () async {
                final auth = ref.read(caregiverAuthProvider);
                final hasPin = await ref.read(caregiverSetProvider.future);

                if (!context.mounted) return;

                if (!hasPin || setMode) {
                  await auth.setPin(ctrl.text);
                  if (!context.mounted) return;
                  context.go('/caregiver');
                } else {
                  final ok = await auth.verify(ctrl.text);
                  if (!context.mounted) return;

                  if (ok) {
                    context.go('/caregiver');
                  } else {
                    setState(() => error = 'Incorrect PIN');
                  }
                }
              },

              child: Text(setMode ? 'Save' : 'Unlock'),
            ),
            if (error != null) ...[
              const SizedBox(height: 8),
              Text(error!, style: const TextStyle(color: Colors.red)),
            ],
            const Spacer(),
            TextButton(
              onPressed: () => setState(() => setMode = !setMode),
              child: Text(setMode ? 'Use existing PIN' : 'Set/Reset PIN'),
            ),
          ],
        ),
      ),
    );
  }
}
