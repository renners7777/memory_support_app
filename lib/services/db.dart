// lib/services/db.dart
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../models/routine.dart';
import '../models/settings.dart';
import '../models/caregiver.dart';

class DB {
  static Isar? _isar;

  static Future<Isar> instance() async {
    if (_isar != null) return _isar!;
    final dir = await getApplicationDocumentsDirectory();
    await Isar.open(
      [RoutineSchema, AppSettingsSchema, CaregiverSchema],
      directory: dir.path,
      inspector: false,
    );
    return _isar!;
  }

  static Future<void> seedIfFirstRun() async {
    final isar = await instance();
    final hasSettings = await isar.appSettings.get(1) != null;
    if (!hasSettings) {
      await isar.writeTxn(() async {
        await isar.appSettings.put(AppSettings());
        // No caregiver by default; PIN can be set later
        await isar.routines.putAll([
          Routine()
            ..title = 'Take medication'
            ..anchorText = 'At 9:00 AM'
            ..ttsPrompt = 'It’s 9 AM. Time to take your medication.',
          Routine()
            ..title = 'Drink water'
            ..anchorText = 'After brushing your teeth'
            ..ttsPrompt =
                'After brushing your teeth, please drink a glass of water.',
        ]);
      });
    }
  }
}
