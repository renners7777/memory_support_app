// lib/models/caregiver.dart
import 'package:isar/isar.dart';

part 'caregiver.g.dart';

@collection
class Caregiver {
  Id id = 1;

  // Store hash only; basic MVP using SHA-256
  late String pinHash;
  // Simple salt improves over raw hash
  String salt = '';
}
