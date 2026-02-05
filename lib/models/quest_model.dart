/// Quest Model
/// Tracks daily/weekly quests with rewards
class Quest {
  final String id;
  final String title;
  final String description;
  final QuestType type;
  final QuestStatus status;
  final List<QuestTask> tasks;
  final List<QuestReward> rewards;
  final DateTime? startDate;
  final DateTime? endDate;
  final int? requiredLevel;
  final bool isRepeatable;
  final int? repeatInterval; // in hours

  const Quest({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.status,
    required this.tasks,
    required this.rewards,
    this.startDate,
    this.endDate,
    this.requiredLevel,
    this.isRepeatable = false,
    this.repeatInterval,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type.name,
      'status': status.name,
      'tasks': tasks.map((t) => t.toJson()).toList(),
      'rewards': rewards.map((r) => r.toJson()).toList(),
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'requiredLevel': requiredLevel,
      'isRepeatable': isRepeatable,
      'repeatInterval': repeatInterval,
    };
  }

  factory Quest.fromJson(Map<String, dynamic> json) {
    return Quest(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      type: QuestType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => QuestType.daily,
      ),
      status: QuestStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => QuestStatus.locked,
      ),
      tasks: (json['tasks'] as List<dynamic>)
          .map((t) => QuestTask.fromJson(t as Map<String, dynamic>))
          .toList(),
      rewards: (json['rewards'] as List<dynamic>)
          .map((r) => QuestReward.fromJson(r as Map<String, dynamic>))
          .toList(),
      startDate: json['startDate'] != null
          ? DateTime.parse(json['startDate'] as String)
          : null,
      endDate: json['endDate'] != null
          ? DateTime.parse(json['endDate'] as String)
          : null,
      requiredLevel: json['requiredLevel'] as int?,
      isRepeatable: json['isRepeatable'] as bool,
      repeatInterval: json['repeatInterval'] as int?,
    );
  }

  /// Get progress percentage
  double get progress {
    if (tasks.isEmpty) return 0;
    final completedTasks = tasks.where((t) => t.isCompleted).length;
    return completedTasks / tasks.length;
  }

  /// Check if quest is completed
  bool get isCompleted => tasks.every((t) => t.isCompleted);

  /// Check if quest is expired
  bool get isExpired {
    if (endDate == null) return false;
    return DateTime.now().isAfter(endDate!);
  }
}

enum QuestType { daily, weekly, special, event }

enum QuestStatus { locked, available, inProgress, completed, expired }

class QuestTask {
  final String id;
  final String description;
  final TaskType type;
  final String? targetId; // For word learning tasks
  final int? targetCount;
  final int currentCount;
  final bool isCompleted;

  const QuestTask({
    required this.id,
    required this.description,
    required this.type,
    this.targetId,
    this.targetCount,
    this.currentCount = 0,
    this.isCompleted = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'type': type.name,
      'targetId': targetId,
      'targetCount': targetCount,
      'currentCount': currentCount,
      'isCompleted': isCompleted,
    };
  }

  factory QuestTask.fromJson(Map<String, dynamic> json) {
    return QuestTask(
      id: json['id'] as String,
      description: json['description'] as String,
      type: TaskType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => TaskType.learnWords,
      ),
      targetId: json['targetId'] as String?,
      targetCount: json['targetCount'] as int?,
      currentCount: json['currentCount'] as int,
      isCompleted: json['isCompleted'] as bool,
    );
  }
}

enum TaskType {
  learnWords,
  completeLevel,
  earnStars,
  playTime,
  perfectScore,
  interactNPC,
}

class QuestReward {
  final String type; // 'coins', 'stars', 'item', 'xp'
  final int? amount;
  final String? itemId;
  final String? name;
  final String? icon;

