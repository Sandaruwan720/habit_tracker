import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Redesigned hero section for the login screen.
/// Features a 3D growth illustration, floating habit icons,
/// and a rich animated background.
class HeroIllustrationSection extends StatelessWidget {
  const HeroIllustrationSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Stack(
      fit: StackFit.expand,
      children: [
        HeroBackground(),
        AmbientGlow(),
        FloatingParticles(),
        GrowthIllustration(),
        FloatingHabitElements(),
      ],
    );
  }
}

class HeroBackground extends StatelessWidget {
  const HeroBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF08111F),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Purple glow
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              width: 500,
              height: 500,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [Color(0x607C3AED), Colors.transparent],
                  radius: 0.7,
                ),
              ),
            ),
          ).animate(onPlay: (c) => c.repeat(reverse: true)).scale(
                duration: 8.seconds,
                begin: const Offset(1, 1),
                end: const Offset(1.2, 1.2),
              ),
          // Blue glow
          Positioned(
            bottom: -200,
            right: -100,
            child: Container(
              width: 600,
              height: 600,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [Color(0x502563EB), Colors.transparent],
                  radius: 0.7,
                ),
              ),
            ),
          ).animate(onPlay: (c) => c.repeat(reverse: true)).slide(
                duration: 10.seconds,
                begin: const Offset(0, 0),
                end: const Offset(-0.1, -0.1),
              ),
          // Blur filter to smooth everything out
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
            child: Container(color: Colors.transparent),
          ),
        ],
      ),
    );
  }
}

class AmbientGlow extends StatelessWidget {
  const AmbientGlow({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 400,
        height: 400,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [Color(0x4022C55E), Color(0x20EC4899), Colors.transparent],
            stops: [0.0, 0.5, 1.0],
            radius: 0.5,
          ),
        ),
      ).animate(onPlay: (c) => c.repeat(reverse: true)).fadeIn(duration: 4.seconds).then().fadeOut(duration: 4.seconds),
    );
  }
}

class FloatingParticles extends StatefulWidget {
  const FloatingParticles({super.key});

  @override
  State<FloatingParticles> createState() => _FloatingParticlesState();
}

class _FloatingParticlesState extends State<FloatingParticles>
    with SingleTickerProviderStateMixin {
  late AnimationController _particleController;

  @override
  void initState() {
    super.initState();
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }

  @override
  void dispose() {
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _particleController,
      builder: (context, child) => CustomPaint(
        painter: _ParticlePainter(_particleController.value),
        size: Size.infinite,
      ),
    );
  }
}

class _ParticlePainter extends CustomPainter {
  _ParticlePainter(this.progress);
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0x60FFFFFF)
      ..style = PaintingStyle.fill;

    const particleCount = 40;
    final random = math.Random(42);

    for (int i = 0; i < particleCount; i++) {
      final startX = random.nextDouble() * size.width;
      final startY = random.nextDouble() * size.height;
      final speed = random.nextDouble() * 0.5 + 0.2;
      final drift = random.nextDouble() * math.pi * 2;

      // Calculate current position with wrap-around
      double y = startY - (progress * size.height * speed);
      y = y % size.height;
      if (y < 0) y += size.height;

      double x = startX + math.sin(progress * math.pi * 2 + drift) * 20;

      final radius = random.nextDouble() * 2 + 1;
      final alpha = (math.sin(progress * math.pi * 4 + drift) + 1) / 2;
      
      paint.color = Colors.white.withValues(alpha: alpha * 0.4);
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter oldDelegate) =>
      progress != oldDelegate.progress;
}

class GrowthIllustration extends StatelessWidget {
  const GrowthIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.45,
        height: MediaQuery.of(context).size.height * 0.8,
        child: Image.asset(
          'assets/images/hero_plant.png',
          fit: BoxFit.contain,
        ),
      ).animate(onPlay: (c) => c.repeat(reverse: true)).slideY(
            begin: -0.02,
            end: 0.02,
            duration: 6.seconds,
            curve: Curves.easeInOutSine,
          ),
    );
  }
}

class FloatingHabitElements extends StatelessWidget {
  const FloatingHabitElements({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        _buildFloatingIcon(
          icon: Icons.calendar_month_rounded,
          alignment: const Alignment(-0.6, -0.4),
          color: const Color(0xFF3B82F6),
          delay: 0,
        ),
        _buildFloatingIcon(
          icon: Icons.check_circle_outline_rounded,
          alignment: const Alignment(0.5, -0.6),
          color: const Color(0xFF22C55E),
          delay: 1,
          size: 40,
        ),
        _buildFloatingIcon(
          icon: Icons.self_improvement_rounded, // Meditation
          alignment: const Alignment(-0.8, 0.2),
          color: const Color(0xFF8B5CF6),
          delay: 2,
          size: 50,
        ),
        _buildFloatingIcon(
          icon: Icons.menu_book_rounded, // Book
          alignment: const Alignment(0.7, -0.1),
          color: const Color(0xFFF59E0B),
          delay: 3,
        ),
        _buildFloatingIcon(
          icon: Icons.directions_run_rounded, // Running shoe
          alignment: const Alignment(-0.5, 0.6),
          color: const Color(0xFFEF4444),
          delay: 1,
          size: 44,
        ),
        _buildFloatingIcon(
          icon: Icons.water_drop_rounded, // Water drop
          alignment: const Alignment(0.6, 0.5),
          color: const Color(0xFF0EA5E9),
          delay: 0,
          size: 38,
        ),
        _buildFloatingIcon(
          icon: Icons.star_rounded, // Star
          alignment: const Alignment(0.2, -0.8),
          color: const Color(0xFFFCD34D),
          delay: 2,
          size: 24,
        ),
        _buildFloatingIcon(
          icon: Icons.workspace_premium_rounded, // Badge
          alignment: const Alignment(0.1, 0.8),
          color: const Color(0xFFEC4899),
          delay: 3,
          size: 42,
        ),
      ],
    );
  }

  Widget _buildFloatingIcon({
    required IconData icon,
    required Alignment alignment,
    required Color color,
    required int delay,
    double size = 48,
  }) {
    return Align(
      alignment: alignment,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0x1AFFFFFF),
          border: Border.all(color: const Color(0x33FFFFFF), width: 1),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.3),
              blurRadius: 20,
              spreadRadius: 2,
            )
          ],
        ),
        child: Icon(icon, color: Colors.white, size: size),
      )
          .animate(onPlay: (c) => c.repeat(reverse: true))
          .moveY(
            begin: -15,
            end: 15,
            duration: (4 + delay).seconds,
            curve: Curves.easeInOutSine,
          )
          .rotate(
            begin: -0.05,
            end: 0.05,
            duration: (5 + delay).seconds,
            curve: Curves.easeInOutSine,
          )
          .fadeIn(duration: 1.seconds, delay: delay.seconds), 
    );
  }
}
