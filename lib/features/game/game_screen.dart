import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/models/level_data.dart';
import '../../core/providers/player_provider.dart';
import '../../data/level_generator.dart';
import '../home/inventory_screen.dart';
import '../home/main_menu_screen.dart';
import '../home/options_screen.dart';
import 'hud_overlay.dart';
import 'level_end_screens.dart';
import 'parallax_painter.dart';
import 'quiz_screen.dart';

class GameScreen extends ConsumerStatefulWidget {
  final int world;
  final int level;
  const GameScreen({super.key, this.world = 1, this.level = 1});

  @override
  ConsumerState<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends ConsumerState<GameScreen>
    with TickerProviderStateMixin {
  late final Ticker _ticker;
  Duration _last = Duration.zero;

  // World & parallax
  double _worldX = 0.0;
  double _cloudDrift = 0.0;

  // Movement
  bool _movingLeft = false;
  bool _movingRight = false;

  // Jump physics
  bool _isJumping = false;
  double _jumpY = 0.0;
  double _jumpVY = 0.0;

  static const double _speed = 130.0;
  static const double _jumpImpulse = -300.0;
  static const double _gravity = 600.0;

  // Sprite animation
  static const _idleFrame = 'assets/images/Character/tile012.png';
  static const _walkFrames = [
    'assets/images/Character/tile016.png',
    'assets/images/Character/tile017.png',
    'assets/images/Character/tile018.png',
    'assets/images/Character/tile019.png',
    'assets/images/Character/tile020.png',
    'assets/images/Character/tile021.png',
  ];
  static const double _frameDuration = 0.10;

  int _walkFrame = 0;
  double _frameTimer = 0.0;
  bool _facingLeft = false;

  // Level data
  LevelData? _levelData;
  bool _inQuiz = false;

  // NPC proximity
  LevelNPC? _nearNPC;

  // Game session stats
  int _xpEarnedThisLevel = 0;
  bool _levelCompleteHandled = false;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick)..start();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadLevel());
  }

  void _loadLevel() {
    final size = MediaQuery.of(context).size;
    final data = LevelGenerator.generate(
      world: widget.world,
      level: widget.level,
      screenWidth: size.width,
      groundY: size.height * 0.64,
    );
    setState(() => _levelData = data);
  }

  void _onTick(Duration elapsed) {
    if (_inQuiz || _levelCompleteHandled) return;

    // Check hearts
    final player = ref.read(playerProvider);
    if (player.currentHearts <= 0) {
      _ticker.stop();
      _showGameOver();
      return;
    }

    final dt = _last == Duration.zero
        ? 0.0
        : (elapsed - _last).inMicroseconds / 1e6;
    _last = elapsed;
    setState(() {
      _cloudDrift += 18.0 * dt;
      if (_movingLeft) {
        _worldX = (_worldX - _speed * dt).clamp(0, double.infinity);
      }
      if (_movingRight) {
        _worldX = (_worldX + _speed * dt).clamp(
          0,
          _levelData?.worldLength ?? double.infinity,
        );
      }

      if (_isJumping) {
        _jumpVY += _gravity * dt;
        _jumpY += _jumpVY * dt;
        if (_jumpY >= 0) {
          _jumpY = 0;
          _jumpVY = 0;
          _isJumping = false;
        }
      }

      if (_movingLeft || _movingRight) {
        if (_movingLeft) _facingLeft = true;
        if (_movingRight) _facingLeft = false;
        _frameTimer += dt;
        if (_frameTimer >= _frameDuration) {
          _frameTimer -= _frameDuration;
          _walkFrame = (_walkFrame + 1) % _walkFrames.length;
        }
      } else {
        _walkFrame = 0;
        _frameTimer = 0;
      }

      _checkTokens();
      _checkHints();
      _checkNPCProximity();
      _checkLevelComplete();
    });
  }

  void _checkTokens() {
    if (_levelData == null) return;
    for (final token in _levelData!.tokens) {
      if (token.collected) continue;
      final screenX = token.worldX - _worldX;
      // Also need to check vertical distance for collecting
      final charScreenX = MediaQuery.of(context).size.width * 0.27;
      final charY =
          MediaQuery.of(context).size.height * 0.64 -
          MediaQuery.of(context).size.height * 0.20 +
          _jumpY;

      if ((screenX - charScreenX).abs() < 60 &&
          (token.screenY - charY).abs() < 60) {
        token.collected = true;
        ref.read(playerProvider.notifier).collectWord(token.word.id);
      }
    }
  }

  void _checkHints() {
    if (_levelData == null) return;
    for (final hint in _levelData!.hints) {
      if (hint.collected) continue;
      final screenX = hint.worldX - _worldX;
      final charScreenX = MediaQuery.of(context).size.width * 0.27;
      final charY =
          MediaQuery.of(context).size.height * 0.64 -
          MediaQuery.of(context).size.height * 0.20 +
          _jumpY;

      if ((screenX - charScreenX).abs() < 50 &&
          (hint.screenY - charY).abs() < 50) {
        hint.collected = true;
        ref.read(playerProvider.notifier).addHint();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Picked up a Hint Powerup! 💡',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            backgroundColor: Color(0xFF2A4A2A),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  void _checkNPCProximity() {
    if (_levelData == null) return;
    _nearNPC = null;
    for (final npc in _levelData!.npcs) {
      if (npc.completed) continue;
      final screenX = npc.worldX - _worldX;
      final charScreenX = MediaQuery.of(context).size.width * 0.27;
      if ((screenX - charScreenX).abs() < 90) {
        _nearNPC = npc;
        break;
      }
    }
  }

  void _checkLevelComplete() {
    if (_levelData == null || _levelCompleteHandled) return;

    // Win condition: Reached the end of the world OR all NPCs are completed
    final allNpcsDone = _levelData!.npcs.every((n) => n.completed);
    final reachedEnd = _worldX >= _levelData!.worldLength - 100;

    if (allNpcsDone || reachedEnd) {
      _levelCompleteHandled = true;
      _ticker.stop();
      _showLevelComplete();
    }
  }

  void _showGameOver() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => GameOverScreen(
          onMenu: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const MainMenuScreen()),
          ),
          onRetry: () {
            // Re-check hearts, if recovered, restart this level
            if (ref.read(playerProvider).currentHearts > 0) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      GameScreen(world: widget.world, level: widget.level),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Still out of hearts! Wait a bit.'),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  void _showLevelComplete() {
    final tokensCollected = _levelData!.tokens.where((t) => t.collected).length;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => LevelCompleteScreen(
          world: widget.world,
          level: widget.level,
          xpEarned: _xpEarnedThisLevel,
          tokensCollected: tokensCollected,
          onMenu: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const MainMenuScreen()),
          ),
          onNext: () {
            int nw = widget.world;
            int nl = widget.level + 1;
            if (nl > 5) {
              nl = 1;
              nw++;
            }
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => GameScreen(world: nw, level: nl),
              ),
            );
          },
        ),
      ),
    );
  }

  void _jump() {
    if (!_isJumping) {
      _isJumping = true;
      _jumpVY = _jumpImpulse;
    }
  }

  Future<void> _interact() async {
    if (_nearNPC == null || _inQuiz) return;
    final npc = _nearNPC!;
    _ticker.stop();
    setState(() => _inQuiz = true);
    final result = await Navigator.push<QuizResult>(
      context,
      MaterialPageRoute(
        builder: (_) => QuizScreen(
          npcName: npc.name,
          npcGreeting: npc.greeting,
          questions: npc.questions,
        ),
      ),
    );
    npc.completed = true;
    _last = Duration.zero;
    _ticker.start();
    setState(() => _inQuiz = false);
    if (result != null && mounted) {
      _showQuizSummary(result);
    }
  }

  void _showQuizSummary(QuizResult result) {
    if (result.passed) {
      _xpEarnedThisLevel += result.xpEarned;
    }

    final msg = result.passed
        ? 'Maayo! +${result.xpEarned} XP'
        : 'Try harder next time!';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          msg,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        backgroundColor: result.passed
            ? const Color(0xFF1A4A1A)
            : const Color(0xFF4A1A1A),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final groundY = size.height * 0.64;
    final charH = size.height * 0.20;
    final charW = charH * 0.55;
    final charScreenX = size.width * 0.27;
    final charTop = groundY - charH + _jumpY;
    final btnSize = size.height * 0.185;
    final btnGap = size.width * 0.022;
    final player = ref.watch(playerProvider);

    final tokensCollected =
        _levelData?.tokens.where((t) => t.collected).length ?? 0;
    final tokensTotal = _levelData?.tokens.length ?? 0;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // ── Parallax background ──────────────────────────────────────────
          CustomPaint(
            painter: ParallaxPainter(worldX: _worldX, cloudDrift: _cloudDrift),
            child: const SizedBox.expand(),
          ),

          // ── Platforms ────────────────────────────────────────────────────
          if (_levelData != null)
            CustomPaint(
              painter: _PlatformPainter(
                platforms: _levelData!.platforms,
                worldX: _worldX,
              ),
              child: const SizedBox.expand(),
            ),

          // ── Tokens ───────────────────────────────────────────────────────
          if (_levelData != null)
            ..._levelData!.tokens.where((t) => !t.collected).map((t) {
              final sx = t.worldX - _worldX;
              if (sx < -40 || sx > size.width + 40) return const SizedBox();
              return Positioned(
                left: sx - 14,
                top: t.screenY,
                child: const _TokenWidget(),
              );
            }),

          // ── Hints ────────────────────────────────────────────────────────
          if (_levelData != null)
            ..._levelData!.hints.where((h) => !h.collected).map((h) {
              final sx = h.worldX - _worldX;
              if (sx < -40 || sx > size.width + 40) return const SizedBox();
              return Positioned(
                left: sx - 14,
                top: h.screenY,
                child: const _HintWidget(),
              );
            }),

          // ── NPCs ─────────────────────────────────────────────────────────
          if (_levelData != null)
            ..._levelData!.npcs.map((npc) {
              final sx = npc.worldX - _worldX;
              if (sx < -60 || sx > size.width + 60) return const SizedBox();
              return Positioned(
                left: sx - 16,
                top: groundY - size.height * 0.18,
                child: _NPCWidget(
                  name: npc.name,
                  completed: npc.completed,
                  size: size,
                ),
              );
            }),

          // ── Character sprite ─────────────────────────────────────────────
          Positioned(
            left: charScreenX - charW / 2,
            top: charTop,
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..scale(_facingLeft ? -1.0 : 1.0, 1.0),
              child: Image.asset(
                (_movingLeft || _movingRight)
                    ? _walkFrames[_walkFrame]
                    : _idleFrame,
                width: charW,
                height: charH,
                fit: BoxFit.contain,
                filterQuality: FilterQuality.none,
              ),
            ),
          ),

          // ── HUD overlay ──────────────────────────────────────────────────
          HudOverlay(
            player: player,
            tokensCollected: tokensCollected,
            tokensTotal: tokensTotal,
            world: widget.world,
            level: widget.level,
            themeLabel: _levelData?.themeLabel ?? '',
            showInteract: _nearNPC != null,
            onInventory: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const InventoryScreen()),
            ),
          ),

          // ── Controls bottom bar ──────────────────────────────────────────
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: size.height * 0.28,
              color: const Color(0x66000000),
            ),
          ),

          // ── D-pad ────────────────────────────────────────────────────────
          Positioned(
            bottom: size.height * 0.045,
            left: size.width * 0.025,
            child: Row(
              children: [
                _CircleBtn(
                  size: btnSize,
                  onDown: () => setState(() => _movingLeft = true),
                  onUp: () => setState(() => _movingLeft = false),
                  child: Icon(
                    Icons.arrow_back_ios_rounded,
                    color: Colors.white70,
                    size: btnSize * 0.42,
                  ),
                ),
                SizedBox(width: btnGap),
                _CircleBtn(
                  size: btnSize,
                  onDown: () => setState(() => _movingRight = true),
                  onUp: () => setState(() => _movingRight = false),
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.white70,
                    size: btnSize * 0.42,
                  ),
                ),
              ],
            ),
          ),

          // ── A / B buttons ────────────────────────────────────────────────
          Positioned(
            bottom: size.height * 0.045,
            right: size.width * 0.025,
            child: Row(
              children: [
                _LabelBtn(
                  label: 'A',
                  color: Colors.green,
                  size: btnSize,
                  onTap: _interact,
                ),
                SizedBox(width: btnGap),
                _LabelBtn(
                  label: 'B',
                  color: Colors.red,
                  size: btnSize,
                  onTap: _jump,
                ),
              ],
            ),
          ),

          // ── Pause button ─────────────────────────────────────────────────
          Positioned(
            top: size.height * 0.115,
            right: size.width * 0.025,
            child: GestureDetector(
              onTap: () {
                _ticker.stop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const OptionsScreen(isInGame: true),
                  ),
                ).then((_) {
                  _last = Duration.zero;
                  _ticker.start();
                });
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0x99000000),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.white38),
                ),
                child: Icon(
                  Icons.pause,
                  color: Colors.white,
                  size: size.height * 0.05,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Platform painter ──────────────────────────────────────────────────────────
class _PlatformPainter extends CustomPainter {
  final List<LevelPlatform> platforms;
  final double worldX;
  const _PlatformPainter({required this.platforms, required this.worldX});

  @override
  void paint(Canvas canvas, Size size) {
    final grassP = Paint()..color = const Color(0xFF4CAF50);
    final dirtP = Paint()..color = const Color(0xFF7A4E2D);
    for (final p in platforms) {
      final sx = p.worldX - worldX;
      if (sx > size.width + p.width || sx < -p.width) continue;
      canvas.drawRect(Rect.fromLTWH(sx, p.screenY - 6, p.width, 6), grassP);
      canvas.drawRect(Rect.fromLTWH(sx, p.screenY, p.width, 14), dirtP);
    }
  }

  @override
  bool shouldRepaint(_PlatformPainter old) =>
      old.worldX != worldX || old.platforms != platforms;
}

// ── Token widget ──────────────────────────────────────────────────────────────
class _TokenWidget extends StatelessWidget {
  const _TokenWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFFFFD700),
        boxShadow: [BoxShadow(color: Color(0x88FFD700), blurRadius: 8)],
      ),
      child: const Icon(Icons.stars_rounded, color: Colors.white, size: 18),
    );
  }
}

