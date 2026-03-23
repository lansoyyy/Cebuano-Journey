import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/cebuano_words.dart';
import '../../core/models/quiz_question.dart';
import '../../core/providers/player_provider.dart';

class QuizResult {
  final int correct;
  final int total;
  bool get passed => correct >= (total / 2).ceil();
  int get xpEarned => correct * 30;

  const QuizResult({required this.correct, required this.total});
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
  int _index = 0;
  int _correct = 0;
  bool _answered = false;
  String? _selected;
  bool _wasCorrect = false;
  bool _revealed = false; // for flashcard
  bool _showExampleClue = false;

  // Fill blank
  final _fillCtrl = TextEditingController();

  // Word jumble
  List<String> _jumbleSelected = [];
  List<String> _jumblePool = [];

  // Word match
  final Map<int, String> _matchSelections = {};
  List<String> _matchPool = [];

  // Timer
  int _timeLeft = 30;
  Timer? _timer;

  QuizQuestion get _q => widget.questions[_index];

  @override
  void initState() {
    super.initState();
    _initQuestion();
  }

  void _initQuestion() {
    _answered = false;
    _selected = null;
    _wasCorrect = false;
    _revealed = false;
    _showExampleClue = false;
    _fillCtrl.clear();
    _jumbleSelected = [];
    _matchSelections.clear();
    if (_q.type == QuizType.wordJumble) {
      _jumblePool = [..._q.options];
    }
    if (_q.type == QuizType.wordMatch) {
      _matchPool = [..._q.matchTargets]..shuffle();
    }
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timeLeft = 30;
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
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
    final correct =
        answer.trim().toLowerCase() == _q.correctAnswer.trim().toLowerCase();
    _submitGradedAnswer(answer, correct);
  }

  void _submitGradedAnswer(String answer, bool correct) {
    if (_answered) return;
    _timer?.cancel();
    FocusScope.of(context).unfocus();
    if (correct) _correct++;
    setState(() {
      _answered = true;
      _selected = answer;
      _wasCorrect = correct;
    });
    if (!correct) {
      ref.read(playerProvider.notifier).loseHeart();
    }
  }

  void _next() {
    FocusScope.of(context).unfocus();
    if (_index + 1 >= widget.questions.length) {
      final result = QuizResult(
        correct: _correct,
        total: widget.questions.length,
      );
      if (result.passed) {
        ref.read(playerProvider.notifier).addXp(result.xpEarned);
      }
      Navigator.pop(context, result);
    } else {
      setState(() => _index++);
      _initQuestion();
    }
  }

