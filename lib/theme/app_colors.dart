import 'package:flutter/material.dart';

/// Centralized color palette for the Habit Tracker app.
/// Dark-mode optimized with glassmorphism-friendly surface colors.
class AppColors {
  AppColors._();

  // ── Backgrounds ────────────────────────────────────────────────────────────
  static const Color background = Color(0xFF0B0F17);
  static const Color backgroundSecondary = Color(0xFF121826);
  static const Color backgroundTertiary = Color(0xFF1E293B);
  static const Color cardBackground = Color(0xFF121826);

  // ── Glass Surfaces ─────────────────────────────────────────────────────────
  static const Color glassSurface = Color(0x14FFFFFF); // rgba(255,255,255,0.08)
  static const Color glassBorder = Color(0x0FFFFFFF);  // rgba(255,255,255,0.06)
  static const Color glassHighlight = Color(0x26FFFFFF);
  static const Color glassInner = Color(0x08FFFFFF);

  // ── Primary Accent — Indigo ────────────────────────────────────────────────
  static const Color primary = Color(0xFF6366F1);
  static const Color primaryLight = Color(0xFF818CF8);
  static const Color primaryDark = Color(0xFF4F46E5);
  static const Color accentPurple = Color(0xFF6366F1);

  // ── Secondary — Green (Progress) ──────────────────────────────────────────
  static const Color secondary = Color(0xFF22C55E);
  static const Color secondaryLight = Color(0xFF4ADE80);
  static const Color progressGreen = Color(0xFF22C55E);
  static const Color progressGreenEnd = Color(0xFF10B981);

  // ── Semantic ───────────────────────────────────────────────────────────────
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color streakOrange = Color(0xFFF97316);
  static const Color error = Color(0xFFEF4444);
  static const Color accentCyan = Color(0xFF06B6D4);

  // ── Text ───────────────────────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textMuted = Color(0xFF64748B);
  static const Color textTertiary = Color(0xFF475569);

  // ── Notification Badge ─────────────────────────────────────────────────────
  static const Color notificationBadge = Color(0xFFEF4444);
  static const Color onlineStatus = Color(0xFF22C55E);

  // ── Gradients ──────────────────────────────────────────────────────────────
  static const LinearGradient avatarBorderGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF6366F1), Color(0xFF22C55E), Color(0xFF06B6D4)],
    stops: [0.0, 0.5, 1.0],
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF0B0F17), Color(0xFF121826)],
  );

  static const LinearGradient headerGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0B0F17), Color(0xFF131927)],
  );

  /// Progress ring & bar gradient — green sweep
  static const LinearGradient progressGradient = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    colors: [Color(0xFF22C55E), Color(0xFF10B981)],
  );

  /// Indigo accent gradient
  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
  );

  /// Warm orange gradient — streak fire
  static const LinearGradient streakGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFF97316), Color(0xFFEF4444)],
  );

  /// Glow color helpers (low-opacity for box shadows)
  static Color get greenGlow =>
      const Color(0xFF22C55E).withValues(alpha: 0.25);
  static Color get indigoGlow =>
      const Color(0xFF6366F1).withValues(alpha: 0.25);
  static Color get orangeGlow =>
      const Color(0xFFF97316).withValues(alpha: 0.25);

  static const RadialGradient avatarGlow = RadialGradient(
    colors: [Color(0x3D6366F1), Colors.transparent],
    radius: 0.8,
  );
}
