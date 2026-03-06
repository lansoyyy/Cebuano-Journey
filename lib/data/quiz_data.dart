/// Quiz Data - Questions based on PDF Module 1 Content
/// Comprehensive quiz questions for Cebuano learning

import '../core/models/quiz_question.dart';

class QuizData {
  /// Get quiz questions for a specific level
  static List<QuizQuestion> getQuizForLevel(int level) {
    switch (level) {
      case 1:
        return _greetingsQuiz();
      case 2:
        return _numbersQuiz();
      case 3:
        return _colorsQuiz();
      case 4:
        return _animalsQuiz();
      case 5:
        return _foodQuiz();
      case 6:
        return _familyQuiz();
      case 7:
        return _timeQuiz();
      case 8:
        return _weatherQuiz();
      case 9:
        return _emotionsQuiz();
      case 10:
        return _actionsQuiz();
      case 11:
        return _placesQuiz();
      case 12:
        return _objectsQuiz();
      case 13:
        return _mixedReviewQuiz();
      case 14:
        return _challengeQuiz();
      case 15:
        return _masteryQuiz();
      case 16:
        return _honorificsQuiz();
      case 17:
        return _markersQuiz();
      case 18:
        return _interrogativesQuiz();
      case 19:
        return _existentialsQuiz();
      case 20:
        return _adjectivesQuiz();
      case 21:
        return _verbsQuiz();
      case 22:
        return _bodyQuiz();
      case 23:
        return _kitchenQuiz();
      case 24:
        return _directionsQuiz();
      case 25:
        return _natureQuiz();
      case 26:
        return _feelingsQuiz();
      case 27:
        return _advancedGrammarQuiz();
      case 28:
        return _conversationQuiz();
      case 29:
        return _completeReviewQuiz();
      default:
        return _mixedReviewQuiz();
    }
  }

  /// Level 1: Greetings
  static List<QuizQuestion> _greetingsQuiz() {
    return [
      QuizQuestion(
        type: QuizType.multipleChoice,
        prompt: 'How do you say "Good morning" in Cebuano?',
        correctAnswer: 'Maayong buntag',
        cebuano: 'Maayong buntag',
        english: 'Good morning',
        options: [
          'Maayong buntag',
          'Maayong hapon',
          'Maayong gabii',
          'Kumusta',
        ],
        hint: 'Think about the time of day',
      ),
      QuizQuestion(
        type: QuizType.multipleChoice,
        prompt: 'What does "Kumusta" mean?',
        correctAnswer: 'Hello / How are you?',
        cebuano: 'Kumusta',
        english: 'Hello / How are you?',
        options: ['Goodbye', 'Hello / How are you?', 'Thank you', 'Please'],
        hint: 'It\'s a common greeting',
      ),
      QuizQuestion(
        type: QuizType.multipleChoice,
        prompt: 'How do you say "Thank you" in Cebuano?',
        correctAnswer: 'Salamat',
        cebuano: 'Salamat',
        english: 'Thank you',
        options: ['Salamat', 'Palihug', 'Paalam', 'Dili'],
        hint: 'Expressing gratitude',
      ),
      QuizQuestion(
        type: QuizType.multipleChoice,
        prompt: 'What does "Maayong gabii" mean?',
        correctAnswer: 'Good evening',
        cebuano: 'Maayong gabii',
        english: 'Good evening',
        options: [
          'Good morning',
          'Good afternoon',
          'Good evening',
          'Good night',
        ],
        hint: 'Think about nighttime',
      ),
      QuizQuestion(
        type: QuizType.multipleChoice,
        prompt: 'How do you say "Please" in Cebuano?',
        correctAnswer: 'Palihug',
        cebuano: 'Palihug',
        english: 'Please',
        options: ['Salamat', 'Palihug', 'Oo', 'Dili'],
        hint: 'Used when making requests',
      ),
      QuizQuestion(
        type: QuizType.fillBlank,
        prompt: '_____ ka? (How are you?)',
        correctAnswer: 'Kumusta',
        cebuano: 'Kumusta',
        english: 'How are you?',
        options: [],
        hint: 'Common greeting',
      ),
      QuizQuestion(
        type: QuizType.wordJumble,
        prompt: 'Unscramble: "T A M A L A S"',
        correctAnswer: 'Salamat',
        cebuano: 'Salamat',
        english: 'Thank you',
        options: ['S', 'A', 'L', 'A', 'M', 'A', 'T'],
        hint: 'Expressing gratitude',
      ),
      QuizQuestion(
        type: QuizType.flashcard,
        prompt: 'Maayong hapon',
        correctAnswer: 'Good afternoon',
        cebuano: 'Maayong hapon',
        english: 'Good afternoon',
        options: [],
        hint: 'Time between morning and evening',
      ),
    ];
  }

  /// Level 2: Numbers
  static List<QuizQuestion> _numbersQuiz() {
    return [
      QuizQuestion(
        type: QuizType.multipleChoice,
        prompt: 'What is "One" in Cebuano?',
        correctAnswer: 'Usa',
        cebuano: 'Usa',
        english: 'One',
        options: ['Usa', 'Duha', 'Tulo', 'Upat'],
        hint: 'The first number',
      ),
      QuizQuestion(
        type: QuizType.multipleChoice,
        prompt: 'What does "Lima" mean?',
        correctAnswer: 'Five',
        cebuano: 'Lima',
        english: 'Five',
        options: ['Three', 'Five', 'Seven', 'Nine'],
        hint: 'Count on your fingers',
      ),
      QuizQuestion(
        type: QuizType.multipleChoice,
        prompt: 'What is "Ten" in Cebuano?',
        correctAnswer: 'Napulo',
        cebuano: 'Napulo',
        english: 'Ten',
        options: ['Walo', 'Siyam', 'Napulo', 'Unom'],
        hint: 'The highest single digit',
      ),
      QuizQuestion(
        type: QuizType.fillBlank,
        prompt: 'Usa, Duha, _____ (1, 2, 3)',
        correctAnswer: 'Tulo',
        cebuano: 'Tulo',
        english: 'Three',
        options: [],
        hint: 'The number after two',
      ),
      QuizQuestion(
        type: QuizType.wordJumble,
        prompt: 'Unscramble: "U P A T"',
        correctAnswer: 'Upat',
        cebuano: 'Upat',
        english: 'Four',
        options: ['U', 'P', 'A', 'T'],
        hint: 'The number after three',
      ),
      QuizQuestion(
        type: QuizType.multipleChoice,
        prompt: 'What does "Siyam" mean?',
        correctAnswer: 'Nine',
        cebuano: 'Siyam',
        english: 'Nine',
        options: ['Six', 'Seven', 'Eight', 'Nine'],
        hint: 'One less than ten',
      ),
      QuizQuestion(
        type: QuizType.flashcard,
        prompt: 'Pito',
        correctAnswer: 'Seven',
        cebuano: 'Pito',
        english: 'Seven',
        options: [],
        hint: 'Days of the week',
      ),
    ];
  }

  /// Level 3: Colors
  static List<QuizQuestion> _colorsQuiz() {
    return [
      QuizQuestion(
        type: QuizType.multipleChoice,
        prompt: 'What is "Red" in Cebuano?',
        correctAnswer: 'Pula',
        cebuano: 'Pula',
        english: 'Red',
        options: ['Pula', 'Bughaw', 'Itom', 'Asul'],
        hint: 'Color of roses',
      ),
      QuizQuestion(
        type: QuizType.multipleChoice,
        prompt: 'What does "Asul" mean?',
        correctAnswer: 'Blue',
        cebuano: 'Asul',
        english: 'Blue',
        options: ['Red', 'Blue', 'Black', 'Green'],
        hint: 'Color of the sky',
      ),
      QuizQuestion(
        type: QuizType.multipleChoice,
        prompt: 'What is "Black" in Cebuano?',
        correctAnswer: 'Itom',
        cebuano: 'Itom',
        english: 'Black',
        options: ['Pula', 'Bughaw', 'Itom', 'Dalandan'],
        hint: 'Color of night',
      ),
      QuizQuestion(
        type: QuizType.fillBlank,
        prompt: '_____ is white in Cebuano.',
        correctAnswer: 'Bughaw',
        cebuano: 'Bughaw',
        english: 'White',
        options: [],
        hint: 'Color of clouds',
      ),
      QuizQuestion(
        type: QuizType.wordJumble,
        prompt: 'Unscramble: "D U L A W"',
        correctAnswer: 'Dulaw',
        cebuano: 'Dulaw',
        english: 'Yellow',
        options: ['D', 'U', 'L', 'A', 'W'],
        hint: 'Color of the sun',
      ),
      QuizQuestion(
        type: QuizType.flashcard,
        prompt: 'Dalandan',
        correctAnswer: 'Green',
        cebuano: 'Dalandan',
        english: 'Green',
        options: [],
        hint: 'Color of leaves',
      ),
    ];
  }

