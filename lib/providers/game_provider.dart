import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/player_progress.dart';

/// Player Progress Provider
final playerProgressProvider =
    StateNotifierProvider<PlayerProgressNotifier, PlayerProgress>((ref) {
      return PlayerProgressNotifier();
    });

class PlayerProgressNotifier extends StateNotifier<PlayerProgress> {
  PlayerProgressNotifier() : super(const PlayerProgress());

  void updateProgress(PlayerProgress progress) {
    state = progress;
  }

  void addExperience(int amount) {
    final newExp = state.experience + amount;
    int newLevelInStage = state.currentLevelInStage;
    int newStage = state.currentStage;

    // Check for level up
    final expForNextLevel =
        state.currentLevelInStage * PlayerProgress.expPerLevel;
    if (newExp >= expForNextLevel &&
        state.currentLevelInStage < PlayerProgress.maxLevelPerStage) {
      newLevelInStage++;
    }

    // Check for stage completion
    if (newLevelInStage > PlayerProgress.maxLevelPerStage) {
      newLevelInStage = 1;
      newStage++;
    }

    state = state.copyWith(
      experience: newExp,
      currentLevelInStage: newLevelInStage,
      currentStage: newStage,
    );
  }

  void loseHeart() {
    if (state.currentHearts > 0) {
      state = state.copyWith(currentHearts: state.currentHearts - 1);
    }
  }

  void heal(int amount) {
    final newHearts = (state.currentHearts + amount).clamp(0, state.maxHearts);
    state = state.copyWith(currentHearts: newHearts);
  }

  void addCollectedWord(String wordId) {
    if (!state.collectedWords.contains(wordId)) {
      state = state.copyWith(collectedWords: [...state.collectedWords, wordId]);
    }
  }

  void unlockStage(String stageId) {
    if (!state.unlockedStages.contains(stageId)) {
      state = state.copyWith(
        unlockedStages: [...state.unlockedStages, stageId],
      );
    }
  }

  void addScore(int points) {
    state = state.copyWith(totalScore: state.totalScore + points);
  }

  void addFoodItem(String foodId, int amount) {
    final currentAmount = state.foodInventory[foodId] ?? 0;
    final newInventory = Map<String, int>.from(state.foodInventory);
    newInventory[foodId] = currentAmount + amount;
    state = state.copyWith(foodInventory: newInventory);
  }

  void useFoodItem(String foodId) {
    final currentAmount = state.foodInventory[foodId] ?? 0;
    if (currentAmount > 0) {
      final newInventory = Map<String, int>.from(state.foodInventory);
      newInventory[foodId] = currentAmount - 1;
      state = state.copyWith(foodInventory: newInventory);
    }
  }

  void resetDaily() {
    state = state.copyWith(currentHearts: state.maxHearts);
  }
}

/// Game Session Provider (for active gameplay)
final gameSessionProvider =
    StateNotifierProvider<GameSessionNotifier, GameSession>((ref) {
      return GameSessionNotifier();
    });

class GameSession {
  final bool isPlaying;
  final int currentScore;
  final List<String> collectedWordsInSession;
  final int? currentStageId;
  final int? currentLevelId;
  final bool isPaused;

  const GameSession({
    this.isPlaying = false,
    this.currentScore = 0,
    this.collectedWordsInSession = const [],
    this.currentStageId,
    this.currentLevelId,
    this.isPaused = false,
  });

  GameSession copyWith({
    bool? isPlaying,
    int? currentScore,
    List<String>? collectedWordsInSession,
    int? currentStageId,
    int? currentLevelId,
    bool? isPaused,
  }) {
    return GameSession(
      isPlaying: isPlaying ?? this.isPlaying,
      currentScore: currentScore ?? this.currentScore,
      collectedWordsInSession:
          collectedWordsInSession ?? this.collectedWordsInSession,
      currentStageId: currentStageId ?? this.currentStageId,
      currentLevelId: currentLevelId ?? this.currentLevelId,
      isPaused: isPaused ?? this.isPaused,
    );
  }
}

class GameSessionNotifier extends StateNotifier<GameSession> {
  GameSessionNotifier() : super(const GameSession());

  void startGame(int stageId, int levelId) {
    state = GameSession(
      isPlaying: true,
      currentStageId: stageId,
      currentLevelId: levelId,
    );
  }

  void pauseGame() {
    state = state.copyWith(isPaused: true);
  }

  void resumeGame() {
    state = state.copyWith(isPaused: false);
  }

  void endGame() {
    state = const GameSession();
  }

  void addScore(int points) {
    state = state.copyWith(currentScore: state.currentScore + points);
  }

  void collectWord(String wordId) {
    if (!state.collectedWordsInSession.contains(wordId)) {
      state = state.copyWith(
        collectedWordsInSession: [...state.collectedWordsInSession, wordId],
      );
    }
  }

  void resetSession() {
    state = const GameSession();
  }
}

/// Collected Words in Current Session Provider
final sessionWordsProvider = Provider<List<String>>((ref) {
  return ref.watch(gameSessionProvider).collectedWordsInSession;
});

/// Current Game Score Provider
final sessionScoreProvider = Provider<int>((ref) {
  return ref.watch(gameSessionProvider).currentScore;
});
