class PlayerModel {
  final String name;
  final int hearts;
  final int maxHearts;
  final int xp;
  final int level;
  final List<String> collectedWordIds;
  final List<int> powerupCounts; // [hintCount]
  final List<DateTime> heartLostTimes;

  const PlayerModel({
    required this.name,
    this.hearts = 5,
    this.maxHearts = 5,
    this.xp = 0,
    this.level = 1,
    this.collectedWordIds = const [],
    this.powerupCounts = const [0],
    this.heartLostTimes = const [],
  });

  int get xpForNextLevel => (level * level * 150 + 100).clamp(100, 99999);
  double get xpProgress => (xp / xpForNextLevel).clamp(0.0, 1.0);
  int get hintCount => powerupCounts.isNotEmpty ? powerupCounts[0] : 0;

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
      );
}