  /// Level 4: Animals
  static List<QuizQuestion> _animalsQuiz() {
    return [
      QuizQuestion(
        type: QuizType.multipleChoice,
        prompt: 'What is "Dog" in Cebuano?',
        correctAnswer: 'Iro',
        cebuano: 'Iro',
        english: 'Dog',
        options: ['Iro', 'Pusak', 'Baboy', 'Manok'],
        hint: 'Man\'s best friend',
      ),
      QuizQuestion(
        type: QuizType.multipleChoice,
        prompt: 'What does "Pusak" mean?',
        correctAnswer: 'Cat',
        cebuano: 'Pusak',
        english: 'Cat',
        options: ['Dog', 'Cat', 'Pig', 'Chicken'],
        hint: 'Meows',
      ),
      QuizQuestion(
        type: QuizType.multipleChoice,
        prompt: 'What is "Fish" in Cebuano?',
        correctAnswer: 'Iho',
        cebuano: 'Iho',
        english: 'Fish',
        options: ['Iho', 'Baka', 'Kabaw', 'Buang'],
        hint: 'Lives in water',
      ),
      QuizQuestion(
        type: QuizType.fillBlank,
        prompt: 'Ang _____ nagkatulog. (The cat is sleeping.)',
        correctAnswer: 'pusak',
        cebuano: 'pusak',
        english: 'cat',
        options: [],
        hint: 'Small pet that meows',
      ),
      QuizQuestion(
        type: QuizType.wordJumble,
        prompt: 'Unscramble: "B A B O Y"',
        correctAnswer: 'Baboy',
        cebuano: 'Baboy',
        english: 'Pig',
        options: ['B', 'A', 'B', 'O', 'Y'],
        hint: 'Farm animal that oinks',
      ),
      QuizQuestion(
        type: QuizType.flashcard,
        prompt: 'Manok',
        correctAnswer: 'Chicken',
        cebuano: 'Manok',
        english: 'Chicken',
        options: [],
        hint: 'Farm bird that clucks',
      ),
    ];
  }

  /// Level 5: Food
  static List<QuizQuestion> _foodQuiz() {
    return [
      QuizQuestion(
        type: QuizType.multipleChoice,
        prompt: 'What is "Food" in Cebuano?',
        correctAnswer: 'Pagkaon',
        cebuano: 'Pagkaon',
        english: 'Food / To eat',
        options: ['Pagkaon', 'Tubig', 'Puso', 'Isda'],
        hint: 'What we eat',
      ),
      QuizQuestion(
        type: QuizType.multipleChoice,
        prompt: 'What does "Tubig" mean?',
        correctAnswer: 'Water',
        cebuano: 'Tubig',
        english: 'Water',
        options: ['Rice', 'Water', 'Meat', 'Fruits'],
        hint: 'Essential for life',
      ),
      QuizQuestion(
        type: QuizType.multipleChoice,
        prompt: 'What is "Rice" in Cebuano?',
        correctAnswer: 'Puso',
        cebuano: 'Puso',
        english: 'Rice',
        options: ['Puso', 'Isda', 'Karni', 'Prutas'],
        hint: 'Main Filipino staple',
      ),
      QuizQuestion(
        type: QuizType.fillBlank,
        prompt: 'Mangaon ta. (Let\'s ____.)',
        correctAnswer: 'kaon',
        cebuano: 'kaon',
        english: 'eat',
        options: [],
        hint: 'What we do with food',
      ),
      QuizQuestion(
        type: QuizType.wordJumble,
        prompt: 'Unscramble: "K A R N I"',
        correctAnswer: 'Karni',
        cebuano: 'Karni',
        english: 'Meat',
        options: ['K', 'A', 'R', 'N', 'I'],
        hint: 'Protein source',
      ),
      QuizQuestion(
        type: QuizType.flashcard,
        prompt: 'Kape',
        correctAnswer: 'Coffee',
        cebuano: 'Kape',
        english: 'Coffee',
        options: [],
        hint: 'Morning beverage',
      ),
    ];
  }

  /// Level 6: Family
  static List<QuizQuestion> _familyQuiz() {
    return [
      QuizQuestion(
        type: QuizType.multipleChoice,
        prompt: 'What is "Father" in Cebuano?',
        correctAnswer: 'Amahan',
        cebuano: 'Amahan',
        english: 'Father',
        options: ['Amahan', 'Inahan', 'Anak', 'Lalaki'],
        hint: 'Male parent',
      ),
      QuizQuestion(
        type: QuizType.multipleChoice,
        prompt: 'What does "Inahan" mean?',
        correctAnswer: 'Mother',
        cebuano: 'Inahan',
        english: 'Mother',
        options: ['Father', 'Mother', 'Child', 'Boy'],
        hint: 'Female parent',
      ),
      QuizQuestion(
        type: QuizType.multipleChoice,
        prompt: 'What is "Child" in Cebuano?',
        correctAnswer: 'Anak',
        cebuano: 'Anak',
        english: 'Child',
        options: ['Father', 'Mother', 'Child', 'Sister'],
        hint: 'Young person',
      ),
      QuizQuestion(
        type: QuizType.fillBlank,
        prompt: 'Ang akong _____ kay... (My name is...)',
        correctAnswer: 'ngalan',
        cebuano: 'ngalan',
        english: 'name',
        options: [],
        hint: 'What people call you',
      ),
      QuizQuestion(
        type: QuizType.wordJumble,
        prompt: 'Unscramble: "L A K A K I"',
        correctAnswer: 'Lalaki',
        cebuano: 'Lalaki',
        english: 'Boy / Male',
        options: ['L', 'A', 'L', 'A', 'K', 'I'],
        hint: 'Male person',
      ),
      QuizQuestion(
        type: QuizType.flashcard,
        prompt: 'Babaye',
        correctAnswer: 'Girl / Female',
        cebuano: 'Babaye',
        english: 'Girl / Female',
        options: [],
        hint: 'Female person',
      ),
    ];
  }

  /// Level 7: Time
  static List<QuizQuestion> _timeQuiz() {
    return [
      QuizQuestion(
        type: QuizType.multipleChoice,
        prompt: 'What is "Day" in Cebuano?',
        correctAnswer: 'Adlaw',
        cebuano: 'Adlaw',
        english: 'Day',
        options: ['Adlaw', 'Gabii', 'Buntag', 'Hapon'],
        hint: 'When the sun is up',
      ),
      QuizQuestion(
        type: QuizType.multipleChoice,
        prompt: 'What does "Buntag" mean?',
        correctAnswer: 'Morning',
        cebuano: 'Buntag',
        english: 'Morning',
        options: ['Day', 'Morning', 'Afternoon', 'Night'],
        hint: 'Start of the day',
      ),
      QuizQuestion(
        type: QuizType.multipleChoice,
        prompt: 'What is "Night" in Cebuano?',
        correctAnswer: 'Gabii',
        cebuano: 'Gabii',
        english: 'Night',
        options: ['Day', 'Morning', 'Afternoon', 'Night'],
        hint: 'When it\'s dark',
      ),
      QuizQuestion(
        type: QuizType.fillBlank,
        prompt: 'Maayong _____ (Good morning)',
        correctAnswer: 'buntag',
        cebuano: 'buntag',
        english: 'morning',
        options: [],
        hint: 'Start of day greeting',
      ),
      QuizQuestion(
        type: QuizType.wordJumble,
        prompt: 'Unscramble: "U G M A"',
        correctAnswer: 'Ugma',
        cebuano: 'Ugma',
        english: 'Tomorrow',
        options: ['U', 'G', 'M', 'A'],
        hint: 'The day after today',
      ),
      QuizQuestion(
        type: QuizType.flashcard,
        prompt: 'Kahapon',
        correctAnswer: 'Yesterday',
        cebuano: 'Kahapon',
        english: 'Yesterday',
        options: [],
        hint: 'The day before today',
      ),
    ];
  }

