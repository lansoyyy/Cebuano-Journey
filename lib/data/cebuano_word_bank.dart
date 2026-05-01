import '../core/models/word_token.dart';

class CebuanoWordBank {
  static const List<WordToken> words = [
    // Greetings
    WordToken(id: 'g01', cebuano: 'Maayong buntag', english: 'Good morning', category: 'Greetings', example: 'Maayong buntag, Nay!', exampleEn: '"Good morning, Mom!"'),
    WordToken(id: 'g02', cebuano: 'Maayong hapon', english: 'Good afternoon', category: 'Greetings', example: 'Maayong hapon, unsay imong gibuhat?', exampleEn: '"Good afternoon, what are you doing?"'),
    WordToken(id: 'g03', cebuano: 'Maayong gabii', english: 'Good evening', category: 'Greetings', example: 'Maayong gabii sa inyong tanan!', exampleEn: '"Good evening to all of you!"'),
    WordToken(id: 'g04', cebuano: 'Salamat', english: 'Thank you', category: 'Greetings', example: 'Salamat sa imong tabang.', exampleEn: '"Thank you for your help."'),
    WordToken(id: 'g05', cebuano: 'Palihug', english: 'Please', category: 'Greetings', example: 'Palihug hatagi ko og tubig.', exampleEn: '"Please give me water."'),
    WordToken(id: 'g06', cebuano: "Wa'y sapayan", english: "You're welcome", category: 'Greetings', example: "Wa'y sapayan, bisan unsang oras.", exampleEn: '"You\'re welcome, anytime."'),
    WordToken(id: 'g07', cebuano: 'Kumusta', english: 'How are you', category: 'Greetings', example: 'Kumusta ka, dong?', exampleEn: '"How are you, buddy?"'),
    WordToken(id: 'g08', cebuano: 'Adto na ko', english: 'I will go now', category: 'Greetings', example: 'Adto na ko, hasta!', exampleEn: '"I will go now, see you!"'),
    // Numbers
    WordToken(id: 'n01', cebuano: 'Usa', english: 'One', category: 'Numbers', example: 'Usa ka mansanas ang akong gikaon.', exampleEn: '"I ate one apple."'),
    WordToken(id: 'n02', cebuano: 'Duha', english: 'Two', category: 'Numbers', example: 'Duha ka bata ang naglaro.', exampleEn: '"Two children were playing."'),
    WordToken(id: 'n03', cebuano: 'Tulo', english: 'Three', category: 'Numbers', example: 'Tulo ka adlaw ang nahabilin.', exampleEn: '"Three days are left."'),
    WordToken(id: 'n04', cebuano: 'Upat', english: 'Four', category: 'Numbers', example: 'Upat ka buok ang iyang gipalit.', exampleEn: '"She bought four pieces."'),
    WordToken(id: 'n05', cebuano: 'Lima', english: 'Five', category: 'Numbers', example: 'Lima ka minuto na lang.', exampleEn: '"Only five minutes left."'),
    WordToken(id: 'n06', cebuano: 'Unom', english: 'Six', category: 'Numbers', example: 'Unom ang oras sa buntag.', exampleEn: '"It is six in the morning."'),
    WordToken(id: 'n07', cebuano: 'Pito', english: 'Seven', category: 'Numbers', example: 'Pito na ka tuig ang akong edad.', exampleEn: '"I am seven years old."'),
    WordToken(id: 'n08', cebuano: 'Walo', english: 'Eight', category: 'Numbers', example: 'Walo ka kuha ang akong score.', exampleEn: '"I got eight correct."'),
    WordToken(id: 'n09', cebuano: 'Siyam', english: 'Nine', category: 'Numbers', example: 'Siyam ka buwan na ang milabay.', exampleEn: '"Nine months have passed."'),
    WordToken(id: 'n10', cebuano: 'Napulo', english: 'Ten', category: 'Numbers', example: 'Napulo ang akong mga libro.', exampleEn: '"I have ten books."'),
    // Colors
    WordToken(id: 'c01', cebuano: 'Pula', english: 'Red', category: 'Colors', example: 'Pula ang iyang sinina.', exampleEn: '"Her shirt is red."'),
    WordToken(id: 'c02', cebuano: 'Puti', english: 'White', category: 'Colors', example: 'Puti ang bilog nga buwan.', exampleEn: '"The full moon is white."'),
    WordToken(id: 'c03', cebuano: 'Itom', english: 'Black', category: 'Colors', example: 'Itom ang iyang sapatos.', exampleEn: '"His shoes are black."'),
    WordToken(id: 'c04', cebuano: 'Berde', english: 'Green', category: 'Colors', example: 'Berde ang tanum sa bukid.', exampleEn: '"The plants in the mountain are green."'),
    WordToken(id: 'c05', cebuano: 'Asul', english: 'Blue', category: 'Colors', example: 'Asul ang dagat ug langit.', exampleEn: '"The sea and sky are blue."'),
    WordToken(id: 'c06', cebuano: 'Dalag', english: 'Yellow', category: 'Colors', example: 'Dalag ang saging nga hinog na.', exampleEn: '"The ripe banana is yellow."'),
    WordToken(id: 'c07', cebuano: 'Ubanon', english: 'Gray', category: 'Colors', example: 'Ubanon ang panganod karon.', exampleEn: '"The clouds are gray today."'),
    // Food
    WordToken(id: 'f01', cebuano: 'Pagkaon', english: 'Food', category: 'Food', example: 'Maayo kaayo ang pagkaon dinhi.', exampleEn: '"The food here is very good."'),
    WordToken(id: 'f02', cebuano: 'Tubig', english: 'Water', category: 'Food', example: 'Palihug hatagi ko og tubig.', exampleEn: '"Please give me water."'),
    WordToken(id: 'f03', cebuano: 'Karne', english: 'Meat', category: 'Food', example: 'Gusto nako og karne sa panihapon.', exampleEn: '"I want meat for dinner."'),
    WordToken(id: 'f04', cebuano: 'Isda', english: 'Fish', category: 'Food', example: 'Luto na ang isda, kaon na ta!', exampleEn: '"The fish is cooked, let\'s eat!"'),
    WordToken(id: 'f05', cebuano: "Kan-on", english: 'Rice', category: 'Food', example: "Kan-on ug isda ang akong panihapon.", exampleEn: '"Rice and fish is my dinner."'),
    WordToken(id: 'f06', cebuano: 'Buwad', english: 'Dried fish', category: 'Food', example: 'Buwad ang lagwerta sa umoy.', exampleEn: '"Dried fish goes well with vinegar."'),
    WordToken(id: 'f07', cebuano: 'Saging', english: 'Banana', category: 'Food', example: 'Saging ang akong paborito nga prutas.', exampleEn: '"Banana is my favorite fruit."'),
    WordToken(id: 'f08', cebuano: 'Mansanas', english: 'Apple', category: 'Food', example: 'Usa ka mansanas sa matag adlaw.', exampleEn: '"An apple every day."'),
    // Family
    WordToken(id: 'fm1', cebuano: 'Inahan', english: 'Mother', category: 'Family', example: 'Ang akong inahan nag-luto og panihapon.', exampleEn: '"My mother is cooking dinner."'),
    WordToken(id: 'fm2', cebuano: 'Amahan', english: 'Father', category: 'Family', example: 'Ang akong amahan nagtrabaho sa merkado.', exampleEn: '"My father works at the market."'),
    WordToken(id: 'fm3', cebuano: 'Igsoon', english: 'Sibling', category: 'Family', example: 'Ang akong igsoon nag-eskwela pa.', exampleEn: '"My sibling is still in school."'),
    WordToken(id: 'fm4', cebuano: 'Bata', english: 'Child', category: 'Family', example: 'Ang bata natulog na.', exampleEn: '"The child is already asleep."'),
    WordToken(id: 'fm5', cebuano: 'Apohan', english: 'Grandparent', category: 'Family', example: 'Moadto ko sa akong apohan ugma.', exampleEn: '"I will visit my grandparent tomorrow."'),
    WordToken(id: 'fm6', cebuano: 'Pamilya', english: 'Family', category: 'Family', example: 'Ang akong pamilya nagtipon sa pista.', exampleEn: '"My family gathered at the festival."'),
    // Places
    WordToken(id: 'p01', cebuano: 'Merkado', english: 'Market', category: 'Places', example: 'Moadto ko sa merkado pagpalit og pagkaon.', exampleEn: '"I will go to the market to buy food."'),
    WordToken(id: 'p02', cebuano: 'Syudad', english: 'City', category: 'Places', example: 'Dako ang syudad sa Sugbo.', exampleEn: '"The city of Cebu is big."'),
    WordToken(id: 'p03', cebuano: 'Baybay', english: 'Beach', category: 'Places', example: 'Moadto ta sa baybay ugma!', exampleEn: '"Let\'s go to the beach tomorrow!"'),
    WordToken(id: 'p04', cebuano: 'Bukid', english: 'Mountain', category: 'Places', example: 'Hataas kaayo ang bukid sa North.', exampleEn: '"The mountains in the North are very high."'),
    WordToken(id: 'p05', cebuano: 'Dalan', english: 'Street/Road', category: 'Places', example: 'Ang dalan puno og tawo karon.', exampleEn: '"The street is full of people now."'),
    WordToken(id: 'p06', cebuano: 'Balay', english: 'House', category: 'Places', example: 'Ang akong balay duol sa eskwelahan.', exampleEn: '"My house is near the school."'),
    WordToken(id: 'p07', cebuano: 'Eskwelahan', english: 'School', category: 'Places', example: 'Nag-adto siya sa eskwelahan matag adlaw.', exampleEn: '"She goes to school every day."'),
    // Verbs
    WordToken(id: 'v01', cebuano: 'Adto', english: 'Go', category: 'Verbs', example: 'Adto ko sa merkado karon.', exampleEn: '"I am going to the market now."'),
    WordToken(id: 'v02', cebuano: 'Anhi', english: 'Come', category: 'Verbs', example: 'Anhi ka diri sa akong balay.', exampleEn: '"Come here to my house."'),
    WordToken(id: 'v03', cebuano: 'Kaon', english: 'Eat', category: 'Verbs', example: 'Kaon na ta, gutom na ko!', exampleEn: '"Let\'s eat, I\'m hungry!"'),
    WordToken(id: 'v04', cebuano: 'Inom', english: 'Drink', category: 'Verbs', example: 'Inom og tubig kung uga.', exampleEn: '"Drink water when thirsty."'),
    WordToken(id: 'v05', cebuano: 'Sulti', english: 'Speak', category: 'Verbs', example: 'Sulti og Bisaya kanako.', exampleEn: '"Speak Bisaya to me."'),
    WordToken(id: 'v06', cebuano: 'Tan-aw', english: 'Look/Watch', category: 'Verbs', example: 'Tan-aw sa screen, diri!', exampleEn: '"Look at the screen, here!"'),
    WordToken(id: 'v07', cebuano: 'Lakaw', english: 'Walk', category: 'Verbs', example: 'Lakaw ta padulong sa plasa.', exampleEn: '"Let\'s walk towards the plaza."'),
    WordToken(id: 'v08', cebuano: 'Tulog', english: 'Sleep', category: 'Verbs', example: 'Tulog na, gabii na kaayo.', exampleEn: '"Sleep now, it\'s very late."'),
    WordToken(id: 'v09', cebuano: 'Laro', english: 'Play', category: 'Verbs', example: 'Laro ta sa gawas human sa klase.', exampleEn: '"Let\'s play outside after class."'),
    // Adjectives
    WordToken(id: 'a01', cebuano: 'Dako', english: 'Big', category: 'Adjectives', example: 'Dako kaayo ang balay nila.', exampleEn: '"Their house is very big."'),
    WordToken(id: 'a02', cebuano: 'Gamay', english: 'Small', category: 'Adjectives', example: 'Gamay lang ang akong bag.', exampleEn: '"My bag is just small."'),
    WordToken(id: 'a03', cebuano: 'Maayo', english: 'Good/Kind', category: 'Adjectives', example: 'Maayo kaayo siya nga tawo.', exampleEn: '"She is a very good person."'),
    WordToken(id: 'a04', cebuano: 'Daotan', english: 'Bad', category: 'Adjectives', example: 'Daotan og panahon karon.', exampleEn: '"The weather is bad today."'),
    WordToken(id: 'a05', cebuano: 'Gwapa', english: 'Beautiful', category: 'Adjectives', example: 'Gwapa kaayo ang iyang ngiti.', exampleEn: '"Her smile is very beautiful."'),
    WordToken(id: 'a06', cebuano: 'Mainit', english: 'Hot', category: 'Adjectives', example: 'Mainit kaayo ang kape.', exampleEn: '"The coffee is very hot."'),
    WordToken(id: 'a07', cebuano: 'Bugnaw', english: 'Cold', category: 'Adjectives', example: 'Bugnaw ang hangin sa kabuntagon.', exampleEn: '"The morning breeze is cold."'),
    WordToken(id: 'a08', cebuano: 'Kusog', english: 'Strong/Fast', category: 'Adjectives', example: 'Kusog kaayo ang hangin karon.', exampleEn: '"The wind is very strong now."'),
    WordToken(id: 'a09', cebuano: 'Hinay', english: 'Slow/Soft', category: 'Adjectives', example: 'Hinay kaayo ang iyang tingog.', exampleEn: '"Her voice is very soft."'),
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

  /// Maps each vocabulary category to a module lesson group number, matching
  /// the official Cebuano module progression:
  ///   1 = Greetings & Honorifics (Lesson 1)
  ///   2 = Nominative Markers / Family vocabulary (Lesson 2-3)
  ///   4 = Basic Adjectives & Particularizers (Lesson 4)
  ///   5 = Numbers & Exclamatory Adjectives (Lesson 5)
  ///   6 = Existentials, Locatives & Food vocabulary (Lesson 6)
  ///   7 = Prepositions, Directions & Places (Lesson 7)
  ///   8 = Agent Voice Verbs (Lesson 8+)
  static int _lessonGroupForCategory(String category) {
    switch (category) {
      case 'Greetings':
        return 1;
      case 'Family':
        return 2;
      case 'Colors':
      case 'Adjectives':
        return 4;
      case 'Numbers':
        return 5;
      case 'Food':
        return 6;
      case 'Places':
        return 7;
      case 'Verbs':
        return 8;
      default:
        return 1;
    }
  }

  /// Returns the word pool for a given difficulty level, respecting the module
  /// progression.  Each difficulty step (1–25 across 5 worlds) unlocks one
  /// additional lesson group so tokens in-game always reflect the current
  /// and previously studied module content.
  static List<WordToken> forLevel(int levelNumber) {
    // Map difficulty 1-25 → lesson group 1-8
    final maxLesson = ((levelNumber * 8) / 25).ceil().clamp(1, 8);
    final pool = words
        .where((w) => _lessonGroupForCategory(w.category) <= maxLesson)
        .toList();
    return pool.isNotEmpty ? pool : words.take(8).toList();
  }

  /// Returns the difficulty level at which this word first becomes available,
  /// derived from its lesson group using the same mapping as [forLevel].
  /// Inverse of: maxLesson = ceil(difficulty * 8 / 25)
  /// → difficulty = ceil(lessonGroup * 25 / 8), minimum 1.
  static int levelForWord(String wordId) {
    final word = words.firstWhere((w) => w.id == wordId, orElse: () => words.first);
    final lessonGroup = _lessonGroupForCategory(word.category);
    return ((lessonGroup * 25) / 8).ceil().clamp(1, 25);
  }
}
