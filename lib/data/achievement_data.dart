/// Achievement System
/// Defines unlockable achievements and rewards
class Achievement {
  final String id;
  final String name;
  final String description;
  final String icon;
  final AchievementType type;
  final AchievementRequirement requirement;
  final int rewardCoins;
  final int rewardStars;
  final bool isHidden;
  final String? secretCondition;

  const Achievement({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.type,
    required this.requirement,
    required this.rewardCoins,
    required this.rewardStars,
    this.isHidden = false,
    this.secretCondition,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'icon': icon,
      'type': type.name,
      'requirement': requirement.toJson(),
      'rewardCoins': rewardCoins,
      'rewardStars': rewardStars,
      'isHidden': isHidden,
      'secretCondition': secretCondition,
    };
  }

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      icon: json['icon'] as String,
      type: AchievementType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => AchievementType.progression,
      ),
      requirement: AchievementRequirement.fromJson(
        json['requirement'] as Map<String, dynamic>,
      ),
      rewardCoins: json['rewardCoins'] as int,
      rewardStars: json['rewardStars'] as int,
      isHidden: json['isHidden'] as bool,
      secretCondition: json['secretCondition'] as String?,
    );
  }
}

enum AchievementType {
  progression, // Level-based
  collection, // Collect items
  challenge, // Complete specific tasks
  secret, // Hidden achievements
  social, // Multiplayer/community based
  timeBased, // Time-based
}

class AchievementRequirement {
  final RequirementType type;
  final int? targetValue;
  final String? targetId;
  final String? description;

  const AchievementRequirement({
    required this.type,
    this.targetValue,
    this.targetId,
    this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'type': type.name,
      'targetValue': targetValue,
      'targetId': targetId,
      'description': description,
    };
  }

  factory AchievementRequirement.fromJson(Map<String, dynamic> json) {
    return AchievementRequirement(
      type: RequirementType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => RequirementType.completeLevel,
      ),
      targetValue: json['targetValue'] as int?,
      targetId: json['targetId'] as String?,
      description: json['description'] as String?,
    );
  }
}

enum RequirementType {
  completeLevel,
  completeAllLevels,
  collectStars,
  completeDailyQuests,
  completeWeeklyQuests,
  playTime,
  perfectScore,
  noMistakes,
  collectAllWords,
  unlockAllNPCs,
}

