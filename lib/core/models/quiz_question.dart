enum QuizType { multipleChoice, fillBlank, wordJumble, flashcard }

class QuizQuestion {
  final QuizType type;
  final String prompt;
  final String correctAnswer;
  final List<String> options;
  final String cebuano;
  final String english;
  final String hint;

  const QuizQuestion({
    required this.type,
    required this.prompt,
    required this.correctAnswer,
    required this.cebuano,
    required this.english,
    this.options = const [],
    this.hint = '',
  });
}
