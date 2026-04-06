import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/player_provider.dart';
import 'options_screen.dart';
import 'level_select_screen.dart';
import 'game_background_painter.dart';

// ── Wood palette constants ────────────────────────────────────────────────────
const _kBorderColor = Color(0xFF1C0A00);

// ── Sign shape enum ───────────────────────────────────────────────────────────
enum _SignShape { rightArrow, banner, leftArrow }

// ─────────────────────────────────────────────────────────────────────────────
class MainMenuScreen extends ConsumerStatefulWidget {
  const MainMenuScreen({super.key});

  @override
  ConsumerState<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends ConsumerState<MainMenuScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(playerProvider.notifier).checkAndUpdateStreak();
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final player = ref.watch(playerProvider);

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // ── Background ────────────────────────────────────────────────────
          CustomPaint(
            painter: GameBackgroundPainter(),
            child: const SizedBox.expand(),
          ),

          // ── Title ─────────────────────────────────────────────────────────
          Positioned(
            top: size.height * 0.03,
            left: size.width * 0.03,
            right: size.width * 0.30,
            child: _GameTitle(size: size),
          ),

          // ── Philippine Flag (right side) ──────────────────────────────────
          Positioned(
            right: size.width * 0.04,
            bottom: size.height * 0.04,
            child: _PhilippineFlag(
              flagHeight: size.height * 0.30,
              poleExtraHeight: size.height * 0.22,
            ),
          ),

