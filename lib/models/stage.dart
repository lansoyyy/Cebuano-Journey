import 'cebuano_word.dart';

/// Stage/Level Model
/// Represents a playable stage in the game
class Stage {
  final String id;
  final String name;
  final String cebuanoName;
  final String description;
  final String location;
  final int stageNumber;
  final bool isUnlocked;
  final int requiredScore;
  final List<Level> levels;
  final String themeColor;
  final String? backgroundAsset;

  const Stage({
    required this.id,
    required this.name,
    required this.cebuanoName,
    required this.description,
    required this.location,
    required this.stageNumber,
    this.isUnlocked = false,
    this.requiredScore = 0,
    required this.levels,
    this.themeColor = 'primary',
    this.backgroundAsset,
  });

  factory Stage.fromJson(Map<String, dynamic> json) {
    return Stage(
      id: json['id'] as String,
      name: json['name'] as String,
      cebuanoName: json['cebuanoName'] as String,
      description: json['description'] as String,
      location: json['location'] as String,
      stageNumber: json['stageNumber'] as int,
      isUnlocked: json['isUnlocked'] as bool? ?? false,
      requiredScore: json['requiredScore'] as int? ?? 0,
      levels: (json['levels'] as List<dynamic>)
          .map((e) => Level.fromJson(e as Map<String, dynamic>))
          .toList(),
      themeColor: json['themeColor'] as String? ?? 'primary',
      backgroundAsset: json['backgroundAsset'] as String?,
    );
  }
}

/// Level within a Stage
class Level {
  final String id;
  final int levelNumber;
  final String name;
  final String description;
  final int difficulty;
  final List<CebuanoWord> words;
  final List<String> wordIds;
  final int expReward;
  final int scoreReward;
  final bool hasNpc;
  final bool hasMinigame;
  final String? minigameType;
  final String? npcDialogue;

  const Level({
    required this.id,
    required this.levelNumber,
    required this.name,
    required this.description,
    this.difficulty = 1,
    this.words = const [],
    this.wordIds = const [],
    this.expReward = 10,
    this.scoreReward = 100,
    this.hasNpc = false,
    this.hasMinigame = false,
    this.minigameType,
    this.npcDialogue,
  });

  factory Level.fromJson(Map<String, dynamic> json) {
    return Level(
      id: json['id'] as String,
      levelNumber: json['levelNumber'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      difficulty: json['difficulty'] as int? ?? 1,
      wordIds: (json['wordIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
          const [],
      expReward: json['expReward'] as int? ?? 10,
      scoreReward: json['scoreReward'] as int? ?? 100,
      hasNpc: json['hasNpc'] as bool? ?? false,
      hasMinigame: json['hasMinigame'] as bool? ?? false,
      minigameType: json['minigameType'] as String?,
      npcDialogue: json['npcDialogue'] as String?,
    );
  }
}

/// Minigame Types
class MinigameTypes {
  static const String wordJumble = 'word_jumble';
  static const String fillInBlank = 'fill_in_blank';
  static const String sentenceRearrange = 'sentence_rearrange';
  static const String listening = 'listening';
  static const String typing = 'typing';
  static const String translation = 'translation';
  static const String multipleChoice = 'multiple_choice';
}
