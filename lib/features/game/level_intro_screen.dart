import 'dart:async';
import 'package:flutter/material.dart';
import '../../data/level_intro_data.dart';

/// Full-screen narrative intro shown before a level starts.
/// The player sees the MC's thoughts about the upcoming scenario.
class LevelIntroScreen extends StatefulWidget {
  final LevelNarrative narrative;

  const LevelIntroScreen({super.key, required this.narrative});

  @override
  State<LevelIntroScreen> createState() => _LevelIntroScreenState();
}

class _LevelIntroScreenState extends State<LevelIntroScreen>
    with SingleTickerProviderStateMixin {
  int _thoughtIndex = 0;
  String _displayedText = '';
  Timer? _typeTimer;
  bool _isTyping = false;
  late AnimationController _fadeCtrl;
  late Animation<double> _fadeAnim;

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

  void _startTyping() {
    final text = widget.narrative.mcThoughts[_thoughtIndex];
    _displayedText = '';
    _isTyping = true;
    int i = 0;
    _typeTimer?.cancel();
    _typeTimer = Timer.periodic(const Duration(milliseconds: 28), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      if (i < text.length) {
        setState(() {
          _displayedText += text[i];
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
        _displayedText = widget.narrative.mcThoughts[_thoughtIndex];
        _isTyping = false;
      });
      return;
    }
    if (_thoughtIndex < widget.narrative.mcThoughts.length - 1) {
      setState(() => _thoughtIndex++);
      _fadeCtrl.reset();
      _fadeCtrl.forward();
      _startTyping();
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isLast = _thoughtIndex == widget.narrative.mcThoughts.length - 1;

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _advance,
        child: Stack(
          children: [
            // Background
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF080E1E), Color(0xFF101A10)],
                ),
              ),
            ),

            // Top header — level title
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                decoration: const BoxDecoration(
                  color: Color(0xAA000000),
                  border: Border(
                    bottom: BorderSide(color: Color(0x33FFFFFF)),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.narrative.title,
                      style: TextStyle(
                        color: const Color(0xFFFFD700),
                        fontSize: size.height * 0.030,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    Text(
                      widget.narrative.sceneSetting,
                      style: TextStyle(
                        color: Colors.white60,
                        fontSize: size.height * 0.021,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Center — MC portrait + thought bubble
            Center(
              child: FadeTransition(
                opacity: _fadeAnim,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // MC portrait
                    Container(
                      width: size.height * 0.17,
                      height: size.height * 0.17,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF1A3468).withOpacity(0.6),
                        border: Border.all(
                          color: const Color(0xFF5A9EFF),
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '🧑',
                          style: TextStyle(fontSize: size.height * 0.08),
                        ),
                      ),
                    ),
                    SizedBox(width: size.width * 0.03),
                    // Thought bubble
                    Container(
                      constraints: BoxConstraints(
                        maxWidth: size.width * 0.52,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xCC0D1B3E),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                          bottomRight: Radius.circular(16),
                          bottomLeft: Radius.circular(4),
                        ),
                        border: Border.all(
                          color: const Color(0xFF5A9EFF).withOpacity(0.45),
                        ),
                      ),
                      child: Text(
                        _displayedText,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: size.height * 0.030,
                          height: 1.5,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom — continue / start button
            Positioned(
              bottom: 18,
              right: 22,
              child: !_isTyping
                  ? (isLast
                      ? ElevatedButton(
                          onPressed: _advance,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFFD700),
                            foregroundColor: Colors.black87,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 26,
                              vertical: 10,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Start!  ▶',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: size.height * 0.026,
                            ),
                          ),
                        )
                      : Text(
                          'Tap to continue  ▶',
                          style: TextStyle(
                            color: const Color(0xFF5A9EFF).withOpacity(0.7),
                            fontSize: size.height * 0.022,
                            fontStyle: FontStyle.italic,
                          ),
                        ))
                  : const SizedBox.shrink(),
            ),

            // Skip button
            Positioned(
              top: size.height * 0.13,
              right: 12,
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.black38,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Skip  ▶▶',
                  style: TextStyle(color: Colors.white54, fontSize: 11),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
