import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';
import '../constants/app_strings.dart';

/// App Utility Functions
class AppUtils {
  AppUtils._();

  // ========== Date & Time Utilities ==========

  /// Format date for display
  static String formatDate(
    DateTime date, {
    String format = AppConstants.dateFormatDisplay,
  }) {
    return DateFormat(format).format(date);
  }

  /// Format date and time for display
  static String formatDateTime(
    DateTime dateTime, {
    String format = AppConstants.dateFormatDateTime,
  }) {
    return DateFormat(format).format(dateTime);
  }

  /// Format time for display
  static String formatTime(
    DateTime time, {
    String format = AppConstants.dateFormatTime,
  }) {
    return DateFormat(format).format(time);
  }

  /// Get relative time string (e.g., "2 hours ago")
  static String getRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds} ${difference.inSeconds == 1 ? 'second' : 'seconds'} ago';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks ${weeks == 1 ? 'week' : 'weeks'} ago';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    } else {
      final years = (difference.inDays / 365).floor();
      return '$years ${years == 1 ? 'year' : 'years'} ago';
    }
  }

  /// Check if date is today
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  /// Check if date is yesterday
  static bool isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day;
  }

  /// Check if date is tomorrow
  static bool isTomorrow(DateTime date) {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return date.year == tomorrow.year &&
        date.month == tomorrow.month &&
        date.day == tomorrow.day;
  }

  // ========== Validation Utilities ==========

  /// Validate email
  static bool isValidEmail(String email) {
    return RegExp(AppConstants.emailPattern).hasMatch(email);
  }

  /// Validate phone number
  static bool isValidPhone(String phone) {
    return RegExp(AppConstants.phonePattern).hasMatch(phone);
  }

  /// Validate URL
  static bool isValidUrl(String url) {
    return RegExp(AppConstants.urlPattern).hasMatch(url);
  }

  /// Validate password strength
  static bool isStrongPassword(String password) {
    if (password.length < AppConstants.minPasswordLength) return false;

    bool hasUppercase = password.contains(RegExp(r'[A-Z]'));
    bool hasLowercase = password.contains(RegExp(r'[a-z]'));
    bool hasDigits = password.contains(RegExp(r'[0-9]'));
    bool hasSpecialChars = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

    return hasUppercase && hasLowercase && hasDigits && hasSpecialChars;
  }

  // ========== String Utilities ==========

  /// Capitalize first letter of string
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  /// Capitalize each word in string
  static String capitalizeWords(String text) {
    return text.split(' ').map((word) => capitalize(word)).join(' ');
  }

  /// Truncate string to specified length
  static String truncate(
    String text, {
    int maxLength = 50,
    String suffix = '...',
  }) {
    if (text.length <= maxLength) return text;
    return text.substring(0, maxLength) + suffix;
  }

  /// Get initials from name
  static String getInitials(String name, {int maxInitials = 2}) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return '';

    String initials = '';
    for (int i = 0; i < parts.length && i < maxInitials; i++) {
      if (parts[i].isNotEmpty) {
        initials += parts[i][0].toUpperCase();
      }
    }
    return initials;
  }

  // ========== Color Utilities ==========

  /// Get priority color based on priority string
  static Color getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case AppStrings.priorityHigh:
        return AppColors.priorityHigh;
      case AppStrings.priorityMedium:
        return AppColors.priorityMedium;
      case AppStrings.priorityLow:
        return AppColors.priorityLow;
      default:
        return AppColors.textTertiary;
    }
  }

  /// Lighten a color
  static Color lightenColor(Color color, {double amount = 0.2}) {
    final hsl = HSLColor.fromColor(color);
    return hsl
        .withLightness((hsl.lightness + amount).clamp(0.0, 1.0))
        .toColor();
  }

  /// Darken a color
  static Color darkenColor(Color color, {double amount = 0.2}) {
    final hsl = HSLColor.fromColor(color);
    return hsl
        .withLightness((hsl.lightness - amount).clamp(0.0, 1.0))
        .toColor();
  }

  // ========== Number Utilities ==========

  /// Format number with commas
  static String formatNumber(int number) {
    return NumberFormat.decimalPattern().format(number);
  }

  /// Format number as currency
  static String formatCurrency(double amount, {String symbol = '₱'}) {
    return NumberFormat.currency(symbol: symbol).format(amount);
  }

  /// Format number with suffix (e.g., 1K, 1M, 1B)
  static String formatCompactNumber(int number) {
    if (number >= 1000000000) {
      return '${(number / 1000000000).toStringAsFixed(1)}B';
    } else if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }

  // ========== UI Utilities ==========

  /// Show snackbar
  static void showSnackBar(
    BuildContext context,
    String message, {
    SnackBarAction? action,
    Duration duration = const Duration(seconds: 3),
    Color? backgroundColor,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        action: action,
        duration: duration,
        backgroundColor: backgroundColor ?? AppColors.surfaceDark,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  /// Show loading dialog
  static void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );
  }

  /// Hide loading dialog
  static void hideLoadingDialog(BuildContext context) {
    Navigator.of(context).pop();
  }

  /// Show confirmation dialog
  static Future<bool?> showConfirmationDialog(
    BuildContext context, {
    required String title,
    required String message,
    String confirmText = AppStrings.yes,
    String cancelText = AppStrings.no,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(cancelText),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(confirmText),
          ),
        ],
      ),
    );
  }

  // ========== Device Utilities ==========

  /// Check if device is tablet
  static bool isTablet(BuildContext context) {
    return MediaQuery.of(context).size.shortestSide > 600;
  }

  /// Get screen width
  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  /// Get screen height
  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  /// Get safe area padding
  static EdgeInsets getSafeAreaPadding(BuildContext context) {
    return MediaQuery.of(context).padding;
  }

  /// Hide keyboard
  static void hideKeyboard(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  /// Show keyboard
  static void showKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }
}
