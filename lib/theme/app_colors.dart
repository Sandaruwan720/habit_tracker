import 'package:flutter/material.dart';

/// Centralized color palette for the Habit Tracker app.
/// Dark-mode optimized with glassmorphism-friendly surface colors.
class AppColors {
  AppColors._();

  // ── Backgrounds ────────────────────────────────────────────────────────────
  static const Color background = Color(0xFF0F172A);
  static const Color backgroundSecondary = Color(0xFF1E293B);
  static const Color backgroundTertiary = Color(0xFF334155);

  // ── Glass Surfaces ─────────────────────────────────────────────────────────
  static const Color glassSurface = Color(0x14FFFFFF); // rgba(255,255,255,0.08)
  static const Color glassBorder = Color(0x1AFFFFFF);  // rgba(255,255,255,0.10)
  static const Color glassHighlight = Color(0x26FFFFFF);

  // ── Accent Colors ──────────────────────────────────────────────────────────
  static const Color primary = Color(0xFF6366F1);       // Indigo
  static const Color primaryLight = Color(0xFF818CF8);
  static const Color primaryDark = Color(0xFF4F46E5);

  static const Color secondary = Color(0xFF22C55E);     // Green
  static const Color secondaryLight = Color(0xFF4ADE80);

  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);

  // ── Text Colors ────────────────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textMuted = Color(0xFF64748B);

  // ── Gradient Definitions ───────────────────────────────────────────────────
  static const LinearGradient avatarBorderGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF6366F1), Color(0xFF22C55E), Color(0xFF06B6D4)],
    stops: [0.0, 0.5, 1.0],
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
  );

  static const LinearGradient headerGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0F172A), Color(0xFF1A1F3C)],
  );

  static const RadialGradient avatarGlow = RadialGradient(
    colors: [Color(0x3D6366F1), Colors.transparent],
    radius: 0.8,
  );

  // ── Notification Badge ─────────────────────────────────────────────────────
  static const Color notificationBadge = Color(0xFFEF4444);

  // ── Status Indicator ──────────────────────────────────────────────────────
  static const Color onlineStatus = Color(0xFF22C55E);
}
