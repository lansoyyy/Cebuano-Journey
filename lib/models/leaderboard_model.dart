/// Leaderboard Model
/// Score tracking and rankings
class LeaderboardEntry {
  final String id;
  final String playerName;
  final int score;
  final int level;
  final int stars;
  final int wordsLearned;
  final DateTime timestamp;
  final String? avatar;
  final int rank;

  const LeaderboardEntry({
    required this.id,
    required this.playerName,
    required this.score,
    required this.level,
    required this.stars,
    required this.wordsLearned,
    required this.timestamp,
    this.avatar,
    this.rank = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'playerName': playerName,
      'score': score,
      'level': level,
      'stars': stars,
      'wordsLearned': wordsLearned,
      'timestamp': timestamp.toIso8601String(),
      'avatar': avatar,
      'rank': rank,
    };
  }

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) {
    return LeaderboardEntry(
      id: json['id'] as String,
      playerName: json['playerName'] as String,
      score: json['score'] as int,
      level: json['level'] as int,
      stars: json['stars'] as int,
      wordsLearned: json['wordsLearned'] as int,
      timestamp: DateTime.parse(json['timestamp'] as String),
      avatar: json['avatar'] as String?,
      rank: json['rank'] as int,
    );
  }

  /// Calculate total score
  int get totalScore => score + (stars * 10) + (wordsLearned * 5);

  /// Get formatted score
  String get formattedScore {
    if (score >= 1000000) {
      return '${(score / 1000000).toStringAsFixed(1)}M';
    } else if (score >= 1000) {
      return '${(score / 1000).toStringAsFixed(1)}K';
    }
    return score.toString();
  }
}

class Leaderboard {
  final String id;
  final String name;
  final LeaderboardType type;
  final List<LeaderboardEntry> entries;
  final DateTime lastUpdated;
  final int?
  timeRange; // in hours (0 for all-time, 24 for daily, 168 for weekly)

  const Leaderboard({
    required this.id,
    required this.name,
    required this.type,
    required this.entries,
    required this.lastUpdated,
    this.timeRange,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type.name,
      'entries': entries.map((e) => e.toJson()).toList(),
      'lastUpdated': lastUpdated.toIso8601String(),
      'timeRange': timeRange,
    };
  }

  factory Leaderboard.fromJson(Map<String, dynamic> json) {
    return Leaderboard(
      id: json['id'] as String,
      name: json['name'] as String,
      type: LeaderboardType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => LeaderboardType.global,
      ),
      entries: (json['entries'] as List<dynamic>)
          .map((e) => LeaderboardEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
      timeRange: json['timeRange'] as int?,
    );
  }

  /// Get top players
  List<LeaderboardEntry> get topPlayers {
    final sorted = List<LeaderboardEntry>.from(entries);
    sorted.sort((a, b) => b.totalScore.compareTo(a.totalScore));
    // Update ranks
    for (int i = 0; i < sorted.length; i++) {
      sorted[i] = LeaderboardEntry(
        id: sorted[i].id,
        playerName: sorted[i].playerName,
        score: sorted[i].score,
        level: sorted[i].level,
        stars: sorted[i].stars,
        wordsLearned: sorted[i].wordsLearned,
        timestamp: sorted[i].timestamp,
        avatar: sorted[i].avatar,
        rank: i + 1,
      );
    }
    return sorted;
  }

  /// Get top 10
  List<LeaderboardEntry> get top10 => topPlayers.take(10).toList();

  /// Get player rank
  int? getPlayerRank(String playerId) {
    for (int i = 0; i < entries.length; i++) {
      if (entries[i].id == playerId) {
        return i + 1;
      }
    }
    return null;
  }
}

enum LeaderboardType { global, friends, weekly, daily, byLevel }

class PlayerStats {
  final String playerId;
  final String playerName;
  final int totalScore;
  final int highestScore;
  final int currentLevel;
  final int totalStars;
  final int wordsLearned;
  final int gamesPlayed;
  final int gamesWon;
  final int perfectGames;
  final int dailyQuestStreak;
  final int longestStreak;
  final DateTime? lastPlayed;
  final int totalPlayTime; // in minutes

  const PlayerStats({
    required this.playerId,
    required this.playerName,
    required this.totalScore,
    required this.highestScore,
    required this.currentLevel,
    required this.totalStars,
    required this.wordsLearned,
    required this.gamesPlayed,
    required this.gamesWon,
    required this.perfectGames,
    required this.dailyQuestStreak,
    required this.longestStreak,
    this.lastPlayed,
    required this.totalPlayTime,
  });

  Map<String, dynamic> toJson() {
    return {
      'playerId': playerId,
      'playerName': playerName,
      'totalScore': totalScore,
      'highestScore': highestScore,
      'currentLevel': currentLevel,
      'totalStars': totalStars,
      'wordsLearned': wordsLearned,
      'gamesPlayed': gamesPlayed,
      'gamesWon': gamesWon,
      'perfectGames': perfectGames,
      'dailyQuestStreak': dailyQuestStreak,
      'longestStreak': longestStreak,
      'lastPlayed': lastPlayed?.toIso8601String(),
      'totalPlayTime': totalPlayTime,
    };
  }

  factory PlayerStats.fromJson(Map<String, dynamic> json) {
    return PlayerStats(
      playerId: json['playerId'] as String,
      playerName: json['playerName'] as String,
      totalScore: json['totalScore'] as int,
      highestScore: json['highestScore'] as int,
      currentLevel: json['currentLevel'] as int,
      totalStars: json['totalStars'] as int,
      wordsLearned: json['wordsLearned'] as int,
      gamesPlayed: json['gamesPlayed'] as int,
      gamesWon: json['gamesWon'] as int,
      perfectGames: json['perfectGames'] as int,
      dailyQuestStreak: json['dailyQuestStreak'] as int,
      longestStreak: json['longestStreak'] as int,
      lastPlayed: json['lastPlayed'] != null
          ? DateTime.parse(json['lastPlayed'] as String)
          : null,
      totalPlayTime: json['totalPlayTime'] as int,
    );
  }

  /// Calculate win rate
  double get winRate {
    if (gamesPlayed == 0) return 0.0;
    return (gamesWon / gamesPlayed) * 100;
  }

  /// Calculate perfect rate
  double get perfectRate {
    if (gamesPlayed == 0) return 0.0;
    return (perfectGames / gamesPlayed) * 100;
  }

  /// Get formatted play time
  String get formattedPlayTime {
    if (totalPlayTime < 60) {
      return '${totalPlayTime}m';
    } else if (totalPlayTime < 1440) {
      return '${(totalPlayTime / 60).floor()}h ${(totalPlayTime % 60)}m';
    }
    return '${(totalPlayTime / 1440).floor()}d';
  }
}
