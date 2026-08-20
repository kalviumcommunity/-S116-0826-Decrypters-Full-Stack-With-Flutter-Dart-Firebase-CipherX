import 'package:flutter/material.dart';

abstract class AppColors {
  // Brand Primary & Accent (Security Palette)
  static const Color primary = Color(0xFF0F52BA); // Shield Sapphire Blue
  static const Color primaryDark = Color(0xFF0A367C);
  static const Color accentGold = Color(0xFFF59E0B); // Security Gold Accent

  // Background & Surface Neutrals
  static const Color backgroundLight = Color(0xFFF8FAFC);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color backgroundDark = Color(0xFF0F172A);
  static const Color surfaceDark = Color(0xFF1E293B);

  // Status & System Colors
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // Text Neutral Colors
  static const Color textPrimaryLight = Color(0xFF0F172A);
  static const Color textSecondaryLight = Color(0xFF64748B);
  static const Color textPrimaryDark = Color(0xFFF8FAFC);
  static const Color textSecondaryDark = Color(0xFF94A3B8);

  // Borders & Dividers
  static const Color borderLight = Color(0xFFE2E8F0);
  static const Color borderDark = Color(0xFF334155);
}
