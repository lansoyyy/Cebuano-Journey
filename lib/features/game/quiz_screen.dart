import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/cebuano_words.dart';
import '../../core/models/quiz_question.dart';
import '../../core/providers/player_provider.dart';

// ── EXP-based quiz system constants ─────────────────────────────────────────
const int _kStartExp = 100;
const int _kExpPerWrong = 10;   // EXP deducted per wrong answer per round
const int _kMaxRetryRounds = 3;
const int _kPassThreshold = 70;

enum _Phase { answering, retryIntro, result }

class QuizResult {
  final int correct;
  final int total;
  final int finalExp;
  bool get passed => finalExp >= _kPassThreshold;
  int get xpEarned => finalExp;

  const QuizResult({
    required this.correct,
    required this.total,
    required this.finalExp,
  });
}

class QuizScreen extends ConsumerStatefulWidget {
  final String npcName;
  final String npcGreeting;
  final List<QuizQuestion> questions;

  const QuizScreen({
    super.key,
    required this.npcName,
    required this.npcGreeting,
    required this.questions,
  });

  @override
  ConsumerState<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends ConsumerState<QuizScreen> {
  // \u2500\u2500\u2500 EXP / round state \u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500
  int _exp = _kStartExp;
  int _retryRound = 0;                   // 0 = initial, 1\u20133 = retry rounds
  late List<QuizQuestion> _roundQuestions; // current round\u2019s questions
  List<QuizQuestion> _wrongQuestions = []; // questions answered wrong this round
  int _totalCorrect = 0;                 // first-time correct count (for display)
  _Phase _phase = _Phase.answering;

  // \u2500\u2500\u2500 Per-question state \u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500
  int _index = 0;
  bool _answered = false;
  String? _selected;
  bool _revealed = false;
  bool _showExampleClue = false;

  // Fill blank
  final _fillCtrl = TextEditingController();

  // Word jumble
  List<String> _jumbleSelected = [];
  List<String> _jumblePool = [];

  // Timer
  int _timeLeft = 30;
  Timer? _timer;

  QuizQuestion get _q => _roundQuestions[_index];

  @override
  void initState() {
    super.initState();
    // Initialise directly (no setState during initState)
    _roundQuestions = widget.questions.toList()..shuffle(Random());
    _initQuestion();
  }

  // Restart: reshuffle all questions and reset every state field
  void _startSession() {
    _timer?.cancel();
    final shuffled = widget.questions.toList()..shuffle(Random());
    setState(() {
      _exp = _kStartExp;
      _retryRound = 0;
      _roundQuestions = shuffled;
      _wrongQuestions = [];
      _totalCorrect = 0;
      _phase = _Phase.answering;
      _index = 0;
      _answered = false;
      _selected = null;
      _revealed = false;
      _showExampleClue = false;
    });
    _fillCtrl.clear();
    _jumbleSelected = [];
    _jumblePool =
        shuffled.isNotEmpty && shuffled[0].type == QuizType.wordJumble
            ? [...shuffled[0].options]
            : [];
    _startTimer();
  }

  void _initQuestion() {
    _answered = false;
    _selected = null;
    _revealed = false;
    _showExampleClue = false;
    _fillCtrl.clear();
    _jumbleSelected = [];
    if (_q.type == QuizType.wordJumble) {
      _jumblePool = [..._q.options];
    }
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timeLeft = 30;
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) { t.cancel(); return; }
      setState(() {
        _timeLeft--;
        if (_timeLeft <= 0) {
          t.cancel();
          if (!_answered) _submitAnswer('__timeout__');
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _fillCtrl.dispose();
    super.dispose();
  }

  void _submitAnswer(String answer) {
    if (_answered) return;
    _timer?.cancel();
    final isCorrect = answer.trim().toLowerCase() ==
        _q.correctAnswer.trim().toLowerCase();
    if (isCorrect) {
      if (_retryRound == 0) _totalCorrect++;
    } else {
      // Deduct EXP and record for potential retry round
      _exp = (_exp - _kExpPerWrong).clamp(0, _kStartExp);
      _wrongQuestions.add(_q);
      ref.read(playerProvider.notifier).loseHeart();
    }
    setState(() {
      _answered = true;
      _selected = answer;
    });
  }

  void _next() {
    if (_index + 1 < _roundQuestions.length) {
      setState(() => _index++);
      _initQuestion();
    } else {
      _advanceRound();
    }
  }

  // Called when current round finishes — decide what happens next
  void _advanceRound() {
    _timer?.cancel();
    if (_wrongQuestions.isNotEmpty && _retryRound < _kMaxRetryRounds) {
      setState(() => _phase = _Phase.retryIntro);
    } else {
      setState(() => _phase = _Phase.result);
    }
  }

  // Start the next retry round using only wrong questions
  void _startRetryRound() {
    final nextQuestions = List<QuizQuestion>.from(_wrongQuestions);
    setState(() {
      _retryRound++;
      _roundQuestions = nextQuestions;
      _wrongQuestions = [];
      _index = 0;
      _phase = _Phase.answering;
    });
    _initQuestion();
  }

  // Finish the quiz: optionally award XP and return result to GameScreen
  void _finish(bool proceed) {
    if (proceed) {
      ref.read(playerProvider.notifier).addXp(_exp);
    }
    Navigator.pop(
      context,
      QuizResult(
        correct: _totalCorrect,
        total: widget.questions.length,
        finalExp: _exp,
      ),
    );
  }

  // Restart from scratch with reshuffled questions
  void _restart() => _startSession();

  void _useHint() {
    final player = ref.read(playerProvider);
    if (player.hintCount <= 0) return;
    ref.read(playerProvider.notifier).useHint();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Hint: ${_q.hint}'),
      backgroundColor: const Color(0xFF2A4A2A),
      duration: const Duration(seconds: 4),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    switch (_phase) {
      case _Phase.retryIntro:
        return _buildRetryIntroScreen(size);
      case _Phase.result:
        return _buildResultScreen(size);
      case _Phase.answering:
        return _buildQuizScreen(size);
    }
  }

  // \u2500\u2500 Main quiz answering screen \u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500
  Widget _buildQuizScreen(Size size) {
    final player = ref.watch(playerProvider);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0D1B3E), Color(0xFF1A2F5A)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // \u2500\u2500 Header \u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500
              Padding(
                padding: EdgeInsets.all(size.width * 0.02),
                child: Row(
                  children: [
                    // NPC name + retry badge
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.npcName,
                            style: TextStyle(
                              color: const Color(0xFFFFD700),
                              fontSize: size.height * 0.04,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (_retryRound > 0)
                            Text(
                              'Retry Round $_retryRound\u00a0/\u00a0$_kMaxRetryRounds',
                              style: TextStyle(
                                color: Colors.orangeAccent,
                                fontSize: size.height * 0.022,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                        ],
                      ),
                    ),
                    // EXP live indicator
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: _exp >= _kPassThreshold
                            ? const Color(0xFF1A4A1A)
                            : const Color(0xFF4A2A00),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: _exp >= _kPassThreshold
                              ? Colors.greenAccent
                              : Colors.orangeAccent,
                        ),
                      ),
                      child: Text(
                        '$_exp EXP',
                        style: TextStyle(
                          color: _exp >= _kPassThreshold
                              ? Colors.greenAccent
                              : Colors.orangeAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: size.height * 0.028,
                        ),
                      ),
                    ),
                    SizedBox(width: size.width * 0.02),
                    // Progress
                    Text(
                      '${_index + 1}/${_roundQuestions.length}',
                      style: TextStyle(
                          color: Colors.white70,
                          fontSize: size.height * 0.03),
                    ),
                    SizedBox(width: size.width * 0.02),
                    // Timer
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: _timeLeft <= 5
                            ? Colors.red.shade900
                            : const Color(0xFF1A3A5C),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${_timeLeft}s',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: size.height * 0.032,
                        ),
                      ),
                    ),
                    SizedBox(width: size.width * 0.01),
                    // Hint button
                    if (player.hintCount > 0)
                      IconButton(
                        onPressed: _answered ? null : _useHint,
                        icon: Icon(Icons.lightbulb,
                            color: const Color(0xFFFFD700),
                            size: size.height * 0.04),
                      ),
                  ],
                ),
              ),

              // \u2500\u2500 NPC greeting (first question only) \u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500
              if (_index == 0)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0x331A3A5C),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: Text(
                      widget.npcGreeting,
                      style: TextStyle(
                          color: Colors.white70,
                          fontSize: size.height * 0.028),
                    ),
                  ),
                ),

              const Spacer(),

              // ── Question card ────────────────────────────────────────────
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
                child: _buildQuestion(size),
              ),

              const Spacer(),

              // ── Feedback / Next ──────────────────────────────────────────
              if (_answered) _buildFeedback(size),

              SizedBox(height: size.height * 0.02),
            ],
          ),
        ),
      ),
    );
  }

  CebuanoWord? _findClueWord() {
    final normalizedCebuano = _q.cebuano.trim().toLowerCase();
    for (final word in CebuanoWordsDatabase.words) {
      if (word.cebuano.trim().toLowerCase() == normalizedCebuano) {
        return word;
      }
    }

    final normalizedEnglish = _q.english.trim().toLowerCase();
    for (final word in CebuanoWordsDatabase.words) {
      final english = word.english.trim().toLowerCase();
      if (english == normalizedEnglish || english.contains(normalizedEnglish)) {
        return word;
      }
    }
    return null;
  }

  String? _clueTargetText() {
    switch (_q.type) {
      case QuizType.multipleChoice:
      case QuizType.flashcard:
        return _q.cebuano;
      case QuizType.fillBlank:
      case QuizType.wordJumble:
        return _q.english;
    }
  }

  Widget _buildExampleClue(Size size) {
    final clueWord = _findClueWord();
    final clueTarget = _clueTargetText();
    final exampleSentence = clueWord?.exampleSentence;
    final exampleTranslation = clueWord?.exampleTranslation;
    if (clueTarget == null || exampleSentence == null || exampleSentence.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 220),
          child: _showExampleClue
              ? Container(
                  key: const ValueKey('example-clue-open'),
                  width: double.infinity,
                  margin: EdgeInsets.only(bottom: size.height * 0.018),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0x221A6B1A),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.greenAccent.withOpacity(0.55)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Example sentence',
                        style: TextStyle(
                          color: Colors.greenAccent,
                          fontSize: size.height * 0.022,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        exampleSentence,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: size.height * 0.029,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (exampleTranslation != null && exampleTranslation.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          exampleTranslation,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: size.height * 0.022,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ],
                  ),
                )
              : const SizedBox(key: ValueKey('example-clue-closed')),
        ),
        GestureDetector(
          onTap: () => setState(() => _showExampleClue = !_showExampleClue),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0x221A3A5C),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: const Color(0xFF3A6EA5)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  clueTarget,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color(0xFFFFD700),
                    fontSize: size.height * 0.03,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _showExampleClue ? 'Tap to hide example sentence' : 'Tap to show example sentence',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: size.height * 0.02,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuestion(Size size) {
    switch (_q.type) {
      case QuizType.multipleChoice:
        return _MCWidget(
          question: _q,
          clue: _buildExampleClue(size),
          answered: _answered,
          selected: _selected,
          onSelect: _submitAnswer,
          size: size,
        );
      case QuizType.fillBlank:
        return _FillWidget(
          question: _q,
          clue: _buildExampleClue(size),
          ctrl: _fillCtrl,
          answered: _answered,
          selected: _selected,
          onSubmit: _submitAnswer,
          size: size,
        );
      case QuizType.wordJumble:
        return _JumbleWidget(
          question: _q,
          clue: _buildExampleClue(size),
          selected: _jumbleSelected,
          pool: _jumblePool,
          answered: _answered,
          onTapPool: (i) {
            if (_answered) return;
            setState(() {
              _jumbleSelected.add(_jumblePool[i]);
              _jumblePool.removeAt(i);
            });
          },
          onTapSelected: (i) {
            if (_answered) return;
            setState(() {
              _jumblePool.add(_jumbleSelected[i]);
              _jumbleSelected.removeAt(i);
            });
          },
          onSubmit: () => _submitAnswer(_jumbleSelected.join('')),
          size: size,
        );
      case QuizType.flashcard:
        return _FlashWidget(
          question: _q,
          revealed: _revealed,
          onReveal: () => setState(() => _revealed = true),
          onKnew: () => _submitAnswer(_q.correctAnswer),
          onDidnt: () => _submitAnswer('__wrong__'),
          size: size,
        );
    }
  }

  Widget _buildFeedback(Size size) {
    final isCorrect = _selected?.trim().toLowerCase() ==
        _q.correctAnswer.trim().toLowerCase();
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: size.width * 0.04),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isCorrect
                ? const Color(0xFF1A4A1A)
                : const Color(0xFF4A1A1A),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
                color: isCorrect ? Colors.green : Colors.red, width: 2),
          ),
          child: Column(
            children: [
              Text(
                isCorrect ? '✓  Sakto! (Correct!)' : '✗  Mali! (Wrong!)',
                style: TextStyle(
                  color: isCorrect ? Colors.greenAccent : Colors.redAccent,
                  fontSize: size.height * 0.035,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (!isCorrect) ...[
                const SizedBox(height: 4),
                Text(
                  'Answer: ${_q.correctAnswer}',
                  style: TextStyle(
                      color: Colors.white70, fontSize: size.height * 0.028),
                ),
                const SizedBox(height: 4),
                Text(
                  'Tip: ${_q.hint}',
                  style: TextStyle(
                      color: Colors.amber, fontSize: size.height * 0.025),
                ),
              ],
            ],
          ),
        ),
        SizedBox(height: size.height * 0.02),
        ElevatedButton(
          onPressed: _next,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFFD700),
            foregroundColor: Colors.black,
            padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.06, vertical: size.height * 0.02),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)),
          ),
          child: Text(
            _index + 1 >= _roundQuestions.length ? 'Finish Round' : 'Next  →',
            style: TextStyle(
                fontSize: size.height * 0.032, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  // \u2500\u2500 LOOP ACTIVATED screen \u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500
  Widget _buildRetryIntroScreen(Size size) {
    final wrongCount = _wrongQuestions.length;
    final nextRound = _retryRound + 1;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1A0A00), Color(0xFF3A1A00)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(size.width * 0.06),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.loop,
                      color: Colors.orangeAccent,
                      size: size.height * 0.10),
                  SizedBox(height: size.height * 0.03),
                  Text(
                    'LOOP ACTIVATED!',
                    style: TextStyle(
                      color: Colors.orangeAccent,
                      fontSize: size.height * 0.055,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                  SizedBox(height: size.height * 0.02),
                  Text(
                    'You had $wrongCount incorrect answer${wrongCount == 1 ? '' : 's'}.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white, fontSize: size.height * 0.035),
                  ),
                  SizedBox(height: size.height * 0.01),
                  Text(
                    'Retry Round $nextRound\u00a0/\u00a0$_kMaxRetryRounds',
                    style: TextStyle(
                        color: Colors.white70, fontSize: size.height * 0.030),
                  ),
                  SizedBox(height: size.height * 0.02),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Current EXP\u00a0\u00a0$_exp / $_kStartExp',
                          style: TextStyle(
                            color: _exp >= _kPassThreshold
                                ? Colors.greenAccent
                                : Colors.orangeAccent,
                            fontSize: size.height * 0.032,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: size.height * 0.008),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: LinearProgressIndicator(
                            value: _exp / _kStartExp,
                            minHeight: 10,
                            backgroundColor: Colors.black38,
                            valueColor: AlwaysStoppedAnimation(
                              _exp >= _kPassThreshold
                                  ? Colors.greenAccent
                                  : Colors.orangeAccent,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: size.height * 0.015),
                  Text(
                    'Each wrong answer costs \u2013$_kExpPerWrong EXP.\n'
                    'You need $_kPassThreshold EXP to pass.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white54,
                        fontSize: size.height * 0.026),
                  ),
                  SizedBox(height: size.height * 0.05),
                  ElevatedButton(
                    onPressed: _startRetryRound,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF6B00),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: size.width * 0.10,
                        vertical: size.height * 0.022,
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(
                      'Try Again',
                      style: TextStyle(
                        fontSize: size.height * 0.038,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // \u2500\u2500 Final result screen \u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500
  Widget _buildResultScreen(Size size) {
    final passed = _exp >= _kPassThreshold;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: passed
                ? [const Color(0xFF0A2A0A), const Color(0xFF1A4A1A)]
                : [const Color(0xFF2A0A0A), const Color(0xFF4A1A1A)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(size.width * 0.06),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    passed
                        ? Icons.emoji_events
                        : Icons.sentiment_dissatisfied,
                    color: passed
                        ? const Color(0xFFFFD700)
                        : Colors.redAccent,
                    size: size.height * 0.10,
                  ),
                  SizedBox(height: size.height * 0.025),
                  Text(
                    passed ? 'PASSED!' : 'FAILED',
                    style: TextStyle(
                      color: passed
                          ? const Color(0xFFFFD700)
                          : Colors.redAccent,
                      fontSize: size.height * 0.065,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 3,
                    ),
                  ),
                  SizedBox(height: size.height * 0.03),
                  // EXP result card
                  Container(
                    width: size.width * 0.72,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: passed ? Colors.greenAccent : Colors.redAccent,
                        width: 2,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Final EXP',
                          style: TextStyle(
                              color: Colors.white70,
                              fontSize: size.height * 0.028),
                        ),
                        SizedBox(height: size.height * 0.01),
                        Text(
                          '$_exp / $_kStartExp',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: size.height * 0.07,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: size.height * 0.015),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: _exp / _kStartExp,
                            minHeight: 16,
                            backgroundColor: Colors.black38,
                            valueColor: AlwaysStoppedAnimation(
                              passed ? Colors.greenAccent : Colors.redAccent,
                            ),
                          ),
                        ),
                        SizedBox(height: size.height * 0.01),
                        Text(
                          passed
                              ? 'Required: $_kPassThreshold EXP  \u2713'
                              : 'Required: $_kPassThreshold EXP  '
                                  '(Need ${_kPassThreshold - _exp} more)',
                          style: TextStyle(
                            color: passed
                                ? Colors.greenAccent
                                : Colors.orangeAccent,
                            fontSize: size.height * 0.025,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: size.height * 0.04),
                  if (passed) ...[
                    ElevatedButton(
                      onPressed: () => _finish(true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFD700),
                        foregroundColor: Colors.black,
                        padding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.10,
                          vertical: size.height * 0.022,
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(
                        'Proceed  \u2192',
                        style: TextStyle(
                          fontSize: size.height * 0.038,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ] else ...[
                    Text(
                      'You did not reach the required EXP.\nChoose an option:',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white70,
                          fontSize: size.height * 0.028),
                    ),
                    SizedBox(height: size.height * 0.03),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: _restart,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF3A6EA5),
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                              horizontal: size.width * 0.06,
                              vertical: size.height * 0.02,
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          child: Text(
                            '\u21ba  Restart',
                            style: TextStyle(
                              fontSize: size.height * 0.032,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(width: size.width * 0.04),
                        ElevatedButton(
                          onPressed: () => _finish(false),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4A1A1A),
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                              horizontal: size.width * 0.06,
                              vertical: size.height * 0.02,
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          child: Text(
                            'End',
                            style: TextStyle(
                              fontSize: size.height * 0.032,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Multiple Choice ────────────────────────────────────────────────────────────
class _MCWidget extends StatelessWidget {
  final QuizQuestion question;
  final Widget clue;
  final bool answered;
  final String? selected;
  final void Function(String) onSelect;
  final Size size;

  const _MCWidget({
    required this.question,
    required this.clue,
    required this.answered,
    required this.selected,
    required this.onSelect,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        clue,
        SizedBox(height: size.height * 0.02),
        Text(
          question.prompt,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.white,
              fontSize: size.height * 0.038,
              fontWeight: FontWeight.bold),
        ),
        SizedBox(height: size.height * 0.03),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          alignment: WrapAlignment.center,
          children: question.options.map((opt) {
            Color bg = const Color(0xFF1A3A5C);
            Color border = Colors.white24;
            if (answered) {
              if (opt == question.correctAnswer) {
                bg = const Color(0xFF1A4A1A);
                border = Colors.green;
              } else if (opt == selected) {
                bg = const Color(0xFF4A1A1A);
                border = Colors.red;
              }
            }
            return GestureDetector(
              onTap: answered ? null : () => onSelect(opt),
              child: Container(
                width: size.width * 0.3,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: bg,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: border, width: 2),
                ),
                child: Text(
                  opt,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white, fontSize: size.height * 0.030),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

// ── Fill in the Blank ─────────────────────────────────────────────────────────
class _FillWidget extends StatelessWidget {
  final QuizQuestion question;
  final Widget clue;
  final TextEditingController ctrl;
  final bool answered;
  final String? selected;
  final void Function(String) onSubmit;
  final Size size;

  const _FillWidget({
    required this.question,
    required this.clue,
    required this.ctrl,
    required this.answered,
    required this.selected,
    required this.onSubmit,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        clue,
        SizedBox(height: size.height * 0.02),
        Text(
          question.prompt,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.white,
              fontSize: size.height * 0.038,
              fontWeight: FontWeight.bold),
        ),
        SizedBox(height: size.height * 0.04),
        TextField(
          controller: ctrl,
          enabled: !answered,
          autofocus: true,
          style: TextStyle(color: Colors.white, fontSize: size.height * 0.04),
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF0D1B3E),
            hintText: 'Type here...',
            hintStyle: const TextStyle(color: Colors.white38),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFF3A6EA5)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFF3A6EA5)),
            ),
          ),
          onSubmitted: answered ? null : onSubmit,
        ),
        if (!answered) ...[
          SizedBox(height: size.height * 0.02),
          ElevatedButton(
            onPressed: () => onSubmit(ctrl.text),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3A6EA5),
              foregroundColor: Colors.white,
            ),
            child: const Text('Submit'),
          ),
        ],
      ],
    );
  }
}

// ── Word Jumble ───────────────────────────────────────────────────────────────
class _JumbleWidget extends StatelessWidget {
  final QuizQuestion question;
  final Widget clue;
  final List<String> selected;
  final List<String> pool;
  final bool answered;
  final void Function(int) onTapPool;
  final void Function(int) onTapSelected;
  final VoidCallback onSubmit;
  final Size size;

  const _JumbleWidget({
    required this.question,
    required this.clue,
    required this.selected,
    required this.pool,
    required this.answered,
    required this.onTapPool,
    required this.onTapSelected,
    required this.onSubmit,
    required this.size,
  });

  Widget _letterTile(String ch, VoidCallback onTap, Color color) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(3),
        width: 38,
        height: 42,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Colors.white24),
        ),
        child: Center(
          child: Text(ch,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        clue,
        SizedBox(height: size.height * 0.02),
        Text(
          question.prompt,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.white,
              fontSize: size.height * 0.034,
              fontWeight: FontWeight.bold),
        ),
        SizedBox(height: size.height * 0.025),
        // Selected row
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF0D1B3E),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFF3A6EA5)),
          ),
          child: Wrap(
            alignment: WrapAlignment.center,
            children: [
              for (int i = 0; i < selected.length; i++)
                _letterTile(selected[i], () => onTapSelected(i),
                    const Color(0xFF2A5A8A)),
              if (selected.isEmpty)
                const Text('Tap letters below...',
                    style: TextStyle(color: Colors.white38)),
            ],
          ),
        ),
        SizedBox(height: size.height * 0.02),
        // Pool row
        Wrap(
          alignment: WrapAlignment.center,
          children: [
            for (int i = 0; i < pool.length; i++)
              _letterTile(
                  pool[i], () => onTapPool(i), const Color(0xFF1A3A5C)),
          ],
        ),
        SizedBox(height: size.height * 0.02),
        if (!answered)
          ElevatedButton(
            onPressed: selected.isEmpty ? null : onSubmit,
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3A6EA5)),
            child: const Text('Submit', style: TextStyle(color: Colors.white)),
          ),
      ],
    );
  }
}

