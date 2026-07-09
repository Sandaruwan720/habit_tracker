import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/app_colors.dart';

/// Circular glassmorphism action button used for Notification & Settings.
///
/// Features:
/// - 48×48 glass circle
/// - Press scale-down feedback + haptic
/// - Optional badge with animated pulse
class HeaderActionButton extends StatefulWidget {
  const HeaderActionButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.badgeCount = 0,
    this.tooltip = '',
  });

  final IconData icon;
  final VoidCallback onTap;

  /// When > 0, a red badge is shown at top-right with this count.
  final int badgeCount;
  final String tooltip;

  @override
  State<HeaderActionButton> createState() => _HeaderActionButtonState();
}

class _HeaderActionButtonState extends State<HeaderActionButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pressController;
  late final Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _pressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      reverseDuration: const Duration(milliseconds: 180),
      lowerBound: 0.0,
      upperBound: 1.0,
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.88).animate(
      CurvedAnimation(parent: _pressController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  Future<void> _onTapDown(TapDownDetails _) async {
    await _pressController.forward();
  }

  Future<void> _onTapUp(TapUpDetails _) async {
    await _pressController.reverse();
    widget.onTap();
    HapticFeedback.lightImpact();
  }

  Future<void> _onTapCancel() async {
    await _pressController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.tooltip,
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        child: ScaleTransition(
          scale: _scaleAnim,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // ── Glass Circle ───────────────────────────────────────────────
              _GlassCircle(icon: widget.icon),

              // ── Notification Badge ─────────────────────────────────────────
              if (widget.badgeCount > 0)
                Positioned(
                  top: -3,
                  right: -3,
                  child: _PulseBadge(count: widget.badgeCount),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────────────────────
// Private sub-widgets
// ────────────────────────────────────────────────────────────────────────────

class _GlassCircle extends StatelessWidget {
  const _GlassCircle({required this.icon});
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.glassSurface,
        border: Border.all(color: AppColors.glassBorder, width: 1.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(icon, color: AppColors.textSecondary, size: 20),
    );
  }
}

/// Animated pulsing badge for unread notification count.
class _PulseBadge extends StatefulWidget {
  const _PulseBadge({required this.count});
  final int count;

  @override
  State<_PulseBadge> createState() => _PulseBadgeState();
}

class _PulseBadgeState extends State<_PulseBadge>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.85, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final label = widget.count > 9 ? '9+' : '${widget.count}';
    return ScaleTransition(
      scale: _pulseAnim,
      child: Container(
        constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        decoration: BoxDecoration(
          color: AppColors.notificationBadge,
          borderRadius: BorderRadius.circular(9),
          border: Border.all(color: AppColors.background, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: AppColors.error.withValues(alpha: 0.5),
              blurRadius: 6,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            height: 1,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
