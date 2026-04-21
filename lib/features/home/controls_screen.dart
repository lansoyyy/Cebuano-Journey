import 'package:flutter/material.dart';
import 'game_background_painter.dart';

class ControlsScreen extends StatelessWidget {
  const ControlsScreen({super.key});

  static const _controls = [
    _Control(icon: Icons.arrow_back_ios_rounded, color: Color(0xFF90CAF9), label: 'Move Left'),
    _Control(icon: Icons.arrow_forward_ios_rounded, color: Color(0xFF90CAF9), label: 'Move Right'),
    _Control(icon: Icons.arrow_downward_rounded, color: Color(0xFF90CAF9), label: 'Crouch (hold)'),
    _Control(letter: 'B', color: Color(0xFFEF5350), label: 'Jump / Double Jump'),
    _Control(letter: 'X', color: Color(0xFF42A5F5), label: 'Dash (has cooldown)'),
    _Control(letter: 'A', color: Color(0xFF66BB6A), label: 'Interact with NPC'),
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isPhone = size.width < 700;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          CustomPaint(
            painter: GameBackgroundPainter(),
            child: const SizedBox.expand(),
          ),
          Container(color: const Color(0x88000000)),
          SafeArea(
            child: Column(
              children: [
                // Title bar
                Container(
                  height: (size.height * 0.10).clamp(60.0, 96.0),
                  color: const Color(0xBB000000),
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: isPhone ? 28 : 36,
                        ),
                      ),
                      SizedBox(width: size.width * 0.03),
                      Text(
                        'CONTROLS',
                        style: TextStyle(
                          fontSize: isPhone ? 28 : 38,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 4,
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: Center(
                    child: Container(
                      margin: EdgeInsets.all(size.width * 0.05),
                      padding: EdgeInsets.all(size.width * 0.04),
                      decoration: BoxDecoration(
                        color: const Color(0xDD1A1A2E),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white24, width: 1.5),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          for (final ctrl in _controls) ...[
                            _ControlRow(control: ctrl, size: size),
                            if (ctrl != _controls.last)
                              Divider(color: Colors.white12, height: 1),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Data ──────────────────────────────────────────────────────────────────────
class _Control {
  final IconData? icon;
  final String? letter;
  final Color color;
  final String label;
  const _Control({
    this.icon,
    this.letter,
    required this.color,
    required this.label,
  });
}

// ── Row widget ────────────────────────────────────────────────────────────────
class _ControlRow extends StatelessWidget {
  final _Control control;
  final Size size;
  const _ControlRow({required this.control, required this.size});

  @override
  Widget build(BuildContext context) {
    final isPhone = size.width < 700;
    final btnSize = isPhone ? 44.0 : 56.0;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          // Button badge
          Container(
            width: btnSize,
            height: btnSize,
            decoration: BoxDecoration(
              color: control.color.withOpacity(0.18),
              shape: BoxShape.circle,
              border: Border.all(color: control.color, width: 2),
            ),
            child: Center(
              child: control.letter != null
                  ? Text(
                      control.letter!,
                      style: TextStyle(
                        color: control.color,
                        fontWeight: FontWeight.w900,
                        fontSize: isPhone ? 20 : 26,
                      ),
                    )
                  : Icon(
                      control.icon!,
                      color: control.color,
                      size: isPhone ? 20 : 26,
                    ),
            ),
          ),
          SizedBox(width: size.width * 0.04),
          // Description
          Expanded(
            child: Text(
              control.label,
              style: TextStyle(
                color: Colors.white,
                fontSize: isPhone ? 15 : 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
