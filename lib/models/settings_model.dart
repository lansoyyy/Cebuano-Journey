/// Settings Model
/// User preferences (sound, music, language)
class AppSettings {
  final String playerId;
  final String playerName;
  final String? avatar;
  final bool soundEnabled;
  final bool musicEnabled;
  final double musicVolume;
  final double soundVolume;
  final bool vibrationEnabled;
  final bool notificationsEnabled;
  final String language;
  final ThemeMode themeMode;
  final bool hapticFeedback;
  final int? selectedLevel; // Last played level
  final int? dailyReminderTime; // Hour of day (0-23)
  final bool autoPlayMusic;
  final bool showHints;
  final int difficulty; // 1-5 scale

  const AppSettings({
    required this.playerId,
    required this.playerName,
    this.avatar,
    this.soundEnabled = true,
    this.musicEnabled = true,
    this.musicVolume = 0.7,
    this.soundVolume = 0.8,
    this.vibrationEnabled = true,
    this.notificationsEnabled = true,
    this.language = 'en',
    this.themeMode = ThemeMode.system,
    this.hapticFeedback = true,
    this.selectedLevel,
    this.dailyReminderTime,
    this.autoPlayMusic = true,
    this.showHints = true,
    this.difficulty = 3,
  });

  Map<String, dynamic> toJson() {
    return {
      'playerId': playerId,
      'playerName': playerName,
      'avatar': avatar,
      'soundEnabled': soundEnabled,
      'musicEnabled': musicEnabled,
      'musicVolume': musicVolume,
      'soundVolume': soundVolume,
      'vibrationEnabled': vibrationEnabled,
      'notificationsEnabled': notificationsEnabled,
      'language': language,
      'themeMode': themeMode.name,
      'hapticFeedback': hapticFeedback,
      'selectedLevel': selectedLevel,
      'dailyReminderTime': dailyReminderTime,
      'autoPlayMusic': autoPlayMusic,
      'showHints': showHints,
      'difficulty': difficulty,
    };
  }

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      playerId: json['playerId'] as String,
      playerName: json['playerName'] as String,
      avatar: json['avatar'] as String?,
      soundEnabled: json['soundEnabled'] as bool,
      musicEnabled: json['musicEnabled'] as bool,
      musicVolume: (json['musicVolume'] as num).toDouble(),
      soundVolume: (json['soundVolume'] as num).toDouble(),
      vibrationEnabled: json['vibrationEnabled'] as bool,
      notificationsEnabled: json['notificationsEnabled'] as bool,
      language: json['language'] as String,
      themeMode: ThemeMode.values.firstWhere(
        (e) => e.name == json['themeMode'],
        orElse: () => ThemeMode.system,
      ),
      hapticFeedback: json['hapticFeedback'] as bool,
      selectedLevel: json['selectedLevel'] as int?,
      dailyReminderTime: json['dailyReminderTime'] as int?,
      autoPlayMusic: json['autoPlayMusic'] as bool,
      showHints: json['showHints'] as bool,
      difficulty: json['difficulty'] as int,
    );
  }

  /// Get copy with updated values
  AppSettings copyWith({
    String? playerId,
    String? playerName,
    String? avatar,
    bool? soundEnabled,
    bool? musicEnabled,
    double? musicVolume,
    double? soundVolume,
    bool? vibrationEnabled,
    bool? notificationsEnabled,
    String? language,
    ThemeMode? themeMode,
    bool? hapticFeedback,
    int? selectedLevel,
    int? dailyReminderTime,
    bool? autoPlayMusic,
    bool? showHints,
    int? difficulty,
  }) {
    return AppSettings(
      playerId: playerId ?? this.playerId,
      playerName: playerName ?? this.playerName,
      avatar: avatar ?? this.avatar,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      musicEnabled: musicEnabled ?? this.musicEnabled,
      musicVolume: musicVolume ?? this.musicVolume,
      soundVolume: soundVolume ?? this.soundVolume,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      language: language ?? this.language,
      themeMode: themeMode ?? this.themeMode,
      hapticFeedback: hapticFeedback ?? this.hapticFeedback,
      selectedLevel: selectedLevel ?? this.selectedLevel,
      dailyReminderTime: dailyReminderTime ?? this.dailyReminderTime,
      autoPlayMusic: autoPlayMusic ?? this.autoPlayMusic,
      showHints: showHints ?? this.showHints,
      difficulty: difficulty ?? this.difficulty,
    );
  }
}

enum ThemeMode { light, dark, system }

enum AppLanguage {
  english('en', 'English'),
  cebuano('ceb', 'Cebuano'),
  tagalog('tl', 'Tagalog');

  const AppLanguage(this.code, this.name);

