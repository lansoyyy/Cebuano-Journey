import 'package:flutter/material.dart';

/// App Assets Utility Class
/// Centralized management of all app assets
class AppAssets {
  AppAssets._();

  // ========== Images ==========
  static const String _imagesPath = 'assets/images';

  // User Images
  static const String userAvatar = '$_imagesPath/user (1).png';

  // ========== Icons ==========
  static const String iconsPath = 'assets/icons';

  // ========== Animations ==========
  static const String animationsPath = 'assets/animations';

  // ========== Sounds ==========
  static const String soundsPath = 'assets/sounds';

  // ========== Fonts ==========
  static const String fontsPath = 'assets/fonts';

  // Font Family Names
  static const String fontRegular = 'Regular';
  static const String fontMedium = 'Medium';
  static const String fontBold = 'Bold';

  // ========== Asset Loaders ==========

  /// Load an image asset
  static Image loadImage(
    String path, {
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    Color? color,
  }) {
    return Image.asset(
      path,
      width: width,
      height: height,
      fit: fit,
      color: color,
    );
  }

  /// Load an SVG asset (requires flutter_svg package)
  // static SvgPicture loadSvg(
  //   String path, {
  //   double? width,
  //   double? height,
  //   Color? color,
  // }) {
  //   return SvgPicture.asset(
  //     path,
  //     width: width,
  //     height: height,
  //     colorFilter: color != null
  //         ? ColorFilter.mode(color, BlendMode.srcIn)
  //         : null,
  //   );
  // }

  /// Load a Lottie animation (requires lottie package)
  // static LottieBuilder loadLottie(
  //   String path, {
  //   double? width,
  //   double? height,
  //   bool animate = true,
  //   bool repeat = true,
  // }) {
  //   return Lottie.asset(
  //     path,
  //     width: width,
  //     height: height,
  //     animate: animate,
  //     repeat: repeat,
  //   );
  // }

  // ========== Game Specific Assets ==========

  // Game Backgrounds
  static const String gameBackground = '$_imagesPath/game_background.png';

  // Game Characters
  static const String characterIdle = '$_imagesPath/character_idle.png';
  static const String characterWalk = '$_imagesPath/character_walk.png';
  static const String characterJump = '$_imagesPath/character_jump.png';

  // Game Items
  static const String itemCoin = '$_imagesPath/item_coin.png';
  static const String itemStar = '$_imagesPath/item_star.png';
  static const String itemPowerUp = '$_imagesPath/item_powerup.png';

  // Game UI
  static const String uiButton = '$_imagesPath/ui_button.png';
  static const String uiPanel = '$_imagesPath/ui_panel.png';
  static const String uiHealthBar = '$_imagesPath/ui_healthbar.png';

  // Game Enemies
  static const String enemyBasic = '$_imagesPath/enemy_basic.png';
  static const String enemyBoss = '$_imagesPath/enemy_boss.png';

  // ========== Task Management Assets ==========

  // Task Icons
  static const String taskCheck = '$_imagesPath/task_check.png';
  static const String taskUnchecked = '$_imagesPath/task_unchecked.png';
  static const String taskPriorityHigh = '$_imagesPath/task_priority_high.png';
  static const String taskPriorityMedium =
      '$_imagesPath/task_priority_medium.png';
  static const String taskPriorityLow = '$_imagesPath/task_priority_low.png';

  // Category Icons
  static const String categoryWork = '$_imagesPath/category_work.png';
  static const String categoryPersonal = '$_imagesPath/category_personal.png';
  static const String categoryHealth = '$_imagesPath/category_health.png';
  static const String categoryLearning = '$_imagesPath/category_learning.png';
  static const String categoryOther = '$_imagesPath/category_other.png';

  // ========== Placeholder Assets ==========

  /// Get a placeholder color container
  static Widget placeholder({
    double? width,
    double? height,
    Color color = Colors.grey,
    String? label,
  }) {
    return Container(
      width: width,
      height: height,
      color: color,
      child: label != null
          ? Center(
              child: Text(label, style: const TextStyle(color: Colors.white)),
            )
          : null,
    );
  }
}

/// Extension for easy asset loading
extension AssetExtension on String {
  /// Convert to image asset
  Image toImage({
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    Color? color,
  }) {
    return Image.asset(
      this,
      width: width,
      height: height,
      fit: fit,
      color: color,
    );
  }
}
