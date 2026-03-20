import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/player_provider.dart';
import '../../data/tutorial_data.dart';
import '../home/main_menu_screen.dart';

class TutorialScreen extends ConsumerStatefulWidget {
  const TutorialScreen({super.key});

  @override
  ConsumerState<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends ConsumerState<TutorialScreen>
    with SingleTickerProviderStateMixin {
  int _lineIndex = 0;
  String _displayedText = '';
  Timer? _typeTimer;
  bool _isTyping = false;
  late AnimationController _fadeCtrl;
  late Animation<double> _fadeAnim;

  static final _lines = TutorialData.lines;

  // ── Speaker styling ────────────────────────────────────────────────────

  static const _bgColors = <TutorialSpeaker, List<Color>>{
    TutorialSpeaker.mc: [Color(0xFF060F25), Color(0xFF0E2050)],
    TutorialSpeaker.sign: [Color(0xFF0A1F08), Color(0xFF1A4A14)],
    TutorialSpeaker.npc: [Color(0xFF1F0E05), Color(0xFF4A2810)],
    TutorialSpeaker.narrator: [Color(0xFF100820), Color(0xFF2A1050)],
    TutorialSpeaker.info: [Color(0xFF061A1A), Color(0xFF0E3A3A)],
  };

  static const _accentColors = <TutorialSpeaker, Color>{
    TutorialSpeaker.mc: Color(0xFF5A9EFF),
    TutorialSpeaker.sign: Color(0xFFFFD700),
    TutorialSpeaker.npc: Color(0xFFFF8C42),
    TutorialSpeaker.narrator: Color(0xFFCC88FF),
    TutorialSpeaker.info: Color(0xFF44DDCC),
  };

  static const _speakerIcons = <TutorialSpeaker, String>{
    TutorialSpeaker.mc: '🧑',
    TutorialSpeaker.sign: '📋',
    TutorialSpeaker.npc: '👴',
    TutorialSpeaker.narrator: '✨',
    TutorialSpeaker.info: '📖',
  };

  // ── Lifecycle ──────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
    _fadeCtrl.forward();
    _startTyping();
  }

  @override
  void dispose() {
    _typeTimer?.cancel();
    _fadeCtrl.dispose();
    super.dispose();
  }

  // ── Typewriter ─────────────────────────────────────────────────────────

