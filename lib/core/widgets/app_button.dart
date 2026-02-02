import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import '../theme/app_text_styles.dart';

/// Custom Button Widgets for Cebuano Journey
/// All buttons use the Urbanist font family
class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isDisabled;
  final bool isFullWidth;
  final Widget? icon;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? disabledBackgroundColor;
  final Color? disabledForegroundColor;
  final BorderSide? borderSide;
  final double? elevation;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;
  final TextStyle? textStyle;
  final ButtonStyle? style;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
    this.isFullWidth = false,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
    this.disabledBackgroundColor,
    this.disabledForegroundColor,
    this.borderSide,
    this.elevation,
    this.borderRadius,
    this.padding,
    this.textStyle,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveStyle =
        style ??
        ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          disabledBackgroundColor: disabledBackgroundColor ?? AppColors.border,
          disabledForegroundColor:
              disabledForegroundColor ?? AppColors.textTertiary,
          elevation: elevation ?? 2,
          padding: padding ?? AppSpacing.buttonPadding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              borderRadius ?? AppSpacing.radiusMD,
            ),
            side: borderSide ?? BorderSide.none,
          ),
          textStyle: textStyle ?? AppTextStyles.buttonMedium,
        );

    final button = ElevatedButton(
      style: effectiveStyle,
      onPressed: (isDisabled || isLoading) ? null : onPressed,
      child: isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.textWhite),
              ),
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  icon!,
                  const SizedBox(width: AppSpacing.sm),
                ],
                Text(text),
              ],
            ),
    );

    if (isFullWidth) {
      return SizedBox(width: double.infinity, child: button);
    }

    return button;
  }
}

/// Primary Button
class AppPrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isDisabled;
  final bool isFullWidth;
  final Widget? icon;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;

  const AppPrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
    this.isFullWidth = false,
    this.icon,
    this.borderRadius,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return AppButton(
      text: text,
      onPressed: onPressed,
      isLoading: isLoading,
      isDisabled: isDisabled,
      isFullWidth: isFullWidth,
      icon: icon,
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.textWhite,
      disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.5),
      borderRadius: borderRadius,
      padding: padding,
    );
  }
}

/// Secondary Button
class AppSecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isDisabled;
  final bool isFullWidth;
  final Widget? icon;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;

  const AppSecondaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
    this.isFullWidth = false,
    this.icon,
    this.borderRadius,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return AppButton(
      text: text,
      onPressed: onPressed,
      isLoading: isLoading,
      isDisabled: isDisabled,
      isFullWidth: isFullWidth,
      icon: icon,
      backgroundColor: AppColors.secondary,
      foregroundColor: AppColors.textWhite,
      disabledBackgroundColor: AppColors.secondary.withValues(alpha: 0.5),
      borderRadius: borderRadius,
      padding: padding,
    );
  }
}

/// Outlined Button
class AppOutlinedButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isDisabled;
  final bool isFullWidth;
  final Widget? icon;
  final Color? borderColor;
  final Color? textColor;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;

  const AppOutlinedButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
    this.isFullWidth = false,
    this.icon,
    this.borderColor,
    this.textColor,
    this.borderRadius,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return AppColors.textTertiary;
          }
          return textColor ?? AppColors.primary;
        }),
        side: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return const BorderSide(color: AppColors.border, width: 1.5);
          }
          return BorderSide(
            color: borderColor ?? AppColors.primary,
            width: 1.5,
          );
        }),
        padding: WidgetStateProperty.all(padding ?? AppSpacing.buttonPadding),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              borderRadius ?? AppSpacing.radiusMD,
            ),
          ),
        ),
        textStyle: WidgetStateProperty.all(AppTextStyles.buttonMedium),
      ),
      onPressed: (isDisabled || isLoading) ? null : onPressed,
      child: isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  icon!,
                  const SizedBox(width: AppSpacing.sm),
                ],
                Text(text),
              ],
            ),
    );
  }
}

/// Text Button
class AppTextButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isDisabled;
  final Widget? icon;
  final Color? textColor;
  final EdgeInsetsGeometry? padding;

  const AppTextButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isDisabled = false,
    this.icon,
    this.textColor,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        foregroundColor: textColor ?? AppColors.primary,
        disabledForegroundColor: AppColors.textTertiary,
        padding: padding ?? AppSpacing.buttonPaddingSM,
        textStyle: AppTextStyles.buttonMedium,
      ),
      onPressed: isDisabled ? null : onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[icon!, const SizedBox(width: AppSpacing.xs)],
          Text(text),
        ],
      ),
    );
  }
}

/// Icon Button
class AppIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final bool isDisabled;
  final Color? iconColor;
  final Color? backgroundColor;
  final double? iconSize;
  final double? size;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;

  const AppIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.isDisabled = false,
    this.iconColor,
    this.backgroundColor,
    this.iconSize,
    this.size,
    this.borderRadius,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon, color: iconColor, size: iconSize),
      onPressed: isDisabled ? null : onPressed,
      style: IconButton.styleFrom(
        backgroundColor: backgroundColor,
        padding: padding,
        minimumSize: size != null ? Size(size!, size!) : null,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}

/// Floating Action Button
class AppFloatingActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? elevation;

  const AppFloatingActionButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.tooltip,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      tooltip: tooltip,
      backgroundColor: backgroundColor ?? AppColors.primary,
      foregroundColor: foregroundColor ?? AppColors.textWhite,
      elevation: elevation ?? 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLG),
      ),
      child: Icon(icon),
    );
  }
}

/// Game Button
class AppGameButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isDisabled;
  final Widget? icon;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;

  const AppGameButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
    this.icon,
    this.borderRadius,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return AppButton(
      text: text,
      onPressed: onPressed,
      isLoading: isLoading,
      isDisabled: isDisabled,
      icon: icon,
      backgroundColor: AppColors.gamePrimary,
      foregroundColor: AppColors.textWhite,
      disabledBackgroundColor: AppColors.gamePrimary.withValues(alpha: 0.5),
      elevation: 4,
      borderRadius: borderRadius ?? AppSpacing.radiusLG,
      padding: padding ?? AppSpacing.buttonPaddingLG,
      textStyle: AppTextStyles.buttonLarge.copyWith(
        fontFamily: AppTextStyles.fontFamilyBold,
      ),
    );
  }
}
