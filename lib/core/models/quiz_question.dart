enum QuizType {
  multipleChoice,
  fillBlank,
  wordJumble,
  flashcard,
  conversation,
  wordMatch,
}

class QuizQuestion {
  final QuizType type;
  final String prompt;
  final String correctAnswer;
  final List<String> options;
  final List<String> matchTargets;
  final String cebuano;
  final String english;
  final String hint;
  final bool useSpacesInJumble;

  const QuizQuestion({
    required this.type,
    required this.prompt,
    required this.correctAnswer,
    required this.cebuano,
    required this.english,
    this.options = const [],
    this.matchTargets = const [],
    this.hint = '',
    this.useSpacesInJumble = false,
  });
}
