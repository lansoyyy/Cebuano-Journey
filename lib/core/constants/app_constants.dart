/// App Constants
/// Centralized constants for the application
class AppConstants {
  AppConstants._();

  // ========== App Info ==========
  static const String appName = 'Cebuano Journey';
  static const String appDescription =
      'A journey through Cebuano language and culture';
  static const String appVersion = '1.0.0';

  // ========== API ==========
  static const String apiBaseUrl = 'https://api.cebuanojourney.com';
  static const String apiVersion = 'v1';
  static const int apiTimeout = 30000; // 30 seconds

  // ========== Storage Keys ==========
  static const String keyIsLoggedIn = 'is_logged_in';
  static const String keyAuthToken = 'auth_token';
  static const String keyUserId = 'user_id';
  static const String keyUserName = 'user_name';
  static const String keyUserEmail = 'user_email';
  static const String keyThemeMode = 'theme_mode';
  static const String keyLanguage = 'language';
  static const String keyFirstLaunch = 'first_launch';
  static const String keyGameScore = 'game_score';
  static const String keyHighScore = 'high_score';
  static const String keyCurrentLevel = 'current_level';

  // ========== Pagination ==========
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // ========== Animation Durations ==========
  static const int animationDurationShort = 150; // milliseconds
  static const int animationDurationMedium = 300; // milliseconds
  static const int animationDurationLong = 500; // milliseconds

  // ========== Debounce Times ==========
  static const int debounceTimeShort = 300; // milliseconds
  static const int debounceTimeMedium = 500; // milliseconds
  static const int debounceTimeLong = 1000; // milliseconds

  // ========== Image Sizes ==========
  static const double avatarSizeSmall = 32.0;
  static const double avatarSizeMedium = 48.0;
  static const double avatarSizeLarge = 64.0;
  static const double avatarSizeExtraLarge = 96.0;

  static const double iconSizeSmall = 16.0;
  static const double iconSizeMedium = 24.0;
  static const double iconSizeLarge = 32.0;
  static const double iconSizeExtraLarge = 48.0;

  // ========== Game Constants ==========
  static const int gameInitialLives = 3;
  static const int gameInitialScore = 0;
  static const int gameInitialLevel = 1;
  static const int gameMaxLevel = 100;
  static const int gameBonusScore = 100;

  // ========== Task Constants ==========
  static const int maxTasksPerDay = 50;
  static const int taskCompletionReward = 10;
  static const int streakRewardMultiplier = 2;

  // ========== Validation ==========
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 128;
  static const int minNameLength = 2;
  static const int maxNameLength = 50;
  static const int maxDescriptionLength = 500;

  // ========== Date Formats ==========
  static const String dateFormatDisplay = 'MMMM d, yyyy';
  static const String dateFormatShort = 'MMM d, yyyy';
  static const String dateFormatTime = 'h:mm a';
  static const String dateFormatDateTime = 'MMM d, yyyy h:mm a';
  static const String dateFormatApi = 'yyyy-MM-dd';
  static const String dateFormatApiDateTime = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";

  // ========== Regex Patterns ==========
  static const String emailPattern =
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  static const String phonePattern = r'^\+?[\d\s-]{10,}$';
  static const String urlPattern =
      r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$';

  // ========== Supported Languages ==========
  static const List<String> supportedLanguages = [
    'en', // English
    'ceb', // Cebuano
    'tl', // Tagalog
  ];

  // ========== Supported Themes ==========
  static const List<String> supportedThemes = ['light', 'dark', 'system'];
}
