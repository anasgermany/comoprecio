import 'package:flutter/material.dart';

/// Typography system for ComoPrecio
class AppTypography {
  AppTypography._();

  // ═══════════════════════════════════════════════════════════════════════════
  // BASE FONT
  // ═══════════════════════════════════════════════════════════════════════════

  static String get fontFamily => 'Inter';

  static TextStyle get _baseStyle => const TextStyle(
        fontFamily: 'Inter',
        color: Colors.white,
        letterSpacing: -0.2,
      );

  // ═══════════════════════════════════════════════════════════════════════════
  // DISPLAY STYLES
  // ═══════════════════════════════════════════════════════════════════════════

  /// Large display for hero sections
  static TextStyle get displayLarge => _baseStyle.copyWith(
        fontSize: 48,
        fontWeight: FontWeight.w700,
        height: 1.1,
        letterSpacing: -1.5,
      );

  /// Medium display for section headers
  static TextStyle get displayMedium => _baseStyle.copyWith(
        fontSize: 36,
        fontWeight: FontWeight.w700,
        height: 1.15,
        letterSpacing: -1.0,
      );

  /// Small display
  static TextStyle get displaySmall => _baseStyle.copyWith(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        height: 1.2,
        letterSpacing: -0.5,
      );

  // ═══════════════════════════════════════════════════════════════════════════
  // HEADLINE STYLES
  // ═══════════════════════════════════════════════════════════════════════════

  /// Screen titles
  static TextStyle get headlineLarge => _baseStyle.copyWith(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        height: 1.25,
        letterSpacing: -0.3,
      );

  /// Section headers
  static TextStyle get headlineMedium => _baseStyle.copyWith(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 1.3,
      );

  /// Subsection headers
  static TextStyle get headlineSmall => _baseStyle.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 1.35,
      );

  // ═══════════════════════════════════════════════════════════════════════════
  // TITLE STYLES
  // ═══════════════════════════════════════════════════════════════════════════

  /// Card titles, list item titles
  static TextStyle get titleLarge => _baseStyle.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.4,
      );

  /// Secondary titles
  static TextStyle get titleMedium => _baseStyle.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.4,
      );

  /// Small titles
  static TextStyle get titleSmall => _baseStyle.copyWith(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        height: 1.4,
      );

  // ═══════════════════════════════════════════════════════════════════════════
  // BODY STYLES
  // ═══════════════════════════════════════════════════════════════════════════

  /// Primary body text
  static TextStyle get bodyLarge => _baseStyle.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5,
      );

  /// Secondary body text
  static TextStyle get bodyMedium => _baseStyle.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.5,
      );

  /// Small body text
  static TextStyle get bodySmall => _baseStyle.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.5,
      );

  // ═══════════════════════════════════════════════════════════════════════════
  // LABEL STYLES
  // ═══════════════════════════════════════════════════════════════════════════

  /// Button labels
  static TextStyle get labelLarge => _baseStyle.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.2,
        letterSpacing: 0.1,
      );

  /// Secondary labels
  static TextStyle get labelMedium => _baseStyle.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 1.3,
        letterSpacing: 0.5,
      );

  /// Caption labels
  static TextStyle get labelSmall => _baseStyle.copyWith(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        height: 1.3,
        letterSpacing: 0.5,
      );

  // ═══════════════════════════════════════════════════════════════════════════
  // SPECIAL STYLES
  // ═══════════════════════════════════════════════════════════════════════════

  /// Large price display
  static TextStyle get priceXLarge => _baseStyle.copyWith(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        height: 1.0,
        letterSpacing: -0.5,
      );

  /// Standard price
  static TextStyle get priceLarge => _baseStyle.copyWith(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        height: 1.0,
        letterSpacing: -0.3,
      );

  /// Medium price
  static TextStyle get priceMedium => _baseStyle.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        height: 1.0,
      );

  /// Small price
  static TextStyle get priceSmall => _baseStyle.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.0,
      );

  /// Strikethrough original price
  static TextStyle get priceStrikethrough => _baseStyle.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.0,
        decoration: TextDecoration.lineThrough,
        color: Colors.grey,
      );

  /// Badge text
  static TextStyle get badge => _baseStyle.copyWith(
        fontSize: 10,
        fontWeight: FontWeight.w700,
        height: 1.0,
        letterSpacing: 0.5,
      );

  /// Monospace for codes/UPC
  static TextStyle get mono => _baseStyle.copyWith(
        fontFamily: 'monospace',
        fontSize: 13,
        fontWeight: FontWeight.w400,
        letterSpacing: 1.0,
      );
}
