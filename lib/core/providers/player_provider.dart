import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/player_model.dart';

const _kName = 'player_name';
const _kHearts = 'player_hearts';
const _kXp = 'player_xp';
const _kLevel = 'player_level';
const _kWords = 'player_words';
const _kPowerups = 'player_powerups';
const _kHeartTimes = 'player_heart_times';
const _kCoins = 'player_coins';
const _kLevelStars = 'player_level_stars';
const _kStreak = 'player_streak_days';
const _kLastPlay = 'player_last_play_date';

class PlayerNotifier extends StateNotifier<PlayerModel> {
  PlayerNotifier() : super(const PlayerModel(name: ''));

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString(_kName) ?? '';
    final hearts = prefs.getInt(_kHearts) ?? 5;
    final xp = prefs.getInt(_kXp) ?? 0;
    final level = prefs.getInt(_kLevel) ?? 1;
    final words = prefs.getStringList(_kWords) ?? [];
    final powerups = (jsonDecode(prefs.getString(_kPowerups) ?? '[0]') as List)
        .cast<int>();
    final timesRaw = prefs.getStringList(_kHeartTimes) ?? [];
    final heartTimes =
        timesRaw.map((s) => DateTime.parse(s)).toList();
    final coins = prefs.getInt(_kCoins) ?? 0;
    final starsRaw = prefs.getString(_kLevelStars) ?? '{}';
    final Map<String, dynamic> starsJson = jsonDecode(starsRaw) as Map<String, dynamic>;
    final levelStars = starsJson.map((k, v) => MapEntry(k, v as int));
    final streakDays = prefs.getInt(_kStreak) ?? 0;
    final lastPlayRaw = prefs.getString(_kLastPlay);
    final lastPlayDate = lastPlayRaw != null ? DateTime.tryParse(lastPlayRaw) : null;

    state = PlayerModel(
      name: name,
      hearts: hearts,
      xp: xp,
      level: level,
      collectedWordIds: words,
      powerupCounts: powerups,
      heartLostTimes: heartTimes,
      coins: coins,
      levelStars: levelStars,
      streakDays: streakDays,
      lastPlayDate: lastPlayDate,
    );
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kName, state.name);
    await prefs.setInt(_kHearts, state.hearts);
    await prefs.setInt(_kXp, state.xp);
    await prefs.setInt(_kLevel, state.level);
    await prefs.setStringList(_kWords, state.collectedWordIds);
    await prefs.setString(_kPowerups, jsonEncode(state.powerupCounts));
    await prefs.setStringList(
        _kHeartTimes, state.heartLostTimes.map((t) => t.toIso8601String()).toList());
    await prefs.setInt(_kCoins, state.coins);
    await prefs.setString(_kLevelStars, jsonEncode(state.levelStars));
    await prefs.setInt(_kStreak, state.streakDays);
    if (state.lastPlayDate != null) {
      await prefs.setString(_kLastPlay, state.lastPlayDate!.toIso8601String());
    }
  }

  Future<void> setName(String name) async {
    state = state.copyWith(name: name);
    await _save();
  }

  Future<void> collectWord(String wordId) async {
    if (state.collectedWordIds.contains(wordId)) return;
    state = state.copyWith(
        collectedWordIds: [...state.collectedWordIds, wordId]);
    await _save();
  }

  Future<void> addXp(int amount) async {
    int newXp = state.xp + amount;
    int newLevel = state.level;
    while (newXp >= state.xpForNextLevel) {
      newXp -= state.xpForNextLevel;
      newLevel++;
    }
    state = state.copyWith(xp: newXp, level: newLevel);
    await _save();
  }

  Future<void> loseHeart() async {
    if (state.hearts <= 0) return;
    final times = [...state.heartLostTimes, DateTime.now()];
    state = state.copyWith(
      hearts: state.hearts - 1,
      heartLostTimes: times,
    );
    await _save();
  }

  Future<void> addHint() async {
    final p = [...state.powerupCounts];
    p[0] = (p[0]) + 1;
    state = state.copyWith(powerupCounts: p);
    await _save();
  }

  Future<void> useHint() async {
    if (state.hintCount <= 0) return;
    final p = [...state.powerupCounts];
    p[0] = p[0] - 1;
    state = state.copyWith(powerupCounts: p);
    await _save();
  }

  /// Award coins to the player.
  Future<void> addCoins(int amount) async {
    state = state.copyWith(coins: state.coins + amount);
    await _save();
  }

  /// Save the result of a completed level and return the coins earned.
  /// Only updates stars if the new result is better than before.
  /// Returns the coins actually awarded (0 if no improvement).
  Future<int> saveLevelResult(int world, int lvl, int stars) async {
    final key = '${world}_$lvl';
    final prev = state.levelStars[key] ?? 0;
    final isImprovement = stars > prev;
    final newStars = {...state.levelStars};
    if (isImprovement) newStars[key] = stars;

    // Coins: awarded for full completion and improvements.
    final baseCoins = [0, 10, 25, 50][stars.clamp(0, 3)];
    final improvementBonus = (isImprovement && prev > 0) ? 15 : 0;
    final coinsEarned = isImprovement ? baseCoins + improvementBonus : 0;

    state = state.copyWith(
      levelStars: isImprovement ? newStars : null,
      coins: state.coins + coinsEarned,
    );
    await _save();
    return coinsEarned;
  }

  /// Call once per session entry (e.g., when tapping "Start").
  /// Increments streak if the player hasn't played today yet.
  Future<void> checkAndUpdateStreak() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final last = state.lastPlayDate;

    int newStreak = state.streakDays;
    if (last == null) {
      newStreak = 1;
    } else {
      final lastDay = DateTime(last.year, last.month, last.day);
      final diff = today.difference(lastDay).inDays;
      if (diff == 0) {
        // Already played today — no change
        return;
      } else if (diff == 1) {
        newStreak = state.streakDays + 1;
      } else {
        // Streak broken
        newStreak = 1;
      }
    }
    state = state.copyWith(streakDays: newStreak, lastPlayDate: today);
    await _save();
  }
}

final playerProvider =
    StateNotifierProvider<PlayerNotifier, PlayerModel>((ref) {
  return PlayerNotifier();
});
