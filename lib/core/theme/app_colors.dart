import 'package:flutter/material.dart';

/// ComoPrecio Color Palette
/// Dark theme optimized for price comparison app
class AppColors {
  AppColors._();

  // ═══════════════════════════════════════════════════════════════════════════
  // DARK THEME (PRIMARY)
  // ═══════════════════════════════════════════════════════════════════════════

  // Backgrounds
  static const Color darkBackground = Color(0xFF0A0A0B);
  static const Color darkSurface = Color(0xFF121214);
  static const Color darkCard = Color(0xFF1A1A1E);
  static const Color darkCardHover = Color(0xFF222226);

  // Surface variations
  static const Color surfaceVariant = Color(0xFF2A2A2E);
  static const Color surfaceBright = Color(0xFF323236);

  // ═══════════════════════════════════════════════════════════════════════════
  // ACCENT COLORS
  // ═══════════════════════════════════════════════════════════════════════════

  // Primary - Emerald Green (Best Price / Success)
  static const Color primary = Color(0xFF00E676);
  static const Color primaryLight = Color(0xFF69F0AE);
  static const Color primaryDark = Color(0xFF00C853);
  static const Color primaryMuted = Color(0xFF00E676);

  // Secondary - Electric Blue (Links / Actions)
  static const Color secondary = Color(0xFF2979FF);
  static const Color secondaryLight = Color(0xFF75A7FF);
  static const Color secondaryDark = Color(0xFF0D47A1);

  // Accent - Amber Orange (Alerts / Warnings)
  static const Color accent = Color(0xFFFF9100);
  static const Color accentLight = Color(0xFFFFAB40);
  static const Color accentDark = Color(0xFFFF6D00);

  // Error - Coral Red (Price Up / Errors)
  static const Color error = Color(0xFFFF5252);
  static const Color errorLight = Color(0xFFFF8A80);
  static const Color errorDark = Color(0xFFD32F2F);

  // ═══════════════════════════════════════════════════════════════════════════
  // TEXT COLORS
  // ═══════════════════════════════════════════════════════════════════════════

  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB3B3B3);
  static const Color textMuted = Color(0xFF757575);
  static const Color textDisabled = Color(0xFF4A4A4A);

  // ═══════════════════════════════════════════════════════════════════════════
  // SEMANTIC COLORS
  // ═══════════════════════════════════════════════════════════════════════════

  // Price indicators
  static const Color priceBest = Color(0xFF00E676);     // Lowest price
  static const Color priceGood = Color(0xFF69F0AE);     // Good deal
  static const Color priceNeutral = Color(0xFFB3B3B3);  // Average
  static const Color priceHigh = Color(0xFFFF9100);     // Above average
  static const Color priceHighest = Color(0xFFFF5252);  // Expensive

  // Confidence indicators
  static const Color confidenceHigh = Color(0xFF00E676);    // 90%+
  static const Color confidenceMedium = Color(0xFFFF9100);  // 70-90%
  static const Color confidenceLow = Color(0xFFFF5252);     // <70%

  // Stock status
  static const Color inStock = Color(0xFF00E676);
  static const Color lowStock = Color(0xFFFF9100);
  static const Color outOfStock = Color(0xFFFF5252);

  // ═══════════════════════════════════════════════════════════════════════════
  // STORE BRAND COLORS
  // ═══════════════════════════════════════════════════════════════════════════

  static const Color amazonOrange = Color(0xFFFF9900);
  static const Color aliexpressRed = Color(0xFFE62E04);
  static const Color ebayBlue = Color(0xFF0064D2);
  static const Color pcComponentesOrange = Color(0xFFFF6600);
  static const Color mediaMarktRed = Color(0xFFDF0000);
  static const Color banggoodOrange = Color(0xFFFF6600);

  // ═══════════════════════════════════════════════════════════════════════════
  // GRADIENTS
  // ═══════════════════════════════════════════════════════════════════════════

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [darkCard, darkCardHover],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient priceDropGradient = LinearGradient(
    colors: [primary, Color(0xFF00BFA5)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient shimmerGradient = LinearGradient(
    colors: [
      surfaceVariant,
      surfaceBright,
      surfaceVariant,
    ],
    stops: [0.0, 0.5, 1.0],
    begin: Alignment(-1.0, -0.3),
    end: Alignment(1.0, 0.3),
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // SHADOWS
  // ═══════════════════════════════════════════════════════════════════════════

  static List<BoxShadow> get cardShadow => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.3),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ];

  static List<BoxShadow> get elevatedShadow => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.4),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ];

  static List<BoxShadow> get glowShadow => [
        BoxShadow(
          color: primary.withValues(alpha: 0.3),
          blurRadius: 20,
          spreadRadius: 2,
        ),
      ];
}
