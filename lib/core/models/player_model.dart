class PlayerModel {
  final String name;
  final int hearts;
  final int maxHearts;
  final int xp;
  final int level;
  final List<String> collectedWordIds;
  final List<int> powerupCounts; // [hintCount]
  final List<DateTime> heartLostTimes;
  // ── Replayability additions ──
  final int coins;
  /// Key: "${world}_${level}", value: best star count (1–3)
  final Map<String, int> levelStars;
  final int streakDays;
  final DateTime? lastPlayDate;
  // ── Tutorial ──
  final bool tutorialDone;

  const PlayerModel({
    required this.name,
    this.hearts = 5,
    this.maxHearts = 5,
    this.xp = 0,
    this.level = 1,
    this.collectedWordIds = const [],
    this.powerupCounts = const [0],
    this.heartLostTimes = const [],
    this.coins = 0,
    this.levelStars = const {},
    this.streakDays = 0,
    this.lastPlayDate,
    this.tutorialDone = false,
  });

  int get xpForNextLevel => (level * level * 150 + 100).clamp(100, 99999);
  double get xpProgress => (xp / xpForNextLevel).clamp(0.0, 1.0);
  int get hintCount => powerupCounts.isNotEmpty ? powerupCounts[0] : 0;

  int starsFor(int world, int lvl) => levelStars['${world}_$lvl'] ?? 0;

  int get currentHearts {
    final now = DateTime.now();
    final recovered =
        heartLostTimes.where((t) => now.difference(t).inMinutes >= 15).length;
    return (hearts + recovered).clamp(0, maxHearts);
  }

  Duration? get nextHeartRecovery {
    final now = DateTime.now();
    final pending =
        heartLostTimes.where((t) => now.difference(t).inMinutes < 15).toList();
    if (pending.isEmpty) return null;
    pending.sort();
    final elapsed = now.difference(pending.first);
    return Duration(minutes: 15) - elapsed;
  }

  PlayerModel copyWith({
    String? name,
    int? hearts,
    int? maxHearts,
    int? xp,
    int? level,
    List<String>? collectedWordIds,
    List<int>? powerupCounts,
    List<DateTime>? heartLostTimes,
    int? coins,
    Map<String, int>? levelStars,
    int? streakDays,
    DateTime? lastPlayDate,
    bool clearLastPlayDate = false,
    bool? tutorialDone,
  }) =>
      PlayerModel(
        name: name ?? this.name,
        hearts: hearts ?? this.hearts,
        maxHearts: maxHearts ?? this.maxHearts,
        xp: xp ?? this.xp,
        level: level ?? this.level,
        collectedWordIds: collectedWordIds ?? this.collectedWordIds,
        powerupCounts: powerupCounts ?? this.powerupCounts,
        heartLostTimes: heartLostTimes ?? this.heartLostTimes,
        coins: coins ?? this.coins,
        levelStars: levelStars ?? this.levelStars,
        streakDays: streakDays ?? this.streakDays,
        lastPlayDate:
            clearLastPlayDate ? null : (lastPlayDate ?? this.lastPlayDate),
        tutorialDone: tutorialDone ?? this.tutorialDone,
      );
}
