// lib/models/settings.dart
import 'package:isar/isar.dart';

part 'settings.g.dart';

@collection
class AppSettings {
  Id id = 1;

  // Accessibility
  double textScale = 1.0;
  bool highContrast = false;

  // TTS
  double ttsRate = 0.5; // 0.0–1.0 mapped to engine range
  double ttsPitch = 1.0; // 0.5–2.0 typical
}
