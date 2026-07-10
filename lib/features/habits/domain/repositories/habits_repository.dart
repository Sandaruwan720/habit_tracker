import '../entities/habit_entity.dart';

/// Contract for all habit CRUD + log operations.
abstract class HabitsRepository {
  // Habits
  Future<List<HabitEntity>> getHabits(String userId);
  Future<HabitEntity> createHabit(HabitEntity habit);
  Future<HabitEntity> updateHabit(HabitEntity habit);
  Future<void> deleteHabit(String habitId);

  // Logs
  Future<List<HabitLogEntity>> getLogs(String habitId, {DateTime? from, DateTime? to});
  Future<HabitLogEntity> logCompletion(HabitLogEntity log);
  Future<void> deleteLog(String logId);

  // Sync
  Future<void> syncAll();
}
