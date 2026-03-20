import 'dart:async';
import 'package:flutter/material.dart';
import '../../data/level_intro_data.dart';

/// Overlay shown before an NPC quiz.
/// Displays a short scripted dialogue between the MC and the NPC,
/// setting the narrative context for the quiz.
class NpcDialogueScreen extends StatefulWidget {
  final String npcName;
  final List<NpcDialogueLine> lines;

  const NpcDialogueScreen({
    super.key,
    required this.npcName,
    required this.lines,
  });

  @override
  State<NpcDialogueScreen> createState() => _NpcDialogueScreenState();
}

class _NpcDialogueScreenState extends State<NpcDialogueScreen> {
  int _lineIndex = 0;
  String _displayedText = '';
  Timer? _typeTimer;
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _startTyping();
  }

  @override
  void dispose() {
    _typeTimer?.cancel();
    super.dispose();
  }

  void _startTyping() {
    final full = widget.lines[_lineIndex].text;
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

  void _advance() {
    if (_isTyping) {
      _typeTimer?.cancel();
      setState(() {
        _displayedText = widget.lines[_lineIndex].text;
        _isTyping = false;
      });
      return;
    }
    if (_lineIndex < widget.lines.length - 1) {
      setState(() => _lineIndex++);
      _startTyping();
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final line = widget.lines[_lineIndex];
    final isPlayer = line.isPlayer;
    final isLast = _lineIndex == widget.lines.length - 1;

    final accentColor =
        isPlayer ? const Color(0xFF5A9EFF) : const Color(0xFFFF8C42);
    final speakerName = isPlayer ? 'You' : widget.npcName;
    final speakerIcon = isPlayer ? '🧑' : '🗣️';

    return Scaffold(
      // Dark overlay — game is paused beneath
      backgroundColor: Colors.black.withOpacity(0.82),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _advance,
        child: Stack(
          children: [
            // ── Top: speaker portrait ──────────────────────────────────
            Positioned(
              top: size.height * 0.06,
              left: isPlayer ? null : size.width * 0.04,
              right: isPlayer ? size.width * 0.04 : null,
              child: _Portrait(
                icon: speakerIcon,
                name: speakerName,
                accent: accentColor,
                size: size,
              ),
            ),

            // ── Bottom: dialogue panel ─────────────────────────────────
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xF0000000),
                  border: Border(
                    top: BorderSide(
                      color: accentColor.withOpacity(0.5),
                      width: 1.5,
                    ),
                  ),
                ),
                padding: EdgeInsets.fromLTRB(
                  size.width * 0.05,
                  14,
                  size.width * 0.05,
                  size.height * 0.04,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Speaker name tag
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(speakerIcon, style: const TextStyle(fontSize: 16)),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: accentColor.withOpacity(0.18),
                            border: Border.all(
                              color: accentColor.withOpacity(0.6),
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            speakerName,
                            style: TextStyle(
                              color: accentColor,
                              fontWeight: FontWeight.bold,
                              fontSize: size.height * 0.025,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Dialogue text
                    Text(
                      _displayedText,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.95),
                        fontSize: size.height * 0.029,
                        height: 1.55,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Advance indicator
                    if (!_isTyping)
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          isLast ? 'A  —  Start Quiz  ▶' : 'Tap to continue  ▶',
                          style: TextStyle(
                            color: accentColor.withOpacity(0.65),
                            fontSize: size.height * 0.021,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Portrait extends StatelessWidget {
  final String icon;
  final String name;
  final Color accent;
  final Size size;

  const _Portrait({
    required this.icon,
    required this.name,
    required this.accent,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final d = size.height * 0.15;
    return Column(
      children: [
        Container(
          width: d,
          height: d,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: accent.withOpacity(0.15),
            border: Border.all(color: accent.withOpacity(0.5), width: 2),
          ),
          child: Center(
            child: Text(icon, style: TextStyle(fontSize: d * 0.44)),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          name,
          style: TextStyle(
            color: accent.withOpacity(0.85),
            fontSize: size.height * 0.020,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
