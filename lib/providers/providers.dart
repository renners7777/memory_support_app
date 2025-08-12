// lib/providers/providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/routine_repo.dart';
import '../models/routine.dart';
import '../models/settings.dart';
import '../services/db.dart';
import '../services/tts_service.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import '../models/caregiver.dart';

final dbProvider = Provider((_) => DB);

final routineRepoProvider = Provider((_) => RoutineRepo());

final routinesProvider = StreamProvider<List<Routine>>((ref) {
  return ref.read(routineRepoProvider).watchAll();
});

final ttsProvider = Provider<TtsService>((ref) {
  return TtsService();
});

final settingsProvider = FutureProvider<AppSettings>((ref) async {
  final isar = await DB.instance();
  final s = await isar.appSettings.get(1);
  return s ?? AppSettings();
});

final caregiverSetProvider = FutureProvider<bool>((ref) async {
  final isar = await DB.instance();
  return (await isar.caregivers.get(1)) != null;
});

String _hash(String pin, String salt) {
  final bytes = utf8.encode('$salt:$pin');
  return sha256.convert(bytes).toString();
}

final caregiverAuthProvider = Provider((ref) {
  return _CaregiverAuth();
});

class _CaregiverAuth {
  Future<bool> setPin(String pin) async {
    final isar = await DB.instance();
    final salt = DateTime.now().microsecondsSinceEpoch.toString();
    final hash = _hash(pin, salt);
    return isar.writeTxn(() async {
      await isar.caregivers.put(
        Caregiver()
          ..pinHash = hash
          ..salt = salt,
      );
      return true;
    });
  }

  Future<bool> verify(String pin) async {
    final isar = await DB.instance();
    final cg = await isar.caregivers.get(1);
    if (cg == null) return false;
    return _hash(pin, cg.salt) == cg.pinHash;
  }

  Future<void> clear() async {
    final isar = await DB.instance();
    await isar.writeTxn(() => isar.caregivers.delete(1));
  }
}
