import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/player_progress.dart';

/// Storage Service for persisting game data
class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  SharedPreferences? _prefs;

  static const String _keyPlayerProgress = 'player_progress';
  static const String _keyLastPlayed = 'last_played_date';
  static const String _keySoundEnabled = 'sound_enabled';
  static const String _keyMusicEnabled = 'music_enabled';

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Player Progress
  Future<void> savePlayerProgress(PlayerProgress progress) async {
    await _prefs?.setString(_keyPlayerProgress, jsonEncode(progress.toJson()));
  }

  PlayerProgress? loadPlayerProgress() {
    final jsonString = _prefs?.getString(_keyPlayerProgress);
    if (jsonString != null) {
      try {
        return PlayerProgress.fromJson(jsonDecode(jsonString));
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  /// Settings
  Future<void> setSoundEnabled(bool enabled) async {
    await _prefs?.setBool(_keySoundEnabled, enabled);
  }

  bool getSoundEnabled() {
    return _prefs?.getBool(_keySoundEnabled) ?? true;
  }

  Future<void> setMusicEnabled(bool enabled) async {
    await _prefs?.setBool(_keyMusicEnabled, enabled);
  }

  bool getMusicEnabled() {
    return _prefs?.getBool(_keyMusicEnabled) ?? true;
  }

  /// Last Played Date (for daily heart reset)
  Future<void> setLastPlayedDate(String date) async {
    await _prefs?.setString(_keyLastPlayed, date);
  }

  String? getLastPlayedDate() {
    return _prefs?.getString(_keyLastPlayed);
  }

  /// Clear all data
  Future<void> clearAll() async {
    await _prefs?.clear();
  }
}
