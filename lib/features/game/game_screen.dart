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
  double _gameTime = 0.0; // Track total game time for moving platforms

  // World & parallax
  double _worldX = 0.0;
  double _cloudDrift = 0.0;

  // Movement
  bool _movingLeft = false;
  bool _movingRight = false;
  bool _isCrouching = false;

  // Jump physics
  bool _isJumping = false;
  int _jumpCount = 0;
  static const int _maxJumps = 2; // Double jump
  double _jumpY = 0.0;
  double _jumpVY = 0.0;

  // Dash physics
  bool _isDashing = false;
  double _dashCooldown = 0.0;
  static const double _dashDuration = 0.15;
  static const double _dashCooldownTime = 1.0;
  static const double _dashSpeed = 400.0;

  static const double _speed = 130.0;
  static const double _sprintSpeed = 200.0;
  static const double _jumpImpulse = -300.0;
  static const double _gravity = 600.0;

  // Crouch physics
  static const double _crouchSpeed = 65.0; // Half speed when crouching
  static const double _crouchHeightMultiplier =
      0.6; // Character is 60% height when crouching

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
    _gameTime += dt; // Track game time for moving platforms
    setState(() {
      _cloudDrift += 18.0 * dt;

      // Update dash cooldown
      if (_dashCooldown > 0) {
        _dashCooldown -= dt;
      }

      // Handle dash
      if (_isDashing) {
        _dashCooldown = _dashCooldownTime;
        // Dash ends after duration
        if (_dashCooldown >= _dashCooldownTime - _dashDuration) {
          _isDashing = false;
        }
      }

      // Apply movement speed (sprint when dashing, crouch when crouching)
      final currentSpeed = _isDashing
          ? _dashSpeed
          : (_isCrouching ? _crouchSpeed : _speed);

      if (_movingLeft) {
        _worldX = (_worldX - currentSpeed * dt).clamp(0, double.infinity);
      }
      if (_movingRight) {
        _worldX = (_worldX + currentSpeed * dt).clamp(
          0,
          _levelData?.worldLength ?? double.infinity,
        );
      }

      // Jump physics with double jump
      if (_isJumping) {
        _jumpVY += _gravity * dt;
        _jumpY += _jumpVY * dt;
        if (_jumpY >= 0) {
          _jumpY = 0;
          _jumpVY = 0;
          _isJumping = false;
          _jumpCount = 0; // Reset jump count when landing
        }
      }

      // Animation and facing
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
    final size = MediaQuery.of(context).size;
    final groundY = size.height * 0.64;
    final charH =
        size.height * 0.20 * (_isCrouching ? _crouchHeightMultiplier : 1.0);

    for (final token in _levelData!.tokens) {
      if (token.collected) continue;
      final screenX = token.worldX - _worldX;
      // Also need to check vertical distance for collecting
      final charScreenX = size.width * 0.27;
      final charY = groundY - charH + _jumpY;

      if ((screenX - charScreenX).abs() < 60 &&
          (token.screenY - charY).abs() < 60) {
        token.collected = true;
        ref.read(playerProvider.notifier).collectWord(token.word.id);
      }
    }
  }

  void _checkHints() {
    if (_levelData == null) return;
    final size = MediaQuery.of(context).size;
    final groundY = size.height * 0.64;
    final charH =
        size.height * 0.20 * (_isCrouching ? _crouchHeightMultiplier : 1.0);

    for (final hint in _levelData!.hints) {
      if (hint.collected) continue;
      final screenX = hint.worldX - _worldX;
      final charScreenX = size.width * 0.27;
      final charY = groundY - charH + _jumpY;

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
    final size = MediaQuery.of(context).size;
    final groundY = size.height * 0.64;
    final charH =
        size.height * 0.20 * (_isCrouching ? _crouchHeightMultiplier : 1.0);
    final charY = groundY - charH + _jumpY;

    _nearNPC = null;
    for (final npc in _levelData!.npcs) {
      if (npc.completed) continue;
      final screenX = npc.worldX - _worldX;
      final charScreenX = size.width * 0.27;
      final npcY = groundY - size.height * 0.22;

      if ((screenX - charScreenX).abs() < 90 && (npcY - charY).abs() < 90) {
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
    // Allow jump if not jumping OR if we have jumps left (double jump)
    if (!_isJumping || (_jumpCount < _maxJumps - 1)) {
      _isJumping = true;
      _jumpVY = _jumpImpulse;
      _jumpCount++;
      // Reset jump Y slightly for double jump to feel responsive
      if (_jumpCount > 1) {
        _jumpY = -10.0;
      }
    }
  }

  void _dash() {
    if (_dashCooldown <= 0 && !_isDashing && !_isCrouching) {
      _isDashing = true;
      _dashCooldown = _dashCooldownTime;
    }
  }

  void _crouch(bool isDown) {
    if (!_isJumping) {
      setState(() => _isCrouching = isDown);
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
    final charH =
        size.height * 0.20 * (_isCrouching ? _crouchHeightMultiplier : 1.0);
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
                gameTime: _gameTime,
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
                left: sx - size.height * 0.09,
                top: groundY - size.height * 0.22,
                child: _NPCWidget(
                  name: npc.name,
                  npcId: npc.npcId,
                  completed: npc.completed,
                  isNear: _nearNPC == npc,
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
            dashCooldown: _dashCooldown,
            isCrouching: _isCrouching,
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
            child: Column(
              children: [
                Row(
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
                SizedBox(height: btnGap * 0.5),
                // Crouch button (down arrow)
                _CircleBtn(
                  size: btnSize * 0.8,
                  onDown: () => _crouch(true),
                  onUp: () => _crouch(false),
                  child: Icon(
                    Icons.arrow_downward_rounded,
                    color: _isCrouching
                        ? const Color(0xFFFFD700)
                        : Colors.white70,
                    size: btnSize * 0.35,
                  ),
                ),
              ],
            ),
          ),

          // ── A / B / X buttons ───────────────────────────────────────────
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
                SizedBox(width: btnGap),
                _LabelBtn(
                  label: 'X',
                  color: _dashCooldown <= 0
                      ? Colors.blue
                      : Colors.blue.shade900,
                  size: btnSize,
                  onTap: _dash,
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
  final double gameTime;
  const _PlatformPainter({
    required this.platforms,
    required this.worldX,
    this.gameTime = 0.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final grassP = Paint()..color = const Color(0xFF4CAF50);
    final dirtP = Paint()..color = const Color(0xFF7A4E2D);
    final movingP = Paint()..color = const Color(0xFF4CAF50).withOpacity(0.7);

    for (final p in platforms) {
      // Use getCurrentX for moving platforms
      final px = p.getCurrentX(gameTime);
      final sx = px - worldX;
      if (sx > size.width + p.width || sx < -p.width) continue;

      // Draw platform with different color if moving
      final platformPaint = p.isMoving ? movingP : grassP;
      canvas.drawRect(
        Rect.fromLTWH(sx, p.screenY - 6, p.width, 6),
        platformPaint,
      );
      canvas.drawRect(Rect.fromLTWH(sx, p.screenY, p.width, 14), dirtP);

      // Add arrow indicator for moving platforms
      if (p.isMoving) {
        final arrowP = Paint()..color = Colors.white.withOpacity(0.5);
        final arrowSize = 8.0;
        final centerX = sx + p.width / 2;
        final centerY = p.screenY - 20;
        // Draw left/right arrows
        canvas.drawCircle(
          Offset(centerX - p.moveRange / 2, centerY),
          3,
          arrowP,
        );
        canvas.drawCircle(
          Offset(centerX + p.moveRange / 2, centerY),
          3,
          arrowP,
        );
        // Draw horizontal line
        canvas.drawLine(
          Offset(centerX - p.moveRange / 2, centerY),
          Offset(centerX + p.moveRange / 2, centerY),
          arrowP,
        );
      }
    }
  }

  @override
  bool shouldRepaint(_PlatformPainter old) =>
      old.worldX != worldX ||
      old.platforms != platforms ||
      old.gameTime != gameTime;
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

// ── NPC animated sprite widget ────────────────────────────────────────────────
//
// npc1-4  → tile pattern: tile000-003.png (4 frames)
// npc5-16 → Idle000-003.png (idle), Special000-005.png (talking, if present)
//
// _kNpcMeta[npcId] = (isTile, idleCount, specialCount)
//   isTile       : true  → use tile000-N frames
//   idleCount    : number of Idle frames (or tile frames for tile NPCs)
//   specialCount : number of Special frames (0 = no special → fall back to idle)
//
const _kNpcMeta = <int, (bool, int, int)>{
  1: (true, 4, 0),
  2: (true, 4, 0),
  3: (true, 4, 0),
  4: (true, 4, 0),
  5: (false, 6, 6),
  6: (false, 4, 4),
  7: (false, 4, 6),
  8: (false, 4, 4),
  9: (false, 4, 0),
  10: (false, 4, 6),
  11: (false, 4, 6),
  12: (false, 4, 4),
  13: (false, 4, 0),
  14: (false, 4, 6),
  15: (false, 4, 0),
  16: (false, 4, 0),
};

class _NPCWidget extends StatefulWidget {
  final String name;
  final int npcId;
  final bool completed;
  final bool isNear;
  final Size size;

  const _NPCWidget({
    required this.name,
    required this.npcId,
    required this.completed,
    required this.isNear,
    required this.size,
  });

  @override
  State<_NPCWidget> createState() => _NPCWidgetState();
}

class _NPCWidgetState extends State<_NPCWidget>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  int _frame = 0;
  double _frameTimer = 0;
  static const double _fps = 1 / 8; // 8 fps

  @override
  void initState() {
    super.initState();
    Duration last = Duration.zero;
    _ticker = createTicker((elapsed) {
      final dt = last == Duration.zero
          ? 0.0
          : (elapsed - last).inMicroseconds / 1e6;
      last = elapsed;
      _frameTimer += dt;
      final meta = _kNpcMeta[widget.npcId]!;
      final useSpecial = widget.isNear && meta.$3 > 0;
      final frameCount = useSpecial ? meta.$3 : meta.$2;
      if (_frameTimer >= _fps) {
        _frameTimer -= _fps;
        setState(() => _frame = (_frame + 1) % frameCount);
      }
    })..start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  String _framePath() {
    final id = widget.npcId;
    final meta = _kNpcMeta[id]!;
    final useSpecial = widget.isNear && meta.$3 > 0;

    if (meta.$1) {
      // tile pattern
      return 'assets/images/NPC/npc$id/tile${_frame.toString().padLeft(3, '0')}.png';
    }
    final frameCount = useSpecial ? meta.$3 : meta.$2;
    final f = _frame % frameCount;
    final prefix = useSpecial ? 'Special' : 'Idle';
    return 'assets/images/NPC/npc$id/$prefix${f.toString().padLeft(3, '0')}.png';
  }

  @override
  Widget build(BuildContext context) {
    final spriteH = widget.size.height * 0.18;
    final spriteW = spriteH;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Name label
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
          decoration: BoxDecoration(
            color: widget.completed
                ? const Color(0xCC1A4A1A)
                : const Color(0xCC1A1A3A),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            widget.name,
            style: TextStyle(
              color: widget.completed ? const Color(0xFF80FF80) : Colors.white,
              fontSize: widget.size.height * 0.022,
              fontWeight: FontWeight.bold,
              shadows: const [Shadow(color: Colors.black, blurRadius: 4)],
            ),
          ),
        ),
        const SizedBox(height: 2),
        // Sprite frame
        Stack(
          alignment: Alignment.center,
          children: [
            Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..scale(-1.0, 1.0), // Flip horizontally to face left
              child: Image.asset(
                _framePath(),
                width: spriteW,
                height: spriteH,
                filterQuality: FilterQuality.none,
                fit: BoxFit.contain,
              ),
            ),
            // Green checkmark overlay when completed
            if (widget.completed)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  width: spriteW * 0.36,
                  height: spriteW * 0.36,
                  decoration: const BoxDecoration(
                    color: Color(0xFF4CAF50),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 12),
                ),
              ),
            // Pulsing "!" when near and not completed
            if (widget.isNear && !widget.completed)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  width: spriteW * 0.36,
                  height: spriteW * 0.36,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFD700),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text(
                      '!',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w900,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
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
