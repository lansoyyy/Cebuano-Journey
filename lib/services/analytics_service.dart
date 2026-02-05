import 'package:flutter/foundation.dart';

/// Analytics Service
/// Track player behavior and progress
class AnalyticsService {
  static final AnalyticsService _instance = AnalyticsService._internal();

  factory AnalyticsService() => _instance;

  AnalyticsService._internal();

  // Session tracking
  String? _sessionId;
  DateTime? _sessionStartTime;

  // Player info
  String? _playerId;

  /// Initialize analytics service
  Future<void> initialize(String playerId) async {
    _playerId = playerId;
    _startSession();
  }

  /// Start new session
  void _startSession() {
    _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
    _sessionStartTime = DateTime.now();

    // TODO: Send session start event to analytics backend
    _logEvent('session_start', {
      'session_id': _sessionId,
      'player_id': _playerId,
      'timestamp': _sessionStartTime!.toIso8601String(),
    });
  }

  /// End session
  void endSession() {
    if (_sessionStartTime == null) return;

    final sessionDuration = DateTime.now().difference(_sessionStartTime!);

    _logEvent('session_end', {
      'session_id': _sessionId,
      'player_id': _playerId,
      'duration_seconds': sessionDuration.inSeconds,
    });

    _sessionId = null;
    _sessionStartTime = null;
  }

  // ========== Level Events ==========

  /// Track level start
  void trackLevelStart(int level) {
    _logEvent('level_start', {
      'player_id': _playerId,
      'level': level,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  /// Track level complete
  void trackLevelComplete({
    required int level,
    required int score,
    required int stars,
    required int mistakes,
    required int timeSpent,
  }) {
    _logEvent('level_complete', {
      'player_id': _playerId,
      'level': level,
      'score': score,
      'stars': stars,
      'mistakes': mistakes,
      'time_spent_seconds': timeSpent,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  /// Track level failed
  void trackLevelFailed({
    required int level,
    required String reason,
    required int timeSpent,
  }) {
    _logEvent('level_failed', {
      'player_id': _playerId,
      'level': level,
      'reason': reason,
      'time_spent_seconds': timeSpent,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  // ========== Word Learning Events ==========

  /// Track word learned
  void trackWordLearned({
    required String wordId,
    required String category,
    required int difficulty,
  }) {
    _logEvent('word_learned', {
      'player_id': _playerId,
      'word_id': wordId,
      'category': category,
      'difficulty': difficulty,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  /// Track word correct
  void trackWordCorrect({required String wordId, required int timeTaken}) {
    _logEvent('word_correct', {
      'player_id': _playerId,
      'word_id': wordId,
      'time_taken_seconds': timeTaken,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  /// Track word wrong
  void trackWordWrong({required String wordId, required String correctAnswer}) {
    _logEvent('word_wrong', {
      'player_id': _playerId,
      'word_id': wordId,
      'correct_answer': correctAnswer,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  // ========== Quest Events ==========

  /// Track quest started
  void trackQuestStarted(String questId) {
    _logEvent('quest_started', {
      'player_id': _playerId,
      'quest_id': questId,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  /// Track quest completed
  void trackQuestCompleted({
    required String questId,
    required int tasksCompleted,
    required int totalTasks,
  }) {
    _logEvent('quest_completed', {
      'player_id': _playerId,
      'quest_id': questId,
      'tasks_completed': tasksCompleted,
      'total_tasks': totalTasks,
      'completion_percentage': (tasksCompleted / totalTasks * 100).round(),
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  /// Track quest failed
  void trackQuestFailed({required String questId, required String reason}) {
    _logEvent('quest_failed', {
      'player_id': _playerId,
      'quest_id': questId,
      'reason': reason,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  // ========== Achievement Events ==========

  /// Track achievement unlocked
  void trackAchievementUnlocked(String achievementId) {
    _logEvent('achievement_unlocked', {
      'player_id': _playerId,
      'achievement_id': achievementId,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  /// Track achievement viewed
  void trackAchievementViewed(String achievementId) {
    _logEvent('achievement_viewed', {
      'player_id': _playerId,
      'achievement_id': achievementId,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  // ========== Shop Events ==========

  /// Track item purchased
  void trackItemPurchased({
    required String itemId,
    required int cost,
    required String currency,
  }) {
    _logEvent('item_purchased', {
      'player_id': _playerId,
      'item_id': itemId,
      'cost': cost,
      'currency': currency,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  /// Track item used
  void trackItemUsed(String itemId) {
    _logEvent('item_used', {
      'player_id': _playerId,
      'item_id': itemId,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  // ========== NPC Events ==========

  /// Track NPC interaction
  void trackNPCInteraction({
    required String npcId,
    required String interactionType,
  }) {
    _logEvent('npc_interaction', {
      'player_id': _playerId,
      'npc_id': npcId,
      'interaction_type': interactionType,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  // ========== Screen Events ==========

  /// Track screen view
  void trackScreenView(String screenName) {
    _logEvent('screen_view', {
      'player_id': _playerId,
      'screen_name': screenName,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  // ========== Settings Events ==========

  /// Track settings changed
  void trackSettingsChanged({
    required String settingType,
    required String oldValue,
    required String newValue,
  }) {
    _logEvent('settings_changed', {
      'player_id': _playerId,
      'setting_type': settingType,
      'old_value': oldValue,
      'new_value': newValue,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  // ========== Error Events ==========

  /// Track error
  void trackError({
    required String errorType,
    required String errorMessage,
    String? stackTrace,
  }) {
    _logEvent('error', {
      'player_id': _playerId,
      'error_type': errorType,
      'error_message': errorMessage,
      'stack_trace': stackTrace,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  // ========== Utility Methods ==========

  /// Log event
  void _logEvent(String eventName, Map<String, dynamic> parameters) {
    // TODO: Send to analytics backend (Firebase Analytics, Mixpanel, etc.)
    // For now, just print to console
    debugPrint('Analytics Event: $eventName');
    debugPrint('Parameters: $parameters');
  }

  /// Get session duration
  Duration? getSessionDuration() {
    if (_sessionStartTime == null) return null;
    return DateTime.now().difference(_sessionStartTime!);
  }

  /// Get current session ID
  String? get sessionId => _sessionId;
}
