import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  bool _revealed = false; // for flashcard

  // Fill blank
  final _fillCtrl = TextEditingController();

  // Word jumble
  List<String> _jumbleSelected = [];
  List<String> _jumblePool = [];

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
    _revealed = false;
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
    final correct = answer.trim().toLowerCase() ==
        _q.correctAnswer.trim().toLowerCase();
    if (correct) _correct++;
    setState(() {
      _answered = true;
      _selected = answer;
    });
    if (!correct) {
      ref.read(playerProvider.notifier).loseHeart();
    }
  }

  void _next() {
    if (_index + 1 >= widget.questions.length) {
      final result = QuizResult(correct: _correct, total: widget.questions.length);
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
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Hint: ${_q.hint}'),
      backgroundColor: const Color(0xFF2A4A2A),
      duration: const Duration(seconds: 4),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
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

  Widget _buildQuestion(Size size) {
    switch (_q.type) {
      case QuizType.multipleChoice:
        return _MCWidget(
          question: _q,
          answered: _answered,
          selected: _selected,
          onSelect: _submitAnswer,
          size: size,
        );
      case QuizType.fillBlank:
        return _FillWidget(
          question: _q,
          ctrl: _fillCtrl,
          answered: _answered,
          selected: _selected,
          onSubmit: _submitAnswer,
          size: size,
        );
      case QuizType.wordJumble:
        return _JumbleWidget(
          question: _q,
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
                isCorrect ? '✓  Husto! (Correct!)' : '✗  Mali! (Wrong!)',
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
            _index + 1 >= widget.questions.length ? 'Finish' : 'Next  →',
            style: TextStyle(
                fontSize: size.height * 0.032, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}

// ── Multiple Choice ────────────────────────────────────────────────────────────
class _MCWidget extends StatelessWidget {
  final QuizQuestion question;
  final bool answered;
  final String? selected;
  final void Function(String) onSelect;
  final Size size;

  const _MCWidget({
    required this.question,
    required this.answered,
    required this.selected,
    required this.onSelect,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
  final TextEditingController ctrl;
  final bool answered;
  final String? selected;
  final void Function(String) onSubmit;
  final Size size;

  const _FillWidget({
    required this.question,
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
  final List<String> selected;
  final List<String> pool;
  final bool answered;
  final void Function(int) onTapPool;
  final void Function(int) onTapSelected;
  final VoidCallback onSubmit;
  final Size size;

  const _JumbleWidget({
    required this.question,
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