  /// Level 8: Weather
  static List<QuizQuestion> _weatherQuiz() {
    return [
      QuizQuestion(
        type: QuizType.multipleChoice,
        prompt: 'What is "Rain" in Cebuano?',
        correctAnswer: 'Uwan',
        cebuano: 'Uwan',
        english: 'Rain',
        options: ['Uwan', 'Hangin', 'Kilat', 'Aldaw'],
        hint: 'Falls from the sky',
      ),
      QuizQuestion(
        type: QuizType.multipleChoice,
        prompt: 'What does "Hangin" mean?',
        correctAnswer: 'Wind',
        cebuano: 'Hangin',
        english: 'Wind',
        options: ['Rain', 'Wind', 'Lightning', 'Thunder'],
        hint: 'Moving air',
      ),
      QuizQuestion(
        type: QuizType.multipleChoice,
        prompt: 'What is "Sun" in Cebuano?',
        correctAnswer: 'Aldaw',
        cebuano: 'Aldaw',
        english: 'Sun / Day',
        options: ['Moon', 'Sun', 'Sky', 'Earth'],
        hint: 'Brightest star',
      ),
      QuizQuestion(
        type: QuizType.fillBlank,
        prompt: 'Nag-ulan karon. (It\'s _____ now.)',
        correctAnswer: 'raining',
        cebuano: 'raining',
        english: 'raining',
        options: [],
        hint: 'Water falling from sky',
      ),
      QuizQuestion(
        type: QuizType.wordJumble,
        prompt: 'Unscramble: "G I N I H A N"',
        correctAnswer: 'Hangin',
        cebuano: 'Hangin',
        english: 'Wind',
        options: ['H', 'A', 'N', 'G', 'I', 'N'],
        hint: 'Moving air',
      ),
      QuizQuestion(
        type: QuizType.flashcard,
        prompt: 'Bulan',
        correctAnswer: 'Moon',
        cebuano: 'Bulan',
        english: 'Moon',
        options: [],
        hint: 'Night light',
      ),
    ];
  }

  /// Level 9: Emotions
  static List<QuizQuestion> _emotionsQuiz() {
    return [
      QuizQuestion(
        type: QuizType.multipleChoice,
        prompt: 'What is "Happy" in Cebuano?',
        correctAnswer: 'Saya',
        cebuano: 'Saya',
        english: 'Happy',
        options: ['Saya', 'Luoy', 'Kahadlok', 'Gutom'],
        hint: 'Positive feeling',
      ),
      QuizQuestion(
        type: QuizType.multipleChoice,
        prompt: 'What does "Gutom" mean?',
        correctAnswer: 'Hungry',
        cebuano: 'Gutom',
        english: 'Hungry',
        options: ['Happy', 'Hungry', 'Thirsty', 'Sad'],
        hint: 'Need to eat',
      ),
      QuizQuestion(
        type: QuizType.multipleChoice,
        prompt: 'What is "Afraid" in Cebuano?',
        correctAnswer: 'Kahadlok',
        cebuano: 'Kahadlok',
        english: 'Afraid / Scared',
        options: ['Happy', 'Worried', 'Afraid', 'Angry'],
        hint: 'Fear feeling',
      ),
      QuizQuestion(
        type: QuizType.fillBlank,
        prompt: '_____ na ko. (I am hungry now.)',
        correctAnswer: 'Gutom',
        cebuano: 'Gutom',
        english: 'Hungry',
        options: [],
        hint: 'Need food',
      ),
      QuizQuestion(
        type: QuizType.wordJumble,
        prompt: 'Unscramble: "S A Y A"',
        correctAnswer: 'Saya',
        cebuano: 'Saya',
        english: 'Happy',
        options: ['S', 'A', 'Y', 'A'],
        hint: 'Joyful feeling',
      ),
      QuizQuestion(
        type: QuizType.flashcard,
        prompt: 'Utan',
        correctAnswer: 'Thirsty',
        cebuano: 'Utan',
        english: 'Thirsty',
        options: [],
        hint: 'Need water',
      ),
    ];
  }

  /// Level 10: Actions
  static List<QuizQuestion> _actionsQuiz() {
    return [
      QuizQuestion(
        type: QuizType.multipleChoice,
        prompt: 'What is "To eat" in Cebuano?',
        correctAnswer: 'Mangaon',
        cebuano: 'Mangaon',
        english: 'To eat',
        options: ['Mangaon', 'Moinom', 'Matulog', 'Moadto'],
        hint: 'What we do with food',
      ),
      QuizQuestion(
        type: QuizType.multipleChoice,
        prompt: 'What does "Matulog" mean?',
        correctAnswer: 'To sleep',
        cebuano: 'Matulog',
        english: 'To sleep',
        options: ['To eat', 'To sleep', 'To run', 'To walk'],
        hint: 'Rest at night',
      ),
      QuizQuestion(
        type: QuizType.multipleChoice,
        prompt: 'What is "To go" in Cebuano?',
        correctAnswer: 'Moadto',
        cebuano: 'Moadto',
        english: 'To go',
        options: ['To eat', 'To drink', 'To sleep', 'To go'],
        hint: 'Movement',
      ),
      QuizQuestion(
        type: QuizType.fillBlank,
        prompt: 'Mangaon ta. (Let\'s ____.)',
        correctAnswer: 'eat',
        cebuano: 'eat',
        english: 'eat',
        options: [],
        hint: 'Consume food',
      ),
      QuizQuestion(
        type: QuizType.wordJumble,
        prompt: 'Unscramble: "D A G A N"',
        correctAnswer: 'Dagan',
        cebuano: 'Dagan',
        english: 'Run',
        options: ['D', 'A', 'G', 'A', 'N'],
        hint: 'Fast movement',
      ),
      QuizQuestion(
        type: QuizType.flashcard,
        prompt: 'Mabasa',
        correctAnswer: 'To read',
        cebuano: 'Mabasa',
        english: 'To read',
        options: [],
        hint: 'With books',
      ),
    ];
  }

  /// Level 11: Places
  static List<QuizQuestion> _placesQuiz() {
    return [
      QuizQuestion(
        type: QuizType.multipleChoice,
        prompt: 'What is "Room" in Cebuano?',
        correctAnswer: 'Kwarto',
        cebuano: 'Kwarto',
        english: 'Room',
        options: ['Kwarto', 'Kusina', 'Banyo', 'Balay'],
        hint: 'Part of a house',
      ),
      QuizQuestion(
        type: QuizType.multipleChoice,
        prompt: 'What does "Kusina" mean?',
        correctAnswer: 'Kitchen',
        cebuano: 'Kusina',
        english: 'Kitchen',
        options: ['Room', 'Kitchen', 'Bathroom', 'Bedroom'],
        hint: 'Where cooking happens',
      ),
      QuizQuestion(
        type: QuizType.multipleChoice,
        prompt: 'What is "Bathroom" in Cebuano?',
        correctAnswer: 'Banyo',
        cebuano: 'Banyo',
        english: 'Bathroom',
        options: ['Kwarto', 'Kusina', 'Banyo', 'Sala'],
        hint: 'Personal hygiene room',
      ),
      QuizQuestion(
        type: QuizType.fillBlank,
        prompt: 'Naa sa kwarto ang bata. (The child is in the ____.)',
        correctAnswer: 'room',
        cebuano: 'room',
        english: 'room',
        options: [],
        hint: 'Private space',
      ),
      QuizQuestion(
        type: QuizType.wordJumble,
        prompt: 'Unscramble: "B A N Y O"',
        correctAnswer: 'Banyo',
        cebuano: 'Banyo',
        english: 'Bathroom',
        options: ['B', 'A', 'N', 'Y', 'O'],
        hint: 'Toilet room',
      ),
      QuizQuestion(
        type: QuizType.flashcard,
        prompt: 'Balay',
        correctAnswer: 'House',
        cebuano: 'Balay',
        english: 'House',
        options: [],
        hint: 'Where people live',
      ),
    ];
  }