  final String code;
  final String name;
}

/// Default settings
class DefaultSettings {
  static AppSettings get defaultSettings => const AppSettings(
    playerId: 'default',
    playerName: 'Player',
    soundEnabled: true,
    musicEnabled: true,
    musicVolume: 0.7,
    soundVolume: 0.8,
    vibrationEnabled: true,
    notificationsEnabled: true,
    language: 'en',
    themeMode: ThemeMode.system,
    hapticFeedback: true,
    autoPlayMusic: true,
    showHints: true,
    difficulty: 3,
  );

  /// Get available languages
  static List<AppLanguage> get availableLanguages => AppLanguage.values;

  /// Get language by code
  static AppLanguage getLanguageByCode(String code) {
    return AppLanguage.values.firstWhere(
      (lang) => lang.code == code,
      orElse: () => AppLanguage.english,
    );
  }

  /// Get difficulty levels
  static const List<int> difficultyLevels = [1, 2, 3, 4, 5];

  /// Get difficulty label
  static String getDifficultyLabel(int difficulty) {
    switch (difficulty) {
      case 1:
        return 'Very Easy';
      case 2:
        return 'Easy';
      case 3:
        return 'Medium';
      case 4:
        return 'Hard';
      case 5:
        return 'Very Hard';
      default:
        return 'Medium';
    }
  }

  /// Get reminder time options
  static const List<int> reminderTimes = [6, 8, 10, 12, 14, 16, 18, 20];

  /// Get formatted reminder time
  static String getFormattedReminderTime(int hour) {
    if (hour == 0) return '12:00 AM';
    if (hour < 12) return '$hour:00 AM';
    return '${hour - 12}:00 PM';
  }
}

/// Notification Settings
class NotificationSettings {
  final bool dailyQuestReminder;
  final int dailyQuestReminderTime;
  final bool weeklyQuestReminder;
  final bool achievementUnlocked;
  final bool friendActivity;
  final bool newContentAvailable;

  const NotificationSettings({
    this.dailyQuestReminder = true,
    this.dailyQuestReminderTime = 9, // 9 AM
    this.weeklyQuestReminder = true,
    this.achievementUnlocked = true,
    this.friendActivity = false,
    this.newContentAvailable = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'dailyQuestReminder': dailyQuestReminder,
      'dailyQuestReminderTime': dailyQuestReminderTime,
      'weeklyQuestReminder': weeklyQuestReminder,
      'achievementUnlocked': achievementUnlocked,
      'friendActivity': friendActivity,
      'newContentAvailable': newContentAvailable,
    };
  }

  factory NotificationSettings.fromJson(Map<String, dynamic> json) {
    return NotificationSettings(
      dailyQuestReminder: json['dailyQuestReminder'] as bool,
      dailyQuestReminderTime: json['dailyQuestReminderTime'] as int,
      weeklyQuestReminder: json['weeklyQuestReminder'] as bool,
      achievementUnlocked: json['achievementUnlocked'] as bool,
      friendActivity: json['friendActivity'] as bool,
      newContentAvailable: json['newContentAvailable'] as bool,
    );
  }
}

/// Audio Settings
class AudioSettings {
  final bool musicEnabled;
  final double musicVolume;
  final bool soundEffectsEnabled;
  final double soundEffectsVolume;
  final bool voiceOverEnabled;
  final double voiceOverVolume;
  final bool autoPlayMusic;

  const AudioSettings({
    this.musicEnabled = true,
    this.musicVolume = 0.7,
    this.soundEffectsEnabled = true,
    this.soundEffectsVolume = 0.8,
    this.voiceOverEnabled = true,
    this.voiceOverVolume = 0.9,
    this.autoPlayMusic = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'musicEnabled': musicEnabled,
      'musicVolume': musicVolume,
      'soundEffectsEnabled': soundEffectsEnabled,
      'soundEffectsVolume': soundEffectsVolume,
      'voiceOverEnabled': voiceOverEnabled,
      'voiceOverVolume': voiceOverVolume,
      'autoPlayMusic': autoPlayMusic,
    };
  }

  factory AudioSettings.fromJson(Map<String, dynamic> json) {
    return AudioSettings(
      musicEnabled: json['musicEnabled'] as bool,
      musicVolume: (json['musicVolume'] as num).toDouble(),
      soundEffectsEnabled: json['soundEffectsEnabled'] as bool,
      soundEffectsVolume: (json['soundEffectsVolume'] as num).toDouble(),
      voiceOverEnabled: json['voiceOverEnabled'] as bool,
      voiceOverVolume: (json['voiceOverVolume'] as num).toDouble(),
      autoPlayMusic: json['autoPlayMusic'] as bool,
    );
  }
}
