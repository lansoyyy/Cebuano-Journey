import 'package:flutter/material.dart';
import 'game_screen.dart';
import '../home/main_menu_screen.dart';

// ── Level Complete ────────────────────────────────────────────────────────────
class LevelCompleteScreen extends StatefulWidget {
  final int world;
  final int level;
  final int xpEarned;
  final int tokensCollected;
  final int totalTokens;
  final int stars;
  final int prevBestStars;
  final int coinsEarned;

  const LevelCompleteScreen({
    super.key,
    required this.world,
    required this.level,
    required this.xpEarned,
    required this.tokensCollected,
    required this.totalTokens,
    required this.stars,
    required this.prevBestStars,
    required this.coinsEarned,
  });

  @override
  State<LevelCompleteScreen> createState() => _LevelCompleteScreenState();
}

class _LevelCompleteScreenState extends State<LevelCompleteScreen>
    with TickerProviderStateMixin {
  late final AnimationController _starCtrl;
  late final List<Animation<double>> _starAnims;

  @override
  void initState() {
    super.initState();
    _starCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    // Each star pops in sequentially
    _starAnims = List.generate(3, (i) {
      final start = i * 0.28;
      final end = (start + 0.4).clamp(0.0, 1.0);
      return CurvedAnimation(
        parent: _starCtrl,
        curve: Interval(start, end, curve: Curves.elasticOut),
      );
    });
    // Small delay before animating so the screen settles first
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) _starCtrl.forward();
    });
  }

  @override
  void dispose() {
    _starCtrl.dispose();
    super.dispose();
  }

  void _goMenu(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const MainMenuScreen()),
      (route) => false,
    );
  }

  void _goReplay(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => GameScreen(world: widget.world, level: widget.level),
      ),
      (route) => false,
    );
  }

  void _goNext(BuildContext context) {
    int nw = widget.world;
    int nl = widget.level + 1;
    if (nl > 5) {
      nl = 1;
      nw++;
    }
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => GameScreen(world: nw, level: nl),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isPortrait = size.height > size.width;
    final isNewBest = widget.stars > widget.prevBestStars;

    // Responsive: use more width on portrait phones
    final containerWidth = isPortrait
        ? size.width * 0.92
        : size.width * 0.55;
    final titleFontSize = isPortrait ? size.width * 0.07 : size.height * 0.055;
    final starSize = isPortrait ? size.width * 0.14 : size.height * 0.09;
    final statFontSize = isPortrait ? size.width * 0.038 : size.height * 0.030;

    return Scaffold(
      backgroundColor: const Color(0xDD000000),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: size.height * 0.02),
            child: Container(
              width: containerWidth,
              padding: EdgeInsets.all(size.width * 0.05),
              decoration: BoxDecoration(
                color: const Color(0xFF1A3A5C),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFFFD700), width: 3),
                boxShadow: const [
                  BoxShadow(color: Colors.black54, blurRadius: 12, offset: Offset(0, 4))
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'LEVEL COMPLETE!',
                    style: TextStyle(
                      color: const Color(0xFFFFD700),
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                    ),
                  ),
                  if (isNewBest) ...[
                    SizedBox(height: size.height * 0.01),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF8C00),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '★ NEW BEST!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isPortrait ? size.width * 0.04 : size.height * 0.022,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                  SizedBox(height: size.height * 0.025),

                  // ── Animated stars ──────────────────────────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (i) {
                      final earned = i < widget.stars;
                      return AnimatedBuilder(
                        animation: _starAnims[i],
                        builder: (_, __) {
                          final scale = earned ? _starAnims[i].value : 1.0;
                          return Transform.scale(
                            scale: scale,
                            child: Icon(
                              earned ? Icons.star : Icons.star_border,
                              color: earned
                                  ? const Color(0xFFFFD700)
                                  : Colors.white24,
                              size: starSize,
                            ),
                          );
                        },
                      );
                    }),
                  ),

                  SizedBox(height: size.height * 0.025),

                  _StatRow('World - Level:', 'W${widget.world} - L${widget.level}', statFontSize),
                  const SizedBox(height: 8),
                  _StatRow('XP Earned:', '+${widget.xpEarned} XP', statFontSize),
                  const SizedBox(height: 8),
                  _StatRow(
                    'Tokens Found:',
                    '${widget.tokensCollected}/${widget.totalTokens}',
                    statFontSize,
                  ),
                  if (widget.coinsEarned > 0) ...[
                    const SizedBox(height: 8),
                    _StatRow(
                      'Coins Earned:',
                      '+${widget.coinsEarned} 🪙',
                      statFontSize,
                      valueColor: const Color(0xFFFFD700),
                    ),
                  ],

                  SizedBox(height: size.height * 0.035),

                  // ── Buttons ─────────────────────────────────────────────────
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      // Menu
                      _ActionButton(
                        label: 'Menu',
                        icon: Icons.menu,
                        bgColor: const Color(0xFF3A6EA5),
                        textColor: Colors.white,
                        onTap: () => _goMenu(context),
                        isPortrait: isPortrait,
                        size: size,
                      ),
                      // Replay
                      _ActionButton(
                        label: 'Replay',
                        icon: Icons.replay,
                        bgColor: const Color(0xFF2A5A2A),
                        textColor: Colors.white,
                        onTap: () => _goReplay(context),
                        isPortrait: isPortrait,
                        size: size,
                      ),
                      // Next
                      _ActionButton(
                        label: 'Next',
                        icon: Icons.arrow_forward,
                        bgColor: const Color(0xFFFFD700),
                        textColor: Colors.black,
                        onTap: () => _goNext(context),
                        isPortrait: isPortrait,
                        size: size,
                        bold: true,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Game Over ─────────────────────────────────────────────────────────────────
class GameOverScreen extends StatelessWidget {
  final VoidCallback onRetry;
  final VoidCallback onMenu;

  const GameOverScreen({
    super.key,
    required this.onRetry,
    required this.onMenu,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xEE330000),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.heart_broken, color: Colors.red, size: size.height * 0.2),
            SizedBox(height: size.height * 0.04),
            Text(
              'OUT OF HEARTS',
              style: TextStyle(
                color: Colors.white,
                fontSize: size.height * 0.08,
                fontWeight: FontWeight.w900,
                letterSpacing: 4,
              ),
            ),
            SizedBox(height: size.height * 0.02),
            Text(
              'Hearts recover 1 every 15 minutes.',
              style: TextStyle(
                color: Colors.white70,
                fontSize: size.height * 0.04,
              ),
            ),
            SizedBox(height: size.height * 0.08),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: onMenu,
                  icon: const Icon(Icons.menu, color: Colors.white),
                  label: const Text('Main Menu', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A3A5C),
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                ),
                const SizedBox(width: 20),
                ElevatedButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh, color: Colors.black),
                  label: const Text('Check Hearts', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFD700),
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String val;
  final double fontSize;
  final Color? valueColor;
  const _StatRow(this.label, this.val, this.fontSize, {this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(child: Text(label, style: TextStyle(color: Colors.white70, fontSize: fontSize))),
        const SizedBox(width: 8),
        Text(
          val,
          style: TextStyle(
            color: valueColor ?? Colors.white,
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color bgColor;
  final Color textColor;
  final VoidCallback onTap;
  final Size size;
  final bool isPortrait;
  final bool bold;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.bgColor,
    required this.textColor,
    required this.onTap,
    required this.size,
    required this.isPortrait,
    this.bold = false,
  });

  @override
  Widget build(BuildContext context) {
    final iconSize = isPortrait ? size.width * 0.05 : size.height * 0.025;
    final fontSize = isPortrait ? size.width * 0.042 : size.height * 0.022;
    final hPad = isPortrait ? size.width * 0.05 : size.width * 0.02;
    final vPad = isPortrait ? size.height * 0.015 : size.height * 0.012;
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, color: textColor, size: iconSize),
      label: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontWeight: bold ? FontWeight.bold : FontWeight.normal,
          fontSize: fontSize,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        padding: EdgeInsets.symmetric(horizontal: hPad, vertical: vPad),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
