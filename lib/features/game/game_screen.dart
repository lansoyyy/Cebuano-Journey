import 'package:flutter/material.dart';
import '../home/options_screen.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen>
    with SingleTickerProviderStateMixin {
  // Character position (normalized 0.0–1.0)
  double _charX = 0.45;
  bool _movingLeft = false;
  bool _movingRight = false;
  bool _isJumping = false;
  double _charY = 0.0; // vertical offset for jump
  late AnimationController _jumpController;
  late Animation<double> _jumpAnim;

  @override
  void initState() {
    super.initState();
    _jumpController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _jumpAnim =
        Tween<double>(begin: 0, end: -0.18).animate(
          CurvedAnimation(parent: _jumpController, curve: Curves.easeOut),
        )..addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            _jumpController.reverse();
          } else if (status == AnimationStatus.dismissed) {
            setState(() => _isJumping = false);
          }
        });
    _jumpAnim.addListener(() => setState(() => _charY = _jumpAnim.value));

    // Continuous movement loop
    _runMovementLoop();
  }

  void _runMovementLoop() {
    Future.delayed(const Duration(milliseconds: 16), () {
      if (!mounted) return;
      setState(() {
        if (_movingLeft) _charX = (_charX - 0.005).clamp(0.05, 0.95);
        if (_movingRight) _charX = (_charX + 0.005).clamp(0.05, 0.95);
      });
      _runMovementLoop();
    });
  }

  void _jump() {
    if (!_isJumping) {
      setState(() => _isJumping = true);
      _jumpController.forward();
    }
  }

  @override
  void dispose() {
    _jumpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Game background
          CustomPaint(
            painter: _GameLevelPainter(),
            child: const SizedBox.expand(),
          ),

          // ── Character ────────────────────────────────────────────────────
          Positioned(
            left: _charX * size.width - 20,
            top: (size.height * 0.52 + _charY * size.height) - 60,
            child: _CharacterSprite(size: size),
          ),

          // ── HUD top-right: Pause/Option button ───────────────────────────
          Positioned(
            top: size.height * 0.03,
            right: size.width * 0.02,
            child: _HudButton(
              icon: Icons.pause,
              size: size,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const OptionsScreen(isInGame: true),
                ),
              ),
            ),
          ),

          // ── Left/Right D-pad (bottom-left) ───────────────────────────────
          Positioned(
            bottom: size.height * 0.06,
            left: size.width * 0.02,
            child: Row(
              children: [
                // Backward (mirrored Forward.png)
                _DpadButton(
                  child: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationY(3.14159),
                    child: Image.asset(
                      'assets/images/Forward.png',
                      width: size.height * 0.18,
                      height: size.height * 0.18,
                      fit: BoxFit.contain,
                    ),
                  ),
                  onPointerDown: () => setState(() => _movingLeft = true),
                  onPointerUp: () => setState(() => _movingLeft = false),
                ),
                SizedBox(width: size.width * 0.02),
                // Forward
                _DpadButton(
                  child: Image.asset(
                    'assets/images/Forward.png',
                    width: size.height * 0.18,
                    height: size.height * 0.18,
                    fit: BoxFit.contain,
                  ),
                  onPointerDown: () => setState(() => _movingRight = true),
                  onPointerUp: () => setState(() => _movingRight = false),
                ),
              ],
            ),
          ),

          // ── A (Interact) + B (Jump) buttons (bottom-right) ───────────────
          Positioned(
            bottom: size.height * 0.06,
            right: size.width * 0.02,
            child: Row(
              children: [
                // A — interaction
                _ActionButton(
                  label: 'A',
                  size: size,
                  color: const Color(0xFF888888),
                  onTap: () {
                    // Future: trigger interaction
                  },
                ),
                SizedBox(width: size.width * 0.025),
                // B — jump
                _ActionButton(
                  label: 'B',
                  size: size,
                  color: const Color(0xFF888888),
                  onTap: _jump,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Character Sprite ──────────────────────────────────────────────────────────
class _CharacterSprite extends StatelessWidget {
  final Size size;
  const _CharacterSprite({required this.size});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/user (1).png',
      width: 40,
      height: 60,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => Container(
        width: 40,
        height: 60,
        decoration: BoxDecoration(
          color: const Color(0xFFCC3366),
          borderRadius: BorderRadius.circular(4),
        ),
        child: const Icon(Icons.person, color: Colors.white, size: 36),
      ),
    );
  }
}

// ── D-pad Button (hold-to-move) ───────────────────────────────────────────────
class _DpadButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onPointerDown;
  final VoidCallback onPointerUp;

  const _DpadButton({
    required this.child,
    required this.onPointerDown,
    required this.onPointerUp,
  });

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) => onPointerDown(),
      onPointerUp: (_) => onPointerUp(),
      onPointerCancel: (_) => onPointerUp(),
      child: child,
    );
  }
}

