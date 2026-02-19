import 'package:flutter/material.dart';
import 'game_background_painter.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Dark night background
          CustomPaint(
            painter: DarkBackgroundPainter(),
            child: const SizedBox.expand(),
          ),

          // INVENTORY title strip at top
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              color: const Color(0xCC000000),
              padding: EdgeInsets.symmetric(vertical: size.height * 0.018),
              child: Text(
                'INVENTORY',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Bold',
                  fontSize: size.height * 0.08,
                  color: Colors.white,
                  letterSpacing: 4,
                ),
              ),
            ),
          ),

          // Back button (top-left)
          Positioned(
            top: size.height * 0.02,
            left: size.width * 0.02,
            child: _BackButton(size: size),
          ),

          // Main content — equipped slot (left) + storage grid (right)
          Padding(
            padding: EdgeInsets.only(top: size.height * 0.18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Current equipped slot
                _EquippedSlot(size: size),
                SizedBox(width: size.width * 0.04),
                // Inventory grid (Storage.png)
                _StorageGrid(size: size),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  final Size size;
  const _BackButton({required this.size});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xAA000000),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white38),
        ),
        child: Icon(
          Icons.arrow_back,
          color: Colors.white,
          size: size.height * 0.05,
        ),
      ),
    );
  }
}

class _EquippedSlot extends StatelessWidget {
  final Size size;
  const _EquippedSlot({required this.size});

  @override
  Widget build(BuildContext context) {
    final slotSize = size.height * 0.52;
    return Container(
      width: slotSize,
      height: slotSize,
      decoration: BoxDecoration(
        color: const Color(0xFFB0B0B0),
        borderRadius: BorderRadius.circular(16),
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
      // Equipped item would be displayed here
      child: const Center(
        child: Icon(Icons.person, size: 60, color: Color(0x44000000)),
      ),
    );
  }
}

class _StorageGrid extends StatelessWidget {
  final Size size;
  const _StorageGrid({required this.size});

  @override
  Widget build(BuildContext context) {
    final gridW = size.width * 0.46;
    final gridH = size.height * 0.56;

    return SizedBox(
      width: gridW,
      height: gridH,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Storage.png as the grid background
          Image.asset(
            'assets/images/Storage.png',
            width: gridW,
            height: gridH,
            fit: BoxFit.fill,
          ),
          // Tap areas for the 6 slots (2 rows × 3 cols) — optional interaction
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: gridW * 0.04,
              vertical: gridH * 0.06,
            ),
            child: GridView.count(
              crossAxisCount: 3,
              mainAxisSpacing: gridH * 0.06,
              crossAxisSpacing: gridW * 0.04,
              physics: const NeverScrollableScrollPhysics(),
              children: List.generate(6, (i) => _ItemSlotTap(index: i)),
            ),
          ),
        ],
      ),
    );
  }
}

class _ItemSlotTap extends StatelessWidget {
  final int index;
  const _ItemSlotTap({required this.index});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Future: show item details
      },
      child: Container(color: Colors.transparent),
    );
  }
}
