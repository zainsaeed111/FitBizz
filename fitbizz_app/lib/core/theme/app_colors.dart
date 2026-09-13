import 'package:flutter/material.dart';

/// Centralized FittBizz Brand & Semantic Color Tokens (Japani Phal & White Identity)
class AppColors {
  // Japani Phal (Persimmon / Kaki) Primary Palette
  static const Color japaniPhal = Color(0xFFF97316);
  static const Color japaniPhalDark = Color(0xFFEA580C);
  static const Color japaniPhalTerracotta = Color(0xFFC2410C);
  static const Color persimmonCream = Color(0xFFFFEDD5);

  // Stone & White Foundation Tokens
  static const Color stone900 = Color(0xFF1C1917);
  static const Color stone800 = Color(0xFF292524);
  static const Color stone700 = Color(0xFF44403C);
  static const Color stone600 = Color(0xFF57534E);
  static const Color stone500 = Color(0xFF78716C);
  static const Color stone400 = Color(0xFFA8A29E);
  static const Color stone300 = Color(0xFFD6D3D1);
  static const Color stone200 = Color(0xFFE7E5E4);
  static const Color stone100 = Color(0xFFF5F5F4);
  static const Color stone50 = Color(0xFFFAFAF9);
  static const Color pureWhite = Color(0xFFFFFFFF);

  // Legacy & Direct Color Aliases (for backward compatibility)
  static const Color slate900 = Color(0xFF1C1917);
  static const Color slate700 = Color(0xFF44403C);
  static const Color blue600 = Color(0xFFEA580C); // Mapped to Japani Phal Primary
  static const Color blue500 = Color(0xFFF97316);
  static const Color blue50 = Color(0xFFFFEDD5); // Mapped to Japani Phal subtle cream
  static const Color slate50 = Color(0xFFFAFAF9);
  static const Color slate500 = Color(0xFF78716C);
  static const Color slate200 = Color(0xFFE7E5E4);
  static const Color green600 = Color(0xFF16A34A);
  static const Color amber500 = Color(0xFFF59E0B);
  static const Color red600 = Color(0xFFDC2626);

  // Semantic Feedback Tokens
  static const Color successBg = Color(0xFFDCFCE7);
  static const Color successText = Color(0xFF15803D);
  static const Color successBorder = Color(0xFF86EFAC);

  static const Color warningBg = Color(0xFFFEF3C7);
  static const Color warningText = Color(0xFFB45309);
  static const Color warningBorder = Color(0xFFFDE68A);

  static const Color dangerBg = Color(0xFFFEE2E2);
  static const Color dangerText = Color(0xFFB91C1C);
  static const Color dangerBorder = Color(0xFFFCA5A5);

  static const Color infoBg = Color(0xFFFFEDD5);
  static const Color infoText = Color(0xFFC2410C);
  static const Color infoBorder = Color(0xFFFED7AA);

  // Dark Theme Tokens
  static const Color darkBackground = Color(0xFF0C0A09);
  static const Color darkSurface = Color(0xFF1C1917);
  static const Color darkSurfaceElevated = Color(0xFF292524);
  static const Color darkBorder = Color(0xFF292524);

  // Semantic Aliases
  static const Color brand = japaniPhalDark;
  static const Color brandSubtle = persimmonCream;
  static const Color primaryText = stone900;
  static const Color bodyText = stone700;
  static const Color secondaryText = stone500;
  static const Color border = stone200;
  static const Color borderSubtle = Color(0xFFF5F5F4);
  static const Color borderOrange = Color(0xFFFED7AA);
  static const Color background = stone50;
  static const Color surface = pureWhite;
  static const Color surfaceElevated = Color(0xFFFAFAF9);
  static const Color primaryAction = japaniPhalDark;
}
