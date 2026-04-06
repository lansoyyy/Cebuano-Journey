import 'package:flutter/material.dart';
import 'inventory_screen.dart';
import 'game_background_painter.dart';

// ── Constants ─────────────────────────────────────────────────────────────────
const _kPanelBorder = Color(0xFF1C0A00);
const _kButtonBase = Color(0xFF8A5820);
const _kButtonLight = Color(0xFFB07838);
const _kButtonDark = Color(0xFF4A2C08);

// ─────────────────────────────────────────────────────────────────────────────
class OptionsScreen extends StatefulWidget {
  final bool isInGame;
  const OptionsScreen({super.key, required this.isInGame});

  @override
  State<OptionsScreen> createState() => _OptionsScreenState();
}

class _OptionsScreenState extends State<OptionsScreen> {
  double _soundsVol = 0.5;
  double _musicVol = 0.5;
  double _sfxVol = 0.5;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          CustomPaint(
            painter: GameBackgroundPainter(),
            child: const SizedBox.expand(),
          ),
          Center(
            child: _OptionsPanel(
              size: size,
              soundsVol: _soundsVol,
              musicVol: _musicVol,
              sfxVol: _sfxVol,
              isInGame: widget.isInGame,
              onSoundsChanged: (v) => setState(() => _soundsVol = v),
              onMusicChanged: (v) => setState(() => _musicVol = v),
              onSfxChanged: (v) => setState(() => _sfxVol = v),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Options Panel ─────────────────────────────────────────────────────────────
class _OptionsPanel extends StatelessWidget {
  final Size size;
  final double soundsVol, musicVol, sfxVol;
  final bool isInGame;
  final ValueChanged<double> onSoundsChanged, onMusicChanged, onSfxChanged;

  const _OptionsPanel({
    required this.size,
    required this.soundsVol,
    required this.musicVol,
    required this.sfxVol,
    required this.isInGame,
    required this.onSoundsChanged,
    required this.onMusicChanged,
    required this.onSfxChanged,
  });

  @override
  Widget build(BuildContext context) {
    final panelW = size.width * 0.42;
    final panelH = size.height * 0.96;
    final innerW = panelW * 0.80;
    final tabH = panelH * 0.090;
    final btnH = panelH * 0.110;
    final btnSmH = panelH * 0.095;
    final sliderSpacing = panelH * 0.028;

    return SizedBox(
      width: panelW,
      height: panelH,
      child: Stack(
        children: [
          // ── Shield panel background ──────────────────────────────────
          CustomPaint(
            painter: _ShieldPainter(),
            size: Size(panelW, panelH),
          ),

          // ── "Option" tab at top ──────────────────────────────────────
          Positioned(
            top: 0,
            left: panelW / 2 - innerW * 0.45,
            child: _OptionTab(
              width: innerW * 0.90,
              height: tabH,
            ),
          ),

          // ── Content ──────────────────────────────────────────────────
          Positioned(
            top: tabH + panelH * 0.028,
            left: panelW * 0.100,
            right: panelW * 0.100,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _WoodSliderRow(
                  label: 'Sounds',
                  value: soundsVol,
                  width: innerW,
                  height: panelH * 0.075,
                  onChanged: onSoundsChanged,
                ),
                SizedBox(height: sliderSpacing),
                _WoodSliderRow(
                  label: 'Music',
                  value: musicVol,
                  width: innerW,
                  height: panelH * 0.075,
                  onChanged: onMusicChanged,
                ),
                SizedBox(height: sliderSpacing),
                _WoodSliderRow(
                  label: 'SFX',
                  value: sfxVol,
                  width: innerW,
                  height: panelH * 0.075,
                  onChanged: onSfxChanged,
                ),
                SizedBox(height: panelH * 0.040),
                _WoodButton(
                  label: 'Inventory',
                  width: innerW,
                  height: btnH,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const InventoryScreen()),
                  ),
                ),
                if (isInGame) ...[
                  SizedBox(height: panelH * 0.022),
                  _WoodButton(
                    label: 'Back to Game',
                    width: innerW,
                    height: btnH,
                    onTap: () => Navigator.pop(context),
                  ),
                ],
                SizedBox(height: panelH * 0.022),
                _WoodButton(
                  label: 'Exit',
                  width: innerW * 0.62,
                  height: btnSmH,
                  isExit: true,
                  onTap: () {
                    if (isInGame) {
                      Navigator.of(context).popUntil((r) => r.isFirst);
                    } else {
                      Navigator.pop(context);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Shield Painter ────────────────────────────────────────────────────────────
class _ShieldPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size s) {
    final w = s.width;
    final h = s.height;
    final r = w * 0.065;

    final path = Path()
      ..moveTo(r, 0)
      ..lineTo(w - r, 0)
      ..quadraticBezierTo(w, 0, w, r)
      ..lineTo(w, h * 0.82)
      ..lineTo(w / 2, h)
      ..lineTo(0, h * 0.82)
      ..lineTo(0, r)
      ..quadraticBezierTo(0, 0, r, 0)
      ..close();

    // Drop shadow
    canvas.drawPath(
      path.shift(const Offset(6, 8)),
      Paint()
        ..color = const Color(0x66000000)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10),
    );

    // Wood fill gradient
    canvas.drawPath(
      path,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFC48A3C),
            Color(0xFFA06828),
            Color(0xFF885218),
            Color(0xFF704010),
          ],
          stops: [0.0, 0.35, 0.70, 1.0],
        ).createShader(Rect.fromLTWH(0, 0, w, h)),
    );

    // Wood grain
    canvas.save();
    canvas.clipPath(path);
    final grainPaint = Paint()
      ..color = const Color(0x25000000)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;
    for (double y = h * 0.06; y < h; y += h * 0.065) {
      canvas.drawLine(Offset(0, y), Offset(w, y + 0.8), grainPaint);
    }
    // Left/right inner highlight strips
    final edgePaint = Paint()
      ..color = const Color(0x18FFFFFF)
      ..strokeWidth = w * 0.028
      ..style = PaintingStyle.stroke;
    canvas.drawLine(
        Offset(w * 0.022, r), Offset(w * 0.022, h * 0.80), edgePaint);
    canvas.drawLine(
        Offset(w * 0.978, r), Offset(w * 0.978, h * 0.80), edgePaint);
    canvas.restore();

    // Border
    canvas.drawPath(
      path,
      Paint()
        ..color = _kPanelBorder
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.0,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ── Option Tab ────────────────────────────────────────────────────────────────
class _OptionTab extends StatelessWidget {
  final double width, height;
  const _OptionTab({required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _TabPainter(),
      child: SizedBox(
        width: width,
        height: height,
        child: Center(
          child: Text(
            'Option',
            style: TextStyle(
              fontFamily: 'Bold',
              color: Colors.white,
              fontSize: height * 0.54,
              letterSpacing: 2,
              shadows: const [
                Shadow(
                    color: Color(0x99000000),
                    offset: Offset(2, 2),
                    blurRadius: 2),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TabPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size s) {
    final r = s.height * 0.28;
    final path = Path()
      ..moveTo(0, s.height)
      ..lineTo(0, r)
      ..quadraticBezierTo(0, 0, r, 0)
      ..lineTo(s.width - r, 0)
      ..quadraticBezierTo(s.width, 0, s.width, r)
      ..lineTo(s.width, s.height)
      ..close();

    canvas.drawPath(
      path,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFCC8C38), Color(0xFF8A5418)],
        ).createShader(Rect.fromLTWH(0, 0, s.width, s.height)),
    );
    canvas.drawPath(
      path,
      Paint()
        ..color = _kPanelBorder
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ── Wood Slider Row ───────────────────────────────────────────────────────────
class _WoodSliderRow extends StatelessWidget {
  final String label;
  final double value, width, height;
  final ValueChanged<double> onChanged;

  const _WoodSliderRow({
    required this.label,
    required this.value,
    required this.width,
    required this.height,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final labelW = width * 0.30;
    final sliderW = width * 0.66;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Label pill
        Container(
          width: labelW,
          height: height,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF5A3210), Color(0xFF3A1E06)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: _kPanelBorder, width: 1.5),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontFamily: 'Bold',
                color: Colors.white,
                fontSize: height * 0.52,
                letterSpacing: 1,
              ),
            ),
          ),
        ),
        SizedBox(width: width * 0.04),
        // Slider track
        SizedBox(
          width: sliderW,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Track pill background
              Container(
                height: height * 0.42,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF2A1200), Color(0xFF4A2808), Color(0xFF2A1200)],
                    stops: [0.0, 0.50, 1.0],
                  ),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: _kPanelBorder, width: 1.5),
                ),
              ),
              // Flutter slider (transparent track, visible thumb)
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 0,
                  activeTrackColor: Colors.transparent,
                  inactiveTrackColor: Colors.transparent,
                  thumbColor: const Color(0xFF1C0A00),
                  thumbShape:
                      const RoundSliderThumbShape(enabledThumbRadius: 10),
                  overlayShape: SliderComponentShape.noOverlay,
                ),
                child: Slider(
                  value: value,
                  onChanged: onChanged,
                  min: 0,
                  max: 1,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Wood Button ───────────────────────────────────────────────────────────────
class _WoodButton extends StatefulWidget {
  final String label;
  final double width, height;
  final VoidCallback onTap;
  final bool isExit;

  const _WoodButton({
    required this.label,
    required this.width,
    required this.height,
    required this.onTap,
    this.isExit = false,
  });

  @override
  State<_WoodButton> createState() => _WoodButtonState();
}

class _WoodButtonState extends State<_WoodButton> {
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
          painter: _BannerPainter(isExit: widget.isExit),
          child: SizedBox(
            width: widget.width,
            height: widget.height,
            child: Center(
              child: Text(
                widget.label,
                style: TextStyle(
                  fontFamily: 'Bold',
                  color: Colors.white,
                  fontSize: widget.height * 0.46,
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

// ── Banner Painter (for option screen buttons) ────────────────────────────────
class _BannerPainter extends CustomPainter {
  final bool isExit;
  const _BannerPainter({this.isExit = false});

  @override
  void paint(Canvas canvas, Size s) {
    final w = s.width;
    final h = s.height;

    // Banner/chevron shape: both sides slightly notched
    final notch = isExit ? 0.16 : 0.10;
    final path = Path()
      ..moveTo(w * notch, 0)
      ..lineTo(w * (1 - notch), 0)
      ..lineTo(w, h * 0.50)
      ..lineTo(w * (1 - notch), h)
      ..lineTo(w * notch, h)
      ..lineTo(0, h * 0.50)
      ..close();

    // Drop shadow
    canvas.drawPath(
      path.shift(const Offset(3, 5)),
      Paint()
        ..color = const Color(0x55000000)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
    );

    // Gradient fill
    canvas.drawPath(
      path,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [_kButtonLight, _kButtonBase, _kButtonDark],
          stops: [0.0, 0.45, 1.0],
        ).createShader(Rect.fromLTWH(0, 0, w, h)),
    );

    // Grain
    canvas.save();
    canvas.clipPath(path);
    final grainPaint = Paint()
      ..color = _kButtonDark.withAlpha(40)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;
    for (double y = h * 0.33; y < h; y += h * 0.33) {
      canvas.drawLine(Offset(0, y), Offset(w, y + 1.2), grainPaint);
    }
    canvas.restore();

    // Border
    canvas.drawPath(
      path,
      Paint()
        ..color = _kPanelBorder
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
