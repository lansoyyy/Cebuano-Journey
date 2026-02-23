import '../core/models/word_token.dart';

class CebuanoWordBank {
  static const List<WordToken> words = [
    // Greetings
    WordToken(id: 'g01', cebuano: 'Maayong buntag', english: 'Good morning', category: 'Greetings'),
    WordToken(id: 'g02', cebuano: 'Maayong hapon', english: 'Good afternoon', category: 'Greetings'),
    WordToken(id: 'g03', cebuano: 'Maayong gabii', english: 'Good evening', category: 'Greetings'),
    WordToken(id: 'g04', cebuano: 'Salamat', english: 'Thank you', category: 'Greetings'),
    WordToken(id: 'g05', cebuano: 'Palihug', english: 'Please', category: 'Greetings'),
    WordToken(id: 'g06', cebuano: "Wa'y sapayan", english: "You're welcome", category: 'Greetings'),
    WordToken(id: 'g07', cebuano: 'Kumusta', english: 'How are you', category: 'Greetings'),
    WordToken(id: 'g08', cebuano: 'Adto na ko', english: 'I will go now', category: 'Greetings'),
    // Numbers
    WordToken(id: 'n01', cebuano: 'Usa', english: 'One', category: 'Numbers'),
    WordToken(id: 'n02', cebuano: 'Duha', english: 'Two', category: 'Numbers'),
    WordToken(id: 'n03', cebuano: 'Tulo', english: 'Three', category: 'Numbers'),
    WordToken(id: 'n04', cebuano: 'Upat', english: 'Four', category: 'Numbers'),
    WordToken(id: 'n05', cebuano: 'Lima', english: 'Five', category: 'Numbers'),
    WordToken(id: 'n06', cebuano: 'Unom', english: 'Six', category: 'Numbers'),
    WordToken(id: 'n07', cebuano: 'Pito', english: 'Seven', category: 'Numbers'),
    WordToken(id: 'n08', cebuano: 'Walo', english: 'Eight', category: 'Numbers'),
    WordToken(id: 'n09', cebuano: 'Siyam', english: 'Nine', category: 'Numbers'),
    WordToken(id: 'n10', cebuano: 'Napulo', english: 'Ten', category: 'Numbers'),
    // Colors
    WordToken(id: 'c01', cebuano: 'Pula', english: 'Red', category: 'Colors'),
    WordToken(id: 'c02', cebuano: 'Puti', english: 'White', category: 'Colors'),
    WordToken(id: 'c03', cebuano: 'Itom', english: 'Black', category: 'Colors'),
    WordToken(id: 'c04', cebuano: 'Berde', english: 'Green', category: 'Colors'),
    WordToken(id: 'c05', cebuano: 'Asul', english: 'Blue', category: 'Colors'),
    WordToken(id: 'c06', cebuano: 'Dalag', english: 'Yellow', category: 'Colors'),
    WordToken(id: 'c07', cebuano: 'Ubanon', english: 'Gray', category: 'Colors'),
    // Food
    WordToken(id: 'f01', cebuano: 'Pagkaon', english: 'Food', category: 'Food'),
    WordToken(id: 'f02', cebuano: 'Tubig', english: 'Water', category: 'Food'),
    WordToken(id: 'f03', cebuano: 'Karne', english: 'Meat', category: 'Food'),
    WordToken(id: 'f04', cebuano: 'Isda', english: 'Fish', category: 'Food'),
    WordToken(id: 'f05', cebuano: "Kan-on", english: 'Rice', category: 'Food'),
    WordToken(id: 'f06', cebuano: 'Buwad', english: 'Dried fish', category: 'Food'),
    WordToken(id: 'f07', cebuano: 'Saging', english: 'Banana', category: 'Food'),
    WordToken(id: 'f08', cebuano: 'Mansanas', english: 'Apple', category: 'Food'),
    // Family
    WordToken(id: 'fm1', cebuano: 'Inahan', english: 'Mother', category: 'Family'),
    WordToken(id: 'fm2', cebuano: 'Amahan', english: 'Father', category: 'Family'),
    WordToken(id: 'fm3', cebuano: 'Igsoon', english: 'Sibling', category: 'Family'),
    WordToken(id: 'fm4', cebuano: 'Bata', english: 'Child', category: 'Family'),
    WordToken(id: 'fm5', cebuano: 'Apohan', english: 'Grandparent', category: 'Family'),
    WordToken(id: 'fm6', cebuano: 'Pamilya', english: 'Family', category: 'Family'),
    // Places
    WordToken(id: 'p01', cebuano: 'Merkado', english: 'Market', category: 'Places'),
    WordToken(id: 'p02', cebuano: 'Syudad', english: 'City', category: 'Places'),
    WordToken(id: 'p03', cebuano: 'Baybay', english: 'Beach', category: 'Places'),
    WordToken(id: 'p04', cebuano: 'Bukid', english: 'Mountain', category: 'Places'),
    WordToken(id: 'p05', cebuano: 'Dalan', english: 'Street/Road', category: 'Places'),
    WordToken(id: 'p06', cebuano: 'Balay', english: 'House', category: 'Places'),
    WordToken(id: 'p07', cebuano: 'Eskwelahan', english: 'School', category: 'Places'),
    // Verbs
    WordToken(id: 'v01', cebuano: 'Adto', english: 'Go', category: 'Verbs'),
    WordToken(id: 'v02', cebuano: 'Anhi', english: 'Come', category: 'Verbs'),
    WordToken(id: 'v03', cebuano: 'Kaon', english: 'Eat', category: 'Verbs'),
    WordToken(id: 'v04', cebuano: 'Inom', english: 'Drink', category: 'Verbs'),
    WordToken(id: 'v05', cebuano: 'Sulti', english: 'Speak', category: 'Verbs'),
    WordToken(id: 'v06', cebuano: 'Tan-aw', english: 'Look/Watch', category: 'Verbs'),
    WordToken(id: 'v07', cebuano: 'Lakaw', english: 'Walk', category: 'Verbs'),
    WordToken(id: 'v08', cebuano: 'Tulog', english: 'Sleep', category: 'Verbs'),
    WordToken(id: 'v09', cebuano: 'Laro', english: 'Play', category: 'Verbs'),
    // Adjectives
    WordToken(id: 'a01', cebuano: 'Dako', english: 'Big', category: 'Adjectives'),
    WordToken(id: 'a02', cebuano: 'Gamay', english: 'Small', category: 'Adjectives'),
    WordToken(id: 'a03', cebuano: 'Maayo', english: 'Good/Kind', category: 'Adjectives'),
    WordToken(id: 'a04', cebuano: 'Daotan', english: 'Bad', category: 'Adjectives'),
    WordToken(id: 'a05', cebuano: 'Gwapa', english: 'Beautiful', category: 'Adjectives'),
    WordToken(id: 'a06', cebuano: 'Mainit', english: 'Hot', category: 'Adjectives'),
    WordToken(id: 'a07', cebuano: 'Bugnaw', english: 'Cold', category: 'Adjectives'),
    WordToken(id: 'a08', cebuano: 'Kusog', english: 'Strong/Fast', category: 'Adjectives'),
    WordToken(id: 'a09', cebuano: 'Hinay', english: 'Slow/Soft', category: 'Adjectives'),
  ];

  static WordToken? byId(String id) {
    try {
      return words.firstWhere((w) => w.id == id);
    } catch (_) {
      return null;
    }
  }

  static List<WordToken> byCategory(String category) =>
      words.where((w) => w.category == category).toList();

  static List<WordToken> forLevel(int levelNumber) {
    final count = (levelNumber * 3 + 5).clamp(5, words.length);
    return words.take(count).toList();
  }
}
