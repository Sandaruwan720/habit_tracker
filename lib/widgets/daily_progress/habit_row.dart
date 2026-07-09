import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/habit_model.dart';
import '../../theme/app_colors.dart';

/// Single premium habit card with an animated completion toggle.
///
/// Features:
/// - Glass surface with inner glow when completed
/// - Haptic feedback on toggle
/// - Scale + opacity press animation
/// - Animated checkmark circle on the trailing edge
/// - Category chip + streak badge
class HabitRow extends StatefulWidget {
  const HabitRow({
    super.key,
    required this.habit,
    required this.onToggle,
    this.animationDelay = Duration.zero,
  });

  final HabitModel habit;
  final VoidCallback onToggle;
  final Duration animationDelay;

  @override
  State<HabitRow> createState() => _HabitRowState();
}

class _HabitRowState extends State<HabitRow>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pressController;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _pressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      reverseDuration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _pressController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  void _handleTap() {
    HapticFeedback.lightImpact();
    widget.onToggle();
  }

  @override
  Widget build(BuildContext context) {
    final completed = widget.habit.isCompleted;

    return GestureDetector(
      onTapDown: (_) => _pressController.forward(),
      onTapUp: (_) => _pressController.reverse(),
      onTapCancel: () => _pressController.reverse(),
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) => Transform.scale(
          scale: _scaleAnimation.value,
          child: child,
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: completed
                ? const Color(0xFF0F1E14)
                : AppColors.cardBackground,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: completed
                  ? const Color(0xFF22C55E).withValues(alpha: 0.3)
                  : AppColors.glassBorder,
              width: completed ? 1.0 : 0.8,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
              if (completed)
                BoxShadow(
                  color: const Color(0xFF22C55E).withValues(alpha: 0.10),
                  blurRadius: 20,
                  offset: const Offset(0, 2),
                ),
            ],
          ),
          child: Row(
            children: [
              // ── Leading: emoji icon ────────────────────────────────────
              _EmojiIcon(
                emoji: widget.habit.emoji,
                isCompleted: completed,
              ),

              const SizedBox(width: 14),

              // ── Center: name + category + streak ──────────────────────
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 300),
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w600,
                        color: completed
                            ? AppColors.textPrimary.withValues(alpha: 0.6)
                            : AppColors.textPrimary,
                        decoration: completed
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        decorationColor:
                            AppColors.textPrimary.withValues(alpha: 0.4),
                        height: 1.3,
                      ),
                      child: Text(widget.habit.name),
                    ),

                    const SizedBox(height: 5),

                    Row(
                      children: [
                        // Category chip
                        _CategoryChip(label: widget.habit.category),

                        const SizedBox(width: 8),

                        // Streak badge
                        _StreakBadge(days: widget.habit.streakDays),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              // ── Trailing: animated toggle ──────────────────────────────
              _ToggleButton(isCompleted: completed),
            ],
          ),
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Sub-components
// ──────────────────────────────────────────────────────────────────────────────

class _EmojiIcon extends StatelessWidget {
  const _EmojiIcon({required this.emoji, required this.isCompleted});

  final String emoji;
  final bool isCompleted;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        color: isCompleted
            ? const Color(0xFF22C55E).withValues(alpha: 0.15)
            : const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(
          color: isCompleted
              ? const Color(0xFF22C55E).withValues(alpha: 0.35)
              : const Color(0xFF2D3748),
          width: 0.8,
        ),
      ),
      child: Center(
        child: Text(emoji, style: const TextStyle(fontSize: 22)),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.glassSurface,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.glassBorder, width: 0.7),
      ),
      child: Text(
        label,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}

class _StreakBadge extends StatelessWidget {
  const _StreakBadge({required this.days});

  final int days;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('🔥', style: TextStyle(fontSize: 10)),
        const SizedBox(width: 3),
        Text(
          '$days Day Streak',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: AppColors.streakOrange,
          ),
        ),
      ],
    );
  }
}

class _ToggleButton extends StatelessWidget {
  const _ToggleButton({required this.isCompleted});

  final bool isCompleted;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutBack,
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: isCompleted ? AppColors.progressGradient : null,
        color: isCompleted ? null : Colors.transparent,
        border: Border.all(
          color: isCompleted
              ? Colors.transparent
              : AppColors.textMuted.withValues(alpha: 0.4),
          width: 1.5,
        ),
        boxShadow: isCompleted
            ? [
                BoxShadow(
                  color: const Color(0xFF22C55E).withValues(alpha: 0.4),
                  blurRadius: 12,
                  spreadRadius: 0,
                ),
              ]
            : null,
      ),
      child: Center(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, anim) => ScaleTransition(
            scale: anim,
            child: FadeTransition(opacity: anim, child: child),
          ),
          child: isCompleted
              ? const Icon(
                  Icons.check_rounded,
                  key: ValueKey('check'),
                  size: 16,
                  color: Colors.white,
                )
              : const SizedBox.shrink(key: ValueKey('empty')),
        ),
      ),
    );
  }
}