// ── Hint widget ───────────────────────────────────────────────────────────────
class _HintWidget extends StatelessWidget {
  const _HintWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFF4CAF50),
        boxShadow: [BoxShadow(color: Color(0x884CAF50), blurRadius: 8)],
      ),
      child: const Icon(Icons.lightbulb, color: Colors.white, size: 18),
    );
  }
}

// ── NPC widget ────────────────────────────────────────────────────────────────
class _NPCWidget extends StatelessWidget {
  final String name;
  final bool completed;
  final Size size;
  const _NPCWidget({
    required this.name,
    required this.completed,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          name,
          style: TextStyle(
            color: Colors.white,
            fontSize: size.height * 0.022,
            shadows: const [Shadow(color: Colors.black, blurRadius: 4)],
          ),
        ),
        const SizedBox(height: 2),
        CustomPaint(
          size: Size(size.height * 0.14, size.height * 0.18),
          painter: _PixelNPCPainter(completed: completed),
        ),
      ],
    );
  }
}

class _PixelNPCPainter extends CustomPainter {
  final bool completed;
  const _PixelNPCPainter({required this.completed});

  @override
  void paint(Canvas canvas, Size s) {
    final bodyColor = completed
        ? const Color(0xFF4CAF50)
        : const Color(0xFF2196F3);
    final skin = Paint()..color = const Color(0xFFD4956A);
    final body = Paint()..color = bodyColor;
    final pants = Paint()..color = const Color(0xFF333366);
    final hair = Paint()..color = const Color(0xFF3B1F0A);
    canvas.drawRect(
      Rect.fromLTWH(s.width * 0.2, 0, s.width * 0.6, s.height * 0.18),
      hair,
    );
    canvas.drawRect(
      Rect.fromLTWH(
        s.width * 0.15,
        s.height * 0.08,
        s.width * 0.7,
        s.height * 0.22,
      ),
      skin,
    );
    canvas.drawRect(
      Rect.fromLTWH(
        s.width * 0.18,
        s.height * 0.30,
        s.width * 0.64,
        s.height * 0.32,
      ),
      body,
    );
    canvas.drawRect(
      Rect.fromLTWH(
        s.width * 0.15,
        s.height * 0.62,
        s.width * 0.28,
        s.height * 0.38,
      ),
      pants,
    );
    canvas.drawRect(
      Rect.fromLTWH(
        s.width * 0.55,
        s.height * 0.62,
        s.width * 0.28,
        s.height * 0.38,
      ),
      pants,
    );
  }

