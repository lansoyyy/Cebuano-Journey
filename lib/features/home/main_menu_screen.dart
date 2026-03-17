import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/player_provider.dart';
import 'options_screen.dart';
import 'level_select_screen.dart';
import 'game_background_painter.dart';

class MainMenuScreen extends ConsumerStatefulWidget {
  const MainMenuScreen({super.key});

  @override
  ConsumerState<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends ConsumerState<MainMenuScreen> {
  @override
  void initState() {
    super.initState();
    // Update daily streak when the player reaches the main menu
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
          // Pixel-art painted background
          CustomPaint(
            painter: GameBackgroundPainter(),
            child: const SizedBox.expand(),
          ),

          // Philippine Flag — right side
          Positioned(
            right: size.width * 0.06,
            top: size.height * 0.5,
            child: Image.asset(
              'assets/images/Philippine Flag.png',
              height: size.height * 0.3,
              fit: BoxFit.contain,
            ),
          ),

          // Streak + Coins badge — top-right
          Positioned(
            top: size.height * 0.03,
            right: size.width * 0.03,
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
                SizedBox(height: size.height * 0.008),
                _BadgeChip(
                  icon: Icons.toll,
                  iconColor: const Color(0xFFFFD700),
                  label: '${player.coins} coins',
                  size: size,
                ),
              ],
            ),
          ),

          // Title.png (title text + shield background) + button overlay
          Center(child: _MenuPanel(size: size)),
        ],
      ),
    );
  }
}

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
        horizontal: size.width * 0.018,
        vertical: size.height * 0.008,
      ),
      decoration: BoxDecoration(
        color: const Color(0xCC0D1B3E),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: iconColor, size: size.height * 0.028),
          SizedBox(width: size.width * 0.01),
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: size.height * 0.022,
              fontWeight: FontWeight.bold,
            ),
          ),
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
    final double btnW = imgW * 0.65;

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
                    MaterialPageRoute(
                      builder: (_) => const LevelSelectScreen(),
                    ),
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
