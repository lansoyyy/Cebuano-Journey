import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../game/parallax_painter.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen>
    with TickerProviderStateMixin {
  late final Ticker _ticker;
  Duration _last = Duration.zero;
  double _scrollX = 0.0;

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
    setState(() => _scrollX += 60.0 * dt);
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final titleH = size.height * 0.14;
    final contentTop = titleH + size.height * 0.04;
    final slotSize = size.height * 0.50;
    final gridW = size.width * 0.44;
    final gridH = size.height * 0.54;
    final btnSize = size.height * 0.175;
    final btnGap = size.width * 0.022;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // ── Animated urban background ───────────────────────────────────
          CustomPaint(
            painter: UrbanParallaxPainter(scrollX: _scrollX),
            child: const SizedBox.expand(),
          ),

          // ── Dark overlay so UI pops ─────────────────────────────────────
          Container(color: const Color(0x55000000)),

          // ── INVENTORY title bar ─────────────────────────────────────────
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: titleH,
              color: const Color(0xBB000000),
              alignment: Alignment.center,
              child: Text(
                'INVENTORY',
                style: TextStyle(
                  fontSize: size.height * 0.075,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: 6,
                  shadows: const [Shadow(color: Colors.black, blurRadius: 8)],
                ),
              ),
            ),
          ),

          // ── Equipped slot (left) + Storage grid (right) ─────────────────
          Positioned(
            top: contentTop,
            left: 0,
            right: 0,
            bottom: size.height * 0.26,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _EquippedSlot(size: slotSize),
                SizedBox(width: size.width * 0.03),
                _StorageGrid(width: gridW, height: gridH),
              ],
            ),
          ),

          // ── Control bar background ──────────────────────────────────────
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: size.height * 0.26,
              color: const Color(0x88000000),
            ),
          ),

          // ── D-pad (bottom-left) ─────────────────────────────────────────
          Positioned(
            bottom: size.height * 0.04,
            left: size.width * 0.025,
            child: Row(
              children: [
                _CircleCtrlBtn(
                  size: btnSize,
                  child: Icon(
                    Icons.arrow_back_ios_rounded,
                    color: Colors.white70,
                    size: btnSize * 0.42,
                  ),
                ),
                SizedBox(width: btnGap),
                _CircleCtrlBtn(
                  size: btnSize,
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.white70,
                    size: btnSize * 0.42,
                  ),
                ),
              ],
            ),
          ),

          // ── A / B (bottom-right) ────────────────────────────────────────
          Positioned(
            bottom: size.height * 0.04,
            right: size.width * 0.025,
            child: Row(
              children: [
                _CircleCtrlBtn(
                  size: btnSize,
                  child: Text(
                    'A',
                    style: TextStyle(
                      fontSize: btnSize * 0.40,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ),
                SizedBox(width: btnGap),
                _CircleCtrlBtn(
                  size: btnSize,
                  child: Text(
                    'B',
                    style: TextStyle(
                      fontSize: btnSize * 0.40,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Back button (top-left) ──────────────────────────────────────
          Positioned(
            top: size.height * 0.02,
            left: size.width * 0.02,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0x99000000),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.white38),
                ),
                child: Icon(
                  Icons.arrow_back,
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

// ── Equipped slot ─────────────────────────────────────────────────────────────
class _EquippedSlot extends StatelessWidget {
  final double size;
  const _EquippedSlot({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF555555), width: 3),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFCCCCCC), Color(0xFF888888)],
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x88000000),
            blurRadius: 8,
            offset: Offset(3, 3),
          ),
        ],
      ),
      child: const Center(
        child: Icon(Icons.person, size: 56, color: Color(0x55000000)),
      ),
    );
  }
}

// ── Storage grid ──────────────────────────────────────────────────────────────
class _StorageGrid extends StatelessWidget {
  final double width;
  final double height;
  const _StorageGrid({required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/Storage.png', fit: BoxFit.fill),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.04,
              vertical: height * 0.06,
            ),
            child: GridView.count(
              crossAxisCount: 3,
              mainAxisSpacing: height * 0.06,
              crossAxisSpacing: width * 0.04,
              physics: const NeverScrollableScrollPhysics(),
              children: List.generate(
                6,
                (_) => GestureDetector(
                  onTap: () {},
                  child: Container(color: Colors.transparent),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Circle control button (inactive, display only) ────────────────────────────
class _CircleCtrlBtn extends StatelessWidget {
  final double size;
  final Widget child;
  const _CircleCtrlBtn({required this.size, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0x33FFFFFF),
        border: Border.all(color: const Color(0xAABBBBBB), width: 3),
      ),
      child: Center(child: child),
    );
  }
}
