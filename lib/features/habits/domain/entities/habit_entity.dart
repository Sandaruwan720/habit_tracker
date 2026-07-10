/// Immutable domain entity representing a habit.
class HabitEntity {
  const HabitEntity({
    required this.id,
    required this.userId,
    required this.name,
    this.description,
    this.color = 0xFF22C55E,
    this.icon = 'check_circle',
    this.frequency = 'daily',
    this.targetCount = 1,
    required this.createdAt,
    required this.updatedAt,
    this.isDeleted = false,
  });

  final String id;
  final String userId;
  final String name;
  final String? description;
  final int color;
  final String icon;
  final String frequency;
  final int targetCount;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isDeleted;

  HabitEntity copyWith({
    String? id,
    String? userId,
    String? name,
    String? description,
    int? color,
    String? icon,
    String? frequency,
    int? targetCount,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isDeleted,
  }) {
    return HabitEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      description: description ?? this.description,
      color: color ?? this.color,
      icon: icon ?? this.icon,
      frequency: frequency ?? this.frequency,
      targetCount: targetCount ?? this.targetCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }
}

/// Immutable domain entity representing a single habit completion log.
class HabitLogEntity {
  const HabitLogEntity({
    required this.id,
    required this.habitId,
    required this.userId,
    required this.completedAt,
    this.note,
    required this.updatedAt,
    this.isDeleted = false,
  });

  final String id;
  final String habitId;
  final String userId;
  final DateTime completedAt;
  final String? note;
  final DateTime updatedAt;
  final bool isDeleted;
}
