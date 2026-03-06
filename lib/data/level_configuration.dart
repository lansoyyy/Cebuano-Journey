/// Level/Stage Configuration
/// Defines difficulty levels, stages, and progression for the game
class LevelConfiguration {
  final int level;
  final String name;
  final String description;
  final int requiredScore;
  final int wordCount;
  final int timeLimit; // in seconds
  final List<String> allowedCategories;
  final int difficultyRange; // min-max difficulty (e.g., 1-2)
  final int starsToUnlock;
  final List<Reward> rewards;

  const LevelConfiguration({
    required this.level,
    required this.name,
    required this.description,
    required this.requiredScore,
    required this.wordCount,
    required this.timeLimit,
    required this.allowedCategories,
    required this.difficultyRange,
    required this.starsToUnlock,
    required this.rewards,
  });

  Map<String, dynamic> toJson() {
    return {
      'level': level,
      'name': name,
      'description': description,
      'requiredScore': requiredScore,
      'wordCount': wordCount,
      'timeLimit': timeLimit,
      'allowedCategories': allowedCategories,
      'difficultyRange': difficultyRange,
      'starsToUnlock': starsToUnlock,
      'rewards': rewards.map((r) => r.toJson()).toList(),
    };
  }

  factory LevelConfiguration.fromJson(Map<String, dynamic> json) {
    return LevelConfiguration(
      level: json['level'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      requiredScore: json['requiredScore'] as int,
      wordCount: json['wordCount'] as int,
      timeLimit: json['timeLimit'] as int,
      allowedCategories: (json['allowedCategories'] as List<dynamic>)
          .cast<String>(),
      difficultyRange: json['difficultyRange'] as int,
      starsToUnlock: json['starsToUnlock'] as int,
      rewards: (json['rewards'] as List<dynamic>)
          .map((r) => Reward.fromJson(r as Map<String, dynamic>))
          .toList(),
    );
  }
}

class Reward {
  final String type; // 'coins', 'stars', 'item', 'achievement'
  final int? amount;
  final String? itemId;
  final String? name;
  final String? icon;

  const Reward({
    required this.type,
    this.amount,
    this.itemId,
    this.name,
    this.icon,
  });

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'amount': amount,
      'itemId': itemId,
      'name': name,
      'icon': icon,
    };
  }

  factory Reward.fromJson(Map<String, dynamic> json) {
    return Reward(
      type: json['type'] as String,
      amount: json['amount'] as int?,
      itemId: json['itemId'] as String?,
      name: json['name'] as String?,
      icon: json['icon'] as String?,
    );
  }
}

