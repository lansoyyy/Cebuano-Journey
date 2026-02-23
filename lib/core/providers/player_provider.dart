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

    state = PlayerModel(
      name: name,
      hearts: hearts,
      xp: xp,
      level: level,
      collectedWordIds: words,
      powerupCounts: powerups,
      heartLostTimes: heartTimes,
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
}

final playerProvider =
    StateNotifierProvider<PlayerNotifier, PlayerModel>((ref) {
  return PlayerNotifier();
});
