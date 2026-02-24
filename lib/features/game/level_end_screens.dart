import 'package:flutter/material.dart';

class LevelCompleteScreen extends StatelessWidget {
  final int world;
  final int level;
  final int xpEarned;
  final int tokensCollected;
  final VoidCallback onNext;
  final VoidCallback onMenu;

  const LevelCompleteScreen({
    super.key,
    required this.world,
    required this.level,
    required this.xpEarned,
    required this.tokensCollected,
    required this.onNext,
    required this.onMenu,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xDD000000),
      body: Center(
        child: Container(
          width: size.width * 0.5,
          padding: EdgeInsets.all(size.width * 0.03),
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
                  fontSize: size.height * 0.06,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                ),
              ),
              SizedBox(height: size.height * 0.04),
              _StatRow('World - Level:', 'W$world - L$level', size),
              const SizedBox(height: 8),
              _StatRow('XP Earned:', '+$xpEarned XP', size),
              const SizedBox(height: 8),
              _StatRow('Tokens Found:', '$tokensCollected', size),
              SizedBox(height: size.height * 0.06),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: onMenu,
                    icon: const Icon(Icons.menu, color: Colors.white),
                    label: const Text('Menu', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3A6EA5),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton.icon(
                    onPressed: onNext,
                    icon: const Icon(Icons.arrow_forward, color: Colors.black),
                    label: const Text('Next Level', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFD700),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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
  final Size size;
  const _StatRow(this.label, this.val, this.size);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Colors.white70, fontSize: size.height * 0.035)),
        Text(val, style: TextStyle(color: Colors.white, fontSize: size.height * 0.035, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
