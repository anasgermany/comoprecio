import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_typography.dart';

/// App-wide theme configuration
class AppTheme {
  AppTheme._();

  /// Dark theme (primary)
  static ThemeData get darkTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,

        // Colors
        colorScheme: const ColorScheme.dark(
          primary: AppColors.primary,
          onPrimary: AppColors.darkBackground,
          secondary: AppColors.secondary,
          onSecondary: Colors.white,
          tertiary: AppColors.accent,
          error: AppColors.error,
          surface: AppColors.darkSurface,
          onSurface: AppColors.textPrimary,
        ),

        // Scaffold
        scaffoldBackgroundColor: AppColors.darkBackground,

        // AppBar
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.darkBackground,
          foregroundColor: AppColors.textPrimary,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: AppTypography.headlineMedium,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
            systemNavigationBarColor: AppColors.darkBackground,
            systemNavigationBarIconBrightness: Brightness.light,
          ),
        ),

        // Cards
        cardTheme: CardThemeData(
          color: AppColors.darkCard,
          elevation: 0,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),

        // Bottom Navigation
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.darkSurface,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textMuted,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
        ),

        // Navigation Bar (Material 3)
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: AppColors.darkSurface,
          indicatorColor: AppColors.primary.withValues(alpha: 0.2),
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return AppTypography.labelSmall.copyWith(
                color: AppColors.primary,
              );
            }
            return AppTypography.labelSmall.copyWith(
              color: AppColors.textMuted,
            );
          }),
          iconTheme: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const IconThemeData(color: AppColors.primary);
            }
            return const IconThemeData(color: AppColors.textMuted);
          }),
        ),

        // Buttons
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.darkBackground,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: AppTypography.labelLarge,
          ),
        ),

        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.textPrimary,
            side: const BorderSide(color: AppColors.surfaceVariant),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: AppTypography.labelLarge,
          ),
        ),

        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            textStyle: AppTypography.labelLarge,
          ),
        ),

        // Input Decoration
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.darkCard,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          hintStyle: AppTypography.bodyMedium.copyWith(
            color: AppColors.textMuted,
          ),
          labelStyle: AppTypography.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: AppColors.surfaceVariant,
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: AppColors.primary,
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: AppColors.error,
              width: 1,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: AppColors.error,
              width: 2,
            ),
          ),
        ),

        // Chips
        chipTheme: ChipThemeData(
          backgroundColor: AppColors.surfaceVariant,
          labelStyle: AppTypography.labelMedium,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          side: BorderSide.none,
        ),

        // Divider
        dividerTheme: const DividerThemeData(
          color: AppColors.surfaceVariant,
          thickness: 1,
          space: 1,
        ),

        // Dialog
        dialogTheme: DialogThemeData(
          backgroundColor: AppColors.darkCard,
          elevation: 24,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          titleTextStyle: AppTypography.headlineSmall,
          contentTextStyle: AppTypography.bodyMedium,
        ),

        // Bottom Sheet
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: AppColors.darkCard,
          elevation: 24,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          dragHandleColor: AppColors.surfaceVariant,
          dragHandleSize: Size(40, 4),
          showDragHandle: true,
        ),

        // Snackbar
        snackBarTheme: SnackBarThemeData(
          backgroundColor: AppColors.darkCard,
          contentTextStyle: AppTypography.bodyMedium,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),

        // Progress Indicator
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: AppColors.primary,
          linearTrackColor: AppColors.surfaceVariant,
        ),

        // Slider
        sliderTheme: SliderThemeData(
          activeTrackColor: AppColors.primary,
          inactiveTrackColor: AppColors.surfaceVariant,
          thumbColor: AppColors.primary,
          overlayColor: AppColors.primary.withValues(alpha: 0.2),
        ),

        // Switch
        switchTheme: SwitchThemeData(
          thumbColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return AppColors.primary;
            }
            return AppColors.textMuted;
          }),
          trackColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return AppColors.primary.withValues(alpha: 0.4);
            }
            return AppColors.surfaceVariant;
          }),
        ),

        // Tab Bar
        tabBarTheme: TabBarThemeData(
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textMuted,
          labelStyle: AppTypography.labelLarge,
          unselectedLabelStyle: AppTypography.labelLarge,
          indicator: const UnderlineTabIndicator(
            borderSide: BorderSide(
              color: AppColors.primary,
              width: 3,
            ),
          ),
        ),

        // Icon
        iconTheme: const IconThemeData(
          color: AppColors.textPrimary,
          size: 24,
        ),

        // Text Theme
        textTheme: TextTheme(
          displayLarge: AppTypography.displayLarge,
          displayMedium: AppTypography.displayMedium,
          displaySmall: AppTypography.displaySmall,
          headlineLarge: AppTypography.headlineLarge,
          headlineMedium: AppTypography.headlineMedium,
          headlineSmall: AppTypography.headlineSmall,
          titleLarge: AppTypography.titleLarge,
          titleMedium: AppTypography.titleMedium,
          titleSmall: AppTypography.titleSmall,
          bodyLarge: AppTypography.bodyLarge,
          bodyMedium: AppTypography.bodyMedium,
          bodySmall: AppTypography.bodySmall,
          labelLarge: AppTypography.labelLarge,
          labelMedium: AppTypography.labelMedium,
          labelSmall: AppTypography.labelSmall,
        ),
      );
}
