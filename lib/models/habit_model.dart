/// Immutable data model for a single habit entry.
class HabitModel {
  const HabitModel({
    required this.id,
    required this.name,
    required this.emoji,
    required this.category,
    required this.streakDays,
    this.isCompleted = false,
  });

  final String id;
  final String name;

  /// Unicode emoji representing the habit (e.g. '💧', '📚').
  final String emoji;

  final String category;
  final int streakDays;
  final bool isCompleted;

  HabitModel copyWith({
    String? id,
    String? name,
    String? emoji,
    String? category,
    int? streakDays,
    bool? isCompleted,
  }) {
    return HabitModel(
      id: id ?? this.id,
      name: name ?? this.name,
      emoji: emoji ?? this.emoji,
      category: category ?? this.category,
      streakDays: streakDays ?? this.streakDays,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HabitModel && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