  /// Level 12: Objects
  static List<QuizQuestion> _objectsQuiz() {
    return [
      QuizQuestion(
        type: QuizType.multipleChoice,
        prompt: 'What is "Table" in Cebuano?',
        correctAnswer: 'Lamisa',
        cebuano: 'Lamisa',
        english: 'Table',
        options: ['Lamisa', 'Silya', 'Lames', 'Kama'],
        hint: 'Furniture for eating',
      ),
      QuizQuestion(
        type: QuizType.multipleChoice,
        prompt: 'What does "Silya" mean?',
        correctAnswer: 'Chair',
        cebuano: 'Silya',
        english: 'Chair',
        options: ['Table', 'Chair', 'Bed', 'Sofa'],
        hint: 'Furniture for sitting',
      ),
      QuizQuestion(
        type: QuizType.multipleChoice,
        prompt: 'What is "Bed" in Cebuano?',
        correctAnswer: 'Kama',
        cebuano: 'Kama',
        english: 'Bed',
        options: ['Lamisa', 'Silya', 'Kama', 'Telepono'],
        hint: 'For sleeping',
      ),
      QuizQuestion(
        type: QuizType.fillBlank,
        prompt: 'Naa sa lamisa ang pagkaon. (The food is on the ____.)',
        correctAnswer: 'table',
        cebuano: 'table',
        english: 'table',
        options: [],
        hint: 'Flat surface for eating',
      ),
      QuizQuestion(
        type: QuizType.wordJumble,
        prompt: 'Unscramble: "L A M I S A"',
        correctAnswer: 'Lamisa',
        cebuano: 'Lamisa',
        english: 'Table',
        options: ['L', 'A', 'M', 'I', 'S', 'A'],
        hint: 'Eating furniture',
      ),
      QuizQuestion(
        type: QuizType.flashcard,
        prompt: 'Telepono',
        correctAnswer: 'Telephone',
        cebuano: 'Telepono',
        english: 'Telephone',
        options: [],
        hint: 'Communication device',
      ),
    ];
  }

  /// Level 13: Mixed Review
  static List<QuizQuestion> _mixedReviewQuiz() {
    return [
      QuizQuestion(
        type: QuizType.multipleChoice,
        prompt: 'How do you say "Hello" in Cebuano?',
        correctAnswer: 'Kumusta',
        cebuano: 'Kumusta',
        english: 'Hello / How are you?',
        options: ['Kumusta', 'Salamat', 'Oo', 'Dili'],
        hint: 'Greeting',
      ),
      QuizQuestion(
        type: QuizType.multipleChoice,
        prompt: 'What is "Three" in Cebuano?',
        correctAnswer: 'Tulo',
        cebuano: 'Tulo',
        english: 'Three',
        options: ['Usa', 'Duha', 'Tulo', 'Upat'],
        hint: 'Number',
      ),
      QuizQuestion(
        type: QuizType.multipleChoice,
        prompt: 'What does "Pula" mean?',
        correctAnswer: 'Red',
        cebuano: 'Pula',
        english: 'Red',
        options: ['Red', 'Blue', 'Green', 'Yellow'],
        hint: 'Color',
      ),
      QuizQuestion(
        type: QuizType.multipleChoice,
        prompt: 'What is "Dog" in Cebuano?',
        correctAnswer: 'Iro',
        cebuano: 'Iro',
        english: 'Dog',
        options: ['Iro', 'Pusak', 'Baboy', 'Manok'],
        hint: 'Animal',
      ),
      QuizQuestion(
        type: QuizType.multipleChoice,
        prompt: 'What does "Tubig" mean?',
        correctAnswer: 'Water',
        cebuano: 'Tubig',
        english: 'Water',
        options: ['Rice', 'Water', 'Meat', 'Fruit'],
        hint: 'Food/Drink',
      ),
      QuizQuestion(
        type: QuizType.fillBlank,
        prompt: 'Ang akong _____ kay... (My name is...)',
        correctAnswer: 'ngalan',
        cebuano: 'ngalan',
        english: 'name',
        options: [],
        hint: 'Introduction',
      ),
      QuizQuestion(
        type: QuizType.wordJumble,
        prompt: 'Unscramble: "S A L A M A T"',
        correctAnswer: 'Salamat',
        cebuano: 'Salamat',
        english: 'Thank you',
        options: ['S', 'A', 'L', 'A', 'M', 'A', 'T'],
        hint: 'Gratitude',
      ),
      QuizQuestion(
        type: QuizType.flashcard,
        prompt: 'Maayong buntag',
        correctAnswer: 'Good morning',
        cebuano: 'Maayong buntag',
        english: 'Good morning',
        options: [],
        hint: 'Morning greeting',
      ),
    ];
  }

  /// Level 14: Challenge
  static List<QuizQuestion> _challengeQuiz() {
    return [
      QuizQuestion(
        type: QuizType.multipleChoice,
        prompt: 'What does "Kini" mean?',
        correctAnswer: 'This',
        cebuano: 'Kini',
        english: 'This',
        options: ['This', 'That', 'These', 'Those'],
        hint: 'Demonstrative - near',
      ),
      QuizQuestion(
        type: QuizType.multipleChoice,
        prompt: 'What is "Ang" used for?',
        correctAnswer: 'Nominative marker',
        cebuano: 'Ang',
        english: 'The (nominative marker)',
        options: [
          'Personal marker',
          'Nominative marker',
          'Genitive marker',
          'Linker',
        ],
        hint: 'Grammar marker',
      ),
      QuizQuestion(
        type: QuizType.multipleChoice,
        prompt: 'What does "Unsa" mean?',
        correctAnswer: 'What',
        cebuano: 'Unsa',
        english: 'What',
        options: ['Who', 'What', 'Where', 'When'],
        hint: 'Question word',
      ),
      QuizQuestion(
        type: QuizType.fillBlank,
        prompt: '_____ ang balay? (Where is the house?)',
        correctAnswer: 'Asa',
        cebuano: 'Asa',
        english: 'Where',
        options: [],
        hint: 'Location question',
      ),
      QuizQuestion(
        type: QuizType.wordJumble,
        prompt: 'Unscramble: "K I N S A"',
        correctAnswer: 'Kinsa',
        cebuano: 'Kinsa',
        english: 'Who',
        options: ['K', 'I', 'N', 'S', 'A'],
        hint: 'Person question',
      ),
      QuizQuestion(
        type: QuizType.flashcard,
        prompt: 'Kana',
        correctAnswer: 'That',
        cebuano: 'Kana',
        english: 'That',
        options: [],
        hint: 'Demonstrative - far',
      ),
    ];
  }

  /// Level 15: Mastery
  static List<QuizQuestion> _masteryQuiz() {
    return [
      QuizQuestion(
        type: QuizType.multipleChoice,
        prompt: 'What does "May" mean?',
        correctAnswer: 'There is / There are',
        cebuano: 'May',
        english: 'There is / There are',
        options: ['There is', 'There is no', 'Not', 'No'],
        hint: 'Existential - positive',
      ),
      QuizQuestion(
        type: QuizType.multipleChoice,
        prompt: 'What does "Wala" mean?',
        correctAnswer: 'There is no / There are no',
        cebuano: 'Wala',
        english: 'There is no / There are no',
        options: ['There is', 'There is no', 'Yes', 'Please'],
        hint: 'Existential - negative',
      ),
      QuizQuestion(
        type: QuizType.multipleChoice,
        prompt: 'What does "Dili" mean?',
        correctAnswer: 'No / Not',
        cebuano: 'Dili',
        english: 'No / Not',
        options: ['Yes', 'No', 'Please', 'Thank you'],
        hint: 'Negative',
      ),
      QuizQuestion(
        type: QuizType.fillBlank,
        prompt: '_____ libro sa lames. (There is a book on the table.)',
        correctAnswer: 'May',
        cebuano: 'May',
        english: 'There is',
        options: [],
        hint: 'Existential positive',
      ),
      QuizQuestion(
        type: QuizType.wordJumble,
        prompt: 'Unscramble: "D I L I"',
        correctAnswer: 'Dili',
        cebuano: 'Dili',
        english: 'No / Not',
        options: ['D', 'I', 'L', 'I'],
        hint: 'Negative response',
      ),
      QuizQuestion(
        type: QuizType.flashcard,
        prompt: 'Nga',
        correctAnswer: 'Linker (that/which)',
        cebuano: 'Nga',
        english: 'Linker (that/which)',
        options: [],
        hint: 'Grammar linker',
      ),
    ];
  }