          // ── Wooden Signpost (center) ──────────────────────────────────────
          Positioned.fill(
            child: Center(
              child: _WoodenSignpost(
                size: size,
                onStart: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LevelSelectScreen()),
                ),
                onOption: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const OptionsScreen(isInGame: false)),
                ),
                onExit: () => SystemNavigator.pop(),
              ),
            ),
          ),

          // ── Streak + Coins badges (top-right) ────────────────────────────
          Positioned(
            top: size.height * 0.03,
            right: size.width * 0.018,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (player.streakDays > 0)
                  _BadgeChip(
                    icon: Icons.local_fire_department,
                    iconColor: const Color(0xFFFF6B00),
                    label: '${player.streakDays} day streak',
                    size: size,
                  ),
                SizedBox(height: size.height * 0.010),
                _BadgeChip(
                  icon: Icons.toll,
                  iconColor: const Color(0xFFFFD700),
                  label: '${player.coins} coins',
                  size: size,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Game Title ────────────────────────────────────────────────────────────────
class _GameTitle extends StatelessWidget {
  final Size size;
  const _GameTitle({required this.size});

  @override
  Widget build(BuildContext context) {
    final fontSize = size.height * 0.195;
    final outlinePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = fontSize * 0.055
      ..color = const Color(0xCC2A1200);

    final baseStyle = TextStyle(
      fontFamily: 'Bold',
      fontSize: fontSize,
      letterSpacing: fontSize * 0.01,
      height: 1.0,
    );

    return Stack(
      children: [
        // Outline layer
        Text(
          'Cebuano\nJourney',
          style: baseStyle.copyWith(foreground: outlinePaint),
        ),
        // Fill layer
        Text(
          'Cebuano\nJourney',
          style: baseStyle.copyWith(
            color: const Color(0xCCC8BAA4),
            shadows: const [
              Shadow(
                color: Color(0x994A2A00),
                offset: Offset(4, 5),
                blurRadius: 3,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Badge Chip ────────────────────────────────────────────────────────────────
class _BadgeChip extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final Size size;

  const _BadgeChip({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: size.width * 0.016,
        vertical: size.height * 0.008,
      ),
      decoration: BoxDecoration(
        color: const Color(0xCC0D1B3E),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white24),
        boxShadow: const [
          BoxShadow(color: Color(0x44000000), blurRadius: 4, offset: Offset(1, 2)),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: iconColor, size: size.height * 0.030),
          SizedBox(width: size.width * 0.008),
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Bold',
              fontSize: size.height * 0.024,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Wooden Signpost ───────────────────────────────────────────────────────────
class _WoodenSignpost extends StatelessWidget {
  final Size size;
  final VoidCallback onStart, onOption, onExit;

  const _WoodenSignpost({
    required this.size,
    required this.onStart,
    required this.onOption,
    required this.onExit,
  });

  @override
  Widget build(BuildContext context) {
    final postW = size.width * 0.046;
    final signW = size.width * 0.400;
    final signH = size.height * 0.170;
    final gap = size.height * 0.018;
    final capW = size.width * 0.055;
    final capH = size.height * 0.072;
    final bottomPost = size.height * 0.220;

    final totalW = signW + size.width * 0.022; // arrow overhang room
    final totalH =
        capH + gap + signH + gap + signH + gap + signH + bottomPost;

    return SizedBox(
      width: totalW,
      height: totalH,
      child: Stack(
        children: [
          // ── Vertical post (behind everything) ──────────────────────────
          Positioned(
            left: totalW / 2 - postW / 2,
            top: 0,
            bottom: 0,
            width: postW,
            child: DecoratedBox(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Color(0xFF2E1500),
                    Color(0xFF7A4E1A),
                    Color(0xFF9A6828),
                    Color(0xFF7A4E1A),
                    Color(0xFF2E1500),
                  ],
                  stops: [0.0, 0.25, 0.50, 0.75, 1.0],
                ),
              ),
            ),
          ),

          // ── Post cap (dark block at top) ────────────────────────────────
          Positioned(
            top: 0,
            left: totalW / 2 - capW / 2,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: capW * 0.80,
                  height: capH * 0.46,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1C0A00),
                    border: Border.all(color: Colors.black, width: 1.5),
                  ),
                ),
                Container(
                  width: capW,
                  height: capH * 0.54,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFF4A2808), Color(0xFF1C0A00)],
                    ),
                    border: Border.all(color: Colors.black, width: 1.5),
                  ),
                ),
              ],
            ),
          ),

          // ── Start sign ─────────────────────────────────────────────────
          Positioned(
            top: capH + gap,
            left: 0,
            child: _SignButton(
              label: 'Start',
              width: signW + size.width * 0.020,
              height: signH,
              shape: _SignShape.rightArrow,
              woodBase: const Color(0xFF9B7A42),
              woodLight: const Color(0xFFC6A262),
              woodDark: const Color(0xFF5C3A10),
              border: _kBorderColor,
              textColor: const Color(0xFF46D4E8),
              fontSize: signH * 0.50,
              onTap: onStart,
            ),
          ),

          // ── Option sign ─────────────────────────────────────────────────
          Positioned(
            top: capH + gap + signH + gap,
            left: size.width * 0.004,
            child: _SignButton(
              label: 'Option',
              width: signW - size.width * 0.010,
              height: signH,
              shape: _SignShape.banner,
              woodBase: const Color(0xFF7A5A2C),
              woodLight: const Color(0xFFA07840),
              woodDark: const Color(0xFF3E2408),
              border: _kBorderColor,
              textColor: Colors.white,
              fontSize: signH * 0.48,
              onTap: onOption,
            ),
          ),

          // ── Exit sign ──────────────────────────────────────────────────
          Positioned(
            top: capH + gap + signH * 2 + gap * 2,
            left: size.width * 0.010,
            child: _SignButton(
              label: 'Exit',
              width: signW - size.width * 0.030,
              height: signH,
              shape: _SignShape.banner,
              woodBase: const Color(0xFF665030),
              woodLight: const Color(0xFF887048),
              woodDark: const Color(0xFF362010),
              border: _kBorderColor,
              textColor: const Color(0xFFCCA87C),
              fontSize: signH * 0.48,
              onTap: onExit,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Sign Button ───────────────────────────────────────────────────────────────
class _SignButton extends StatefulWidget {
  final String label;
  final double width, height, fontSize;
  final _SignShape shape;
  final Color woodBase, woodLight, woodDark, border, textColor;
  final VoidCallback onTap;

  const _SignButton({
    required this.label,
    required this.width,
    required this.height,
    required this.shape,
    required this.woodBase,
    required this.woodLight,
    required this.woodDark,
    required this.border,
    required this.textColor,
    required this.fontSize,
    required this.onTap,
  });

  @override
  State<_SignButton> createState() => _SignButtonState();
}

class _SignButtonState extends State<_SignButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.91 : 1.0,
        duration: const Duration(milliseconds: 70),
        child: CustomPaint(
          painter: _SignPainter(
            base: widget.woodBase,
            light: widget.woodLight,
            dark: widget.woodDark,
            border: widget.border,
            shape: widget.shape,
          ),
          child: SizedBox(
            width: widget.width,
            height: widget.height,
            child: Align(
              alignment: widget.shape == _SignShape.rightArrow
                  ? const Alignment(0.15, 0)
                  : widget.shape == _SignShape.leftArrow
                      ? const Alignment(-0.15, 0)
                      : Alignment.center,
              child: Text(
                widget.label,
                style: TextStyle(
                  fontFamily: 'Bold',
                  color: widget.textColor,
                  fontSize: widget.fontSize,
                  letterSpacing: 1.5,
                  shadows: const [
                    Shadow(
                      color: Color(0xAA000000),
                      offset: Offset(2, 2),
                      blurRadius: 2,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Sign Painter ──────────────────────────────────────────────────────────────
class _SignPainter extends CustomPainter {
  final Color base, light, dark, border;
  final _SignShape shape;

  const _SignPainter({
    required this.base,
    required this.light,
    required this.dark,
    required this.border,
    required this.shape,
  });

  @override
  void paint(Canvas canvas, Size s) {
    final w = s.width;
    final h = s.height;
    final path = _buildPath(w, h);

    // Drop shadow
    canvas.drawPath(
      path.shift(const Offset(4, 6)),
      Paint()
        ..color = const Color(0x55000000)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5),
    );

    // Gradient fill
    canvas.drawPath(
      path,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [light, base, dark],
          stops: const [0.0, 0.42, 1.0],
        ).createShader(Rect.fromLTWH(0, 0, w, h)),
    );

    // Wood grain (clipped horizontal lines)
    canvas.save();
    canvas.clipPath(path);
    final grainPaint = Paint()
      ..color = dark.withAlpha(45)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;
    for (double y = h * 0.30; y < h; y += h * 0.30) {
      canvas.drawLine(Offset(0, y), Offset(w, y + 1.5), grainPaint);
    }
    // Top highlight edge
    canvas.drawLine(
      const Offset(0, 3),
      Offset(w, 3),
      Paint()
        ..color = light.withAlpha(90)
        ..strokeWidth = 2.0
        ..style = PaintingStyle.stroke,
    );
    canvas.restore();

    // Border outline
    canvas.drawPath(
      path,
      Paint()
        ..color = border
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5,
    );
  }

  Path _buildPath(double w, double h) {
    switch (shape) {
      case _SignShape.rightArrow:
        return Path()
          ..moveTo(0, h * 0.16)
          ..lineTo(w * 0.80, 0)
          ..lineTo(w, h * 0.50)
          ..lineTo(w * 0.80, h)
          ..lineTo(0, h * 0.84)
          ..lineTo(w * 0.17, h * 0.50)
          ..close();
      case _SignShape.banner:
        return Path()
          ..moveTo(w * 0.11, 0)
          ..lineTo(w * 0.89, 0)
          ..lineTo(w, h * 0.50)
          ..lineTo(w * 0.89, h)
          ..lineTo(w * 0.11, h)
          ..lineTo(0, h * 0.50)
          ..close();
      case _SignShape.leftArrow:
        return Path()
          ..moveTo(w, h * 0.16)
          ..lineTo(w * 0.20, 0)
          ..lineTo(0, h * 0.50)
          ..lineTo(w * 0.20, h)
          ..lineTo(w, h * 0.84)
          ..lineTo(w * 0.83, h * 0.50)
          ..close();
    }
  }

  @override
  bool shouldRepaint(_SignPainter old) =>
      old.shape != shape || old.base != base;
}

// ── Philippine Flag ───────────────────────────────────────────────────────────
class _PhilippineFlag extends StatelessWidget {
  final double flagHeight;
  final double poleExtraHeight;

  const _PhilippineFlag({
    required this.flagHeight,
    required this.poleExtraHeight,
  });

  @override
  Widget build(BuildContext context) {
    final flagWidth = flagHeight * 2.0;
    final poleWidth = flagHeight * 0.045;
    final poleTotal = flagHeight + poleExtraHeight;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Pole
        Container(
          width: poleWidth,
          height: poleTotal,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Color(0xFF3A2008), Color(0xFF7A5028), Color(0xFF3A2008)],
              stops: [0.0, 0.50, 1.0],
            ),
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(poleWidth / 2),
            ),
          ),
        ),
        // Flag body
        Container(
          decoration: BoxDecoration(
            boxShadow: const [
              BoxShadow(
                color: Color(0x55000000),
                blurRadius: 6,
                offset: Offset(3, 3),
              ),
            ],
          ),
          child: CustomPaint(
            painter: _FlagPainter(),
            size: Size(flagWidth, flagHeight),
          ),
        ),
      ],
    );
  }
}

// ── Flag Painter ──────────────────────────────────────────────────────────────
class _FlagPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size s) {
    final w = s.width;
    final h = s.height;
    const sqrt3 = 1.7320508075688772;
    final triTipX = h * sqrt3 / 2.0;

    // Blue top half
    canvas.drawRect(
      Rect.fromLTWH(0, 0, w, h / 2),
      Paint()..color = const Color(0xFF0038A8),
    );
    // Red bottom half
    canvas.drawRect(
      Rect.fromLTWH(0, h / 2, w, h / 2),
      Paint()..color = const Color(0xFFCE1126),
    );

    // White equilateral triangle
    final triPath = Path()
      ..moveTo(0, 0)
      ..lineTo(triTipX, h / 2)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(triPath, Paint()..color = Colors.white);

    // Gold paint (sun + stars)
    final goldPaint = Paint()..color = const Color(0xFFFCD116);
    final sunCX = triTipX * 0.42;
    final sunCY = h / 2;
    final sunR = h * 0.115;
    final rayLen = sunR * 0.88;
    final rayW = sunR * 0.22;
    final innerRayW = sunR * 0.08;

    // Clip to white triangle for sun/rays/stars
    canvas.save();
    canvas.clipPath(triPath);

    // 8 Sun rays
    for (int i = 0; i < 8; i++) {
      final angle = i * pi / 4;
      canvas.save();
      canvas.translate(sunCX, sunCY);
      canvas.rotate(angle);
      canvas.drawPath(
        Path()
          ..moveTo(-rayW / 2, sunR)
          ..lineTo(rayW / 2, sunR)
          ..lineTo(innerRayW / 2, sunR + rayLen)
          ..lineTo(-innerRayW / 2, sunR + rayLen)
          ..close(),
        goldPaint,
      );
      canvas.restore();
    }
    // Sun circle
    canvas.drawCircle(Offset(sunCX, sunCY), sunR, goldPaint);

    // 3 five-pointed stars at triangle corners
    _drawStar(canvas, Offset(triTipX * 0.19, h * 0.16), h * 0.060, goldPaint);
    _drawStar(canvas, Offset(triTipX * 0.19, h * 0.84), h * 0.060, goldPaint);
    _drawStar(canvas, Offset(triTipX * 0.76, h * 0.50), h * 0.060, goldPaint);

    canvas.restore();

    // Flag border
    canvas.drawRect(
      Rect.fromLTWH(0, 0, w, h),
      Paint()
        ..color = const Color(0x44000000)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
  }

  void _drawStar(Canvas canvas, Offset center, double r, Paint paint) {
    final innerR = r * 0.40;
    final path = Path();
    for (int i = 0; i < 5; i++) {
      final outerA = i * 2 * pi / 5 - pi / 2;
      final innerA = (i + 0.5) * 2 * pi / 5 - pi / 2;
      final outerPt =
          Offset(center.dx + r * cos(outerA), center.dy + r * sin(outerA));
      final innerPt = Offset(
          center.dx + innerR * cos(innerA), center.dy + innerR * sin(innerA));
      if (i == 0) {
        path.moveTo(outerPt.dx, outerPt.dy);
      } else {
        path.lineTo(outerPt.dx, outerPt.dy);
      }
      path.lineTo(innerPt.dx, innerPt.dy);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

