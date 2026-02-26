import 'dart:math';
import '../core/models/level_data.dart';
import '../core/models/quiz_question.dart';
import '../core/models/word_token.dart';
import 'cebuano_word_bank.dart';

class LevelGenerator {
  static const _themes = WorldTheme.values;

  static LevelData generate({
    required int world,
    required int level,
    required double screenWidth,
    required double groundY,
  }) {
    final seed = world * 100 + level;
    final rng = Random(seed);
    final theme = _themes[(world - 1) % _themes.length];
    final difficulty = (world - 1) * 5 + level;
    final worldLength = screenWidth * (4 + difficulty * 0.5);

    final levelWords = CebuanoWordBank.forLevel(difficulty);

    // ── Platforms ────────────────────────────────────────────────────────────
    final platformCount = 8 + difficulty * 2;
    final platforms = <LevelPlatform>[];
    double px = screenWidth * 0.6;
    for (int i = 0; i < platformCount; i++) {
      final w = 80.0 + rng.nextDouble() * 120;
      final sy = groundY - 80 - rng.nextDouble() * (groundY * 0.45);
      platforms.add(LevelPlatform(worldX: px, screenY: sy, width: w));
      px += 140 + rng.nextDouble() * 180;
    }

    // ── Tokens (one per word, placed near platforms) ─────────────────────────
    final tokenWords = _pickRandom(
      levelWords,
      min(levelWords.length, 8 + difficulty),
      rng,
    );
    final tokens = <LevelToken>[];
    for (int i = 0; i < tokenWords.length; i++) {
      final plat = i < platforms.length
          ? platforms[i]
          : platforms[rng.nextInt(platforms.length)];
      tokens.add(
        LevelToken(
          worldX: plat.worldX + plat.width / 2,
          screenY: plat.screenY - 28,
          word: tokenWords[i],
        ),
      );
    }

    // ── NPCs (3 per level at intervals) ─────────────────────────────────────
    final npcCount = 3;
    final npcs = <LevelNPC>[];
    final npcNames = ['Lola Rosa', 'Kuya Ben', 'Ate Mila'];
    final npcGreetings = [
      'Kumusta! Tagad og tubag sa akong pangutana.',
      'Hoy! Makigsulti ta. Tubaga ang akong pangutana.',
      'Halika! Sulayan nato ang imong nahibaloan.',
    ];
    // Deterministic NPC sprite ID based on world+level+index, cycling 1-16
    final npcIdBase = ((world - 1) * 5 + (level - 1)) * npcCount;
    for (int i = 0; i < npcCount; i++) {
      final npcX = worldLength * ((i + 1) / (npcCount + 1));
      final quizWords = _pickRandom(tokenWords, min(4, tokenWords.length), rng);
      npcs.add(
        LevelNPC(
          worldX: npcX,
          name: npcNames[i % npcNames.length],
          greeting: npcGreetings[i % npcGreetings.length],
          questions: _buildQuestions(quizWords, levelWords, rng),
          npcId: (npcIdBase + i) % 16 + 1,
        ),
      );
    }

    // ── Hints (1-2 per level on hard to reach platforms) ────────────────────
    final hints = <LevelHint>[];
    if (rng.nextBool() || difficulty > 5) {
      final plat = platforms[rng.nextInt(platforms.length)];
      hints.add(
        LevelHint(
          worldX: plat.worldX + plat.width / 2,
          screenY: plat.screenY - 60, // Higher up
        ),
      );
    }

    return LevelData(
      world: world,
      level: level,
      theme: theme,
      worldLength: worldLength,
      platforms: platforms,
      tokens: tokens,
      npcs: npcs,
      hints: hints,
    );
  }

  static List<QuizQuestion> _buildQuestions(
    List<WordToken> quizWords,
    List<WordToken> allWords,
    Random rng,
  ) {
    final questions = <QuizQuestion>[];
    final types = QuizType.values;
    for (int i = 0; i < quizWords.length; i++) {
      final word = quizWords[i];
      final type = types[i % types.length];
      questions.add(_makeQuestion(type, word, allWords, rng));
    }
    return questions;
  }

  static QuizQuestion _makeQuestion(
    QuizType type,
    WordToken word,
    List<WordToken> allWords,
    Random rng,
  ) {
    switch (type) {
      case QuizType.multipleChoice:
        final distractors = allWords.where((w) => w.id != word.id).toList()
          ..shuffle(rng);
        final opts = [
          word.english,
          ...distractors.take(3).map((w) => w.english),
        ]..shuffle(rng);
        return QuizQuestion(
          type: QuizType.multipleChoice,
          prompt: 'What does "${word.cebuano}" mean?',
          correctAnswer: word.english,
          options: opts,
          cebuano: word.cebuano,
          english: word.english,
          hint: 'Think about the category: ${word.category}',
        );

      case QuizType.fillBlank:
        return QuizQuestion(
          type: QuizType.fillBlank,
          prompt: 'Type the Cebuano word for "${word.english}":',
          correctAnswer: word.cebuano,
          cebuano: word.cebuano,
          english: word.english,
          hint: 'It starts with "${word.cebuano[0]}"',
        );

      case QuizType.wordJumble:
        final letters = word.cebuano.toUpperCase().split('')..shuffle(rng);
        return QuizQuestion(
          type: QuizType.wordJumble,
          prompt:
              'Arrange the letters to form the Cebuano word for "${word.english}":',
          correctAnswer: word.cebuano.toUpperCase(),
          options: letters,
          cebuano: word.cebuano,
          english: word.english,
          hint: 'The word has ${word.cebuano.length} characters',
        );

      case QuizType.flashcard:
        return QuizQuestion(
          type: QuizType.flashcard,
          prompt: word.cebuano,
          correctAnswer: word.english,
          cebuano: word.cebuano,
          english: word.english,
          hint: word.category,
        );
    }
  }

  static List<T> _pickRandom<T>(List<T> source, int count, Random rng) {
    final list = [...source]..shuffle(rng);
    return list.take(count).toList();
  }
}