  /// Level 16: Honorifics
  static List<QuizQuestion> _honorificsQuiz() {
    return [
      QuizQuestion(
        type: QuizType.multipleChoice,
        prompt: 'What is "Manong" used for?',
        correctAnswer: 'Older brother (respectful)',
        cebuano: 'Manong',
        english: 'Older brother (respectful)',
        options: ['Older brother', 'Older sister', 'Young man', 'Young lady'],
        hint: 'Respectful address',
      ),
      QuizQuestion(
        type: QuizType.multipleChoice,
        prompt: 'What does "Inday" mean?',
        correctAnswer: 'Young lady (endearing)',
        cebuano: 'Inday',
        english: 'Young lady (endearing)',
        options: ['Older brother', 'Young lady', 'Young man', 'Older sister'],
        hint: 'Endearing term',
      ),
      QuizQuestion(
        type: QuizType.multipleChoice,
        prompt: 'What is "Nong"?',
        correctAnswer: 'Mister / Brother (short)',
        cebuano: 'Nong',
        english: 'Mister / Brother (short)',
        options: ['Miss', 'Mister', 'Little boy', 'Young lady'],
        hint: 'Short honorific',
      ),
      QuizQuestion(
        type: QuizType.fillBlank,
        prompt: 'Kumusta, _____? (Hello, older brother.)',
        correctAnswer: 'Manong',
        cebuano: 'Manong',
        english: 'older brother',
        options: [],
        hint: 'Respectful address',
      ),
      QuizQuestion(
        type: QuizType.wordJumble,
        prompt: 'Unscramble: "D A Y"',
        correctAnswer: 'Day',
        cebuano: 'Day',
        english: 'Young lady (short)',
        options: ['D', 'A', 'Y'],
        hint: 'Short endearment',
      ),
      QuizQuestion(
        type: QuizType.flashcard,
        prompt: 'Manang',
        correctAnswer: 'Older sister (respectful)',
        cebuano: 'Manang',
        english: 'Older sister (respectful)',
        options: [],
        hint: 'Respectful female address',
      ),
    ];
  }

  /// Level 17: Markers
  static List<QuizQuestion> _markersQuiz() {
    return [
      QuizQuestion(
        type: QuizType.multipleChoice,
        prompt: 'What is "Si" used for?',
        correctAnswer: 'Personal marker',
        cebuano: 'Si',
        english: 'Personal marker',
        options: [
          'Nominative marker',
          'Personal marker',
          'Genitive marker',
          'Linker',
        ],
        hint: 'Before names',
      ),
      QuizQuestion(
        type: QuizType.multipleChoice,
        prompt: 'What does "Kanaa" mean?',
        correctAnswer: 'That over there',
        cebuano: 'Kanaa',
        english: 'That over there',
        options: ['This', 'That', 'That over there', 'These'],
        hint: 'Far demonstrative',
      ),
      QuizQuestion(
        type: QuizType.multipleChoice,
        prompt: 'What is "Kiniy"?',
        correctAnswer: 'These',
        cebuano: 'Kiniy',
        english: 'These',
        options: ['This', 'That', 'These', 'Those'],
        hint: 'Plural near',
      ),
      QuizQuestion(
        type: QuizType.fillBlank,
        prompt: '_____ bata. (The child.)',
        correctAnswer: 'Ang',
        cebuano: 'Ang',
        english: 'The',
        options: [],
        hint: 'Nominative marker',
      ),
      QuizQuestion(
        type: QuizType.wordJumble,
        prompt: 'Unscramble: "K A N A H"',
        correctAnswer: 'Kanah',
        cebuano: 'Kanah',
        english: 'Those',
        options: ['K', 'A', 'N', 'A', 'H'],
        hint: 'Plural far',
      ),
      QuizQuestion(
        type: QuizType.flashcard,
        prompt: 'Kini',
        correctAnswer: 'This',
        cebuano: 'Kini',
        english: 'This',
        options: [],
        hint: 'Near demonstrative',
      ),
    ];
  }

  /// Level 18: Interrogatives
  static List<QuizQuestion> _interrogativesQuiz() {
    return [
      QuizQuestion(
        type: QuizType.multipleChoice,
        prompt: 'What does "Ngano" mean?',
        correctAnswer: 'Why',
        cebuano: 'Ngano',
        english: 'Why',
        options: ['Who', 'What', 'Why', 'Where'],
        hint: 'Reason question',
      ),
      QuizQuestion(
        type: QuizType.multipleChoice,
        prompt: 'What is "Hain" used for?',
        correctAnswer: 'Where (location)',
        cebuano: 'Hain',
        english: 'Where (location)',
        options: ['Who', 'Where', 'When', 'How much'],
        hint: 'Location question',
      ),
      QuizQuestion(
        type: QuizType.multipleChoice,
        prompt: 'What does "Tagpila" mean?',
        correctAnswer: 'How much',
        cebuano: 'Tagpila',
        english: 'How much',
        options: ['How many', 'How much', 'Who', 'What'],
        hint: 'Price question',
      ),
      QuizQuestion(
        type: QuizType.fillBlank,
        prompt: '_____ ka nagsulti ana? (Why did you say that?)',
        correctAnswer: 'Ngano',
        cebuano: 'Ngano',
        english: 'Why',
        options: [],
        hint: 'Reason',
      ),
      QuizQuestion(
        type: QuizType.wordJumble,
        prompt: 'Unscramble: "K A N U S"',
        correctAnswer: 'Kanus-a',
        cebuano: 'Kanus-a',
        english: 'When',
        options: ['K', 'A', 'N', 'U', 'S'],
        hint: 'Time question',
      ),
      QuizQuestion(
        type: QuizType.flashcard,
        prompt: 'Kinsay',
        correctAnswer: 'Who is',
        cebuano: 'Kinsay',
        english: 'Who is',
        options: [],
        hint: 'Person question',
      ),
    ];
  }

  /// Level 19: Existentials
  static List<QuizQuestion> _existentialsQuiz() {
    return [
      QuizQuestion(
        type: QuizType.multipleChoice,
        prompt: 'What is the opposite of "May"?',
        correctAnswer: 'Wala',
        cebuano: 'Wala',
        english: 'There is no / There are no',
        options: ['May', 'Wala', 'Dili', 'Oo'],
        hint: 'Negative existential',
      ),
      QuizQuestion(
        type: QuizType.multipleChoice,
        prompt: 'What does "Walâ" mean?',
        correctAnswer: 'None / Not (past)',
        cebuano: 'Walâ',
        english: 'None / Not (past)',
        options: ['There is', 'None / Not', 'Yes', 'Please'],
        hint: 'Past negative',
      ),
      QuizQuestion(
        type: QuizType.multipleChoice,
        prompt: 'What does "Dilì" mean?',
        correctAnswer: 'Not (non-past)',
        cebuano: 'Dilì',
        english: 'Not (non-past)',
        options: ['Yes', 'No', 'Not (past)', 'Not (non-past)'],
        hint: 'Non-past negative',
      ),
      QuizQuestion(
        type: QuizType.fillBlank,
        prompt: '_____ kwarta. (There is no money.)',
        correctAnswer: 'Wala',
        cebuano: 'Wala',
        english: 'There is no',
        options: [],
        hint: 'Negative existential',
      ),
      QuizQuestion(
        type: QuizType.wordJumble,
        prompt: 'Unscramble: "M A Y"',
        correctAnswer: 'May',
        cebuano: 'May',
        english: 'There is / There are',
        options: ['M', 'A', 'Y'],
        hint: 'Positive existential',
      ),
      QuizQuestion(
        type: QuizType.flashcard,
        prompt: 'Dili',
        correctAnswer: 'No / Not',
        cebuano: 'Dili',
        english: 'No / Not',
        options: [],
        hint: 'Negative',
      ),
    ];
  }

