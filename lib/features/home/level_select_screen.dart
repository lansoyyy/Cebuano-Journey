import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/player_provider.dart';
import '../../data/level_configuration.dart';
import '../game/game_screen.dart';
import '../game/lesson_screen.dart';

class LevelSelectScreen extends ConsumerWidget {
  const LevelSelectScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final player = ref.watch(playerProvider);
    final size = MediaQuery.of(context).size;
    final maxWorld = ((player.level - 1) ~/ 5) + 1;
    final maxLevel = ((player.level - 1) % 5) + 1;

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
              // Header
              Padding(
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
                          size: size.height * 0.05,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      'SELECT LEVEL',
                      style: TextStyle(
                        color: const Color(0xFFFFD700),
                        fontSize: size.height * 0.06,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),

              // Worlds List
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.all(size.width * 0.04),
                  itemCount:
                      maxWorld, // Can only see worlds unlocked by player level
                  itemBuilder: (context, wIndex) {
                    final worldNum = wIndex + 1;
                    final levelsInWorld = (worldNum == maxWorld) ? maxLevel : 5;

                    return Container(
                      margin: EdgeInsets.only(bottom: size.height * 0.04),
                      padding: EdgeInsets.all(size.width * 0.02),
                      decoration: BoxDecoration(
                        color: const Color(0x33FFFFFF),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white24),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 8.0,
                              bottom: 12.0,
                            ),
                            child: Text(
                              'World $worldNum',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: size.height * 0.04,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: size.height * 0.22,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: 5,
                              itemBuilder: (context, lIndex) {
                                final levelNum = lIndex + 1;
                                final isUnlocked = levelNum <= levelsInWorld;
                                final globalLevel =
                                    ((worldNum - 1) * 5) + levelNum;
                                final bestStars =
                                    player.starsFor(worldNum, levelNum);
                                final isCompleted = bestStars > 0;

                                return Container(
                                  width: size.height * 0.18,
                                  margin: const EdgeInsets.only(right: 12),
                                  child: Column(
                                    children: [
                                      // Level number card
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: isUnlocked
                                              ? () {
                                                  Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (_) =>
                                                          GameScreen(
                                                            world: worldNum,
                                                            level: levelNum,
                                                          ),
                                                    ),
                                                  );
                                                }
                                              : null,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: isUnlocked
                                                  ? (isCompleted
                                                      ? const Color(0xFF2A5A2A)
                                                      : const Color(0xFF3A6EA5))
                                                  : const Color(0xFF1A2A3A),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              border: Border.all(
                                                color: isUnlocked
                                                    ? (isCompleted
                                                        ? const Color(0xFF4CAF50)
                                                        : const Color(0xFFFFD700))
                                                    : Colors.white12,
                                                width: isUnlocked ? 2 : 1,
                                              ),
                                            ),
                                            child: Center(
                                              child: isUnlocked
                                                  ? Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        Text(
                                                          '$levelNum',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize:
                                                                size.height * 0.07,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        if (isCompleted)
                                                          Row(
                                                            mainAxisSize: MainAxisSize.min,
                                                            children: List.generate(3, (si) {
                                                              return Icon(
                                                                si < bestStars
                                                                    ? Icons.star
                                                                    : Icons.star_border,
                                                                color: si < bestStars
                                                                    ? const Color(0xFFFFD700)
                                                                    : Colors.white24,
                                                                size: size.height * 0.022,
                                                              );
                                                            }),
                                                          ),
                                                      ],
                                                    )
                                                  : Icon(
                                                      Icons.lock,
                                                      color: Colors.white24,
                                                      size: size.height * 0.08,
                                                    ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: size.height * 0.01),
                                      // Lesson button
                                      GestureDetector(
                                        onTap: isUnlocked
                                            ? () {
                                                final levelConfig =
                                                    LevelDatabase.levels
                                                        .firstWhere(
                                                          (l) =>
                                                              l.level ==
                                                              globalLevel,
                                                          orElse: () =>
                                                              LevelDatabase
                                                                  .levels
                                                                  .first,
                                                        );
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (_) =>
                                                        LessonScreen(
                                                          lessonNumber:
                                                              globalLevel,
                                                          lessonTitle:
                                                              levelConfig.name,
                                                          lessonDescription:
                                                              levelConfig
                                                                  .description,
                                                        ),
                                                  ),
                                                );
                                              }
                                            : null,
                                        child: Container(
                                          height: size.height * 0.04,
                                          decoration: BoxDecoration(
                                            color: isUnlocked
                                                ? const Color(0xFF4CAF50)
                                                : const Color(0xFF1A2A3A),
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            border: Border.all(
                                              color: isUnlocked
                                                  ? Colors.white38
                                                  : Colors.white12,
                                              width: 1,
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              'Lesson',
                                              style: TextStyle(
                                                color: isUnlocked
                                                    ? Colors.white
                                                    : Colors.white24,
                                                fontSize: size.height * 0.018,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              // Coins display
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0x33FFD700),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0x66FFD700)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.toll, color: const Color(0xFFFFD700), size: size.height * 0.03),
                    const SizedBox(width: 6),
                    Text(
                      '${player.coins}',
                      style: TextStyle(
                        color: const Color(0xFFFFD700),
                        fontSize: size.height * 0.028,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),            ],
          ),
        ),
      ),
    );
  }
}