  void _useHint() {
    final player = ref.read(playerProvider);
    if (player.hintCount <= 0) return;
    ref.read(playerProvider.notifier).useHint();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Hint: ${_q.hint}'),
        backgroundColor: const Color(0xFF2A4A2A),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final player = ref.watch(playerProvider);

    return Scaffold(
      resizeToAvoidBottomInset: true,
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
              // ── Header ──────────────────────────────────────────────────
              Padding(
                padding: EdgeInsets.all(size.width * 0.02),
                child: Row(
                  children: [
                    // NPC name
                    Expanded(
                      child: Text(
                        widget.npcName,
                        style: TextStyle(
                          color: const Color(0xFFFFD700),
                          fontSize: size.height * 0.04,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    // Progress
                    Text(
                      '${_index + 1}/${widget.questions.length}',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: size.height * 0.03,
                      ),
                    ),
                    SizedBox(width: size.width * 0.02),
                    // Timer
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
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
                        icon: Icon(
                          Icons.lightbulb,
                          color: const Color(0xFFFFD700),
                          size: size.height * 0.04,
                        ),
                      ),
                  ],
                ),
              ),

              // ── NPC greeting (first question only) ──────────────────────
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
                        fontSize: size.height * 0.028,
                      ),
                    ),
                  ),
                ),

              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      padding: EdgeInsets.fromLTRB(
                        size.width * 0.04,
                        size.height * 0.03,
                        size.width * 0.04,
                        size.height * 0.03,
                      ),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight - size.height * 0.02,
                        ),
                        child: Center(child: _buildQuestion(size)),
                      ),
                    );
                  },
                ),
              ),

              // ── Feedback / Next ──────────────────────────────────────────
              if (_answered)
                SafeArea(
                  top: false,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      size.width * 0.04,
                      size.height * 0.01,
                      size.width * 0.04,
                      size.height * 0.02,
                    ),
                    child: _buildFeedback(size),
                  ),
                )
              else
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
      case QuizType.conversation:
      case QuizType.wordMatch:
        return _q.english;
    }
  }

  Widget _buildExampleClue(Size size) {
    final clueWord = _findClueWord();
    final clueTarget = _clueTargetText();
    final exampleSentence = clueWord?.exampleSentence;
    final exampleTranslation = clueWord?.exampleTranslation;
    if (clueTarget == null ||
        exampleSentence == null ||
        exampleSentence.isEmpty) {
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
                    border: Border.all(
                      color: Colors.greenAccent.withOpacity(0.55),
                    ),
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
                      if (exampleTranslation != null &&
                          exampleTranslation.isNotEmpty) ...[
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
                  _showExampleClue
                      ? 'Tap to hide example sentence'
                      : 'Tap to show example sentence',
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
          onSubmit: () => _submitAnswer(
            _jumbleSelected.join(_q.useSpacesInJumble ? ' ' : ''),
          ),
          size: size,
        );
      case QuizType.flashcard:
        return _FlashWidget(
          question: _q,
          revealed: _revealed,
          onReveal: () => setState(() => _revealed = true),
          onKnew: () => _submitGradedAnswer(_q.correctAnswer, true),
          onDidnt: () => _submitGradedAnswer('__wrong__', false),
          size: size,
        );
      case QuizType.conversation:
        return _ConversationWidget(
          question: _q,
          clue: _buildExampleClue(size),
          answered: _answered,
          selected: _selected,
          onSelect: _submitAnswer,
          size: size,
        );
      case QuizType.wordMatch:
        return _WordMatchWidget(
          question: _q,
          clue: _buildExampleClue(size),
          answered: _answered,
          pool: _matchPool,
          selections: _matchSelections,
          onChanged: (index, value) {
            setState(() {
              if (value == null || value.isEmpty) {
                _matchSelections.remove(index);
              } else {
                _matchSelections[index] = value;
              }
            });
          },
          onSubmit: () {
            final summary = List.generate(
              _q.options.length,
              (i) => '${_q.options[i]} = ${_matchSelections[i] ?? '-'}',
            ).join('\n');
            final correct = List.generate(
              _q.options.length,
              (i) => _matchSelections[i] == _q.matchTargets[i],
            ).every((value) => value);
            _submitGradedAnswer(summary, correct);
          },
          size: size,
        );
    }
  }

  Widget _buildFeedback(Size size) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: size.width * 0.04),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: _wasCorrect
                ? const Color(0xFF1A4A1A)
                : const Color(0xFF4A1A1A),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: _wasCorrect ? Colors.green : Colors.red,
              width: 2,
            ),
          ),
          child: Column(
            children: [
              Text(
                _wasCorrect ? '✓  Sakto! (Correct!)' : '✗  Mali! (Wrong!)',
                style: TextStyle(
                  color: _wasCorrect ? Colors.greenAccent : Colors.redAccent,
                  fontSize: size.height * 0.035,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (!_wasCorrect) ...[
                const SizedBox(height: 4),
                Text(
                  'Answer: ${_q.correctAnswer}',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: size.height * 0.028,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Tip: ${_q.hint}',
                  style: TextStyle(
                    color: Colors.amber,
                    fontSize: size.height * 0.025,
                  ),
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
            minimumSize: Size(size.width * 0.45, size.height * 0.075),
            padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.08,
              vertical: size.height * 0.02,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Text(
            _index + 1 >= widget.questions.length ? 'Finish' : 'Next  →',
            style: TextStyle(
              fontSize: size.height * 0.032,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
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
            fontWeight: FontWeight.bold,
          ),
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
                    color: Colors.white,
                    fontSize: size.height * 0.030,
                  ),
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
            fontWeight: FontWeight.bold,
          ),
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
        constraints: const BoxConstraints(minWidth: 38, minHeight: 42),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Colors.white24),
        ),
        child: Center(
          child: Text(
            ch,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
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
            fontWeight: FontWeight.bold,
          ),
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
                _letterTile(
                  selected[i],
                  () => onTapSelected(i),
                  const Color(0xFF2A5A8A),
                ),
              if (selected.isEmpty)
                const Text(
                  'Tap letters below...',
                  style: TextStyle(color: Colors.white38),
                ),
            ],
          ),
        ),
        SizedBox(height: size.height * 0.02),
        // Pool row
        Wrap(
          alignment: WrapAlignment.center,
          children: [
            for (int i = 0; i < pool.length; i++)
              _letterTile(pool[i], () => onTapPool(i), const Color(0xFF1A3A5C)),
          ],
        ),
        SizedBox(height: size.height * 0.02),
        if (!answered)
          ElevatedButton(
            onPressed: selected.isEmpty ? null : onSubmit,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3A6EA5),
            ),
            child: const Text('Submit', style: TextStyle(color: Colors.white)),
          ),
      ],
    );
  }
}

