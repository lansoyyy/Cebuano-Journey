import 'word_token.dart';
import 'quiz_question.dart';

class LevelPlatform {
  final double worldX;
  final double screenY;
  final double width;

  const LevelPlatform({
    required this.worldX,
    required this.screenY,
    required this.width,
  });
}

class LevelToken {
  final double worldX;
  final double screenY;
  final WordToken word;
  bool collected;

  LevelToken({
    required this.worldX,
    required this.screenY,
    required this.word,
    this.collected = false,
  });
}

class LevelNPC {
  final double worldX;
  final String name;
  final String greeting;
  final List<QuizQuestion> questions;
  bool completed;

  LevelNPC({
    required this.worldX,
    required this.name,
    required this.greeting,
    required this.questions,
    this.completed = false,
  });
}

enum WorldTheme { market, festival, city, nature }

class LevelHint {
  final double worldX;
  final double screenY;
  bool collected;

  LevelHint({
    required this.worldX,
    required this.screenY,
    this.collected = false,
  });
}

class LevelData {
  final int world;
  final int level;
  final WorldTheme theme;
  final double worldLength;
  final List<LevelPlatform> platforms;
  final List<LevelToken> tokens;
  final List<LevelNPC> npcs;
  final List<LevelHint> hints;

  const LevelData({
    required this.world,
    required this.level,
    required this.theme,
    required this.worldLength,
    required this.platforms,
    required this.tokens,
    required this.npcs,
    this.hints = const [],
  });

  String get themeLabel {
    switch (theme) {
      case WorldTheme.market:
        return 'Merkado';
      case WorldTheme.festival:
        return 'Pista';
      case WorldTheme.city:
        return 'Syudad';
      case WorldTheme.nature:
        return 'Kinaiyahan';
    }
  }
}