// ── Action Button (A / B) ─────────────────────────────────────────────────────
class _ActionButton extends StatefulWidget {
  final String label;
  final Size size;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.size,
    required this.color,
    required this.onTap,
  });

  @override
  State<_ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<_ActionButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final btnSize = widget.size.height * 0.18;
    return Listener(
      onPointerDown: (_) {
        setState(() => _pressed = true);
        widget.onTap();
      },
      onPointerUp: (_) => setState(() => _pressed = false),
      onPointerCancel: (_) => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.90 : 1.0,
        duration: const Duration(milliseconds: 80),
        child: Container(
          width: btnSize,
          height: btnSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _pressed ? const Color(0xAABBBBBB) : const Color(0x88AAAAAA),
            border: Border.all(color: const Color(0xCCCCCCCC), width: 3),
          ),
          child: Center(
            child: Text(
              widget.label,
              style: TextStyle(
                fontFamily: 'Bold',
                fontSize: btnSize * 0.38,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── HUD Pause Button ──────────────────────────────────────────────────────────
class _HudButton extends StatelessWidget {
  final IconData icon;
  final Size size;
  final VoidCallback onTap;

  const _HudButton({
    required this.icon,
    required this.size,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xAA000000),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white38),
        ),
        child: Icon(icon, color: Colors.white, size: size.height * 0.05),
      ),
    );
  }
}

// ── Game Level Background Painter ─────────────────────────────────────────────
class _GameLevelPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size s) {
    // Sky
    canvas.drawRect(
      Rect.fromLTWH(0, 0, s.width, s.height),
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF87CEEB), Color(0xFF5BB0D4)],
        ).createShader(Rect.fromLTWH(0, 0, s.width, s.height)),
    );

    // Distant hills
    final hillPaint = Paint()..color = const Color(0xFF4A7C59);
    final hillPath = Path()
      ..moveTo(0, s.height * 0.55)
      ..lineTo(s.width * 0.12, s.height * 0.38)
      ..lineTo(s.width * 0.25, s.height * 0.50)
      ..lineTo(s.width * 0.38, s.height * 0.32)
      ..lineTo(s.width * 0.52, s.height * 0.48)
      ..lineTo(s.width * 0.65, s.height * 0.35)
      ..lineTo(s.width * 0.80, s.height * 0.50)
      ..lineTo(s.width * 0.92, s.height * 0.40)
      ..lineTo(s.width, s.height * 0.48)
      ..lineTo(s.width, s.height * 0.55)
      ..close();
    canvas.drawPath(hillPath, hillPaint);

    // Ground (dirt)
    canvas.drawRect(
      Rect.fromLTWH(0, s.height * 0.58, s.width, s.height * 0.42),
      Paint()..color = const Color(0xFF7A4E2D),
    );

    // Grass on top
    canvas.drawRect(
      Rect.fromLTWH(0, s.height * 0.56, s.width, s.height * 0.045),
      Paint()..color = const Color(0xFF4CAF50),
    );

    // Pixel grass tufts
    final tuffPaint = Paint()..color = const Color(0xFF388E3C);
    for (int i = 0; i < 25; i++) {
      canvas.drawRect(
        Rect.fromLTWH(
          s.width * (i / 25.0),
          s.height * 0.540,
          s.width * 0.018,
          s.height * 0.028,
        ),
        tuffPaint,
      );
    }

    // Some platform tiles
    _drawPlatform(canvas, s, 0.20, 0.40, 0.12);
    _drawPlatform(canvas, s, 0.55, 0.35, 0.10);
    _drawPlatform(canvas, s, 0.78, 0.42, 0.08);
  }

  void _drawPlatform(
    Canvas c,
    Size s,
    double xRatio,
    double yRatio,
    double wRatio,
  ) {
    final x = s.width * xRatio;
    final y = s.height * yRatio;
    final w = s.width * wRatio;
    const h = 14.0;
    // Dirt
    c.drawRect(
      Rect.fromLTWH(x, y, w, h),
      Paint()..color = const Color(0xFF7A4E2D),
    );
    // Grass top
    c.drawRect(
      Rect.fromLTWH(x, y - 4, w, 8),
      Paint()..color = const Color(0xFF4CAF50),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