  void _startTyping() {
    final full = _lines[_lineIndex].text;
    _displayedText = '';
    _isTyping = true;
    int i = 0;
    _typeTimer?.cancel();
    _typeTimer = Timer.periodic(const Duration(milliseconds: 26), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      if (i < full.length) {
        setState(() {
          _displayedText += full[i];
          i++;
        });
      } else {
        t.cancel();
        if (mounted) setState(() => _isTyping = false);
      }
    });
  }

  // ── Navigation ─────────────────────────────────────────────────────────

  void _advance() {
    if (_isTyping) {
      // Skip typewriter — show full text immediately
      _typeTimer?.cancel();
      setState(() {
        _displayedText = _lines[_lineIndex].text;
        _isTyping = false;
      });
      return;
    }
    if (_lineIndex < _lines.length - 1) {
      setState(() => _lineIndex++);
      _fadeCtrl.reset();
      _fadeCtrl.forward();
      _startTyping();
    } else {
      _finish();
    }
  }

  Future<void> _finish() async {
    _typeTimer?.cancel();
    await ref.read(playerProvider.notifier).completeTutorial();
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const MainMenuScreen()),
    );
  }

  // ── Build ──────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final line = _lines[_lineIndex];
    final bg = _bgColors[line.speaker]!;
    final accent = _accentColors[line.speaker]!;
    final icon = _speakerIcons[line.speaker]!;
    final isInfo = line.speaker == TutorialSpeaker.info;
    final isLast = _lineIndex == _lines.length - 1;

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _advance,
        child: Stack(
          children: [
            // ── Animated gradient background ─────────────────────────────
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: bg,
                ),
              ),
            ),

            // ── Main content ─────────────────────────────────────────────
            FadeTransition(
              opacity: _fadeAnim,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Scene transition banner
                  if (line.sceneLabel != null)
                    _SceneBanner(label: line.sceneLabel!, accent: accent, size: size),

                  // Portrait / info card area
                  Expanded(
                    child: isInfo
                        ? _InfoCard(
                            text: _displayedText,
                            isTyping: _isTyping,
                            size: size,
                          )
                        : _PortraitArea(
                            icon: icon,
                            accent: accent,
                            size: size,
                          ),
                  ),

                  // Dialogue box (not shown for info card)
                  if (!isInfo)
                    _DialogueBox(
                      speakerName: line.name,
                      text: _displayedText,
                      accent: accent,
                      isTyping: _isTyping,
                      isLast: isLast,
                      size: size,
                    ),
                ],
              ),
            ),

            // ── Skip button ───────────────────────────────────────────────
            Positioned(
              top: 10,
              right: 14,
              child: TextButton(
                onPressed: _finish,
                style: TextButton.styleFrom(
                  backgroundColor: Colors.black45,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  'Skip  ▶▶',
                  style: TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ),
            ),

            // ── Progress dots ─────────────────────────────────────────────
            Positioned(
              bottom: 6,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_lines.length, (i) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    width: i == _lineIndex ? 12 : 5,
                    height: 5,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      color: i == _lineIndex ? accent : Colors.white.withOpacity(0.22),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Sub-widgets ────────────────────────────────────────────────────────────

class _SceneBanner extends StatelessWidget {
  final String label;
  final Color accent;
  final Size size;

  const _SceneBanner({required this.label, required this.accent, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 9),
      color: Colors.black54,
      child: Text(
        '— $label —',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: accent.withOpacity(0.85),
          fontSize: size.height * 0.024,
          fontStyle: FontStyle.italic,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _PortraitArea extends StatelessWidget {
  final String icon;
  final Color accent;
  final Size size;

  const _PortraitArea({
    required this.icon,
    required this.accent,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final d = size.height * 0.22;
    return Center(
      child: Container(
        width: d,
        height: d,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: accent.withOpacity(0.12),
          border: Border.all(color: accent.withOpacity(0.35), width: 2),
        ),
        child: Center(
          child: Text(icon, style: TextStyle(fontSize: d * 0.46)),
        ),
      ),
    );
  }
}

class _DialogueBox extends StatelessWidget {
  final String speakerName;
  final String text;
  final Color accent;
  final bool isTyping;
  final bool isLast;
  final Size size;

  const _DialogueBox({
    required this.speakerName,
    required this.text,
    required this.accent,
    required this.isTyping,
    required this.isLast,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: size.height * 0.30),
      decoration: BoxDecoration(
        color: const Color(0xDD000000),
        border: Border(
          top: BorderSide(color: accent.withOpacity(0.45), width: 1.5),
        ),
      ),
      padding: EdgeInsets.fromLTRB(
        size.width * 0.05,
        14,
        size.width * 0.05,
        28,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Speaker name chip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: accent.withOpacity(0.18),
              border: Border.all(color: accent.withOpacity(0.55)),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              speakerName,
              style: TextStyle(
                color: accent,
                fontWeight: FontWeight.bold,
                fontSize: size.height * 0.026,
              ),
            ),
          ),
          const SizedBox(height: 10),
          // Dialogue text
          Text(
            text,
            style: TextStyle(
              color: Colors.white.withOpacity(0.95),
              fontSize: size.height * 0.029,
              height: 1.55,
            ),
          ),
          const SizedBox(height: 6),
          // Tap hint
          if (!isTyping)
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                isLast ? 'Tap to start  ▶' : 'Tap to continue  ▶',
                style: TextStyle(
                  color: accent.withOpacity(0.65),
                  fontSize: size.height * 0.022,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String text;
  final bool isTyping;
  final Size size;

  const _InfoCard({
    required this.text,
    required this.isTyping,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    const teal = Color(0xFF44DDCC);
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.06,
          vertical: 12,
        ),
        child: Container(
          padding: EdgeInsets.all(size.width * 0.03),
          decoration: BoxDecoration(
            color: const Color(0xCC001A1A),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: teal.withOpacity(0.45)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '📖  Intro to the Cebuano Language',
                style: TextStyle(
                  color: teal,
                  fontWeight: FontWeight.bold,
                  fontSize: size.height * 0.028,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                text,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.92),
                  fontSize: size.height * 0.026,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 12),
              if (!isTyping)
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Tap to continue  ▶',
                    style: TextStyle(
                      color: teal.withOpacity(0.65),
                      fontSize: size.height * 0.022,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
