import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/app_colors.dart';

/// Circular avatar with a gradient border ring, soft glow, and a green
/// online-status indicator in the bottom-right corner.
///
/// Tapping the avatar triggers [onTap] with a scale press effect.
class ProfileSection extends StatefulWidget {
  const ProfileSection({
    super.key,
    this.avatarUrl,
    this.avatarRadius = 28.0, // 56px diameter
    this.onTap,
  });

  /// Network or asset image URL. Falls back to initials placeholder when null.
  final String? avatarUrl;

  /// Outer radius of the avatar circle (half of diameter).
  final double avatarRadius;

  final VoidCallback? onTap;

  @override
  State<ProfileSection> createState() => _ProfileSectionState();
}

class _ProfileSectionState extends State<ProfileSection>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pressController;
  late final Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _pressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 110),
      reverseDuration: const Duration(milliseconds: 160),
      lowerBound: 0,
      upperBound: 1,
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.92).animate(
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
    HapticFeedback.lightImpact();
    widget.onTap?.call();
  }

  Future<void> _onTapCancel() async => _pressController.reverse();

  @override
  Widget build(BuildContext context) {
    final double ringPadding = 3;
    final double ringBorderWidth = 2.5;
    final double totalSize =
        (widget.avatarRadius + ringPadding + ringBorderWidth) * 2;
    final double indicatorSize = 14;

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: ScaleTransition(
        scale: _scaleAnim,
        child: SizedBox(
          width: totalSize + indicatorSize / 2,
          height: totalSize + indicatorSize / 2,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              // ── Glow behind ring ─────────────────────────────────────────
              Container(
                width: totalSize,
                height: totalSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.35),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),

              // ── Gradient ring border ──────────────────────────────────────
              Container(
                width: totalSize,
                height: totalSize,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppColors.avatarBorderGradient,
                ),
                child: Padding(
                  padding: EdgeInsets.all(ringBorderWidth),
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.background,
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(ringPadding),
                      // ── Avatar image ──────────────────────────────────────
                      child: _AvatarImage(
                        avatarUrl: widget.avatarUrl,
                        radius: widget.avatarRadius,
                      ),
                    ),
                  ),
                ),
              ),

              // ── Online status dot ─────────────────────────────────────────
              Positioned(
                bottom: indicatorSize / 4,
                right: indicatorSize / 4,
                child: _StatusIndicator(size: indicatorSize),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────────────────────
// Private helpers
// ────────────────────────────────────────────────────────────────────────────

class _AvatarImage extends StatelessWidget {
  const _AvatarImage({required this.avatarUrl, required this.radius});
  final String? avatarUrl;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: avatarUrl != null
          ? Image.network(
              avatarUrl!,
              width: radius * 2,
              height: radius * 2,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => _PlaceholderAvatar(radius: radius),
            )
          : _PlaceholderAvatar(radius: radius),
    );
  }
}

class _PlaceholderAvatar extends StatelessWidget {
  const _PlaceholderAvatar({required this.radius});
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
        ),
      ),
      child: Center(
        child: Text(
          'T',
          style: TextStyle(
            fontSize: radius * 0.75,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class _StatusIndicator extends StatelessWidget {
  const _StatusIndicator({required this.size});
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.onlineStatus,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.background, width: 2),
        boxShadow: [
          BoxShadow(
            color: AppColors.onlineStatus.withValues(alpha: 0.6),
            blurRadius: 6,
            spreadRadius: 1,
          ),
        ],
      ),
    );
  }
}
