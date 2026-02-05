import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../models/settings_model.dart';

/// Audio Service
/// Background music, sound effects, voice-over
class AudioService {
  static final AudioService _instance = AudioService._internal();

  factory AudioService() => _instance;

  AudioService._internal();

  // Audio Players
  AudioPlayer? _musicPlayer;
  AudioPlayer? _sfxPlayer;
  AudioPlayer? _voicePlayer;

  // Settings
  AudioSettings _settings = const AudioSettings();

  // Asset paths
  static const String _musicPath = 'assets/audio/music/';
  static const String _sfxPath = 'assets/audio/sfx/';
  static const String _voicePath = 'assets/audio/voice/';

  // Current state
  bool _isInitialized = false;
  String? _currentMusic;

  /// Initialize audio service
  Future<void> initialize() async {
    if (_isInitialized) return;

    _musicPlayer = AudioPlayer();
    _sfxPlayer = AudioPlayer();
    _voicePlayer = AudioPlayer();

    // Load settings from storage
    await _loadSettings();

    _isInitialized = true;
  }

  /// Load audio settings
  Future<void> _loadSettings() async {
    // TODO: Load from shared preferences
    // For now, use default settings
    _settings = const AudioSettings();
  }

  /// Save audio settings
  Future<void> _saveSettings() async {
    // TODO: Save to shared preferences
  }

  /// Update settings
  void updateSettings(AudioSettings settings) {
    _settings = settings;
    _saveSettings();

    // Apply settings
    if (_musicPlayer != null) {
      if (!settings.musicEnabled) {
        pauseMusic();
      } else {
        setMusicVolume(settings.musicVolume);
      }
    }

    if (_sfxPlayer != null) {
      if (!settings.soundEffectsEnabled) {
        // Disable sfx
      } else {
        setSfxVolume(settings.soundEffectsVolume);
      }
    }

    if (_voicePlayer != null) {
      if (!settings.voiceOverEnabled) {
        // Disable voice
      } else {
        setVoiceVolume(settings.voiceOverVolume);
      }
    }
  }

  // ========== Music Methods ==========

  /// Play background music
  Future<void> playMusic(String musicName) async {
    if (!_settings.musicEnabled || _musicPlayer == null) return;

    try {
      await _musicPlayer!.play(AssetSource('$_musicPath$musicName.mp3'));
      _currentMusic = musicName;

      // Set volume
      await _musicPlayer!.setVolume(_settings.musicVolume);

      // Loop the music
      _musicPlayer!.setReleaseMode(ReleaseMode.loop);
    } catch (e) {
      debugPrint('Error playing music: $e');
    }
  }

  /// Pause background music
  Future<void> pauseMusic() async {
    if (_musicPlayer == null) return;
    await _musicPlayer!.pause();
  }

  /// Resume background music
  Future<void> resumeMusic() async {
    if (_musicPlayer == null) return;
    await _musicPlayer!.resume();
  }

  /// Stop background music
  Future<void> stopMusic() async {
    if (_musicPlayer == null) return;
    await _musicPlayer!.stop();
    _currentMusic = null;
  }

  /// Set music volume
  Future<void> setMusicVolume(double volume) async {
    if (_musicPlayer == null) return;
    await _musicPlayer!.setVolume(volume.clamp(0.0, 1.0));
  }

  /// Get current music
  String? get currentMusic => _currentMusic;

  // ========== Sound Effects Methods ==========

  /// Play sound effect
  Future<void> playSfx(String sfxName) async {
    if (!_settings.soundEffectsEnabled || _sfxPlayer == null) return;

    try {
      await _sfxPlayer!.play(AssetSource('$_sfxPath$sfxName.mp3'));
      await _sfxPlayer!.setVolume(_settings.soundEffectsVolume);
    } catch (e) {
      debugPrint('Error playing SFX: $e');
    }
  }

  /// Play click sound
  Future<void> playClick() async {
    await playSfx('click');
  }

  /// Play success sound
  Future<void> playSuccess() async {
    await playSfx('success');
  }

  /// Play error sound
  Future<void> playError() async {
    await playSfx('error');
  }

  /// Play achievement unlock sound
  Future<void> playAchievement() async {
    await playSfx('achievement');
  }

  /// Play coin collect sound
  Future<void> playCoin() async {
    await playSfx('coin');
  }

  /// Play level complete sound
  Future<void> playLevelComplete() async {
    await playSfx('level_complete');
  }

  /// Set SFX volume
  Future<void> setSfxVolume(double volume) async {
    if (_sfxPlayer == null) return;
    await _sfxPlayer!.setVolume(volume.clamp(0.0, 1.0));
  }

  // ========== Voice Over Methods ==========

  /// Play voice over
  Future<void> playVoice(String voiceName) async {
    if (!_settings.voiceOverEnabled || _voicePlayer == null) return;

    try {
      await _voicePlayer!.play(AssetSource('$_voicePath$voiceName.mp3'));
      await _voicePlayer!.setVolume(_settings.voiceOverVolume);
    } catch (e) {
      debugPrint('Error playing voice: $e');
    }
  }

  /// Stop voice over
  Future<void> stopVoice() async {
    if (_voicePlayer == null) return;
    await _voicePlayer!.stop();
  }

  /// Set voice volume
  Future<void> setVoiceVolume(double volume) async {
    if (_voicePlayer == null) return;
    await _voicePlayer!.setVolume(volume.clamp(0.0, 1.0));
  }

  // ========== Utility Methods ==========

  /// Get current settings
  AudioSettings get settings => _settings;

  /// Check if music is playing
  bool get isMusicPlaying => _musicPlayer?.state == PlayerState.playing;

  /// Check if service is initialized
  bool get isInitialized => _isInitialized;

  /// Dispose all audio players
  void dispose() {
    _musicPlayer?.dispose();
    _sfxPlayer?.dispose();
    _voicePlayer?.dispose();
    _isInitialized = false;
  }

  // ========== Predefined Sound Effects ==========

  /// Available sound effects
  static const List<String> availableSfx = [
    'click',
    'success',
    'error',
    'achievement',
    'coin',
    'level_complete',
    'word_correct',
    'word_wrong',
    'hint',
    'button_hover',
    'menu_open',
    'menu_close',
  ];

  // ========== Predefined Music Tracks ==========

  /// Available music tracks
  static const List<String> availableMusic = [
    'main_theme',
    'gameplay',
    'menu',
    'level_complete',
    'victory',
    'relaxing',
  ];
}