  /// Level 20: Adjectives
  static List<QuizQuestion> _adjectivesQuiz() {
    return [
      QuizQuestion(
        type: QuizType.multipleChoice,
        prompt: 'What does "Dako" mean?',
        correctAnswer: 'Big',
        cebuano: 'Dako',
        english: 'Big',
        options: ['Big', 'Small', 'Tall', 'Short'],
        hint: 'Size adjective',
      ),
      QuizQuestion(
        type: QuizType.multipleChoice,
        prompt: 'What is the opposite of "Dako"?',
        correctAnswer: 'Gamay',
        cebuano: 'Gamay',
        english: 'Small',
        options: ['Big', 'Small', 'New', 'Old'],
        hint: 'Size antonym',
      ),
      QuizQuestion(
        type: QuizType.multipleChoice,
        prompt: 'What does "Taas" mean?',
        correctAnswer: 'Tall / Long',
        cebuano: 'Taas',
        english: 'Tall / Long',
        options: ['Tall', 'Short', 'Wide', 'Narrow'],
        hint: 'Height/length',
      ),
      QuizQuestion(
        type: QuizType.fillBlank,
        prompt: '_____ ang balay. (The house is big.)',
        correctAnswer: 'Dako',
        cebuano: 'Dako',
        english: 'Big',
        options: [],
        hint: 'Size',
      ),
      QuizQuestion(
        type: QuizType.wordJumble,
        prompt: 'Unscramble: "G A M A Y"',
        correctAnswer: 'Gamay',
        cebuano: 'Gamay',
        english: 'Small',
        options: ['G', 'A', 'M', 'A', 'Y'],
        hint: 'Small size',
      ),
      QuizQuestion(
        type: QuizType.flashcard,
        prompt: 'Maayo',
        correctAnswer: 'Good',
        cebuano: 'Maayo',
        english: 'Good',
        options: [],
        hint: 'Quality',
      ),
    ];
  }

  /// Level 21: Verbs
  static List<QuizQuestion> _verbsQuiz() {
    return [
      QuizQuestion(
        type: QuizType.multipleChoice,
        prompt: 'What does "Magsabot" mean?',
        correctAnswer: 'To understand',
        cebuano: 'Magsabot',
        english: 'To understand',
        options: ['To speak', 'To understand', 'To listen', 'To read'],
        hint: 'Comprehension',
      ),
      QuizQuestion(
        type: QuizType.multipleChoice,
        prompt: 'What is "Magsulti"?',
        correctAnswer: 'To speak / To say',
        cebuano: 'Magsulti',
        english: 'To speak / To say',
        options: ['To eat', 'To speak', 'To sleep', 'To run'],
        hint: 'Communication',
      ),
      QuizQuestion(
        type: QuizType.multipleChoice,
        prompt: 'What does "Maminaw" mean?',
        correctAnswer: 'To listen',
        cebuano: 'Maminaw',
        english: 'To listen',
        options: ['To speak', 'To understand', 'To listen', 'To write'],
        hint: 'Hearing',
      ),
      QuizQuestion(
        type: QuizType.fillBlank,
        prompt: 'Magsulti ug _____. (Speak the truth.)',
        correctAnswer: 'tinuod',
        cebuano: 'tinuod',
        english: 'truth',
        options: [],
        hint: 'Honesty',
      ),
      QuizQuestion(
        type: QuizType.wordJumble,
        prompt: 'Unscramble: "M A B A S A"',
        correctAnswer: 'Mabasa',
        cebuano: 'Mabasa',
        english: 'To read',
        options: ['M', 'A', 'B', 'A', 'S', 'A'],
        hint: 'With books',
      ),
      QuizQuestion(
        type: QuizType.flashcard,
        prompt: 'Muli',
        correctAnswer: 'To return / To come back',
        cebuano: 'Muli',
        english: 'To return / To come back',
        options: [],
        hint: 'Going back',
      ),
    ];
  }

  /// Level 22: Body
  static List<QuizQuestion> _bodyQuiz() {
    return [
      QuizQuestion(
        type: QuizType.multipleChoice,
        prompt: 'What is "Head" in Cebuano?',
        correctAnswer: 'Ulo',
        cebuano: 'Ulo',
        english: 'Head',
        options: ['Ulo', 'Baba', 'Lingkod', 'Tindog'],
        hint: 'Top of body',
      ),
      QuizQuestion(
        type: QuizType.multipleChoice,
        prompt: 'What does "Baba" mean?',
        correctAnswer: 'Mouth',
        cebuano: 'Baba',
        english: 'Mouth',
        options: ['Head', 'Mouth', 'Hand', 'Foot'],
        hint: 'For eating/speaking',
      ),
      QuizQuestion(
        type: QuizType.multipleChoice,
        prompt: 'What is "Sit" in Cebuano?',
        correctAnswer: 'Lingkod',
        cebuano: 'Lingkod',
        english: 'Sit',
        options: ['Sit', 'Stand', 'Walk', 'Run'],
        hint: 'Resting position',
      ),
      QuizQuestion(
        type: QuizType.fillBlank,
        prompt: 'Nasakit akong _____. (My head hurts.)',
        correctAnswer: 'ulo',
        cebuano: 'ulo',
        english: 'head',
        options: [],
        hint: 'Body part',
      ),
      QuizQuestion(
        type: QuizType.wordJumble,
        prompt: 'Unscramble: "T I N D O G"',
        correctAnswer: 'Tindog',
        cebuano: 'Tindog',
        english: 'Stand',
        options: ['T', 'I', 'N', 'D', 'O', 'G'],
        hint: 'Upright position',
      ),
      QuizQuestion(
        type: QuizType.flashcard,
        prompt: 'Lakaw',
        correctAnswer: 'Walk / Go',
        cebuano: 'Lakaw',
        english: 'Walk / Go',
        options: [],
        hint: 'Movement',
      ),
    ];
  }

  /// Level 23: Kitchen
  static List<QuizQuestion> _kitchenQuiz() {
    return [
      QuizQuestion(
        type: QuizType.multipleChoice,
        prompt: 'What is "Bread" in Cebuano?',
        correctAnswer: 'Pan',
        cebuano: 'Pan',
        english: 'Bread',
        options: ['Pan', 'Saging', 'Manga', 'Lamisa'],
        hint: 'Baked food',
      ),
      QuizQuestion(
        type: QuizType.multipleChoice,
        prompt: 'What does "Saging" mean?',
        correctAnswer: 'Banana',
        cebuano: 'Saging',
        english: 'Banana',
        options: ['Bread', 'Banana', 'Mango', 'Table'],
        hint: 'Yellow fruit',
      ),
      QuizQuestion(
        type: QuizType.multipleChoice,
        prompt: 'What is "Mango" in Cebuano?',
        correctAnswer: 'Manga',
        cebuano: 'Manga',
        english: 'Mango',
        options: ['Banana', 'Mango', 'Bread', 'Rice'],
        hint: 'Sweet fruit',
      ),
      QuizQuestion(
        type: QuizType.fillBlank,
        prompt: 'Naa koy _____. (I have bread.)',
        correctAnswer: 'pan',
        cebuano: 'pan',
        english: 'bread',
        options: [],
        hint: 'Baked staple',
      ),
      QuizQuestion(
        type: QuizType.wordJumble,
        prompt: 'Unscramble: "S A G I N G"',
        correctAnswer: 'Saging',
        cebuano: 'Saging',
        english: 'Banana',
        options: ['S', 'A', 'G', 'I', 'N', 'G'],
        hint: 'Curved yellow fruit',
      ),
      QuizQuestion(
        type: QuizType.flashcard,
        prompt: 'Nagluto siya sa kusina.',
        correctAnswer: 'She is cooking in the kitchen.',
        cebuano: 'Nagluto siya sa kusina.',
        english: 'She is cooking in the kitchen.',
        options: [],
        hint: 'Cooking location',
      ),
    ];
  }

