// lib/models/routine.dart
import 'package:isar/isar.dart';

part 'routine.g.dart';

@collection
class Routine {
  Id id = Isar.autoIncrement;

  late String title; // "Take medication"
  String? anchorText; // "After brushing teeth"
  String? ttsPrompt; // Optional custom voice prompt
  bool enabled = true;

  // Simple "last done" tick
  DateTime? lastPlayedAt;
}
