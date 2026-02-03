/// NPC Character Model
/// Non-player characters that interact with the player
class NpcCharacter {
  final String id;
  final String name;
  final String cebuanoName;
  final String role;
  final String avatarAsset;
  final List<Dialogue> dialogues;
  final bool givesReward;
  final int? rewardScore;
  final bool unlocksNextStage;

  const NpcCharacter({
    required this.id,
    required this.name,
    required this.cebuanoName,
    required this.role,
    required this.avatarAsset,
    this.dialogues = const [],
    this.givesReward = false,
    this.rewardScore,
    this.unlocksNextStage = false,
  });

  factory NpcCharacter.fromJson(Map<String, dynamic> json) {
    return NpcCharacter(
      id: json['id'] as String,
      name: json['name'] as String,
      cebuanoName: json['cebuanoName'] as String,
      role: json['role'] as String,
      avatarAsset: json['avatarAsset'] as String,
      dialogues: (json['dialogues'] as List<dynamic>?)
          ?.map((e) => Dialogue.fromJson(e as Map<String, dynamic>))
          .toList() ??
          const [],
      givesReward: json['givesReward'] as bool? ?? false,
      rewardScore: json['rewardScore'] as int?,
      unlocksNextStage: json['unlocksNextStage'] as bool? ?? false,
    );
  }
}

/// Dialogue entry for NPC conversations
class Dialogue {
  final String id;
  final String cebuano;
  final String english;
  final String? pronunciation;
  final List<DialogueOption>? options;
  final bool isQuestion;
  final String? correctOptionId;
  final String? explanation;

  const Dialogue({
    required this.id,
    required this.cebuano,
    required this.english,
    this.pronunciation,
    this.options,
    this.isQuestion = false,
    this.correctOptionId,
    this.explanation,
  });

  factory Dialogue.fromJson(Map<String, dynamic> json) {
    return Dialogue(
      id: json['id'] as String,
      cebuano: json['cebuano'] as String,
      english: json['english'] as String,
      pronunciation: json['pronunciation'] as String?,
      options: (json['options'] as List<dynamic>?)
          ?.map((e) => DialogueOption.fromJson(e as Map<String, dynamic>))
          .toList(),
      isQuestion: json['isQuestion'] as bool? ?? false,
      correctOptionId: json['correctOptionId'] as String?,
      explanation: json['explanation'] as String?,
    );
  }
}

/// Dialogue response option
class DialogueOption {
  final String id;
  final String cebuano;
  final String english;
  final String? nextDialogueId;
  final bool isCorrect;

  const DialogueOption({
    required this.id,
    required this.cebuano,
    required this.english,
    this.nextDialogueId,
    this.isCorrect = false,
  });

  factory DialogueOption.fromJson(Map<String, dynamic> json) {
    return DialogueOption(
      id: json['id'] as String,
      cebuano: json['cebuano'] as String,
      english: json['english'] as String,
      nextDialogueId: json['nextDialogueId'] as String?,
      isCorrect: json['isCorrect'] as bool? ?? false,
    );
  }
}

/// Enemy/Challenge Encounter
class EnemyEncounter {
  final String id;
  final String name;
  final String cebuanoName;
  final String description;
  final String type;
  final int difficulty;
  final List<LanguageChallenge> challenges;
  final int expReward;
  final int scoreReward;
  final List<String>? dropItems;

  const EnemyEncounter({
    required this.id,
    required this.name,
    required this.cebuanoName,
    required this.description,
    required this.type,
    this.difficulty = 1,
    this.challenges = const [],
    this.expReward = 20,
    this.scoreReward = 200,
    this.dropItems,
  });

  factory EnemyEncounter.fromJson(Map<String, dynamic> json) {
    return EnemyEncounter(
      id: json['id'] as String,
      name: json['name'] as String,
      cebuanoName: json['cebuanoName'] as String,
      description: json['description'] as String,
      type: json['type'] as String,
      difficulty: json['difficulty'] as int? ?? 1,
      challenges: (json['challenges'] as List<dynamic>?)
          ?.map((e) => LanguageChallenge.fromJson(e as Map<String, dynamic>))
          .toList() ??
          const [],
      expReward: json['expReward'] as int? ?? 20,
      scoreReward: json['scoreReward'] as int? ?? 200,
      dropItems: (json['dropItems'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );
  }
}

/// Language Challenge for encounters/minigames
class LanguageChallenge {
  final String id;
  final String type;
  final String question;
  final String? cebuanoQuestion;
  final List<String> options;
  final String correctAnswer;
  final String? hint;
  final String? explanation;
  final int timeLimit;

  const LanguageChallenge({
    required this.id,
    required this.type,
    required this.question,
    this.cebuanoQuestion,
    required this.options,
    required this.correctAnswer,
    this.hint,
    this.explanation,
    this.timeLimit = 30,
  });

  factory LanguageChallenge.fromJson(Map<String, dynamic> json) {
    return LanguageChallenge(
      id: json['id'] as String,
      type: json['type'] as String,
      question: json['question'] as String,
      cebuanoQuestion: json['cebuanoQuestion'] as String?,
      options: (json['options'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      correctAnswer: json['correctAnswer'] as String,
      hint: json['hint'] as String?,
      explanation: json['explanation'] as String?,
      timeLimit: json['timeLimit'] as int? ?? 30,
    );
  }
}
