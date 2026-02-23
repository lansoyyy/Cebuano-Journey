import 'package:flutter/material.dart';
import '../../core/models/player_model.dart';

class HudOverlay extends StatelessWidget {
  final PlayerModel player;
  final int tokensCollected;
  final int tokensTotal;
  final int world;
  final int level;
  final String themeLabel;
  final bool showInteract;
  final int? timerSeconds;
  final VoidCallback onInventory;

  const HudOverlay({
    super.key,
    required this.player,
    required this.tokensCollected,
    required this.tokensTotal,
    required this.world,
    required this.level,
    required this.themeLabel,
    required this.showInteract,
    required this.onInventory,
    this.timerSeconds,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final hearts = player.currentHearts;

    return Stack(
      children: [
        // ── Top bar ─────────────────────────────────────────────────────────
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.02, vertical: size.height * 0.012),
            color: const Color(0xBB000000),
            child: Row(
              children: [
                // Hearts
                Row(
                  children: List.generate(
                    player.maxHearts,
                    (i) => Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: Icon(
                        i < hearts ? Icons.favorite : Icons.favorite_border,
                        color: i < hearts ? Colors.red : Colors.red.shade900,
                        size: size.height * 0.045,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: size.width * 0.02),
                // XP bar
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Lv.${player.level}  ${player.xp}/${player.xpForNextLevel} XP',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: size.height * 0.022,
                        ),
                      ),
                      const SizedBox(height: 2),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: player.xpProgress,
                          backgroundColor: Colors.white24,
                          color: const Color(0xFFFFD700),
                          minHeight: size.height * 0.018,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: size.width * 0.02),
                // Token counter
                Row(
                  children: [
                    Icon(Icons.stars_rounded,
                        color: const Color(0xFFFFD700),
                        size: size.height * 0.045),
                    const SizedBox(width: 4),
                    Text(
                      '$tokensCollected/$tokensTotal',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: size.height * 0.032,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(width: size.width * 0.02),
                // Inventory button
                GestureDetector(
                  onTap: onInventory,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A4A7A),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: Icon(Icons.backpack_rounded,
                        color: Colors.white, size: size.height * 0.042),
                  ),
                ),
                SizedBox(width: size.width * 0.015),
                // World / level label
                Text(
                  'W$world-L$level  $themeLabel',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: size.height * 0.025,
                  ),
                ),
              ],
            ),
          ),
        ),

        // ── Timer (center top, only when active) ────────────────────────────
        if (timerSeconds != null)
          Positioned(
            top: size.height * 0.12,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                decoration: BoxDecoration(
                  color: timerSeconds! <= 5
                      ? const Color(0xDDCC2222)
                      : const Color(0xDD1A3A5C),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '⏱ ${timerSeconds}s',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: size.height * 0.04,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),

        // ── Interaction prompt ───────────────────────────────────────────────
        if (showInteract)
          Positioned(
            bottom: size.height * 0.30,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xDD000000),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFFFD700), width: 2),
                ),
                child: Text(
                  'Press  A  to talk',
                  style: TextStyle(
                    color: const Color(0xFFFFD700),
                    fontSize: size.height * 0.032,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),

        // ── Hint counter (powerup) ───────────────────────────────────────────
        if (player.hintCount > 0)
          Positioned(
            top: size.height * 0.12,
            right: size.width * 0.02,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xDD2A4A2A),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.lightbulb, color: Color(0xFFFFD700), size: 18),
                  const SizedBox(width: 4),
                  Text('x${player.hintCount}',
                      style: const TextStyle(color: Colors.white)),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
