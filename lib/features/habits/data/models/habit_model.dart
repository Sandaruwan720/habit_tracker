import '../../domain/entities/habit_entity.dart';

// ─────────────────────────────────────────────────────────────────────────────
// HabitModel — data layer representation of a Habit
// ─────────────────────────────────────────────────────────────────────────────

class HabitModel {
  const HabitModel({
    required this.id,
    required this.userId,
    required this.name,
    this.description,
    required this.color,
    required this.icon,
    required this.frequency,
    required this.targetCount,
    required this.createdAt,
    required this.updatedAt,
    required this.isDeleted,
    required this.syncPending,
  });

  final String id;
  final String userId;
  final String name;
  final String? description;
  final int color;
  final String icon;
  final String frequency;
  final int targetCount;
  final String createdAt;  // ISO-8601 string
  final String updatedAt;
  final int isDeleted;     // 0 | 1
  final int syncPending;   // 0 | 1

  // ── Conversions ────────────────────────────────────────────────────────────

  factory HabitModel.fromMap(Map<String, dynamic> map) => HabitModel(
        id: map['id'] as String,
        userId: map['user_id'] as String,
        name: map['name'] as String,
        description: map['description'] as String?,
        color: map['color'] as int? ?? 0xFF22C55E,
        icon: map['icon'] as String? ?? 'check_circle',
        frequency: map['frequency'] as String? ?? 'daily',
        targetCount: map['target_count'] as int? ?? 1,
        createdAt: map['created_at'] as String,
        updatedAt: map['updated_at'] as String,
        isDeleted: map['is_deleted'] as int? ?? 0,
        syncPending: map['sync_pending'] as int? ?? 1,
      );

  /// Build from a Supabase row (bool fields, DateTime strings).
  factory HabitModel.fromSupabase(Map<String, dynamic> map) => HabitModel(
        id: map['id'] as String,
        userId: map['user_id'] as String,
        name: map['name'] as String,
        description: map['description'] as String?,
        color: map['color'] as int? ?? 0xFF22C55E,
        icon: map['icon'] as String? ?? 'check_circle',
        frequency: map['frequency'] as String? ?? 'daily',
        targetCount: map['target_count'] as int? ?? 1,
        createdAt: map['created_at'] as String,
        updatedAt: map['updated_at'] as String,
        isDeleted: (map['is_deleted'] as bool? ?? false) ? 1 : 0,
        syncPending: 0,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'user_id': userId,
        'name': name,
        'description': description,
        'color': color,
        'icon': icon,
        'frequency': frequency,
        'target_count': targetCount,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'is_deleted': isDeleted,
        'sync_pending': syncPending,
      };

  Map<String, dynamic> toSupabaseMap() => {
        'id': id,
        'user_id': userId,
        'name': name,
        'description': description,
        'color': color,
        'icon': icon,
        'frequency': frequency,
        'target_count': targetCount,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'is_deleted': isDeleted == 1,
      };

  HabitEntity toEntity() => HabitEntity(
        id: id,
        userId: userId,
        name: name,
        description: description,
        color: color,
        icon: icon,
        frequency: frequency,
        targetCount: targetCount,
        createdAt: DateTime.parse(createdAt),
        updatedAt: DateTime.parse(updatedAt),
        isDeleted: isDeleted == 1,
      );

  factory HabitModel.fromEntity(HabitEntity e, {bool syncPending = true}) =>
      HabitModel(
        id: e.id,
        userId: e.userId,
        name: e.name,
        description: e.description,
        color: e.color,
        icon: e.icon,
        frequency: e.frequency,
        targetCount: e.targetCount,
        createdAt: e.createdAt.toIso8601String(),
        updatedAt: e.updatedAt.toIso8601String(),
        isDeleted: e.isDeleted ? 1 : 0,
        syncPending: syncPending ? 1 : 0,
      );
}

// ─────────────────────────────────────────────────────────────────────────────
// HabitLogModel
// ─────────────────────────────────────────────────────────────────────────────

class HabitLogModel {
  const HabitLogModel({
    required this.id,
    required this.habitId,
    required this.userId,
    required this.completedAt,
    this.note,
    required this.updatedAt,
    required this.isDeleted,
    required this.syncPending,
  });

  final String id;
  final String habitId;
  final String userId;
  final String completedAt;
  final String? note;
  final String updatedAt;
  final int isDeleted;
  final int syncPending;

  factory HabitLogModel.fromMap(Map<String, dynamic> map) => HabitLogModel(
        id: map['id'] as String,
        habitId: map['habit_id'] as String,
        userId: map['user_id'] as String,
        completedAt: map['completed_at'] as String,
        note: map['note'] as String?,
        updatedAt: map['updated_at'] as String,
        isDeleted: map['is_deleted'] as int? ?? 0,
        syncPending: map['sync_pending'] as int? ?? 1,
      );

  factory HabitLogModel.fromSupabase(Map<String, dynamic> map) => HabitLogModel(
        id: map['id'] as String,
        habitId: map['habit_id'] as String,
        userId: map['user_id'] as String,
        completedAt: map['completed_at'] as String,
        note: map['note'] as String?,
        updatedAt: map['updated_at'] as String,
        isDeleted: (map['is_deleted'] as bool? ?? false) ? 1 : 0,
        syncPending: 0,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'habit_id': habitId,
        'user_id': userId,
        'completed_at': completedAt,
        'note': note,
        'updated_at': updatedAt,
        'is_deleted': isDeleted,
        'sync_pending': syncPending,
      };

  Map<String, dynamic> toSupabaseMap() => {
        'id': id,
        'habit_id': habitId,
        'user_id': userId,
        'completed_at': completedAt,
        'note': note,
        'updated_at': updatedAt,
        'is_deleted': isDeleted == 1,
      };

  HabitLogEntity toEntity() => HabitLogEntity(
        id: id,
        habitId: habitId,
        userId: userId,
        completedAt: DateTime.parse(completedAt),
        note: note,
        updatedAt: DateTime.parse(updatedAt),
        isDeleted: isDeleted == 1,
      );

  factory HabitLogModel.fromEntity(HabitLogEntity e,
          {bool syncPending = true}) =>
      HabitLogModel(
        id: e.id,
        habitId: e.habitId,
        userId: e.userId,
        completedAt: e.completedAt.toIso8601String(),
        note: e.note,
        updatedAt: e.updatedAt.toIso8601String(),
        isDeleted: e.isDeleted ? 1 : 0,
        syncPending: syncPending ? 1 : 0,
      );
}
