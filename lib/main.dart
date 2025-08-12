// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'services/db.dart';
import 'screens/onboarding_screen.dart';
import 'screens/survivor_home_screen.dart';
import 'screens/caregiver_pin_screen.dart';
import 'screens/caregiver_home_screen.dart';
import 'screens/settings_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DB.seedIfFirstRun();
  runApp(const ProviderScope(child: App()));
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(path: '/', builder: (_, __) => const OnboardingScreen()),
        GoRoute(path: '/home', builder: (_, __) => const SurvivorHomeScreen()),
        GoRoute(
          path: '/caregiver_pin',
          builder: (_, __) => const CaregiverPinScreen(),
        ),
        GoRoute(
          path: '/caregiver',
          builder: (_, __) => const CaregiverHomeScreen(),
        ),
        GoRoute(path: '/settings', builder: (_, __) => const SettingsScreen()),
      ],
    );

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      routerConfig: router,
    );
  }
}
