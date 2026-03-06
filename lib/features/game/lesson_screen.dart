/// Lesson Screen - Displays educational content from PDF Module 1
/// Shows vocabulary, grammar concepts, and provides practice exercises

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/cebuano_words.dart';
import '../../data/quiz_data.dart';
import '../../core/models/quiz_question.dart';
import '../../services/audio_service.dart';
import 'quiz_screen.dart';

class LessonScreen extends ConsumerStatefulWidget {
  final int lessonNumber;
  final String lessonTitle;
  final String lessonDescription;

  const LessonScreen({
    super.key,
    required this.lessonNumber,
    required this.lessonTitle,
    required this.lessonDescription,
  });

  @override
  ConsumerState<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends ConsumerState<LessonScreen> {
  int _selectedTab = 0;
  final List<String> _tabs = ['Vocabulary', 'Grammar', 'Practice'];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0D1B3E), Color(0xFF1A3A5C)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context, size),
              _buildTabBar(context, size),
              Expanded(child: _buildContent(context, size)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Size size) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: size.width * 0.04,
        vertical: size.height * 0.02,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0x99000000),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white38),
              ),
              child: Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: size.height * 0.04,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Lesson ${widget.lessonNumber}',
                  style: TextStyle(
                    color: const Color(0xFFFFD700),
                    fontSize: size.height * 0.025,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                  ),
                ),
                Text(
                  widget.lessonTitle,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: size.height * 0.035,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.lessonDescription,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: size.height * 0.02,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar(BuildContext context, Size size) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
      child: Row(
        children: List.generate(_tabs.length, (index) {
          final isSelected = _selectedTab == index;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedTab = index),
              child: Container(
                margin: EdgeInsets.only(
                  right: index < _tabs.length - 1 ? size.width * 0.01 : 0,
                  left: index > 0 ? size.width * 0.01 : 0,
                ),
                padding: EdgeInsets.symmetric(vertical: size.height * 0.015),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFFFFD700)
                      : const Color(0x33FFFFFF),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? Colors.white : Colors.white24,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Center(
                  child: Text(
                    _tabs[index],
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.white70,
                      fontSize: size.height * 0.022,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildContent(BuildContext context, Size size) {
    switch (_selectedTab) {
      case 0:
        return _buildVocabularyTab(context, size);
      case 1:
        return _buildGrammarTab(context, size);
      case 2:
        return _buildPracticeTab(context, size);
      default:
        return _buildVocabularyTab(context, size);
    }
  }

  Widget _buildVocabularyTab(BuildContext context, Size size) {
    final words = _getVocabularyForLesson(widget.lessonNumber);

    return Container(
      padding: EdgeInsets.all(size.width * 0.04),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 2.5,
          crossAxisSpacing: size.width * 0.03,
          mainAxisSpacing: size.height * 0.02,
        ),
        itemCount: words.length,
        itemBuilder: (context, index) {
          final word = words[index];
          return _buildVocabularyCard(context, size, word);
        },
      ),
    );
  }

  Widget _buildVocabularyCard(BuildContext context, Size size, dynamic word) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0x33FFFFFF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white24),
      ),
      child: Padding(
        padding: EdgeInsets.all(size.width * 0.03),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              word.cebuano,
              style: TextStyle(
                color: Colors.white,
                fontSize: size.height * 0.03,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: size.height * 0.01),

            if (word.pronunciation != null && word.pronunciation!.isNotEmpty)
              Text(
                '/${word.pronunciation}/',
                style: TextStyle(
                  color: const Color(0xFFFFD700),
                  fontSize: size.height * 0.02,
                  fontStyle: FontStyle.italic,
                ),
              ),
            SizedBox(height: size.height * 0.01),

            Text(
              word.english,
              style: TextStyle(
                color: Colors.white70,
                fontSize: size.height * 0.025,
              ),
            ),

            if (word.exampleSentence != null &&
                word.exampleSentence!.isNotEmpty) ...[
              SizedBox(height: size.height * 0.015),
              Container(
                padding: EdgeInsets.all(size.width * 0.02),
                decoration: BoxDecoration(
                  color: const Color(0x1AFFD700),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Example:',
                      style: TextStyle(
                        color: const Color(0xFFFFD700),
                        fontSize: size.height * 0.018,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      word.exampleSentence!,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: size.height * 0.022,
                      ),
                    ),
                    if (word.exampleTranslation != null &&
                        word.exampleTranslation!.isNotEmpty)
                      Text(
                        word.exampleTranslation!,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: size.height * 0.02,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                  ],
                ),
              ),
            ],

            SizedBox(height: size.height * 0.01),
            GestureDetector(
              onTap: () {
                final audioService = AudioService();
                audioService.playWordPronunciation(word.cebuano);
              },
              child: Row(
                children: [
                  Icon(
                    Icons.volume_up,
                    color: const Color(0xFFFFD700),
                    size: size.height * 0.025,
                  ),
                  SizedBox(width: size.width * 0.02),
                  Text(
                    'Listen',
                    style: TextStyle(
                      color: const Color(0xFFFFD700),
                      fontSize: size.height * 0.02,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGrammarTab(BuildContext context, Size size) {
    final grammarPoints = _getGrammarForLesson(widget.lessonNumber);

    return Container(
      padding: EdgeInsets.all(size.width * 0.04),
      child: ListView.builder(
        itemCount: grammarPoints.length,
        itemBuilder: (context, index) {
          final point = grammarPoints[index];
          return _buildGrammarCard(context, size, point);
        },
      ),
    );
  }

  Widget _buildGrammarCard(
    BuildContext context,
    Size size,
    Map<String, dynamic> point,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: size.height * 0.02),
      padding: EdgeInsets.all(size.width * 0.03),
      decoration: BoxDecoration(
        color: const Color(0x33FFFFFF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.02,
                  vertical: size.height * 0.01,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFD700),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  point['title'] as String,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: size.height * 0.022,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: size.height * 0.02),

          Text(
            point['explanation'] as String,
            style: TextStyle(
              color: Colors.white,
              fontSize: size.height * 0.025,
              height: 1.5,
            ),
          ),

          if (point['examples'] != null) ...[
            SizedBox(height: size.height * 0.02),
            Container(
              padding: EdgeInsets.all(size.width * 0.02),
              decoration: BoxDecoration(
                color: const Color(0x1A1A3A5C),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Examples:',
                    style: TextStyle(
                      color: const Color(0xFFFFD700),
                      fontSize: size.height * 0.02,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: size.height * 0.01),
                  ...(point['examples'] as List<String>).map(
                    (example) => Padding(
                      padding: EdgeInsets.only(bottom: size.height * 0.01),
                      child: Text(
                        example,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: size.height * 0.022,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPracticeTab(BuildContext context, Size size) {
    final questions = QuizData.getQuizForLevel(widget.lessonNumber);

    return Container(
      padding: EdgeInsets.all(size.width * 0.04),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildPracticeButton(
                  context,
                  size,
                  'Quick Quiz',
                  Icons.quiz,
                  () => _startQuiz(context, questions),
                ),
              ),
              SizedBox(width: size.width * 0.03),
              Expanded(
                child: _buildPracticeButton(
                  context,
                  size,
                  'Flashcards',
                  Icons.style,
                  () => _startFlashcards(context, questions),
                ),
              ),
            ],
          ),
          SizedBox(height: size.height * 0.03),

          _buildPracticeButton(
            context,
            size,
            'Word Jumble',
            Icons.shuffle,
            () => _startWordJumble(context, questions),
          ),
          SizedBox(height: size.height * 0.02),

          _buildPracticeButton(
            context,
            size,
            'Fill in the Blank',
            Icons.edit,
            () => _startFillBlank(context, questions),
          ),
        ],
      ),
    );
  }

  Widget _buildPracticeButton(
    BuildContext context,
    Size size,
    String label,
    IconData icon,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.04,
          vertical: size.height * 0.025,
        ),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFFD700).withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: size.height * 0.03),
            SizedBox(width: size.width * 0.02),
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: size.height * 0.025,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _startQuiz(BuildContext context, List<QuizQuestion> questions) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuizScreen(
          npcName: 'Lesson ${widget.lessonNumber}',
          npcGreeting: 'Test your knowledge!',
          questions: questions,
        ),
      ),
    );
  }

  void _startFlashcards(BuildContext context, List<QuizQuestion> questions) {
    final flashcardQuestions = questions
        .where((q) => q.type == QuizType.flashcard)
        .toList();

    if (flashcardQuestions.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => QuizScreen(
            npcName: 'Lesson ${widget.lessonNumber}',
            npcGreeting: 'Flashcards Practice',
            questions: flashcardQuestions,
          ),
        ),
      );
    }
  }

  void _startWordJumble(BuildContext context, List<QuizQuestion> questions) {
    final jumbleQuestions = questions
        .where((q) => q.type == QuizType.wordJumble)
        .toList();

    if (jumbleQuestions.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => QuizScreen(
            npcName: 'Lesson ${widget.lessonNumber}',
            npcGreeting: 'Word Jumble Practice',
            questions: jumbleQuestions,
          ),
        ),
      );
    }
  }

  void _startFillBlank(BuildContext context, List<QuizQuestion> questions) {
    final fillQuestions = questions
        .where((q) => q.type == QuizType.fillBlank)
        .toList();

    if (fillQuestions.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => QuizScreen(
            npcName: 'Lesson ${widget.lessonNumber}',
            npcGreeting: 'Fill in the Blank Practice',
            questions: fillQuestions,
          ),
        ),
      );
    }
  }

  List<dynamic> _getVocabularyForLesson(int lessonNumber) {
    switch (lessonNumber) {
      case 1:
        return CebuanoWordsDatabase.words
            .where((w) => w.category == WordCategory.greetings)
            .take(10)
            .toList();
      case 2:
        return CebuanoWordsDatabase.words
            .where((w) => w.category == WordCategory.numbers)
            .take(10)
            .toList();
      case 3:
        return CebuanoWordsDatabase.words
            .where((w) => w.category == WordCategory.colors)
            .take(8)
            .toList();
      case 4:
        return CebuanoWordsDatabase.words
            .where((w) => w.category == WordCategory.animals)
            .take(8)
            .toList();
      case 5:
        return CebuanoWordsDatabase.words
            .where((w) => w.category == WordCategory.food)
            .take(8)
            .toList();
      case 6:
        return CebuanoWordsDatabase.words
            .where((w) => w.category == WordCategory.family)
            .take(9)
            .toList();
      case 7:
        return CebuanoWordsDatabase.words
            .where((w) => w.category == WordCategory.time)
            .take(12)
            .toList();
      case 8:
        return CebuanoWordsDatabase.words
            .where((w) => w.category == WordCategory.weather)
            .take(8)
            .toList();
      case 9:
        return CebuanoWordsDatabase.words
            .where((w) => w.category == WordCategory.emotions)
            .take(9)
            .toList();
      case 10:
        return CebuanoWordsDatabase.words
            .where((w) => w.category == WordCategory.actions)
            .take(10)
            .toList();
      case 11:
        return CebuanoWordsDatabase.words
            .where((w) => w.category == WordCategory.places)
            .take(6)
            .toList();
      case 12:
        return CebuanoWordsDatabase.words
            .where((w) => w.category == WordCategory.objects)
            .take(8)
            .toList();
      case 16:
        return CebuanoWordsDatabase.words
            .where((w) => w.id.startsWith('hon'))
            .take(8)
            .toList();
      case 17:
        return CebuanoWordsDatabase.words
            .where((w) => w.id.startsWith('mark'))
            .take(10)
            .toList();
      case 18:
        return CebuanoWordsDatabase.words
            .where((w) => w.id.startsWith('int'))
            .take(8)
            .toList();
      case 19:
        return CebuanoWordsDatabase.words
            .where((w) => w.id.startsWith('ex') || w.id.startsWith('neg'))
            .take(6)
            .toList();
      case 20:
        return CebuanoWordsDatabase.words
            .where((w) => w.id.startsWith('adj'))
            .take(12)
            .toList();
      case 21:
        return CebuanoWordsDatabase.words
            .where((w) => w.id.startsWith('act'))
            .take(10)
            .toList();
      case 22:
        return CebuanoWordsDatabase.words
            .where((w) => w.id.startsWith('body'))
            .take(6)
            .toList();
      case 23:
        return CebuanoWordsDatabase.words
            .where(
              (w) =>
                  w.id.startsWith('food') &&
                  w.id != 'food9' &&
                  w.id != 'food10',
            )
            .take(6)
            .toList();
      case 24:
        return CebuanoWordsDatabase.words
            .where((w) => w.category == WordCategory.places)
            .take(6)
            .toList();
      case 25:
        return CebuanoWordsDatabase.words
            .where((w) => w.category == WordCategory.weather)
            .take(8)
            .toList();
      case 26:
        return CebuanoWordsDatabase.words
            .where((w) => w.category == WordCategory.emotions)
            .take(9)
            .toList();
      default:
        return CebuanoWordsDatabase.words.take(10).toList();
    }
  }

  List<Map<String, dynamic>> _getGrammarForLesson(int lessonNumber) {
    switch (lessonNumber) {
      case 1:
        return [
          {
            'title': 'Common Greetings',
            'explanation':
                'Cebuano has specific greetings for different times of day. These are often used with response particles like "sab" (just), "sad" (also), and "pod" (can).',
            'examples': [
              'Kumusta ka? - How are you?',
              'Maayong buntag - Good morning',
              'Maayong hapon - Good afternoon',
              'Maayong gabii - Good evening',
              'Salamat - Thank you',
              'Palihug - Please',
            ],
          },
          {
            'title': 'Honorifics & Endearments',
            'explanation':
                'Use respectful terms when addressing older people. Endearing terms are used for children or close relationships.',
            'examples': [
              'Manong - Older brother (respectful)',
              'Manang - Older sister (respectful)',
              'Nong - Mister / Brother (short)',
              'Nang - Miss / Sister (short)',
              'Toto - Little boy (endearing)',
              'Inday - Young lady (endearing)',
            ],
          },
        ];
      case 2:
        return [
          {
            'title': 'Basic Numbers (1-10)',
            'explanation':
                'Learn the basic counting numbers in Cebuano. These are essential for everyday conversations.',
            'examples': [
              'Usa - One',
              'Duha - Two',
              'Tulo - Three',
              'Upat - Four',
              'Lima - Five',
              'Unom - Six',
              'Pito - Seven',
              'Walo - Eight',
              'Siyam - Nine',
              'Napulo - Ten',
            ],
          },
        ];
      case 3:
        return [
          {
            'title': 'Basic Colors',
            'explanation':
                'Colors are commonly used in descriptions. Note that some colors like "Dalandan" (green) come from specific fruits.',
            'examples': [
              'Pula - Red',
              'Bughaw - White',
              'Itom - Black',
              'Asul - Blue',
              'Dalandan - Green',
              'Dulaw - Yellow',
              'Orange - Orange',
            ],
          },
        ];
      case 17:
        return [
          {
            'title': 'Nominative Marker "Ang"',
            'explanation':
                '"Ang" is used to mark the subject of a sentence. It\'s equivalent to "The" in English.',
            'examples': [
              'Ang bata - The child',
              'Ang balay - The house',
              'Ang libro - The book',
            ],
          },
          {
            'title': 'Personal Marker "Si"',
            'explanation':
                '"Si" is used before personal names. It\'s similar to using a name directly in English.',
            'examples': [
              'Si Juan - Juan',
              'Si Maria - Maria',
              'Si Pedro - Pedro',
            ],
          },
          {
            'title': 'Demonstratives',
            'explanation':
                'Cebuano has different demonstratives based on distance from the speaker.',
            'examples': [
              'Kini - This (near)',
              'Kana - That (far)',
              'Kanaa - That over there (very far)',
              'Kiniy - These (near plural)',
              'Kanay - Those (far plural)',
            ],
          },
        ];
      case 18:
        return [
          {
            'title': 'Question Words',
            'explanation':
                'Cebuano uses specific question words for different types of questions.',
            'examples': [
              'Unsa - What?',
              'Kinsa - Who?',
              'Asa - Where?',
              'Kanus-a - When?',
              'Ngano - Why?',
              'Pila - How many?',
              'Tagpila - How much?',
            ],
          },
        ];
      case 19:
        return [
          {
            'title': 'Existential "May"',
            'explanation':
                '"May" indicates existence - "There is" or "There are". It\'s used for positive statements.',
            'examples': [
              'May libro - There is a book',
              'May mga tawo - There are people',
              'May kwarta - There is money',
            ],
          },
          {
            'title': 'Negative Existential "Wala"',
            'explanation':
                '"Wala" indicates non-existence - "There is no" or "There are no".',
            'examples': [
              'Wala libro - There is no book',
              'Wala kwarta - There is no money',
              'Wala problema - There is no problem',
            ],
          },
          {
            'title': 'Negative "Dili"',
            'explanation':
                '"Dili" is used for general negation - "No" or "Not".',
            'examples': [
              'Dili ko moadto - I will not go',
              'Dili ko ganahan - I don\'t want to',
              'Dili to - Not that',
            ],
          },
        ];
      default:
        return [
          {
            'title': 'Lesson Overview',
            'explanation':
                'Practice the vocabulary and grammar concepts from this lesson to improve your Cebuano skills.',
            'examples': [
              'Review all words regularly',
              'Practice with quizzes',
              'Use words in sentences',
            ],
          },
        ];
    }
  }
}
