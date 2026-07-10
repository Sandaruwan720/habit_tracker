import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Large premium gradient button with hover glow, press scale animation,
/// loading spinner, and success checkmark morph.
class AnimatedGradientButton extends StatefulWidget {
  const AnimatedGradientButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.isSuccess = false,
    this.height = 56.0,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isSuccess;
  final double height;

  @override
  State<AnimatedGradientButton> createState() => _AnimatedGradientButtonState();
}

class _AnimatedGradientButtonState extends State<AnimatedGradientButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  late Animation<double> _glowAnim;

  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _glowAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        _hoverController.forward();
      },
      onExit: (_) {
        _hoverController.reverse();
      },
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) {
          setState(() => _isPressed = false);
          if (!widget.isLoading && !widget.isSuccess) {
            widget.onPressed?.call();
          }
        },
        onTapCancel: () => setState(() => _isPressed = false),
        child: AnimatedBuilder(
          animation: _hoverController,
          builder: (context, child) {
            final scale = _isPressed ? 0.96 : 1.0;
            return AnimatedScale(
              scale: scale,
              duration: const Duration(milliseconds: 120),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: widget.height,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: const LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Color(0xFF22C55E), Color(0xFF10B981)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF22C55E)
                          .withValues(alpha: 0.2 + _glowAnim.value * 0.35),
                      blurRadius: 8 + _glowAnim.value * 24,
                      offset: const Offset(0, 4),
                      spreadRadius: _glowAnim.value * 2,
                    ),
                  ],
                ),
                child: Center(child: _buildContent()),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (widget.isLoading) {
      return const SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    }

    if (widget.isSuccess) {
      return const Icon(
        Icons.check_rounded,
        color: Colors.white,
        size: 28,
      );
    }

    return Text(
      widget.label,
      style: GoogleFonts.plusJakartaSans(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.3,
      ),
    );
  }
}
