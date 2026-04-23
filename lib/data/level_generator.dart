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
      // Make some platforms moving (30% chance, more on higher difficulty)
      final isMoving = rng.nextDouble() < 0.3 + (difficulty * 0.02);
      final moveSpeed = isMoving ? 30.0 + rng.nextDouble() * 40.0 : 0.0;
      final moveRange = isMoving ? 60.0 + rng.nextDouble() * 80.0 : 0.0;
      platforms.add(
        LevelPlatform(
          worldX: px,
          screenY: sy,
          width: w,
          isMoving: isMoving,
          moveSpeed: moveSpeed,
          moveRange: moveRange,
          initialX: px,
        ),
      );
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
      // Distribute regular NPCs across first 75% of the world
      final npcX = worldLength * ((i + 1) / (npcCount + 1)) * 0.75;
      final quizWords = _pickRandom(tokenWords, min(4, tokenWords.length), rng);
      npcs.add(
        LevelNPC(
          worldX: npcX,
          name: npcNames[i % npcNames.length],
          greeting: npcGreetings[i % npcGreetings.length],
          questions: _buildQuestions(quizWords, levelWords, rng, difficulty),
          npcId: (npcIdBase + i) % 16 + 1,
        ),
      );
    }

    // ── Gatekeeper NPC at the end ────────────────────────────────────────────
    final gatekeeperWords = _pickRandom(tokenWords, min(5, tokenWords.length), rng);
    npcs.add(
      LevelNPC(
        worldX: worldLength * 0.90,
        name: 'Gatekeeper',
        greeting: 'Dili ka makaabot sa sunod nga lebel kung wala ka moagi sa akong pagsulay!',
        questions: _buildQuestions(gatekeeperWords, levelWords, rng, difficulty + 1),
        npcId: (npcIdBase + npcCount) % 16 + 1,
        isGatekeeper: true,
      ),
    );

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
    int difficulty,
  ) {
    final questions = <QuizQuestion>[];
    final types = _typesForDifficulty(difficulty);
    for (int i = 0; i < quizWords.length; i++) {
      final word = quizWords[i];
      final type = types[(difficulty + i) % types.length];
      questions.add(_makeQuestion(type, word, allWords, rng));
    }
    questions.shuffle(rng);
    return questions;
  }

  static List<QuizType> _typesForDifficulty(int difficulty) {
    if (difficulty <= 1) {
      return const [
        QuizType.multipleChoice,
        QuizType.fillBlank,
        QuizType.flashcard,
      ];
    }
    if (difficulty == 2) {
      return const [
        QuizType.multipleChoice,
        QuizType.fillBlank,
        QuizType.wordJumble,
      ];
    }
    if (difficulty == 3) {
      return const [
        QuizType.wordJumble,
        QuizType.fillBlank,
        QuizType.conversation,
      ];
    }
    if (difficulty == 4) {
      return const [
        QuizType.conversation,
        QuizType.wordJumble,
        QuizType.fillBlank,
      ];
    }
    if (difficulty == 5) {
      return const [
        QuizType.conversation,
        QuizType.wordMatch,
        QuizType.fillBlank,
      ];
    }
    return const [
      QuizType.multipleChoice,
      QuizType.fillBlank,
      QuizType.wordJumble,
      QuizType.flashcard,
      QuizType.conversation,
      QuizType.wordMatch,
    ];
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
        final phrase = _buildWordJumblePhrase(word);
        final words = [...phrase.$1]..shuffle(rng);
        return QuizQuestion(
          type: QuizType.wordJumble,
          prompt: phrase.$3,
          correctAnswer: phrase.$2,
          options: words,
          cebuano: word.cebuano,
          english: word.english,
          hint: phrase.$4,
          useSpacesInJumble: true,
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

      case QuizType.conversation:
        final conversation = _buildConversationQuestion(word, allWords, rng);
        return QuizQuestion(
          type: QuizType.conversation,
          prompt: conversation.$1,
          correctAnswer: conversation.$2,
          options: conversation.$3,
          cebuano: word.cebuano,
          english: word.english,
          hint: conversation.$4,
        );

      case QuizType.wordMatch:
        final matchWords = _pickRandom(
          [word, ...allWords.where((candidate) => candidate.id != word.id)],
          min(3, allWords.length),
          rng,
        );
        final leftItems = matchWords.map((w) => w.cebuano).toList();
        final rightItems = matchWords.map((w) => w.english).toList();
        return QuizQuestion(
          type: QuizType.wordMatch,
          prompt: 'Match each Cebuano word with its English meaning.',
          correctAnswer: List.generate(
            matchWords.length,
            (i) => '${leftItems[i]} = ${rightItems[i]}',
          ).join('\n'),
          options: leftItems,
          matchTargets: rightItems,
          cebuano: word.cebuano,
          english: word.english,
          hint: 'Match the words based on the clue you learned earlier.',
        );
    }
  }

  static (List<String>, String, String, String) _buildWordJumblePhrase(
    WordToken word,
  ) {
    switch (word.category) {
      case 'Greetings':
        final phrase = word.cebuano;
        return (
          phrase.split(' '),
          phrase,
          'Arrange the words to form the correct Cebuano greeting:',
          'Think about the phrase someone would say in a real greeting.',
        );
      case 'Numbers':
        final phrase = '${word.cebuano} ka saging';
        return (
          phrase.split(' '),
          phrase,
          'Arrange the words to say "${word.english} bananas" in Cebuano:',
          'Put the number first, then the counter phrase.',
        );
      case 'Food':
        final phrase = 'Palihug ${word.cebuano}';
        return (
          phrase.split(' '),
          phrase,
          'Arrange the words to make a simple food request:',
          'Start with a polite request.',
        );
      default:
        final phrase = 'Asa ang ${word.cebuano}';
        return (
          phrase.split(' '),
          phrase,
          'Arrange the words to complete the Cebuano phrase:',
          'Begin with the question word.',
        );
    }
  }

  static (String, String, List<String>, String) _buildConversationQuestion(
    WordToken word,
    List<WordToken> allWords,
    Random rng,
  ) {
    switch (word.category) {
      case 'Greetings':
        return (
          'A local says "${word.cebuano}" to you. What is the best reply or meaning to choose?',
          word.english,
          _shuffledOptions(word.english, allWords.map((w) => w.english), rng),
          'Choose the response that fits the greeting naturally.',
        );
      case 'Numbers':
        return (
          'A vendor asks for the quantity. Which Cebuano number matches "${word.english}"?',
          word.cebuano,
          _shuffledOptions(word.cebuano, allWords.map((w) => w.cebuano), rng),
          'Think about the number word you would use while ordering.',
        );
      case 'Food':
        return (
          'You want to request "${word.english}" politely. Which Cebuano word should you listen for?',
          word.cebuano,
          _shuffledOptions(word.cebuano, allWords.map((w) => w.cebuano), rng),
          'Pick the food word that fits the request.',
        );
      default:
        return (
          'In a short conversation, what does "${word.cebuano}" mean?',
          word.english,
          _shuffledOptions(word.english, allWords.map((w) => w.english), rng),
          'Use the context of the scene, not just memorization.',
        );
    }
  }

  static List<String> _shuffledOptions(
    String correct,
    Iterable<String> candidates,
    Random rng,
  ) {
    final pool = candidates.where((item) => item != correct).toSet().toList()
      ..shuffle(rng);
    final options = [correct, ...pool.take(3)]..shuffle(rng);
    return options;
  }

  static List<T> _pickRandom<T>(List<T> source, int count, Random rng) {
    final list = [...source]..shuffle(rng);
    return list.take(count).toList();
  }
}