/// Achievement Database
class AchievementDatabase {
  static const List<Achievement> achievements = [
    // Progression Achievements
    Achievement(
      id: 'ach_first_steps',
      name: 'First Steps',
      description: 'Complete your first level',
      icon: '👣',
      type: AchievementType.progression,
      requirement: AchievementRequirement(
        type: RequirementType.completeLevel,
        targetValue: 1,
        description: 'Complete Level 1',
      ),
      rewardCoins: 50,
      rewardStars: 5,
    ),
    Achievement(
      id: 'ach_early_learner',
      name: 'Early Learner',
      description: 'Complete 5 levels',
      icon: '📚',
      type: AchievementType.progression,
      requirement: AchievementRequirement(
        type: RequirementType.completeLevel,
        targetValue: 5,
        description: 'Complete Level 5',
      ),
      rewardCoins: 100,
      rewardStars: 15,
    ),
    Achievement(
      id: 'ach_dedicated_student',
      name: 'Dedicated Student',
      description: 'Complete 10 levels',
      icon: '🎓',
      type: AchievementType.progression,
      requirement: AchievementRequirement(
        type: RequirementType.completeLevel,
        targetValue: 10,
        description: 'Complete Level 10',
      ),
      rewardCoins: 200,
      rewardStars: 30,
    ),
    Achievement(
      id: 'ach_master_learner',
      name: 'Master Learner',
      description: 'Complete all 15 levels',
      icon: '🏆',
      type: AchievementType.progression,
      requirement: AchievementRequirement(
        type: RequirementType.completeAllLevels,
        targetValue: 15,
        description: 'Complete all levels',
      ),
      rewardCoins: 500,
      rewardStars: 100,
    ),

    // Collection Achievements
    Achievement(
      id: 'ach_star_collector',
      name: 'Star Collector',
      description: 'Collect 50 stars',
      icon: '⭐',
      type: AchievementType.collection,
      requirement: AchievementRequirement(
        type: RequirementType.collectStars,
        targetValue: 50,
        description: 'Collect 50 stars',
      ),
      rewardCoins: 100,
      rewardStars: 10,
    ),
    Achievement(
      id: 'ach_star_master',
      name: 'Star Master',
      description: 'Collect 100 stars',
      icon: '🌟',
      type: AchievementType.collection,
      requirement: AchievementRequirement(
        type: RequirementType.collectStars,
        targetValue: 100,
        description: 'Collect 100 stars',
      ),
      rewardCoins: 250,
      rewardStars: 25,
    ),
    Achievement(
      id: 'ach_star_legend',
      name: 'Star Legend',
      description: 'Collect all 200 stars',
      icon: '💫',
      type: AchievementType.collection,
      requirement: AchievementRequirement(
        type: RequirementType.collectStars,
        targetValue: 200,
        description: 'Collect all 200 stars',
      ),
      rewardCoins: 500,
      rewardStars: 50,
    ),

    // Challenge Achievements
    Achievement(
      id: 'ach_perfect_start',
      name: 'Perfect Start',
      description: 'Get 3 stars on your first 3 levels',
      icon: '🎯',
      type: AchievementType.challenge,
      requirement: AchievementRequirement(
        type: RequirementType.perfectScore,
        targetValue: 3,
        description: 'Get 3 stars on first 3 levels',
      ),
      rewardCoins: 75,
      rewardStars: 10,
    ),
    Achievement(
      id: 'ach_no_mistakes',
      name: 'Flawless',
      description: 'Complete a level without any mistakes',
      icon: '✨',
      type: AchievementType.challenge,
      requirement: AchievementRequirement(
        type: RequirementType.noMistakes,
        description: 'Complete level with 0 mistakes',
      ),
      rewardCoins: 150,
      rewardStars: 20,
    ),
    Achievement(
      id: 'ach_speed_demon',
      name: 'Speed Demon',
      description: 'Complete a level with half the time remaining',
      icon: '⚡',
      type: AchievementType.challenge,
      requirement: AchievementRequirement(
        type: RequirementType.playTime,
        description: 'Complete level in half time',
      ),
      rewardCoins: 100,
      rewardStars: 15,
    ),

    // Daily Quest Achievements
    Achievement(
      id: 'ach_daily_streak_3',
      name: '3-Day Streak',
      description: 'Complete daily quests for 3 consecutive days',
      icon: '🔥',
      type: AchievementType.challenge,
      requirement: AchievementRequirement(
        type: RequirementType.completeDailyQuests,
        targetValue: 3,
        description: '3 consecutive daily quests',
      ),
      rewardCoins: 50,
      rewardStars: 10,
    ),
    Achievement(
      id: 'ach_daily_streak_7',
      name: 'Week Warrior',
      description: 'Complete daily quests for 7 consecutive days',
      icon: '🗓️',
      type: AchievementType.challenge,
      requirement: AchievementRequirement(
        type: RequirementType.completeDailyQuests,
        targetValue: 7,
        description: '7 consecutive daily quests',
      ),
      rewardCoins: 150,
      rewardStars: 30,
    ),
    Achievement(
      id: 'ach_daily_streak_30',
      name: 'Monthly Master',
      description: 'Complete daily quests for 30 consecutive days',
      icon: '📅',
      type: AchievementType.challenge,
      requirement: AchievementRequirement(
        type: RequirementType.completeDailyQuests,
        targetValue: 30,
        description: '30 consecutive daily quests',
      ),
      rewardCoins: 500,
      rewardStars: 100,
    ),

    // Weekly Quest Achievements
    Achievement(
      id: 'ach_weekly_complete',
      name: 'Weekly Champion',
      description: 'Complete all weekly quests in a week',
      icon: '🏅',
      type: AchievementType.challenge,
      requirement: AchievementRequirement(
        type: RequirementType.completeWeeklyQuests,
        targetValue: 1,
        description: 'Complete all weekly quests',
      ),
      rewardCoins: 200,
      rewardStars: 40,
    ),

    // Social Achievements
    Achievement(
      id: 'ach_word_master',
      name: 'Word Master',
      description: 'Learn all Cebuano words',
      icon: '📖',
      type: AchievementType.collection,
      requirement: AchievementRequirement(
        type: RequirementType.collectAllWords,
        description: 'Learn all words',
      ),
      rewardCoins: 1000,
      rewardStars: 200,
    ),

    // NPC Achievements
    Achievement(
      id: 'ach_npc_friend',
      name: 'Friend to All',
      description: 'Unlock all NPCs',
      icon: '👥',
      type: AchievementType.collection,
      requirement: AchievementRequirement(
        type: RequirementType.unlockAllNPCs,
        description: 'Unlock all NPCs',
      ),
      rewardCoins: 300,
      rewardStars: 50,
    ),

    // Secret Achievements
    Achievement(
      id: 'ach_secret_easter_egg',
      name: 'Hidden Treasure',
      description: 'Find the hidden Easter egg',
      icon: '🥚',
      type: AchievementType.secret,
      requirement: AchievementRequirement(
        type: RequirementType.collectStars,
        description: 'Find hidden content',
      ),
      rewardCoins: 200,
      rewardStars: 40,
      isHidden: true,
      secretCondition: 'Tap the village tree 10 times',
    ),
    Achievement(
      id: 'ach_secret_ancient',
      name: 'Ancient Wisdom',
      description: 'Discover the ancient Cebuano proverb',
      icon: '📜',
      type: AchievementType.secret,
      requirement: AchievementRequirement(
        type: RequirementType.collectStars,
        description: 'Discover secret proverb',
      ),
      rewardCoins: 300,
      rewardStars: 60,
      isHidden: true,
      secretCondition: 'Complete level 15 with perfect score',
    ),
  ];

