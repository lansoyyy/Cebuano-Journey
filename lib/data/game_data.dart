import '../models/cebuano_word.dart';

/// Game Data - Cebuano Words Database
class GameData {
  static final List<CebuanoWord> cebuanoWords = [
    // Greetings
    const CebuanoWord(
      id: 'greeting_1',
      cebuano: 'Maayong buntag',
      english: 'Good morning',
      category: WordCategories.greetings,
      difficulty: 1,
    ),
    const CebuanoWord(
      id: 'greeting_2',
      cebuano: 'Maayong hapon',
      english: 'Good afternoon',
      category: WordCategories.greetings,
      difficulty: 1,
    ),
    const CebuanoWord(
      id: 'greeting_3',
      cebuano: 'Maayong gabii',
      english: 'Good evening/night',
      category: WordCategories.greetings,
      difficulty: 1,
    ),
    const CebuanoWord(
      id: 'greeting_4',
      cebuano: 'Kumusta',
      english: 'How are you',
      category: WordCategories.greetings,
      difficulty: 1,
    ),
    const CebuanoWord(
      id: 'greeting_5',
      cebuano: 'Salamat',
      english: 'Thank you',
      category: WordCategories.greetings,
      difficulty: 1,
    ),
    // Numbers 1-10
    const CebuanoWord(
      id: 'num_1',
      cebuano: 'Usa',
      english: 'One',
      category: WordCategories.numbers,
      difficulty: 1,
    ),
    const CebuanoWord(
      id: 'num_2',
      cebuano: 'Duha',
      english: 'Two',
      category: WordCategories.numbers,
      difficulty: 1,
    ),
    const CebuanoWord(
      id: 'num_3',
      cebuano: 'Tulo',
      english: 'Three',
      category: WordCategories.numbers,
      difficulty: 1,
    ),
    const CebuanoWord(
      id: 'num_4',
      cebuano: 'Upat',
      english: 'Four',
      category: WordCategories.numbers,
      difficulty: 1,
    ),
    const CebuanoWord(
      id: 'num_5',
      cebuano: 'Lima',
      english: 'Five',
      category: WordCategories.numbers,
      difficulty: 1,
    ),
    // Common Words
    const CebuanoWord(
      id: 'common_1',
      cebuano: 'Oo',
      english: 'Yes',
      category: WordCategories.common,
      difficulty: 1,
    ),
    const CebuanoWord(
      id: 'common_2',
      cebuano: 'Dili',
      english: 'No',
      category: WordCategories.common,
      difficulty: 1,
    ),
    const CebuanoWord(
      id: 'common_3',
      cebuano: 'Palihug',
      english: 'Please',
      category: WordCategories.common,
      difficulty: 1,
    ),
    const CebuanoWord(
      id: 'common_4',
      cebuano: 'Pasensya',
      english: 'Sorry/Excuse me',
      category: WordCategories.common,
      difficulty: 1,
    ),
    // Food
    const CebuanoWord(
      id: 'food_1',
      cebuano: 'Kaon',
      english: 'Eat/Food',
      category: WordCategories.food,
      difficulty: 1,
    ),
    const CebuanoWord(
      id: 'food_2',
      cebuano: 'Tubig',
      english: 'Water',
      category: WordCategories.food,
      difficulty: 1,
    ),
    const CebuanoWord(
      id: 'food_3',
      cebuano: 'Kan-on',
      english: 'Rice',
      category: WordCategories.food,
      difficulty: 1,
    ),
    const CebuanoWord(
      id: 'food_4',
      cebuano: 'Isda',
      english: 'Fish',
      category: WordCategories.food,
      difficulty: 2,
    ),
    const CebuanoWord(
      id: 'food_5',
      cebuano: 'Baboy',
      english: 'Pork',
      category: WordCategories.food,
      difficulty: 2,
    ),
    // Family
    const CebuanoWord(
      id: 'family_1',
      cebuano: 'Inahan',
      english: 'Mother',
      category: WordCategories.family,
      difficulty: 2,
    ),
    const CebuanoWord(
      id: 'family_2',
      cebuano: 'Amahan',
      english: 'Father',
      category: WordCategories.family,
      difficulty: 2,
    ),
    const CebuanoWord(
      id: 'family_3',
      cebuano: 'Igsuon',
      english: 'Sibling',
      category: WordCategories.family,
      difficulty: 2,
    ),
    // Phrases
    const CebuanoWord(
      id: 'phrase_1',
      cebuano: 'Unsa imong ngalan?',
      english: 'What is your name?',
      category: WordCategories.phrases,
      difficulty: 2,
    ),
    const CebuanoWord(
      id: 'phrase_2',
      cebuano: 'Ako si...',
      english: 'I am...',
      category: WordCategories.phrases,
      difficulty: 2,
    ),
    const CebuanoWord(
      id: 'phrase_3',
      cebuano: 'Taga-a ka diin?',
      english: 'Where are you from?',
      category: WordCategories.phrases,
      difficulty: 2,
    ),
    const CebuanoWord(
      id: 'phrase_4',
      cebuano: 'Taga-Cebu ko',
      english: 'I am from Cebu',
      category: WordCategories.phrases,
      difficulty: 2,
    ),
  ];

  static CebuanoWord? getWordById(String id) {
    try {
      return cebuanoWords.firstWhere((w) => w.id == id);
    } catch (e) {
      return null;
    }
  }

  static List<CebuanoWord> getWordsByCategory(String category) {
    return cebuanoWords.where((w) => w.category == category).toList();
  }

  static List<CebuanoWord> getWordsByDifficulty(int difficulty) {
    return cebuanoWords.where((w) => w.difficulty == difficulty).toList();
  }
}