// ── Flashcard ─────────────────────────────────────────────────────────────────
class _FlashWidget extends StatelessWidget {
  final QuizQuestion question;
  final bool revealed;
  final VoidCallback onReveal;
  final VoidCallback onKnew;
  final VoidCallback onDidnt;
  final Size size;

  const _FlashWidget({
    required this.question,
    required this.revealed,
    required this.onReveal,
    required this.onKnew,
    required this.onDidnt,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Flashcard',
          style: TextStyle(color: Colors.white54, fontSize: size.height * 0.028),
        ),
        SizedBox(height: size.height * 0.02),
        GestureDetector(
          onTap: revealed ? null : onReveal,
          child: Container(
            width: size.width * 0.5,
            height: size.height * 0.28,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF1A3A5C), Color(0xFF0D1B3E)],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                  color: revealed
                      ? const Color(0xFFFFD700)
                      : Colors.white38,
                  width: 2),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    question.cebuano,
                    style: TextStyle(
                      color: const Color(0xFFFFD700),
                      fontSize: size.height * 0.055,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (revealed) ...[
                    const SizedBox(height: 12),
                    Text(
                      question.english,
                      style: TextStyle(
                          color: Colors.white, fontSize: size.height * 0.038),
                    ),
                    Text(
                      question.hint,
                      style: TextStyle(
                          color: Colors.white54,
                          fontSize: size.height * 0.025),
                    ),
                  ] else
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Text(
                        'Tap to reveal',
                        style: TextStyle(
                            color: Colors.white38,
                            fontSize: size.height * 0.025),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        if (revealed) ...[
          SizedBox(height: size.height * 0.03),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: onDidnt,
                icon: const Icon(Icons.close, color: Colors.white),
                label: const Text("Didn't know",
                    style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8B1A1A)),
              ),
              const SizedBox(width: 20),
              ElevatedButton.icon(
                onPressed: onKnew,
                icon: const Icon(Icons.check, color: Colors.white),
                label: const Text('I knew it!',
                    style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A6B1A)),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
