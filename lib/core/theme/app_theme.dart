import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import 'app_text_styles.dart';

/// App Theme for Cebuano Journey
class AppTheme {
  AppTheme._();

  // Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      // Color Scheme
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        onPrimary: AppColors.textWhite,
        primaryContainer: AppColors.primaryLight,
        onPrimaryContainer: AppColors.textPrimary,

        secondary: AppColors.secondary,
        onSecondary: AppColors.textWhite,
        secondaryContainer: AppColors.secondaryLight,
        onSecondaryContainer: AppColors.textPrimary,

        tertiary: AppColors.accent,
        onTertiary: AppColors.textWhite,
        tertiaryContainer: AppColors.accentLight,
        onTertiaryContainer: AppColors.textPrimary,

        error: AppColors.error,
        onError: AppColors.textWhite,
        errorContainer: AppColors.errorLight,
        onErrorContainer: AppColors.textPrimary,

        outline: AppColors.border,
        outlineVariant: AppColors.border,

        surface: AppColors.surface,
        onSurface: AppColors.textPrimary,
        surfaceContainerHighest: AppColors.background,
        onSurfaceVariant: AppColors.textSecondary,

        inverseSurface: AppColors.primaryDark,
        onInverseSurface: AppColors.textWhite,

        shadow: AppColors.shadow,
        scrim: AppColors.overlay,
      ),

      // Scaffold Background
      scaffoldBackgroundColor: AppColors.background,

      // App Bar Theme
      appBarTheme: const AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 1,
        centerTitle: true,
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        iconTheme: IconThemeData(color: AppColors.textPrimary),
        titleTextStyle: TextStyle(
          fontFamily: AppTextStyles.fontFamilyMedium,
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        elevation: 2,
        shadowColor: AppColors.shadow,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: AppColors.surface,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: AppTextStyles.buttonMedium.copyWith(
            fontFamily: AppTextStyles.fontFamilyMedium,
          ),
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: AppTextStyles.buttonMedium.copyWith(
            fontFamily: AppTextStyles.fontFamilyMedium,
          ),
        ),
      ),

      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          side: const BorderSide(color: AppColors.border, width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: AppTextStyles.buttonMedium.copyWith(
            fontFamily: AppTextStyles.fontFamilyMedium,
          ),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.background,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        labelStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textSecondary,
        ),
        hintStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textTertiary,
        ),
        errorStyle: AppTextStyles.bodySmall.copyWith(color: AppColors.error),
      ),

      // Text Theme
      textTheme: TextTheme(
        displayLarge: AppTextStyles.displayLarge,
        displayMedium: AppTextStyles.displayMedium,
        displaySmall: AppTextStyles.displaySmall,
        headlineLarge: AppTextStyles.headlineLarge,
        headlineMedium: AppTextStyles.headlineMedium,
        headlineSmall: AppTextStyles.headlineSmall,
        titleLarge: AppTextStyles.titleLarge,
        titleMedium: AppTextStyles.titleMedium,
        titleSmall: AppTextStyles.titleSmall,
        bodyLarge: AppTextStyles.bodyLarge,
        bodyMedium: AppTextStyles.bodyMedium,
        bodySmall: AppTextStyles.bodySmall,
        labelLarge: AppTextStyles.labelLarge,
        labelMedium: AppTextStyles.labelMedium,
        labelSmall: AppTextStyles.labelSmall,
      ),

      // Icon Theme
      iconTheme: const IconThemeData(color: AppColors.textPrimary, size: 24),

      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: AppColors.border,
        thickness: 1,
        space: 1,
      ),

      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.background,
        deleteIconColor: AppColors.textSecondary,
        disabledColor: AppColors.border,
        selectedColor: AppColors.primaryLight,
        secondarySelectedColor: AppColors.secondaryLight,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        labelStyle: AppTextStyles.labelMedium,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),

      // Dialog Theme
      dialogTheme: DialogThemeData(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: AppColors.surface,
        titleTextStyle: AppTextStyles.headlineSmall,
        contentTextStyle: AppTextStyles.bodyMedium,
      ),

      // Bottom Sheet Theme
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        elevation: 8,
      ),

      // Snack Bar Theme
      snackBarTheme: SnackBarThemeData(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        behavior: SnackBarBehavior.floating,
        contentTextStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textWhite,
        ),
      ),

      // Floating Action Button Theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),

      // Tab Bar Theme
      tabBarTheme: const TabBarThemeData(
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.textTertiary,
        labelStyle: TextStyle(
          fontFamily: AppTextStyles.fontFamilyMedium,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: AppTextStyles.fontFamilyRegular,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
      ),
    );
  }

  // Dark Theme
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      // Color Scheme
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryLight,
        onPrimary: AppColors.textPrimary,
        primaryContainer: AppColors.primaryDark,
        onPrimaryContainer: AppColors.textWhite,

        secondary: AppColors.secondaryLight,
        onSecondary: AppColors.textPrimary,
        secondaryContainer: AppColors.secondaryDark,
        onSecondaryContainer: AppColors.textWhite,

        tertiary: AppColors.accentLight,
        onTertiary: AppColors.textPrimary,
        tertiaryContainer: AppColors.accentDark,
        onTertiaryContainer: AppColors.textWhite,

        error: AppColors.error,
        onError: AppColors.textWhite,
        errorContainer: AppColors.errorLight,
        onErrorContainer: AppColors.textPrimary,

        outline: AppColors.borderDark,
        outlineVariant: AppColors.borderDark,

        surface: AppColors.surfaceDark,
        onSurface: AppColors.textWhite,
        surfaceContainerHighest: AppColors.backgroundDark,
        onSurfaceVariant: AppColors.textTertiary,

        inverseSurface: AppColors.primaryLight,
        onInverseSurface: AppColors.textPrimary,

        shadow: AppColors.shadowDark,
        scrim: AppColors.overlay,
      ),

      // Scaffold Background
      scaffoldBackgroundColor: AppColors.backgroundDark,

      // App Bar Theme
      appBarTheme: const AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 1,
        centerTitle: true,
        backgroundColor: AppColors.surfaceDark,
        foregroundColor: AppColors.textWhite,
        iconTheme: IconThemeData(color: AppColors.textWhite),
        titleTextStyle: TextStyle(
          fontFamily: AppTextStyles.fontFamilyMedium,
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: AppColors.textWhite,
        ),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        elevation: 2,
        shadowColor: AppColors.shadowDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: AppColors.surfaceDark,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: AppTextStyles.buttonMedium.copyWith(
            fontFamily: AppTextStyles.fontFamilyMedium,
          ),
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: AppTextStyles.buttonMedium.copyWith(
            fontFamily: AppTextStyles.fontFamilyMedium,
          ),
        ),
      ),

      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          side: const BorderSide(color: AppColors.borderDark, width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: AppTextStyles.buttonMedium.copyWith(
            fontFamily: AppTextStyles.fontFamilyMedium,
          ),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.backgroundDark,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderDark),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderDark),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primaryLight, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        labelStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textTertiary,
        ),
        hintStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textTertiary.withValues(alpha: 0.7),
        ),
        errorStyle: AppTextStyles.bodySmall.copyWith(color: AppColors.error),
      ),

      // Text Theme
      textTheme: TextTheme(
        displayLarge: AppTextStyles.displayLarge.copyWith(
          color: AppColors.textWhite,
        ),
        displayMedium: AppTextStyles.displayMedium.copyWith(
          color: AppColors.textWhite,
        ),
        displaySmall: AppTextStyles.displaySmall.copyWith(
          color: AppColors.textWhite,
        ),
        headlineLarge: AppTextStyles.headlineLarge.copyWith(
          color: AppColors.textWhite,
        ),
        headlineMedium: AppTextStyles.headlineMedium.copyWith(
          color: AppColors.textWhite,
        ),
        headlineSmall: AppTextStyles.headlineSmall.copyWith(
          color: AppColors.textWhite,
        ),
        titleLarge: AppTextStyles.titleLarge.copyWith(
          color: AppColors.textWhite,
        ),
        titleMedium: AppTextStyles.titleMedium.copyWith(
          color: AppColors.textWhite,
        ),
        titleSmall: AppTextStyles.titleSmall.copyWith(
          color: AppColors.textWhite,
        ),
        bodyLarge: AppTextStyles.bodyLarge.copyWith(
          color: AppColors.textSecondary,
        ),
        bodyMedium: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textSecondary,
        ),
        bodySmall: AppTextStyles.bodySmall.copyWith(
          color: AppColors.textTertiary,
        ),
        labelLarge: AppTextStyles.labelLarge.copyWith(
          color: AppColors.textWhite,
        ),
        labelMedium: AppTextStyles.labelMedium.copyWith(
          color: AppColors.textWhite,
        ),
        labelSmall: AppTextStyles.labelSmall.copyWith(
          color: AppColors.textWhite,
        ),
      ),

      // Icon Theme
      iconTheme: const IconThemeData(color: AppColors.textWhite, size: 24),

      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: AppColors.borderDark,
        thickness: 1,
        space: 1,
      ),

      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.backgroundDark,
        deleteIconColor: AppColors.textTertiary,
        disabledColor: AppColors.borderDark,
        selectedColor: AppColors.primaryDark,
        secondarySelectedColor: AppColors.secondaryDark,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        labelStyle: AppTextStyles.labelMedium.copyWith(
          color: AppColors.textWhite,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),

      // Dialog Theme
      dialogTheme: DialogThemeData(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: AppColors.surfaceDark,
        titleTextStyle: AppTextStyles.headlineSmall.copyWith(
          color: AppColors.textWhite,
        ),
        contentTextStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textSecondary,
        ),
      ),

      // Bottom Sheet Theme
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.surfaceDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        elevation: 8,
      ),

      // Snack Bar Theme
      snackBarTheme: SnackBarThemeData(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        behavior: SnackBarBehavior.floating,
        contentTextStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textWhite,
        ),
      ),

      // Floating Action Button Theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),

      // Tab Bar Theme
      tabBarTheme: const TabBarThemeData(
        labelColor: AppColors.primaryLight,
        unselectedLabelColor: AppColors.textTertiary,
        labelStyle: TextStyle(
          fontFamily: AppTextStyles.fontFamilyMedium,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: AppTextStyles.fontFamilyRegular,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(color: AppColors.primaryLight, width: 2),
        ),
      ),
    );
  }

  // Game Theme (Special theme for game screens)
  static ThemeData get gameTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      // Color Scheme
      colorScheme: const ColorScheme.dark(
        primary: AppColors.gamePrimary,
        onPrimary: AppColors.textWhite,
        primaryContainer: AppColors.gameSurface,
        onPrimaryContainer: AppColors.textWhite,

        secondary: AppColors.gameSecondary,
        onSecondary: AppColors.textWhite,
        secondaryContainer: AppColors.gameSurface,
        onSecondaryContainer: AppColors.textWhite,

        tertiary: AppColors.gameAccent,
        onTertiary: AppColors.textWhite,
        tertiaryContainer: AppColors.gameSurface,
        onTertiaryContainer: AppColors.textWhite,

        surface: AppColors.gameBackground,
        onSurface: AppColors.textWhite,
        surfaceContainerHighest: AppColors.gameSurface,
        onSurfaceVariant: AppColors.textTertiary,

        outline: AppColors.borderDark,
        outlineVariant: AppColors.borderDark,
      ),

      // Scaffold Background
      scaffoldBackgroundColor: AppColors.gameBackground,

      // App Bar Theme
      appBarTheme: const AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.textWhite,
        iconTheme: IconThemeData(color: AppColors.textWhite),
        titleTextStyle: TextStyle(
          fontFamily: AppTextStyles.fontFamilyBold,
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: AppColors.textWhite,
        ),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        elevation: 4,
        shadowColor: AppColors.shadowDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: AppColors.gameSurface,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),

      // Text Theme
      textTheme: TextTheme(
        displayLarge: AppTextStyles.displayLarge.copyWith(
          color: AppColors.textWhite,
        ),
        displayMedium: AppTextStyles.displayMedium.copyWith(
          color: AppColors.textWhite,
        ),
        displaySmall: AppTextStyles.displaySmall.copyWith(
          color: AppColors.textWhite,
        ),
        headlineLarge: AppTextStyles.headlineLarge.copyWith(
          color: AppColors.textWhite,
        ),
        headlineMedium: AppTextStyles.headlineMedium.copyWith(
          color: AppColors.textWhite,
        ),
        headlineSmall: AppTextStyles.headlineSmall.copyWith(
          color: AppColors.textWhite,
        ),
        titleLarge: AppTextStyles.titleLarge.copyWith(
          color: AppColors.textWhite,
        ),
        titleMedium: AppTextStyles.titleMedium.copyWith(
          color: AppColors.textWhite,
        ),
        titleSmall: AppTextStyles.titleSmall.copyWith(
          color: AppColors.textWhite,
        ),
        bodyLarge: AppTextStyles.bodyLarge.copyWith(color: AppColors.textWhite),
        bodyMedium: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textWhite,
        ),
        bodySmall: AppTextStyles.bodySmall.copyWith(
          color: AppColors.textTertiary,
        ),
        labelLarge: AppTextStyles.labelLarge.copyWith(
          color: AppColors.textWhite,
        ),
        labelMedium: AppTextStyles.labelMedium.copyWith(
          color: AppColors.textWhite,
        ),
        labelSmall: AppTextStyles.labelSmall.copyWith(
          color: AppColors.textWhite,
        ),
      ),

      // Icon Theme
      iconTheme: const IconThemeData(color: AppColors.textWhite, size: 28),

      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: AppColors.borderDark,
        thickness: 1,
        space: 1,
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 4,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: AppTextStyles.buttonLarge.copyWith(
            fontFamily: AppTextStyles.fontFamilyBold,
          ),
        ),
      ),
    );
  }
}
