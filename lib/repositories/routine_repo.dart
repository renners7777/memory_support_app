// lib/repositories/routine_repo.dart
import 'package:isar/isar.dart';
import '../models/routine.dart';
import '../services/db.dart';

class RoutineRepo {
  Future<Isar> get _isar async => DB.instance();

  Stream<List<Routine>> watchAll() async* {
    final isar = await _isar;
    yield* isar.routines.where().watch(fireImmediately: true);
  }

  Future<void> addOrUpdate(Routine r) async {
    final isar = await _isar;
    await isar.writeTxn(() => isar.routines.put(r));
  }

  Future<void> markPlayed(Routine r) async {
    r.lastPlayedAt = DateTime.now();
    await addOrUpdate(r);
  }

  Future<void> delete(Id id) async {
    final isar = await _isar;
    await isar.writeTxn(() => isar.routines.delete(id));
  }
}
