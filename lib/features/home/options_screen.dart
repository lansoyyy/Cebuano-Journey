import 'package:flutter/material.dart';
import 'inventory_screen.dart';
import 'game_background_painter.dart';

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
    // Option Menu.png is portrait: ~0.72 w:h ratio. "Option" tab at top.
    final double panelH = size.height * 0.98;
    final double panelW = panelH * 0.72;
    // Content inside panel starts below the "Option" tab (~18% from top)
    final double contentTop = panelH * 0.18;
    final double innerW = panelW * 0.78;

    return SizedBox(
      width: panelW,
      height: panelH,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          // Option Menu shield panel
          Image.asset(
            'assets/images/Option Menu.png',
            width: panelW,
            height: panelH,
            fit: BoxFit.fill,
          ),

          // Content
          Positioned(
            top: contentTop,
            child: SizedBox(
              width: innerW,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: size.height * 0.02),
                  // Sounds slider
                  _SliderRow(
                    labelAsset: 'assets/images/Sounds.png',
                    value: soundsVol,
                    onChanged: onSoundsChanged,
                    rowWidth: innerW,
                  ),
                  SizedBox(height: size.height * 0.02),
                  // Music slider
                  _SliderRow(
                    labelAsset: 'assets/images/Music.png',
                    value: musicVol,
                    onChanged: onMusicChanged,
                    rowWidth: innerW,
                  ),
                  SizedBox(height: size.height * 0.02),
                  // SFX slider
                  _SliderRow(
                    labelAsset: 'assets/images/SFX.png',
                    value: sfxVol,
                    onChanged: onSfxChanged,
                    rowWidth: innerW,
                  ),
                  SizedBox(height: size.height * 0.025),
                  // Inventory button
                  _PanelButton(
                    asset: 'assets/images/Inventory2.png',
                    width: innerW,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const InventoryScreen(),
                      ),
                    ),
                  ),
                  SizedBox(height: size.height * 0.01),
                  // Back to Game (only when in-game) OR hidden
                  if (isInGame) ...[
                    _PanelButton(
                      asset: 'assets/images/Back to Game.png',
                      width: innerW,
                      onTap: () => Navigator.pop(context),
                    ),
                    SizedBox(height: size.height * 0.01),
                  ],
                  // Exit — back to main menu
                  _PanelButton(
                    asset: 'assets/images/Exit2.png',
                    width: innerW * 0.70,
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
          ),
        ],
      ),
    );
  }
}

class _SliderRow extends StatelessWidget {
  final String labelAsset;
  final double value;
  final ValueChanged<double> onChanged;
  final double rowWidth;

  const _SliderRow({
    required this.labelAsset,
    required this.value,
    required this.onChanged,
    required this.rowWidth,
  });

  @override
  Widget build(BuildContext context) {
    final labelW = rowWidth * 0.32;
    final sliderW = rowWidth * 0.62;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(labelAsset, width: labelW, fit: BoxFit.contain),
        SizedBox(width: rowWidth * 0.04),
        SizedBox(
          width: sliderW,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Slider track image (Volume2 = base pill track)
              Image.asset(
                'assets/images/Volume2.png',
                width: sliderW,
                fit: BoxFit.fill,
                height: 28,
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 0,
                  activeTrackColor: Colors.transparent,
                  inactiveTrackColor: Colors.transparent,
                  thumbColor: const Color(0xFF1A1A1A),
                  thumbShape: const RoundSliderThumbShape(
                    enabledThumbRadius: 9,
                  ),
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

class _PanelButton extends StatefulWidget {
  final String asset;
  final double width;
  final VoidCallback onTap;
  const _PanelButton({
    required this.asset,
    required this.width,
    required this.onTap,
  });

  @override
  State<_PanelButton> createState() => _PanelButtonState();
}

class _PanelButtonState extends State<_PanelButton> {
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