  @override
  bool shouldRepaint(_PixelNPCPainter old) => old.completed != completed;
}

// ── Circle button (D-pad) ─────────────────────────────────────────────────────
class _CircleBtn extends StatefulWidget {
  final double size;
  final Widget child;
  final VoidCallback onDown;
  final VoidCallback onUp;
  const _CircleBtn({
    required this.size,
    required this.child,
    required this.onDown,
    required this.onUp,
  });

  @override
  State<_CircleBtn> createState() => _CircleBtnState();
}

class _CircleBtnState extends State<_CircleBtn> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) {
        setState(() => _pressed = true);
        widget.onDown();
      },
      onPointerUp: (_) {
        setState(() => _pressed = false);
        widget.onUp();
      },
      onPointerCancel: (_) {
        setState(() => _pressed = false);
        widget.onUp();
      },
      child: AnimatedScale(
        scale: _pressed ? 0.90 : 1.0,
        duration: const Duration(milliseconds: 60),
        child: Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _pressed ? const Color(0x55FFFFFF) : const Color(0x33FFFFFF),
            border: Border.all(color: const Color(0xAABBBBBB), width: 3),
          ),
          child: Center(child: widget.child),
        ),
      ),
    );
  }
}

// ── Label button (A / B) ──────────────────────────────────────────────────────
class _LabelBtn extends StatefulWidget {
  final String label;
  final Color color;
  final double size;
  final VoidCallback onTap;
  const _LabelBtn({
    required this.label,
    required this.color,
    required this.size,
    required this.onTap,
  });

  @override
  State<_LabelBtn> createState() => _LabelBtnState();
}

class _LabelBtnState extends State<_LabelBtn> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) {
        setState(() => _pressed = true);
        widget.onTap();
      },
      onPointerUp: (_) => setState(() => _pressed = false),
      onPointerCancel: (_) => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.88 : 1.0,
        duration: const Duration(milliseconds: 60),
        child: Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _pressed ? const Color(0x55FFFFFF) : const Color(0x33FFFFFF),
            border: Border.all(color: const Color(0xAABBBBBB), width: 3),
          ),
          child: Center(
            child: Text(
              widget.label,
              style: TextStyle(
                fontSize: widget.size * 0.40,
                fontWeight: FontWeight.bold,
                color: widget.color,
                shadows: const [Shadow(color: Colors.black54, blurRadius: 4)],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