  const QuestReward({
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

  factory QuestReward.fromJson(Map<String, dynamic> json) {
    return QuestReward(
      type: json['type'] as String,
      amount: json['amount'] as int?,
      itemId: json['itemId'] as String?,
      name: json['name'] as String?,
      icon: json['icon'] as String?,
    );
  }
}

/// Quest Database
class QuestDatabase {
  static const List<Quest> dailyQuests = [
    Quest(
      id: 'daily_1',
      title: 'Word Learner',
      description: 'Learn 5 new Cebuano words today',
      type: QuestType.daily,
      status: QuestStatus.available,
      tasks: [
        QuestTask(
          id: 'daily_1_task1',
          description: 'Learn 5 new words',
          type: TaskType.learnWords,
          targetCount: 5,
          currentCount: 0,
        ),
      ],
      rewards: [
        QuestReward(type: 'coins', amount: 25),
        QuestReward(type: 'stars', amount: 2),
      ],
      isRepeatable: true,
      repeatInterval: 24, // 24 hours
    ),
    Quest(
      id: 'daily_2',
      title: 'Level Champion',
      description: 'Complete 2 levels today',
      type: QuestType.daily,
      status: QuestStatus.available,
      tasks: [
        QuestTask(
          id: 'daily_2_task1',
          description: 'Complete 2 levels',
          type: TaskType.completeLevel,
          targetCount: 2,
          currentCount: 0,
        ),
      ],
      rewards: [
        QuestReward(type: 'coins', amount: 50),
        QuestReward(type: 'stars', amount: 5),
      ],
      isRepeatable: true,
      repeatInterval: 24,
    ),
    Quest(
      id: 'daily_3',
      title: 'Star Collector',
      description: 'Earn 10 stars today',
      type: QuestType.daily,
      status: QuestStatus.available,
      tasks: [
        QuestTask(
          id: 'daily_3_task1',
          description: 'Earn 10 stars',
          type: TaskType.earnStars,
          targetCount: 10,
          currentCount: 0,
        ),
      ],
      rewards: [
        QuestReward(type: 'coins', amount: 30),
        QuestReward(type: 'stars', amount: 3),
      ],
      isRepeatable: true,
      repeatInterval: 24,
    ),
    Quest(
      id: 'daily_4',
      title: 'Practice Time',
      description: 'Play for 30 minutes today',
      type: QuestType.daily,
      status: QuestStatus.available,
      tasks: [
        QuestTask(
          id: 'daily_4_task1',
          description: 'Play for 30 minutes',
          type: TaskType.playTime,
          targetCount: 30,
          currentCount: 0,
        ),
      ],
      rewards: [
        QuestReward(type: 'coins', amount: 20),
        QuestReward(type: 'stars', amount: 2),
      ],
      isRepeatable: true,
      repeatInterval: 24,
    ),
  ];

  static const List<Quest> weeklyQuests = [
    Quest(
      id: 'weekly_1',
      title: 'Dedicated Student',
      description: 'Complete 10 levels this week',
      type: QuestType.weekly,
      status: QuestStatus.available,
      tasks: [
        QuestTask(
          id: 'weekly_1_task1',
          description: 'Complete 10 levels',
          type: TaskType.completeLevel,
          targetCount: 10,
          currentCount: 0,
        ),
      ],
      rewards: [
        QuestReward(type: 'coins', amount: 200),
        QuestReward(type: 'stars', amount: 30),
        QuestReward(
          type: 'item',
          itemId: 'weekly_badge',
          name: 'Weekly Champion',
          icon: '🏅',
        ),
      ],
      startDate: null,
      endDate: null,
      isRepeatable: true,
      repeatInterval: 168, // 7 days
    ),
    Quest(
      id: 'weekly_2',
      title: 'Word Master',
      description: 'Learn 50 new words this week',
      type: QuestType.weekly,
      status: QuestStatus.available,
      tasks: [
        QuestTask(
          id: 'weekly_2_task1',
          description: 'Learn 50 words',
          type: TaskType.learnWords,
          targetCount: 50,
          currentCount: 0,
        ),
      ],
      rewards: [
        QuestReward(type: 'coins', amount: 150),
        QuestReward(type: 'stars', amount: 20),
      ],
      startDate: null,
      endDate: null,
      isRepeatable: true,
      repeatInterval: 168,
    ),
    Quest(
      id: 'weekly_3',
      title: 'Social Butterfly',
      description: 'Talk to 3 different NPCs this week',
      type: QuestType.weekly,
      status: QuestStatus.available,
      requiredLevel: 5,
      tasks: [
        QuestTask(
          id: 'weekly_3_task1',
          description: 'Talk to 3 NPCs',
          type: TaskType.interactNPC,
          targetCount: 3,
          currentCount: 0,
        ),
      ],
      rewards: [
        QuestReward(type: 'coins', amount: 100),
        QuestReward(type: 'stars', amount: 15),
      ],
      startDate: null,
      endDate: null,
      isRepeatable: true,
      repeatInterval: 168,
    ),
    Quest(
      id: 'weekly_4',
      title: 'Perfect Week',
      description: 'Get 3 stars on 5 different levels this week',
      type: QuestType.weekly,
      status: QuestStatus.available,
      tasks: [
        QuestTask(
          id: 'weekly_4_task1',
          description: 'Perfect score on 5 levels',
          type: TaskType.perfectScore,
          targetCount: 5,
          currentCount: 0,
        ),
      ],
      rewards: [
        QuestReward(type: 'coins', amount: 300),
        QuestReward(type: 'stars', amount: 40),
        QuestReward(
          type: 'item',
          itemId: 'perfect_badge',
          name: 'Perfectionist',
          icon: '🎯',
        ),
      ],
      startDate: null,
      endDate: null,
      isRepeatable: true,
      repeatInterval: 168,
    ),
  ];

  /// Get quest by ID
  static Quest? getQuest(String id) {
    try {
      return [...dailyQuests, ...weeklyQuests].firstWhere((q) => q.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get available daily quests
  static List<Quest> getAvailableDailyQuests(int currentLevel) {
    return dailyQuests.where((q) {
      final levelRequirement =
          q.requiredLevel == null || currentLevel >= q.requiredLevel!;
      final notExpired = !q.isExpired;
      return levelRequirement && notExpired;
    }).toList();
  }

  /// Get available weekly quests
  static List<Quest> getAvailableWeeklyQuests(int currentLevel) {
    return weeklyQuests.where((q) {
      final levelRequirement =
          q.requiredLevel == null || currentLevel >= q.requiredLevel!;
      final notExpired = !q.isExpired;
      return levelRequirement && notExpired;
    }).toList();
  }

  /// Get all available quests
  static List<Quest> getAllAvailableQuests(int currentLevel) {
    return [
      ...getAvailableDailyQuests(currentLevel),
      ...getAvailableWeeklyQuests(currentLevel),
    ];
  }
}
