import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'options_screen.dart';
import '../game/game_screen.dart';
import 'game_background_painter.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Pixel-art painted background
          CustomPaint(
            painter: GameBackgroundPainter(),
            child: const SizedBox.expand(),
          ),

          // Philippine Flag — right side
          Positioned(
            right: size.width * 0.06,
            top: size.height * 0.12,
            child: Image.asset(
              'assets/images/Philippine Flag.png',
              height: size.height * 0.60,
              fit: BoxFit.contain,
            ),
          ),

          // Title.png (title text + shield background) + button overlay
          Center(child: _MenuPanel(size: size)),
        ],
      ),
    );
  }
}

class _MenuPanel extends StatelessWidget {
  final Size size;
  const _MenuPanel({required this.size});

  @override
  Widget build(BuildContext context) {
    // Title.png is portrait (~0.72 w:h ratio).
    // Top 38% = "Cebuano Journey" text; bottom 62% = shield shape.
    final double imgH = size.height * 0.92;
    final double imgW = imgH * 0.72;
    final double shieldTop = imgH * 0.40;
    final double btnW = imgW * 0.80;

    return SizedBox(
      width: imgW,
      height: imgH,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          // Title + shield background
          Image.asset(
            'assets/images/Title.png',
            width: imgW,
            height: imgH,
            fit: BoxFit.fill,
          ),

          // Buttons inside the shield
          Positioned(
            top: shieldTop,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _ImgButton(
                  asset: 'assets/images/Start.png',
                  width: btnW,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const GameScreen()),
                  ),
                ),
                SizedBox(height: size.height * 0.008),
                _ImgButton(
                  asset: 'assets/images/Option.png',
                  width: btnW,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const OptionsScreen(isInGame: false),
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.008),
                _ImgButton(
                  asset: 'assets/images/Exit2.png',
                  width: btnW,
                  onTap: () => SystemNavigator.pop(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ImgButton extends StatefulWidget {
  final String asset;
  final double width;
  final VoidCallback onTap;
  const _ImgButton({
    required this.asset,
    required this.width,
    required this.onTap,
  });

  @override
  State<_ImgButton> createState() => _ImgButtonState();
}

class _ImgButtonState extends State<_ImgButton> {
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
        scale: _pressed ? 0.93 : 1.0,
        duration: const Duration(milliseconds: 80),
        child: Image.asset(
          widget.asset,
          width: widget.width,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
