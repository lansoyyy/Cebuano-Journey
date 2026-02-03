/// Cebuano Word Model
/// Represents a word/phrase in the game
class CebuanoWord {
  final String id;
  final String cebuano;
  final String english;
  final String? pronunciation;
  final String category;
  final int difficulty;
  final String? audioPath;

  const CebuanoWord({
    required this.id,
    required this.cebuano,
    required this.english,
    this.pronunciation,
    required this.category,
    this.difficulty = 1,
    this.audioPath,
  });

  factory CebuanoWord.fromJson(Map<String, dynamic> json) {
    return CebuanoWord(
      id: json['id'] as String,
      cebuano: json['cebuano'] as String,
      english: json['english'] as String,
      pronunciation: json['pronunciation'] as String?,
      category: json['category'] as String,
      difficulty: json['difficulty'] as int? ?? 1,
      audioPath: json['audioPath'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'cebuano': cebuano,
    'english': english,
    'pronunciation': pronunciation,
    'category': category,
    'difficulty': difficulty,
    'audioPath': audioPath,
  };
}

/// Word Categories
class WordCategories {
  static const String greetings = 'greetings';
  static const String numbers = 'numbers';
  static const String food = 'food';
  static const String family = 'family';
  static const String directions = 'directions';
  static const String time = 'time';
  static const String emotions = 'emotions';
  static const String common = 'common';
  static const String phrases = 'phrases';
}