  /// Get achievement by ID
  static Achievement? getAchievement(String id) {
    try {
      return achievements.firstWhere((a) => a.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get achievements by type
  static List<Achievement> getAchievementsByType(AchievementType type) {
    return achievements.where((a) => a.type == type).toList();
  }

  /// Get visible achievements
  static List<Achievement> getVisibleAchievements() {
    return achievements.where((a) => !a.isHidden).toList();
  }

  /// Get secret achievements
  static List<Achievement> getSecretAchievements() {
    return achievements.where((a) => a.isHidden).toList();
  }

  /// Check if achievement is unlocked
  static bool isAchievementUnlocked(
    Achievement achievement,
    int currentLevel,
    int totalStars,
    int dailyQuestStreak,
    int weeklyQuestsCompleted,
  ) {
    switch (achievement.requirement.type) {
      case RequirementType.completeLevel:
        return currentLevel >= achievement.requirement.targetValue!;
      case RequirementType.completeAllLevels:
        return currentLevel >= achievement.requirement.targetValue!;
      case RequirementType.collectStars:
        return totalStars >= achievement.requirement.targetValue!;
      case RequirementType.completeDailyQuests:
        return dailyQuestStreak >= achievement.requirement.targetValue!;
      case RequirementType.completeWeeklyQuests:
        return weeklyQuestsCompleted >= achievement.requirement.targetValue!;
      case RequirementType.unlockAllNPCs:
        return currentLevel >= 10; // All NPCs unlocked by level 10
      case RequirementType.collectAllWords:
        return currentLevel >= 15; // All words learned by level 15
      default:
        return false;
    }
  }
}
