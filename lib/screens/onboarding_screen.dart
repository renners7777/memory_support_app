// lib/screens/onboarding_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              Text('Welcome', style: Theme.of(context).textTheme.displayLarge),
              const SizedBox(height: 12),
              const Text(
                'This app helps with memory support. All data stays on your device.',
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () => context.go('/home'),
                child: const Text('Survivor mode'),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => context.go('/caregiver_pin'),
                child: const Text('Caregiver mode'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