class _ConversationWidget extends StatelessWidget {
  final QuizQuestion question;
  final Widget clue;
  final bool answered;
  final String? selected;
  final void Function(String) onSelect;
  final Size size;

  const _ConversationWidget({
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
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0x221A3A5C),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Conversation',
                style: TextStyle(
                  color: const Color(0xFFFFD700),
                  fontSize: size.height * 0.024,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                question.prompt,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: size.height * 0.031,
                  fontWeight: FontWeight.w600,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: size.height * 0.025),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          alignment: WrapAlignment.center,
          children: question.options.map((opt) {
            var bg = const Color(0xFF1A3A5C);
            var border = Colors.white24;
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
                width: size.width * 0.34,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: bg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: border, width: 2),
                ),
                child: Text(
                  opt,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: size.height * 0.027,
                    height: 1.35,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _WordMatchWidget extends StatelessWidget {
  final QuizQuestion question;
  final Widget clue;
  final bool answered;
  final List<String> pool;
  final Map<int, String> selections;
  final void Function(int, String?) onChanged;
  final VoidCallback onSubmit;
  final Size size;

  const _WordMatchWidget({
    required this.question,
    required this.clue,
    required this.answered,
    required this.pool,
    required this.selections,
    required this.onChanged,
    required this.onSubmit,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final ready = selections.length == question.options.length;
    return Column(
      children: [
        clue,
        SizedBox(height: size.height * 0.02),
        Text(
          question.prompt,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: size.height * 0.036,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: size.height * 0.025),
        ...List.generate(question.options.length, (index) {
          return Container(
            margin: EdgeInsets.only(bottom: size.height * 0.015),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0x221A3A5C),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white24),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    question.options[index],
                    style: TextStyle(
                      color: const Color(0xFFFFD700),
                      fontSize: size.height * 0.03,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selections[index],
                    items: pool
                        .map(
                          (option) => DropdownMenuItem<String>(
                            value: option,
                            child: Text(option),
                          ),
                        )
                        .toList(),
                    onChanged: answered
                        ? null
                        : (value) => onChanged(index, value),
                    dropdownColor: const Color(0xFF1A3A5C),
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFF0D1B3E),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color(0xFF3A6EA5)),
                      ),
                    ),
                    hint: const Text(
                      'Select match',
                      style: TextStyle(color: Colors.white60),
                    ),
                    iconEnabledColor: Colors.white,
                  ),
                ),
              ],
            ),
          );
        }),
        if (!answered)
          ElevatedButton(
            onPressed: ready ? onSubmit : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3A6EA5),
            ),
            child: const Text(
              'Check matches',
              style: TextStyle(color: Colors.white),
            ),
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
          style: TextStyle(
            color: Colors.white54,
            fontSize: size.height * 0.028,
          ),
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
                color: revealed ? const Color(0xFFFFD700) : Colors.white38,
                width: 2,
              ),
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
                        color: Colors.white,
                        fontSize: size.height * 0.038,
                      ),
                    ),
                    Text(
                      question.hint,
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: size.height * 0.025,
                      ),
                    ),
                  ] else
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Text(
                        'Tap to reveal',
                        style: TextStyle(
                          color: Colors.white38,
                          fontSize: size.height * 0.025,
                        ),
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
                label: const Text(
                  "Didn't know",
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8B1A1A),
                ),
              ),
              const SizedBox(width: 20),
              ElevatedButton.icon(
                onPressed: onKnew,
                icon: const Icon(Icons.check, color: Colors.white),
                label: const Text(
                  'I knew it!',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A6B1A),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
