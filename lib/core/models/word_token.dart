class WordToken {
  final String id;
  final String cebuano;
  final String english;
  final String category;
  final String? example;
  final String? exampleEn;

  const WordToken({
    required this.id,
    required this.cebuano,
    required this.english,
    required this.category,
    this.example,
    this.exampleEn,
  });
}
