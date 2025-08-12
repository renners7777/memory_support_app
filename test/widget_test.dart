// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:memory_support_app/main.dart';
import 'package:memory_support_app/screens/onboarding_screen.dart';

void main() {
  // Note: This test skips the `DB.seedIfFirstRun()` from your main() for simplicity.
  // For more complex tests, you would typically mock your database service.
  testWidgets('App starts and displays the OnboardingScreen', (
    WidgetTester tester,
  ) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: App()));
    // Verify that the OnboardingScreen is the first screen shown.
    expect(find.byType(OnboardingScreen), findsOneWidget);
  });
}
