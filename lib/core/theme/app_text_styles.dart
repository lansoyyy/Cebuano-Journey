import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// App Text Styles using Urbanist Font Family
class AppTextStyles {
  AppTextStyles._();

  // Font Family Names (as defined in pubspec.yaml)
  static const String fontFamilyRegular = 'Regular';
  static const String fontFamilyMedium = 'Medium';
  static const String fontFamilyBold = 'Bold';

  // Default Font Family
  static const String defaultFontFamily = fontFamilyRegular;

  // Base Text Style
  static const TextStyle baseTextStyle = TextStyle(
    fontFamily: defaultFontFamily,
    color: AppColors.textPrimary,
    letterSpacing: 0,
    height: 1.5,
  );

  // Display Styles
  static TextStyle displayLarge = baseTextStyle.copyWith(
    fontFamily: fontFamilyBold,
    fontSize: 57,
    fontWeight: FontWeight.w700,
    height: 1.1,
    letterSpacing: -0.25,
  );

  static TextStyle displayMedium = baseTextStyle.copyWith(
    fontFamily: fontFamilyBold,
    fontSize: 45,
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: 0,
  );

  static TextStyle displaySmall = baseTextStyle.copyWith(
    fontFamily: fontFamilyBold,
    fontSize: 36,
    fontWeight: FontWeight.w700,
    height: 1.3,
    letterSpacing: 0,
  );

  // Headline Styles
  static TextStyle headlineLarge = baseTextStyle.copyWith(
    fontFamily: fontFamilyBold,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 1.3,
    letterSpacing: 0,
  );

  static TextStyle headlineMedium = baseTextStyle.copyWith(
    fontFamily: fontFamilyBold,
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 1.4,
    letterSpacing: 0,
  );

  static TextStyle headlineSmall = baseTextStyle.copyWith(
    fontFamily: fontFamilyMedium,
    fontSize: 24,
    fontWeight: FontWeight.w500,
    height: 1.4,
    letterSpacing: 0,
  );

  // Title Styles
  static TextStyle titleLarge = baseTextStyle.copyWith(
    fontFamily: fontFamilyMedium,
    fontSize: 22,
    fontWeight: FontWeight.w500,
    height: 1.4,
    letterSpacing: 0,
  );

  static TextStyle titleMedium = baseTextStyle.copyWith(
    fontFamily: fontFamilyMedium,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.5,
    letterSpacing: 0.15,
  );

  static TextStyle titleSmall = baseTextStyle.copyWith(
    fontFamily: fontFamilyMedium,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.5,
    letterSpacing: 0.1,
  );

  // Body Styles
  static TextStyle bodyLarge = baseTextStyle.copyWith(
    fontFamily: fontFamilyRegular,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: 0.5,
  );

  static TextStyle bodyMedium = baseTextStyle.copyWith(
    fontFamily: fontFamilyRegular,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: 0.25,
  );

  static TextStyle bodySmall = baseTextStyle.copyWith(
    fontFamily: fontFamilyRegular,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: 0.4,
  );

  // Label Styles
  static TextStyle labelLarge = baseTextStyle.copyWith(
    fontFamily: fontFamilyMedium,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.4,
    letterSpacing: 0.1,
  );

  static TextStyle labelMedium = baseTextStyle.copyWith(
    fontFamily: fontFamilyMedium,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.4,
    letterSpacing: 0.5,
  );

  static TextStyle labelSmall = baseTextStyle.copyWith(
    fontFamily: fontFamilyMedium,
    fontSize: 11,
    fontWeight: FontWeight.w500,
    height: 1.4,
    letterSpacing: 0.5,
  );

  // Button Styles
  static TextStyle buttonLarge = baseTextStyle.copyWith(
    fontFamily: fontFamilyMedium,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.2,
    letterSpacing: 0.5,
  );

  static TextStyle buttonMedium = baseTextStyle.copyWith(
    fontFamily: fontFamilyMedium,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.2,
    letterSpacing: 0.5,
  );

  static TextStyle buttonSmall = baseTextStyle.copyWith(
    fontFamily: fontFamilyMedium,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.2,
    letterSpacing: 0.5,
  );

  // Caption Styles
  static TextStyle caption = baseTextStyle.copyWith(
    fontFamily: fontFamilyRegular,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.4,
    letterSpacing: 0.4,
  );

  static TextStyle overline = baseTextStyle.copyWith(
    fontFamily: fontFamilyMedium,
    fontSize: 10,
    fontWeight: FontWeight.w500,
    height: 1.6,
    letterSpacing: 1.5,
  );

  // Custom Styles for Task Management
  static TextStyle taskTitle = baseTextStyle.copyWith(
    fontFamily: fontFamilyMedium,
    fontSize: 18,
    fontWeight: FontWeight.w500,
    height: 1.4,
  );

  static TextStyle taskDescription = baseTextStyle.copyWith(
    fontFamily: fontFamilyRegular,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: AppColors.textSecondary,
  );

  static TextStyle taskDate = baseTextStyle.copyWith(
    fontFamily: fontFamilyRegular,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.4,
    color: AppColors.textTertiary,
  );

  static TextStyle taskPriority = baseTextStyle.copyWith(
    fontFamily: fontFamilyMedium,
    fontSize: 11,
    fontWeight: FontWeight.w500,
    height: 1.3,
    letterSpacing: 0.5,
  );

  // Game Specific Styles
  static TextStyle gameTitle = baseTextStyle.copyWith(
    fontFamily: fontFamilyBold,
    fontSize: 36,
    fontWeight: FontWeight.w700,
    height: 1.2,
    color: AppColors.textWhite,
  );

  static TextStyle gameSubtitle = baseTextStyle.copyWith(
    fontFamily: fontFamilyMedium,
    fontSize: 24,
    fontWeight: FontWeight.w500,
    height: 1.3,
    color: AppColors.textWhite,
  );

  static TextStyle gameScore = baseTextStyle.copyWith(
    fontFamily: fontFamilyBold,
    fontSize: 48,
    fontWeight: FontWeight.w700,
    height: 1.1,
    color: AppColors.accent,
  );

  static TextStyle gameLevel = baseTextStyle.copyWith(
    fontFamily: fontFamilyMedium,
    fontSize: 20,
    fontWeight: FontWeight.w500,
    height: 1.3,
    color: AppColors.textWhite,
  );

  // Color Variants
  static TextStyle withColor(TextStyle style, Color color) {
    return style.copyWith(color: color);
  }

  static TextStyle withPrimary(TextStyle style) {
    return style.copyWith(color: AppColors.primary);
  }

  static TextStyle withSecondary(TextStyle style) {
    return style.copyWith(color: AppColors.secondary);
  }

  static TextStyle withWhite(TextStyle style) {
    return style.copyWith(color: AppColors.textWhite);
  }

  static TextStyle withMuted(TextStyle style) {
    return style.copyWith(color: AppColors.textTertiary);
  }
}