  /// Level 24: Directions
  static List<QuizQuestion> _directionsQuiz() {
    return [
      QuizQuestion(
        type: QuizType.multipleChoice,
        prompt: 'What does "Moadto" mean?',
        correctAnswer: 'To go',
        cebuano: 'Moadto',
        english: 'To go',
        options: ['To come', 'To go', 'To return', 'To stay'],
        hint: 'Movement away',
      ),
      QuizQuestion(
        type: QuizType.multipleChoice,
        prompt: 'What does "Muli" mean?',
        correctAnswer: 'To return / To come back',
        cebuano: 'Muli',
        english: 'To return / To come back',
        options: ['To go', 'To return', 'To stay', 'To leave'],
        hint: 'Coming back',
      ),
      QuizQuestion(
        type: QuizType.multipleChoice,
        prompt: 'What is "Mangita"?',
        correctAnswer: 'To look for / To search',
        cebuano: 'Mangita',
        english: 'To look for / To search',
        options: ['To find', 'To look for', 'To see', 'To watch'],
        hint: 'Searching',
      ),
      QuizQuestion(
        type: QuizType.fillBlank,
        prompt: 'Muli _____. (Return immediately.)',
        correctAnswer: 'dayon',
        cebuano: 'dayon',
        english: 'immediately',
        options: [],
        hint: 'Right away',
      ),
      QuizQuestion(
        type: QuizType.wordJumble,
        prompt: 'Unscramble: "L A K A W"',
        correctAnswer: 'Lakaw',
        cebuano: 'Lakaw',
        english: 'Walk / Go',
        options: ['L', 'A', 'K', 'A', 'W'],
        hint: 'Movement',
      ),
      QuizQuestion(
        type: QuizType.flashcard,
        prompt: 'Naa sa kwarto ang bata.',
        correctAnswer: 'The child is in the room.',
        cebuano: 'Naa sa kwarto ang bata.',
        english: 'The child is in the room.',
        options: [],
        hint: 'Location',
      ),
    ];
  }

  /// Level 25: Nature
  static List<QuizQuestion> _natureQuiz() {
    return [
      QuizQuestion(
        type: QuizType.multipleChoice,
        prompt: 'What is "Lightning" in Cebuano?',
        correctAnswer: 'Kilat',
        cebuano: 'Kilat',
        english: 'Lightning',
        options: ['Kilat', 'Kahilak', 'Hangin', 'Uwan'],
        hint: 'Weather phenomenon',
      ),
      QuizQuestion(
        type: QuizType.multipleChoice,
        prompt: 'What does "Kahilak" mean?',
        correctAnswer: 'Thunder',
        cebuano: 'Kahilak',
        english: 'Thunder',
        options: ['Lightning', 'Thunder', 'Wind', 'Rain'],
        hint: 'Loud weather sound',
      ),
      QuizQuestion(
        type: QuizType.multipleChoice,
        prompt: 'What is "Sky" in Cebuano?',
        correctAnswer: 'Langit',
        cebuano: 'Langit',
        english: 'Sky',
        options: ['Sky', 'Earth', 'Moon', 'Sun'],
        hint: 'Above us',
      ),
      QuizQuestion(
        type: QuizType.fillBlank,
        prompt: 'Nakita ko ang _____. (I saw the lightning.)',
        correctAnswer: 'kilat',
        cebuano: 'kilat',
        english: 'lightning',
        options: [],
        hint: 'Weather flash',
      ),
      QuizQuestion(
        type: QuizType.wordJumble,
        prompt: 'Unscramble: "G I N I H A N"',
        correctAnswer: 'Hangin',
        cebuano: 'Hangin',
        english: 'Wind',
        options: ['H', 'A', 'N', 'G', 'I', 'N'],
        hint: 'Moving air',
      ),
      QuizQuestion(
        type: QuizType.flashcard,
        prompt: 'Yuta',
        correctAnswer: 'Earth / Ground',
        cebuano: 'Yuta',
        english: 'Earth / Ground',
        options: [],
        hint: 'We stand on it',
      ),
    ];
  }

  /// Level 26: Feelings
  static List<QuizQuestion> _feelingsQuiz() {
    return [
      QuizQuestion(
        type: QuizType.multipleChoice,
        prompt: 'What does "Luoy" mean?',
        correctAnswer: 'Sad / Pity',
        cebuano: 'Luoy',
        english: 'Sad / Pity',
        options: ['Happy', 'Sad', 'Angry', 'Afraid'],
        hint: 'Negative emotion',
      ),
      QuizQuestion(
        type: QuizType.multipleChoice,
        prompt: 'What does "Kabalaka" mean?',
        correctAnswer: 'Worried',
        cebuano: 'Kabalaka',
        english: 'Worried',
        options: ['Happy', 'Worried', 'Surprised', 'Calm'],
        hint: 'Anxious feeling',
      ),
      QuizQuestion(
        type: QuizType.multipleChoice,
        prompt: 'What is "Pahiyom"?',
        correctAnswer: 'Angry',
        cebuano: 'Pahiyom',
        english: 'Angry',
        options: ['Happy', 'Sad', 'Angry', 'Afraid'],
        hint: 'Mad emotion',
      ),
      QuizQuestion(
        type: QuizType.fillBlank,
        prompt: '_____ ka. (You are pitiful.)',
        correctAnswer: 'Luoy',
        cebuano: 'Luoy',
        english: 'Sad / Pity',
        options: [],
        hint: 'Compassion',
      ),
      QuizQuestion(
        type: QuizType.wordJumble,
        prompt: 'Unscramble: "S A Y A"',
        correctAnswer: 'Saya',
        cebuano: 'Saya',
        english: 'Happy',
        options: ['S', 'A', 'Y', 'A'],
        hint: 'Joyful emotion',
      ),
      QuizQuestion(
        type: QuizType.flashcard,
        prompt: 'Kasaba ko sa balita.',
        correctAnswer: 'I was surprised by the news.',
        cebuano: 'Kasaba ko sa balita.',
        english: 'I was surprised by the news.',
        options: [],
        hint: 'Unexpected emotion',
      ),
    ];
  }

  /// Level 27: Advanced Grammar
  static List<QuizQuestion> _advancedGrammarQuiz() {
    return [
      QuizQuestion(
        type: QuizType.multipleChoice,
        prompt: 'What is "Sab" used for?',
        correctAnswer: 'Just / Only (response)',
        cebuano: 'Sab',
        english: 'Just / Only (response)',
        options: ['Also', 'Just', 'Can', 'Please'],
        hint: 'Response particle',
      ),
      QuizQuestion(
        type: QuizType.multipleChoice,
        prompt: 'What does "Sad" mean?',
        correctAnswer: 'Also / Too (response)',
        cebuano: 'Sad',
        english: 'Also / Too (response)',
        options: ['Just', 'Also', 'Not', 'No'],
        hint: 'Addition particle',
      ),
      QuizQuestion(
        type: QuizType.multipleChoice,
        prompt: 'What does "Pod" mean?',
        correctAnswer: 'Can / Able to (response)',
        cebuano: 'Pod',
        english: 'Can / Able to (response)',
        options: ['Just', 'Also', 'Can', 'No'],
        hint: 'Ability particle',
      ),
      QuizQuestion(
        type: QuizType.fillBlank,
        prompt: 'Dili _____. (Not really.)',
        correctAnswer: 'sab',
        cebuano: 'sab',
        english: 'really',
        options: [],
        hint: 'Response particle',
      ),
      QuizQuestion(
        type: QuizType.wordJumble,
        prompt: 'Unscramble: "S A D"',
        correctAnswer: 'Sad',
        cebuano: 'Sad',
        english: 'Also / Too (response)',
        options: ['S', 'A', 'D'],
        hint: 'Addition particle',
      ),
      QuizQuestion(
        type: QuizType.flashcard,
        prompt: 'Nga',
        correctAnswer: 'Linker (that/which)',
        cebuano: 'Nga',
        english: 'Linker (that/which)',
        options: [],
        hint: 'Grammar connector',
      ),
    ];
  }

