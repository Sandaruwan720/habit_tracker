import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../controllers/login_controller.dart';

/// Social login section with a "Continue with" divider and
/// Glass-style Google / Apple / Microsoft icon buttons.
class SocialLoginSection extends StatelessWidget {
  const SocialLoginSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ── Divider ─────────────────────────────────────────────────────────
        Row(
          children: [
            const Expanded(
              child: Divider(color: Color(0x18FFFFFF), thickness: 1),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Text(
                'Continue with',
                style: GoogleFonts.plusJakartaSans(
                  color: const Color(0xFF64748B),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Expanded(
              child: Divider(color: Color(0x18FFFFFF), thickness: 1),
            ),
          ],
        )
            .animate()
            .fadeIn(duration: 500.ms, delay: 700.ms),

        const SizedBox(height: 16),

        // ── Social buttons ───────────────────────────────────────────────────
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _SocialButton(
              icon: _GoogleIcon(),
              tooltip: 'Sign in with Google',
              onTap: () => context.read<LoginController>().signInWithGoogle(),
            ),
            const SizedBox(width: 14),
            _SocialButton(
              icon: const Icon(
                Icons.apple,
                color: Colors.white,
                size: 22,
              ),
              tooltip: 'Sign in with Apple',
              onTap: () => context.read<LoginController>().signInWithApple(),
            ),
            const SizedBox(width: 14),
            _SocialButton(
              icon: _MicrosoftIcon(),
              tooltip: 'Sign in with Microsoft',
              onTap: () =>
                  context.read<LoginController>().signInWithMicrosoft(),
            ),
          ],
        )
            .animate()
            .fadeIn(duration: 500.ms, delay: 850.ms)
            .slideY(begin: 0.2, end: 0),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Glass social button
// ─────────────────────────────────────────────────────────────────────────────

class _SocialButton extends StatefulWidget {
  const _SocialButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  final Widget icon;
  final String tooltip;
  final VoidCallback onTap;

  @override
  State<_SocialButton> createState() => _SocialButtonState();
}

class _SocialButtonState extends State<_SocialButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.tooltip,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: _isHovered
                  ? const Color(0x20FFFFFF)
                  : const Color(0x0AFFFFFF),
              border: Border.all(
                color: _isHovered
                    ? const Color(0x40FFFFFF)
                    : const Color(0x18FFFFFF),
                width: 1.0,
              ),
              boxShadow: _isHovered
                  ? [
                      BoxShadow(
                        color: Colors.white.withValues(alpha: 0.05),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      )
                    ]
                  : [],
            ),
            child: Center(child: widget.icon),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Brand icons (drawn inline — no asset dependency)
// ─────────────────────────────────────────────────────────────────────────────

class _GoogleIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(20, 20),
      painter: _GooglePainter(),
    );
  }
}

class _GooglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final r = size.width / 2;

    // Multi-color Google 'G' approximation
    final colors = [
      const Color(0xFF4285F4), // blue
      const Color(0xFF34A853), // green
      const Color(0xFFFBBC05), // yellow
      const Color(0xFFEA4335), // red
    ];

    final sweeps = [1.57, 1.57, 0.79, 0.79];
    double start = -1.57;

    for (int i = 0; i < colors.length; i++) {
      final paint = Paint()
        ..color = colors[i]
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.5
        ..strokeCap = StrokeCap.butt;
      canvas.drawArc(
          Rect.fromCircle(center: c, radius: r - 1.75),
          start,
          sweeps[i],
          false,
          paint);
      start += sweeps[i];
    }

    // White inner fill to simulate 'G' cutout
    final whitePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawRect(
      Rect.fromLTWH(c.dx, c.dy - 3.5, r - 1.75, 7),
      whitePaint,
    );
    canvas.drawRect(
      Rect.fromLTWH(c.dx, c.dy - 3.5, r - 1.75, 7),
      Paint()
        ..color = const Color(0xFF4285F4)
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _MicrosoftIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 20,
      height: 20,
      child: Column(
        children: [
          Row(
            children: [
              _Square(const Color(0xFFF25022)), // red
              const SizedBox(width: 2),
              _Square(const Color(0xFF7FBA00)), // green
            ],
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              _Square(const Color(0xFF00A4EF)), // blue
              const SizedBox(width: 2),
              _Square(const Color(0xFFFFB900)), // yellow
            ],
          ),
        ],
      ),
    );
  }
}

class _Square extends StatelessWidget {
  const _Square(this.color);
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(color: color),
      ),
    );
  }
}
