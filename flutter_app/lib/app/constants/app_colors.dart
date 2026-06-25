import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ── Brand ──────────────────────────────────────────────────────────────────
  static const primary = Color(0xFF0F4C81);
  static const primaryDark = Color(0xFF1F4E8C);
  static const secondary = Color(0xFF2563EB);
  static const success = Color(0xFF4DB6AC);
  static const warning = Color(0xFFFFC83D);
  static const info = Color(0xFFE3F2FD);
  static const error = Color(0xFFDC2626);

  // ── Backgrounds ────────────────────────────────────────────────────────────
  static const background = Color(0xFFF5F7FA);
  static const surfaceLight = Color(0xFFF9FAFB);
  static const white = Colors.white;

  /// Subtle off-white used for expanded child rows in tree cards
  static const subtleBg = Color(0xFFFAFBFC);

  // ── Surface / Card ─────────────────────────────────────────────────────────
  /// Alias kept for widget compatibility (maps to [white])
  static const surface = white;

  // ── Borders & Dividers ─────────────────────────────────────────────────────
  static const border = Color(0xFFE2E8F0);
  static const outline = Color(0xFFE0E0E0);

  /// Divider colour used inside tree cards
  static const divider = Color(0xFFE5E7EB);

  // ── Text ───────────────────────────────────────────────────────────────────
  static const textPrimary = Color(0xFF1E293B);
  static const textHeading = Color(0xFF1F2937);
  static const textSecondary = Color(0xFF64748B);
  static const textMuted = Color(0xFF6B7280);
  static const hint = Color(0xFFB0BEC5);
  static const muted = Color(0xFF9CA3AF);

  // ── Misc ───────────────────────────────────────────────────────────────────
  static const shadow = Color(0x0D000000);
}
