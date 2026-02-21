import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'parallax_painter.dart';
import '../home/options_screen.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
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
  double _jumpY = 0.0; // px offset upward (negative = up)
  double _jumpVY = 0.0; // velocity px/s

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
  static const double _frameDuration = 0.10; // 10 fps walk

  int _walkFrame = 0;
  double _frameTimer = 0.0;
  bool _facingLeft = false;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick)..start();
  }

  void _onTick(Duration elapsed) {
    final dt = _last == Duration.zero
        ? 0.0
        : (elapsed - _last).inMicroseconds / 1e6;
    _last = elapsed;
    setState(() {
      _cloudDrift += 18.0 * dt;
      if (_movingLeft) _worldX -= _speed * dt;
      if (_movingRight) _worldX += _speed * dt;

      if (_isJumping) {
        _jumpVY += _gravity * dt;
        _jumpY += _jumpVY * dt;
        if (_jumpY >= 0) {
          _jumpY = 0;
          _jumpVY = 0;
          _isJumping = false;
        }
      }

      // Sprite walk cycle
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
    });
  }

  void _jump() {
    if (!_isJumping) {
      _isJumping = true;
      _jumpVY = _jumpImpulse;
    }
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

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // ── Animated parallax background ────────────────────────────────
          CustomPaint(
            painter: ParallaxPainter(worldX: _worldX, cloudDrift: _cloudDrift),
            child: const SizedBox.expand(),
          ),

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

          // ── Controls bottom bar (semi-transparent) ───────────────────────
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: size.height * 0.28,
              color: const Color(0x66000000),
            ),
          ),

          // ── D-pad (bottom-left) ──────────────────────────────────────────
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

          // ── A / B buttons (bottom-right) ─────────────────────────────────
          Positioned(
            bottom: size.height * 0.045,
            right: size.width * 0.025,
            child: Row(
              children: [
                _LabelBtn(
                  label: 'A',
                  color: Colors.green,
                  size: btnSize,
                  onTap: () {},
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

          // ── Pause button (top-right) ──────────────────────────────────────
          Positioned(
            top: size.height * 0.04,
            right: size.width * 0.025,
            child: GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const OptionsScreen(isInGame: true),
                ),
              ),
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
                  size: size.height * 0.055,
                ),
              ),
            ),
          ),
        ],
      ),
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
