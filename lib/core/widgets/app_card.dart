import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import '../theme/app_text_styles.dart';

/// Custom Card Widgets for Cebuano Journey
/// All cards use the Urbanist font family
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final Color? shadowColor;
  final double? elevation;
  final double? borderRadius;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final BoxBorder? border;
  final Clip clipBehavior;
  final double? width;
  final double? height;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.shadowColor,
    this.elevation,
    this.borderRadius,
    this.onTap,
    this.onLongPress,
    this.border,
    this.clipBehavior = Clip.none,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final card = Card(
      elevation: elevation ?? 2,
      shadowColor: shadowColor ?? AppColors.shadow,
      color: backgroundColor ?? AppColors.surface,
      shape: border != null
          ? RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                borderRadius ?? AppSpacing.radiusLG,
              ),
              side: border as BorderSide,
            )
          : RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                borderRadius ?? AppSpacing.radiusLG,
              ),
            ),
      clipBehavior: clipBehavior,
      margin: margin ?? AppSpacing.cardMargin,
      child: Padding(padding: padding ?? AppSpacing.cardPadding, child: child),
    );

    if (onTap != null || onLongPress != null) {
      return InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(
          borderRadius ?? AppSpacing.radiusLG,
        ),
        child: SizedBox(width: width, height: height, child: card),
      );
    }

    return SizedBox(width: width, height: height, child: card);
  }
}

/// Primary Card
class AppPrimaryCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final double? width;
  final double? height;

  const AppPrimaryCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
    this.onLongPress,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: padding,
      margin: margin,
      onTap: onTap,
      onLongPress: onLongPress,
      width: width,
      height: height,
      backgroundColor: AppColors.surface,
      elevation: 2,
      borderRadius: AppSpacing.radiusLG,
      child: child,
    );
  }
}

/// Colored Card
class AppColoredCard extends StatelessWidget {
  final Widget child;
  final Color color;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final double? width;
  final double? height;

  const AppColoredCard({
    super.key,
    required this.child,
    required this.color,
    this.padding,
    this.margin,
    this.onTap,
    this.onLongPress,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: padding,
      margin: margin,
      onTap: onTap,
      onLongPress: onLongPress,
      width: width,
      height: height,
      backgroundColor: color,
      elevation: 2,
      borderRadius: AppSpacing.radiusLG,
      child: child,
    );
  }
}

/// Bordered Card
class AppBorderedCard extends StatelessWidget {
  final Widget child;
  final Color? borderColor;
  final double? borderWidth;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final double? width;
  final double? height;

  const AppBorderedCard({
    super.key,
    required this.child,
    this.borderColor,
    this.borderWidth,
    this.padding,
    this.margin,
    this.onTap,
    this.onLongPress,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: padding,
      margin: margin,
      onTap: onTap,
      onLongPress: onLongPress,
      width: width,
      height: height,
      backgroundColor: AppColors.surface,
      elevation: 0,
      borderRadius: AppSpacing.radiusLG,
      border: Border.all(
        color: borderColor ?? AppColors.border,
        width: borderWidth ?? 1,
      ),
      child: child,
    );
  }
}

/// Task Card
class AppTaskCard extends StatelessWidget {
  final String title;
  final String? description;
  final bool isCompleted;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final Widget? leading;
  final Widget? trailing;
  final Color? priorityColor;

  const AppTaskCard({
    super.key,
    required this.title,
    this.description,
    this.isCompleted = false,
    this.onTap,
    this.onLongPress,
    this.leading,
    this.trailing,
    this.priorityColor,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: AppSpacing.paddingMD,
      onTap: onTap,
      onLongPress: onLongPress,
      child: Row(
        children: [
          if (leading != null) ...[
            leading!,
            const SizedBox(width: AppSpacing.md),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.taskTitle.copyWith(
                    decoration: isCompleted ? TextDecoration.lineThrough : null,
                    color: isCompleted ? AppColors.textTertiary : null,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (description != null) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    description!,
                    style: AppTextStyles.taskDescription,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: AppSpacing.md),
            trailing!,
          ],
        ],
      ),
    );
  }
}

/// Game Card
class AppGameCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final double? width;
  final double? height;

  const AppGameCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
    this.onLongPress,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin ?? AppSpacing.cardMargin,
      decoration: BoxDecoration(
        color: AppColors.gameSurface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXL),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowDark.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          borderRadius: BorderRadius.circular(AppSpacing.radiusXL),
          child: Padding(
            padding: padding ?? AppSpacing.cardPaddingLG,
            child: child,
          ),
        ),
      ),
    );
  }
}

/// Info Card
class AppInfoCard extends StatelessWidget {
  final String title;
  final String? description;
  final IconData? icon;
  final Color? iconColor;
  final Color? backgroundColor;
  final VoidCallback? onTap;

  const AppInfoCard({
    super.key,
    required this.title,
    this.description,
    this.icon,
    this.iconColor,
    this.backgroundColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      padding: AppSpacing.paddingMD,
      backgroundColor: backgroundColor,
      child: Row(
        children: [
          if (icon != null) ...[
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: (iconColor ?? AppColors.primary).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppSpacing.radiusSM),
              ),
              child: Icon(
                icon,
                color: iconColor ?? AppColors.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.titleMedium),
                if (description != null) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(description!, style: AppTextStyles.bodySmall),
                ],
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: AppColors.textTertiary),
        ],
      ),
    );
  }
}

/// Stat Card
class AppStatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData? icon;
  final Color? iconColor;
  final Color? backgroundColor;
  final VoidCallback? onTap;

  const AppStatCard({
    super.key,
    required this.title,
    required this.value,
    this.icon,
    this.iconColor,
    this.backgroundColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      padding: AppSpacing.paddingMD,
      backgroundColor: backgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (icon != null)
                Icon(icon, color: iconColor ?? AppColors.primary, size: 24),
              if (onTap != null)
                const Icon(Icons.more_horiz, color: AppColors.textTertiary),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            value,
            style: AppTextStyles.displaySmall.copyWith(
              color: iconColor ?? AppColors.primary,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            title,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