/// All level configurations
class LevelDatabase {
  static const List<LevelConfiguration> levels = [
    // Tutorial Levels
    LevelConfiguration(
      level: 1,
      name: 'Basayo - Introduction',
      description: 'Learn basic greetings in Cebuano',
      requiredScore: 0,
      wordCount: 5,
      timeLimit: 60,
      allowedCategories: ['greetings'],
      difficultyRange: 1,
      starsToUnlock: 0,
      rewards: [
        Reward(type: 'coins', amount: 10),
        Reward(type: 'stars', amount: 1),
      ],
    ),
    LevelConfiguration(
      level: 2,
      name: 'Mga Numero - Numbers',
      description: 'Learn to count in Cebuano',
      requiredScore: 50,
      wordCount: 10,
      timeLimit: 90,
      allowedCategories: ['numbers'],
      difficultyRange: 1,
      starsToUnlock: 3,
      rewards: [
        Reward(type: 'coins', amount: 20),
        Reward(type: 'stars', amount: 2),
      ],
    ),
    LevelConfiguration(
      level: 3,
      name: 'Mga Kolor - Colors',
      description: 'Learn colors in Cebuano',
      requiredScore: 100,
      wordCount: 8,
      timeLimit: 75,
      allowedCategories: ['colors'],
      difficultyRange: 1,
      starsToUnlock: 5,
      rewards: [
        Reward(type: 'coins', amount: 30),
        Reward(type: 'stars', amount: 3),
      ],
    ),

    // Beginner Levels
    LevelConfiguration(
      level: 4,
      name: 'Mga Mananap - Animals',
      description: 'Learn animal names in Cebuano',
      requiredScore: 200,
      wordCount: 8,
      timeLimit: 90,
      allowedCategories: ['animals'],
      difficultyRange: 1,
      starsToUnlock: 8,
      rewards: [
        Reward(type: 'coins', amount: 40),
        Reward(type: 'stars', amount: 4),
        Reward(
          type: 'item',
          itemId: 'animal_badge',
          name: 'Animal Master',
          icon: '🦁',
        ),
      ],
    ),
    LevelConfiguration(
      level: 5,
      name: 'Pagkaon - Food',
      description: 'Learn food-related words',
      requiredScore: 300,
      wordCount: 8,
      timeLimit: 90,
      allowedCategories: ['food'],
      difficultyRange: 1,
      starsToUnlock: 10,
      rewards: [
        Reward(type: 'coins', amount: 50),
        Reward(type: 'stars', amount: 5),
      ],
    ),
    LevelConfiguration(
      level: 6,
      name: 'Pamilya - Family',
      description: 'Learn family terms',
      requiredScore: 450,
      wordCount: 9,
      timeLimit: 100,
      allowedCategories: ['family'],
      difficultyRange: 1,
      starsToUnlock: 12,
      rewards: [
        Reward(type: 'coins', amount: 60),
        Reward(type: 'stars', amount: 6),
      ],
    ),

    // Intermediate Levels
    LevelConfiguration(
      level: 7,
      name: 'Panahon - Time',
      description: 'Learn time-related words',
      requiredScore: 600,
      wordCount: 12,
      timeLimit: 120,
      allowedCategories: ['time'],
      difficultyRange: 2,
      starsToUnlock: 15,
      rewards: [
        Reward(type: 'coins', amount: 80),
        Reward(type: 'stars', amount: 8),
      ],
    ),
    LevelConfiguration(
      level: 8,
      name: 'Kahimtang - Weather',
      description: 'Learn weather expressions',
      requiredScore: 800,
      wordCount: 6,
      timeLimit: 90,
      allowedCategories: ['weather'],
      difficultyRange: 2,
      starsToUnlock: 18,
      rewards: [
        Reward(type: 'coins', amount: 100),
        Reward(type: 'stars', amount: 10),
      ],
    ),
    LevelConfiguration(
      level: 9,
      name: 'Mga Emosyon - Emotions',
      description: 'Express feelings in Cebuano',
      requiredScore: 1000,
      wordCount: 6,
      timeLimit: 90,
      allowedCategories: ['emotions'],
      difficultyRange: 2,
      starsToUnlock: 20,
      rewards: [
        Reward(type: 'coins', amount: 120),
        Reward(type: 'stars', amount: 12),
      ],
    ),
    LevelConfiguration(
      level: 10,
      name: 'Mga Buhat - Actions',
      description: 'Learn common action verbs',
      requiredScore: 1250,
      wordCount: 8,
      timeLimit: 100,
      allowedCategories: ['actions'],
      difficultyRange: 2,
      starsToUnlock: 22,
      rewards: [
        Reward(type: 'coins', amount: 150),
        Reward(type: 'stars', amount: 15),
        Reward(
          type: 'item',
          itemId: 'action_badge',
          name: 'Action Hero',
          icon: '🏃',
        ),
      ],
    ),

    // Advanced Levels
    LevelConfiguration(
      level: 11,
      name: 'Mga Lugar - Places',
      description: 'Learn place names',
      requiredScore: 1500,
      wordCount: 6,
      timeLimit: 90,
      allowedCategories: ['places'],
      difficultyRange: 2,
      starsToUnlock: 25,
      rewards: [
        Reward(type: 'coins', amount: 180),
        Reward(type: 'stars', amount: 18),
      ],
    ),
    LevelConfiguration(
      level: 12,
      name: 'Mga Butang - Objects',
      description: 'Learn object names',
      requiredScore: 1800,
      wordCount: 8,
      timeLimit: 100,
      allowedCategories: ['objects'],
      difficultyRange: 2,
      starsToUnlock: 28,
      rewards: [
        Reward(type: 'coins', amount: 200),
        Reward(type: 'stars', amount: 20),
      ],
    ),
    LevelConfiguration(
      level: 13,
      name: 'Kasamang - Mixed Review',
      description: 'Review all categories',
      requiredScore: 2100,
      wordCount: 15,
      timeLimit: 150,
      allowedCategories: [
        'greetings',
        'numbers',
        'colors',
        'animals',
        'food',
        'family',
      ],
      difficultyRange: 1,
      starsToUnlock: 30,
      rewards: [
        Reward(type: 'coins', amount: 250),
        Reward(type: 'stars', amount: 25),
      ],
    ),

    // Expert Levels
    LevelConfiguration(
      level: 14,
      name: 'Pagsulti - Challenge',
      description: 'Advanced mixed categories',
      requiredScore: 2500,
      wordCount: 20,
      timeLimit: 180,
      allowedCategories: [
        'time',
        'weather',
        'emotions',
        'actions',
        'places',
        'objects',
      ],
      difficultyRange: 3,
      starsToUnlock: 35,
      rewards: [
        Reward(type: 'coins', amount: 300),
        Reward(type: 'stars', amount: 30),
        Reward(
          type: 'item',
          itemId: 'expert_badge',
          name: 'Expert Learner',
          icon: '🏆',
        ),
      ],
    ),
    LevelConfiguration(
      level: 15,
      name: 'Magbasa - Mastery',
      description: 'Complete mastery test',
      requiredScore: 3000,
      wordCount: 25,
      timeLimit: 200,
      allowedCategories: ['general'],
      difficultyRange: 3,
      starsToUnlock: 40,
      rewards: [
        Reward(type: 'coins', amount: 500),
        Reward(type: 'stars', amount: 50),
        Reward(
          type: 'achievement',
          itemId: 'mastery_achievement',
          name: 'Cebuano Master',
          icon: '🎓',
        ),
      ],
    ),

    // PDF-Based Levels - Grammar and Markers
    LevelConfiguration(
      level: 16,
      name: 'Honorifics & Endearments',
      description: 'Learn respectful terms and endearing words',
      requiredScore: 3500,
      wordCount: 8,
      timeLimit: 90,
      allowedCategories: ['general'],
      difficultyRange: 2,
      starsToUnlock: 45,
      rewards: [
        Reward(type: 'coins', amount: 350),
        Reward(type: 'stars', amount: 35),
        Reward(
          type: 'item',
          itemId: 'polite_badge',
          name: 'Polite Speaker',
          icon: '🙏',
        ),
      ],
    ),
    LevelConfiguration(
      level: 17,
      name: 'Markers & Pronouns',
      description: 'Learn nominative markers and pronouns',
      requiredScore: 4000,
      wordCount: 10,
      timeLimit: 100,
      allowedCategories: ['general'],
      difficultyRange: 2,
      starsToUnlock: 50,
      rewards: [
        Reward(type: 'coins', amount: 400),
        Reward(type: 'stars', amount: 40),
      ],
    ),
    LevelConfiguration(
      level: 18,
      name: 'Interrogatives',
      description: 'Learn question words',
      requiredScore: 4500,
      wordCount: 8,
      timeLimit: 90,
      allowedCategories: ['general'],
      difficultyRange: 2,
      starsToUnlock: 55,
      rewards: [
        Reward(type: 'coins', amount: 450),
        Reward(type: 'stars', amount: 45),
      ],
    ),
    LevelConfiguration(
      level: 19,
      name: 'Existentials & Negatives',
      description: 'Learn "May", "Wala", and negative forms',
      requiredScore: 5000,
      wordCount: 6,
      timeLimit: 80,
      allowedCategories: ['general'],
      difficultyRange: 2,
      starsToUnlock: 60,
      rewards: [
        Reward(type: 'coins', amount: 500),
        Reward(type: 'stars', amount: 50),
        Reward(
          type: 'item',
          itemId: 'grammar_badge',
          name: 'Grammar Expert',
          icon: '📚',
        ),
      ],
    ),
    LevelConfiguration(
      level: 20,
      name: 'Adjectives Review',
      description: 'Master descriptive words',
      requiredScore: 5500,
      wordCount: 12,
      timeLimit: 120,
      allowedCategories: ['general'],
      difficultyRange: 2,
      starsToUnlock: 65,
      rewards: [
        Reward(type: 'coins', amount: 550),
        Reward(type: 'stars', amount: 55),
      ],
    ),
    LevelConfiguration(
      level: 21,
      name: 'Action Verbs',
      description: 'Learn common action verbs',
      requiredScore: 6000,
      wordCount: 10,
      timeLimit: 100,
      allowedCategories: ['actions'],
      difficultyRange: 2,
      starsToUnlock: 70,
      rewards: [
        Reward(type: 'coins', amount: 600),
        Reward(type: 'stars', amount: 60),
      ],
    ),
    LevelConfiguration(
      level: 22,
      name: 'Body & Health',
      description: 'Learn body parts and health expressions',
      requiredScore: 6500,
      wordCount: 8,
      timeLimit: 90,
      allowedCategories: ['general'],
      difficultyRange: 2,
      starsToUnlock: 75,
      rewards: [
        Reward(type: 'coins', amount: 650),
        Reward(type: 'stars', amount: 65),
      ],
    ),
    LevelConfiguration(
      level: 23,
      name: 'Food & Kitchen',
      description: 'Learn food and kitchen vocabulary',
      requiredScore: 7000,
      wordCount: 10,
      timeLimit: 100,
      allowedCategories: ['food', 'objects'],
      difficultyRange: 2,
      starsToUnlock: 80,
      rewards: [
        Reward(type: 'coins', amount: 700),
        Reward(type: 'stars', amount: 70),
        Reward(
          type: 'item',
          itemId: 'chef_badge',
          name: 'Food Expert',
          icon: '🍳',
        ),
      ],
    ),
    LevelConfiguration(
      level: 24,
      name: 'Places & Directions',
      description: 'Learn locations and directions',
      requiredScore: 7500,
      wordCount: 8,
      timeLimit: 90,
      allowedCategories: ['places'],
      difficultyRange: 2,
      starsToUnlock: 85,
      rewards: [
        Reward(type: 'coins', amount: 750),
        Reward(type: 'stars', amount: 75),
      ],
    ),
    LevelConfiguration(
      level: 25,
      name: 'Weather & Nature',
      description: 'Learn weather and nature terms',
      requiredScore: 8000,
      wordCount: 8,
      timeLimit: 90,
      allowedCategories: ['weather'],
      difficultyRange: 2,
      starsToUnlock: 90,
      rewards: [
        Reward(type: 'coins', amount: 800),
        Reward(type: 'stars', amount: 80),
      ],
    ),
    LevelConfiguration(
      level: 26,
      name: 'Emotions & Feelings',
      description: 'Express emotions in Cebuano',
      requiredScore: 8500,
      wordCount: 8,
      timeLimit: 90,
      allowedCategories: ['emotions'],
      difficultyRange: 2,
      starsToUnlock: 95,
      rewards: [
        Reward(type: 'coins', amount: 850),
        Reward(type: 'stars', amount: 85),
      ],
    ),
    LevelConfiguration(
      level: 27,
      name: 'Advanced Grammar',
      description: 'Master advanced grammar concepts',
      requiredScore: 9000,
      wordCount: 15,
      timeLimit: 120,
      allowedCategories: ['general', 'actions'],
      difficultyRange: 3,
      starsToUnlock: 100,
      rewards: [
        Reward(type: 'coins', amount: 900),
        Reward(type: 'stars', amount: 90),
        Reward(
          type: 'item',
          itemId: 'grammar_master_badge',
          name: 'Grammar Master',
          icon: '🎓',
        ),
      ],
    ),
    LevelConfiguration(
      level: 28,
      name: 'Conversation Practice',
      description: 'Practice conversational Cebuano',
      requiredScore: 9500,
      wordCount: 20,
      timeLimit: 150,
      allowedCategories: ['greetings', 'general', 'actions', 'emotions'],
      difficultyRange: 3,
      starsToUnlock: 105,
      rewards: [
        Reward(type: 'coins', amount: 950),
        Reward(type: 'stars', amount: 95),
      ],
    ),
    LevelConfiguration(
      level: 29,
      name: 'Complete Review',
      description: 'Comprehensive review of all lessons',
      requiredScore: 10000,
      wordCount: 25,
      timeLimit: 180,
      allowedCategories: [
        'greetings',
        'numbers',
        'colors',
        'animals',
        'food',
        'family',
        'time',
        'weather',
        'emotions',
        'actions',
        'places',
        'objects',
        'general',
      ],
      difficultyRange: 3,
      starsToUnlock: 110,
      rewards: [
        Reward(type: 'coins', amount: 1000),
        Reward(type: 'stars', amount: 100),
        Reward(
          type: 'achievement',
          itemId: 'complete_achievement',
          name: 'Cebuano Champion',
          icon: '🏆',
        ),
      ],
    ),
  ];

  /// Get level by number
  static LevelConfiguration? getLevel(int level) {
    try {
      return levels.firstWhere((l) => l.level == level);
    } catch (e) {
      return null;
    }
  }

  /// Get next level
  static LevelConfiguration? getNextLevel(int currentLevel) {
    return getLevel(currentLevel + 1);
  }

  /// Check if level is unlocked
  static bool isLevelUnlocked(int level, int currentScore) {
    final levelConfig = getLevel(level);
    return levelConfig != null && currentScore >= levelConfig.requiredScore;
  }

  /// Get total levels
  static int get totalLevels => levels.length;

  /// Get maximum level
  static LevelConfiguration get maxLevel => levels.last;
}
