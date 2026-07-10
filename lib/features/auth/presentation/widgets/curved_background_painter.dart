import 'package:flutter/material.dart';

/// Clips the right hero panel with a smooth organic S-curve on its left edge,
/// creating the signature split-panel wave separator.
class HeroPanelClipper extends CustomClipper<Path> {
  const HeroPanelClipper();

  @override
  Path getClip(Size size) {
    final path = Path()
      ..moveTo(60, 0)
      ..cubicTo(
        -50, size.height * 0.30,
        120, size.height * 0.65,
        55, size.height,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(size.width, 0)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

/// Paints the glow-accent wave that sits on top of the panel join,
/// giving it a neon edge highlight effect.
class CurvedEdgePainter extends CustomPainter {
  const CurvedEdgePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0x8022C55E), // green glow at top
          Color(0x606366F1), // indigo mid
          Color(0x4022C55E), // green at bottom
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);

    final path = Path()
      ..moveTo(60, 0)
      ..cubicTo(
        -50, size.height * 0.30,
        120, size.height * 0.65,
        55, size.height,
      );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