  /// Level 28: Conversation
  static List<QuizQuestion> _conversationQuiz() {
    return [
      QuizQuestion(
        type: QuizType.multipleChoice,
        prompt: 'How do you respond to "Kumusta ka?"?',
        correctAnswer: 'Maayo ra ko',
        cebuano: 'Maayo ra ko',
        english: 'I\'m fine / Just okay',
        options: ['Salamat', 'Maayo ra ko', 'Dili', 'Oo'],
        hint: 'Positive response',
      ),
      QuizQuestion(
        type: QuizType.multipleChoice,
        prompt: 'What does "Makig-istorya" mean?',
        correctAnswer: 'To talk with someone',
        cebuano: 'Makig-istorya',
        english: 'To talk with someone',
        options: ['To listen', 'To talk', 'To read', 'To write'],
        hint: 'Conversation',
      ),
      QuizQuestion(
        type: QuizType.multipleChoice,
        prompt: 'What does "Nagtrabaho" mean?',
        correctAnswer: 'Working',
        cebuano: 'Nagtrabaho',
        english: 'Working',
        options: ['Working', 'Studying', 'Cooking', 'Sleeping'],
        hint: 'Employment',
      ),
      QuizQuestion(
        type: QuizType.fillBlank,
        prompt: 'Nag-eskwela ang bata. (The child is _____.)',
        correctAnswer: 'studying',
        cebuano: 'studying',
        english: 'studying',
        options: [],
        hint: 'Education',
      ),
      QuizQuestion(
        type: QuizType.wordJumble,
        prompt: 'Unscramble: "M A B A S A"',
        correctAnswer: 'Mabasa',
        cebuano: 'Mabasa',
        english: 'To read',
        options: ['M', 'A', 'B', 'A', 'S', 'A'],
        hint: 'With books',
      ),
      QuizQuestion(
        type: QuizType.flashcard,
        prompt: 'Makig-istorya ko nimo.',
        correctAnswer: 'I will talk with you.',
        cebuano: 'Makig-istorya ko nimo.',
        english: 'I will talk with you.',
        options: [],
        hint: 'Conversation',
      ),
    ];
  }

  /// Level 29: Complete Review
  static List<QuizQuestion> _completeReviewQuiz() {
    return [
      QuizQuestion(
        type: QuizType.multipleChoice,
        prompt: 'What is "Good morning" in Cebuano?',
        correctAnswer: 'Maayong buntag',
        cebuano: 'Maayong buntag',
        english: 'Good morning',
        options: [
          'Maayong buntag',
          'Maayong hapon',
          'Maayong gabii',
          'Kumusta',
        ],
        hint: 'Morning greeting',
      ),
      QuizQuestion(
        type: QuizType.multipleChoice,
        prompt: 'What is "Three" in Cebuano?',
        correctAnswer: 'Tulo',
        cebuano: 'Tulo',
        english: 'Three',
        options: ['Usa', 'Duha', 'Tulo', 'Upat'],
        hint: 'Number',
      ),
      QuizQuestion(
        type: QuizType.multipleChoice,
        prompt: 'What does "Pula" mean?',
        correctAnswer: 'Red',
        cebuano: 'Pula',
        english: 'Red',
        options: ['Red', 'Blue', 'Green', 'Yellow'],
        hint: 'Color',
      ),
      QuizQuestion(
        type: QuizType.multipleChoice,
        prompt: 'What is "Dog" in Cebuano?',
        correctAnswer: 'Iro',
        cebuano: 'Iro',
        english: 'Dog',
        options: ['Iro', 'Pusak', 'Baboy', 'Manok'],
        hint: 'Animal',
      ),
      QuizQuestion(
        type: QuizType.multipleChoice,
        prompt: 'What does "Tubig" mean?',
        correctAnswer: 'Water',
        cebuano: 'Tubig',
        english: 'Water',
        options: ['Rice', 'Water', 'Meat', 'Fruit'],
        hint: 'Essential liquid',
      ),
      QuizQuestion(
        type: QuizType.multipleChoice,
        prompt: 'What is "Mother" in Cebuano?',
        correctAnswer: 'Inahan',
        cebuano: 'Inahan',
        english: 'Mother',
        options: ['Amahan', 'Inahan', 'Anak', 'Babaye'],
        hint: 'Female parent',
      ),
      QuizQuestion(
        type: QuizType.multipleChoice,
        prompt: 'What does "Buntag" mean?',
        correctAnswer: 'Morning',
        cebuano: 'Buntag',
        english: 'Morning',
        options: ['Day', 'Morning', 'Afternoon', 'Night'],
        hint: 'Time of day',
      ),
      QuizQuestion(
        type: QuizType.multipleChoice,
        prompt: 'What is "Rain" in Cebuano?',
        correctAnswer: 'Uwan',
        cebuano: 'Uwan',
        english: 'Rain',
        options: ['Uwan', 'Hangin', 'Kilat', 'Aldaw'],
        hint: 'Weather',
      ),
      QuizQuestion(
        type: QuizType.multipleChoice,
        prompt: 'What does "Saya" mean?',
        correctAnswer: 'Happy',
        cebuano: 'Saya',
        english: 'Happy',
        options: ['Happy', 'Sad', 'Angry', 'Afraid'],
        hint: 'Positive emotion',
      ),
      QuizQuestion(
        type: QuizType.multipleChoice,
        prompt: 'What is "To eat" in Cebuano?',
        correctAnswer: 'Mangaon',
        cebuano: 'Mangaon',
        english: 'To eat',
        options: ['Mangaon', 'Moinom', 'Matulog', 'Moadto'],
        hint: 'Action',
      ),
      QuizQuestion(
        type: QuizType.multipleChoice,
        prompt: 'What is "Room" in Cebuano?',
        correctAnswer: 'Kwarto',
        cebuano: 'Kwarto',
        english: 'Room',
        options: ['Kwarto', 'Kusina', 'Banyo', 'Balay'],
        hint: 'House part',
      ),
      QuizQuestion(
        type: QuizType.multipleChoice,
        prompt: 'What is "Table" in Cebuano?',
        correctAnswer: 'Lamisa',
        cebuano: 'Lamisa',
        english: 'Table',
        options: ['Lamisa', 'Silya', 'Kama', 'Lames'],
        hint: 'Furniture',
      ),
      QuizQuestion(
        type: QuizType.multipleChoice,
        prompt: 'What does "Kini" mean?',
        correctAnswer: 'This',
        cebuano: 'Kini',
        english: 'This',
        options: ['This', 'That', 'These', 'Those'],
        hint: 'Demonstrative',
      ),
      QuizQuestion(
        type: QuizType.multipleChoice,
        prompt: 'What does "May" mean?',
        correctAnswer: 'There is / There are',
        cebuano: 'May',
        english: 'There is / There are',
        options: ['There is', 'There is no', 'Not', 'No'],
        hint: 'Existential',
      ),
      QuizQuestion(
        type: QuizType.multipleChoice,
        prompt: 'What does "Dako" mean?',
        correctAnswer: 'Big',
        cebuano: 'Dako',
        english: 'Big',
        options: ['Big', 'Small', 'Tall', 'Short'],
        hint: 'Size',
      ),
      QuizQuestion(
        type: QuizType.fillBlank,
        prompt: 'Kumusta _____? (How are you?)',
        correctAnswer: 'ka',
        cebuano: 'ka',
        english: 'you',
        options: [],
        hint: 'Greeting',
      ),
      QuizQuestion(
        type: QuizType.wordJumble,
        prompt: 'Unscramble: "S A L A M A T"',
        correctAnswer: 'Salamat',
        cebuano: 'Salamat',
        english: 'Thank you',
        options: ['S', 'A', 'L', 'A', 'M', 'A', 'T'],
        hint: 'Gratitude',
      ),
      QuizQuestion(
        type: QuizType.flashcard,
        prompt: 'Maayong gabii',
        correctAnswer: 'Good evening',
        cebuano: 'Maayong gabii',
        english: 'Good evening',
        options: [],
        hint: 'Evening greeting',
      ),
    ];
  }
}
