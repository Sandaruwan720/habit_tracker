import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

/// Pill-shaped glassmorphism date chip showing a calendar icon and today's date.
///
/// Animates in with a fade+slide on first render and provides a scale-down
/// tap animation. [onTap] is invoked when the user taps it (e.g. open calendar).
class DateChip extends StatefulWidget {
  const DateChip({super.key, this.onTap, this.date});

  final VoidCallback? onTap;

  /// Override the displayed date. Defaults to [DateTime.now()].
  final DateTime? date;

  @override
  State<DateChip> createState() => _DateChipState();
}

class _DateChipState extends State<DateChip>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pressController;
  late final Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _pressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      reverseDuration: const Duration(milliseconds: 150),
      lowerBound: 0,
      upperBound: 1,
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.93).animate(
      CurvedAnimation(parent: _pressController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  Future<void> _onTapDown(TapDownDetails _) async =>
      _pressController.forward();

  Future<void> _onTapUp(TapUpDetails _) async {
    await _pressController.reverse();
    HapticFeedback.selectionClick();
    widget.onTap?.call();
  }

  Future<void> _onTapCancel() async => _pressController.reverse();

  String _formatDate(DateTime date) {
    const weekdays = [
      'Monday', 'Tuesday', 'Wednesday', 'Thursday',
      'Friday', 'Saturday', 'Sunday'
    ];
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    // DateTime.weekday: 1=Monday … 7=Sunday
    final weekday = weekdays[date.weekday - 1];
    final month = months[date.month - 1];
    return '$weekday, $month ${date.day}';
  }

  @override
  Widget build(BuildContext context) {
    final displayDate = widget.date ?? DateTime.now();
    final label = _formatDate(displayDate);

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: ScaleTransition(
        scale: _scaleAnim,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: AppColors.glassSurface,
                borderRadius: BorderRadius.circular(50),
                border: Border.all(
                  color: AppColors.glassBorder,
                  width: 1.0,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.calendar_month_rounded,
                    size: 13,
                    color: AppColors.primaryLight,
                  ),
                  const SizedBox(width: 6),
                  Text(label, style: AppTextStyles.dateChipLabel),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
