/// Player Progress Model
/// Tracks player stats, levels, and collected items
class PlayerProgress {
  final int currentStage;
  final int currentLevelInStage;
  final int experience;
  final int maxHearts;
  final int currentHearts;
  final List<String> unlockedStages;
  final List<String> collectedWords;
  final Map<String, int> foodInventory;
  final int totalScore;

  const PlayerProgress({
    this.currentStage = 1,
    this.currentLevelInStage = 1,
    this.experience = 0,
    this.maxHearts = 5,
    this.currentHearts = 5,
    this.unlockedStages = const ['stage_1'],
    this.collectedWords = const [],
    this.foodInventory = const {},
    this.totalScore = 0,
  });

  static const int maxLevelPerStage = 10;
  static const int expPerLevel = 100;

  int get currentLevel {
    return ((currentStage - 1) * maxLevelPerStage) + currentLevelInStage;
  }

  int get expToNextLevel {
    return expPerLevel - (experience % expPerLevel);
  }

  int get expProgressPercent {
    return ((experience % expPerLevel) / expPerLevel * 100).round();
  }

  bool get canPlay {
    return currentHearts > 0;
  }

  bool isStageUnlocked(String stageId) {
    return unlockedStages.contains(stageId);
  }

  PlayerProgress copyWith({
    int? currentStage,
    int? currentLevelInStage,
    int? experience,
    int? maxHearts,
    int? currentHearts,
    List<String>? unlockedStages,
    List<String>? collectedWords,
    Map<String, int>? foodInventory,
    int? totalScore,
  }) {
    return PlayerProgress(
      currentStage: currentStage ?? this.currentStage,
      currentLevelInStage: currentLevelInStage ?? this.currentLevelInStage,
      experience: experience ?? this.experience,
      maxHearts: maxHearts ?? this.maxHearts,
      currentHearts: currentHearts ?? this.currentHearts,
      unlockedStages: unlockedStages ?? this.unlockedStages,
      collectedWords: collectedWords ?? this.collectedWords,
      foodInventory: foodInventory ?? this.foodInventory,
      totalScore: totalScore ?? this.totalScore,
    );
  }

  factory PlayerProgress.fromJson(Map<String, dynamic> json) {
    return PlayerProgress(
      currentStage: json['currentStage'] as int? ?? 1,
      currentLevelInStage: json['currentLevelInStage'] as int? ?? 1,
      experience: json['experience'] as int? ?? 0,
      maxHearts: json['maxHearts'] as int? ?? 5,
      currentHearts: json['currentHearts'] as int? ?? 5,
      unlockedStages: (json['unlockedStages'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
          const ['stage_1'],
      collectedWords: (json['collectedWords'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
          const [],
      foodInventory: (json['foodInventory'] as Map<String, dynamic>?)?.map(
            (k, v) => MapEntry(k, v as int),
          ) ??
          const {},
      totalScore: json['totalScore'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'currentStage': currentStage,
    'currentLevelInStage': currentLevelInStage,
    'experience': experience,
    'maxHearts': maxHearts,
    'currentHearts': currentHearts,
    'unlockedStages': unlockedStages,
    'collectedWords': collectedWords,
    'foodInventory': foodInventory,
    'totalScore': totalScore,
  };
}

/// Cebuano Food Item
class FoodItem {
  final String id;
  final String name;
  final String cebuanoName;
  final String description;
  final int healAmount;
  final int? boostDuration;
  final String? effect;

  const FoodItem({
    required this.id,
    required this.name,
    required this.cebuanoName,
    required this.description,
    this.healAmount = 0,
    this.boostDuration,
    this.effect,
  });
}

/// Predefined Cebuano Food Items
class CebuanoFoods {
  static const FoodItem lechon = FoodItem(
    id: 'lechon',
    name: 'Lechon',
    cebuanoName: 'Litson',
    description: 'Roasted pig - restores 2 hearts',
    healAmount: 2,
  );

  static const FoodItem puso = FoodItem(
    id: 'puso',
    name: 'Puso',
    cebuanoName: 'Puso',
    description: 'Hanging rice - restores 1 heart',
    healAmount: 1,
  );

  static const FoodItem mango = FoodItem(
    id: 'mango',
    name: 'Dried Mango',
    cebuanoName: 'Piniritong Mangga',
    description: 'Sweet dried mango - restores 1 heart',
    healAmount: 1,
  );

  static const FoodItem sikwate = FoodItem(
    id: 'sikwate',
    name: 'Sikwate',
    cebuanoName: 'Sikwate',
    description: 'Hot chocolate - boosts speed for 10 seconds',
    healAmount: 0,
    boostDuration: 10,
    effect: 'speed_boost',
  );

  static const FoodItem bibingka = FoodItem(
    id: 'bibingka',
    name: 'Bibingka',
    cebuanoName: 'Bibingka',
    description: 'Rice cake - restores 2 hearts',
    healAmount: 2,
  );

  static const List<FoodItem> all = [lechon, puso, mango, sikwate, bibingka];

  static FoodItem? getById(String id) {
    try {
      return all.firstWhere((f) => f.id == id);
    } catch (e) {
      return null;
    }
  }
}
