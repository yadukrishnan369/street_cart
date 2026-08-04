import 'package:flutter/material.dart';

class ShopAppColors {
  // Primary Theme Colors
  static const Color primary = Color(0xFF00674F);
  static const Color primaryLight = Color(
    0xFFE6F2F0,
  ); // Very light teal for cards
  static const Color accent = Color(0xFFE7F3EF);

  // Neutral Colors
  static const Color background = Color(0xFFF9F9F9);
  static const Color surface = Colors.white;

  // Text Colors
  static const Color textPrimary = Color(0xFF1B242C);
  static const Color textSecondary = Color(0xFF5A6A85);
  static const Color textTertiary = Color(0xFF94A3B8);
  static const Color textLight = Colors.white;

  // Status Colors
  static const Color success = Color(0xFF10B981);
  static const Color successBg = Color(0xFFDCFCE7);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);

  // Border & Divider
  static const Color border = Color(0xFFE2E8F0);

  // Dark Mode Background & Surface
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkTextPrimary = Color(0xFFF3F4F6);
  static const Color darkTextSecondary = Color(0xFF9CA3AF);
  static const Color darkBorder = Color(0xFF2D2D2D);
  static const Color darkInputBackground = Color(0xFF242424);

  static Color getColorFromName(String name) {
    switch (name.toLowerCase().trim()) {
      case 'black':
        return Colors.black;
      case 'blue':
        return Colors.blue;
      case 'red':
        return Colors.red;
      case 'white':
        return Colors.white;
      case 'green':
        return Colors.green;
      case 'orange':
        return Colors.orange;
      case 'purple':
      case 'violet':
        return Colors.purple;
      case 'pink':
        return Colors.pink;
      case 'yellow':
        return Colors.yellow;
      case 'teal':
        return Colors.teal;
      case 'cyan':
        return Colors.cyan;
      case 'brown':
        return Colors.brown;
      case 'grey':
        return Colors.grey;
      case 'navy':
        return const Color(0xFF000080);
      case 'maroon':
        return const Color(0xFF800000);
      case 'gold':
        return const Color(0xFFFFD700);
      case 'silver':
        return const Color(0xFFC0C0C0);
      default:
        // Support hex codes for backward compatibility
        String hexStr = name.trim();
        if (hexStr.startsWith('#')) {
          hexStr = hexStr.substring(1);
        } else if (hexStr.toLowerCase().startsWith('0x')) {
          hexStr = hexStr.substring(2);
        }
        final hexRegex = RegExp(r'^[0-9a-fA-F]+$');
        if ((hexStr.length == 6 || hexStr.length == 8) &&
            hexRegex.hasMatch(hexStr)) {
          try {
            if (hexStr.length == 6) {
              hexStr = 'FF$hexStr';
            }
            final value = int.parse(hexStr, radix: 16);
            return Color(value);
          } catch (_) {}
        }
        return Colors.grey;
    }
  }
}
