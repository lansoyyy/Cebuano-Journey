import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/level_data.dart';

class GameState {
  final int world;
  final int level;
  final LevelData? levelData;
  final bool levelComplete;

  const GameState({
    this.world = 1,
    this.level = 1,
    this.levelData,
    this.levelComplete = false,
  });

  GameState copyWith({
    int? world,
    int? level,
    LevelData? levelData,
    bool? levelComplete,
  }) =>
      GameState(
        world: world ?? this.world,
        level: level ?? this.level,
        levelData: levelData ?? this.levelData,
        levelComplete: levelComplete ?? this.levelComplete,
      );
}

class GameNotifier extends StateNotifier<GameState> {
  GameNotifier() : super(const GameState());

  void setLevel(LevelData data) {
    state = state.copyWith(
      world: data.world,
      level: data.level,
      levelData: data,
      levelComplete: false,
    );
  }

  void markLevelComplete() {
    state = state.copyWith(levelComplete: true);
  }

  void nextLevel() {
    int w = state.world;
    int l = state.level + 1;
    if (l > 5) {
      l = 1;
      w++;
    }
    state = GameState(world: w, level: l);
  }
}

final gameProvider =
    StateNotifierProvider<GameNotifier, GameState>((ref) => GameNotifier());
