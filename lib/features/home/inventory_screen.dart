import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/player_provider.dart';
import '../../data/cebuano_word_bank.dart';
import '../game/parallax_painter.dart';

class InventoryScreen extends ConsumerStatefulWidget {
  const InventoryScreen({super.key});

  @override
  ConsumerState<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends ConsumerState<InventoryScreen>
    with TickerProviderStateMixin {
  late final Ticker _ticker;
  Duration _last = Duration.zero;
  double _scrollX = 0.0;
  String? _selectedCategory;

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

  static const _categories = [
    'All',
    'Greetings',
    'Numbers',
    'Colors',
    'Food',
    'Family',
    'Places',
    'Verbs',
    'Adjectives',
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final titleH = size.height * 0.13;
    final player = ref.watch(playerProvider);

    final allCollected = CebuanoWordBank.words
        .where((w) => player.collectedWordIds.contains(w.id))
        .toList();
    final filtered = _selectedCategory == null || _selectedCategory == 'All'
        ? allCollected
        : allCollected.where((w) => w.category == _selectedCategory).toList();

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // ── Animated urban background ────────────────────────────────────
          CustomPaint(
            painter: UrbanParallaxPainter(scrollX: _scrollX),
            child: const SizedBox.expand(),
          ),
          Container(color: const Color(0x66000000)),

          // ── Title bar ───────────────────────────────────────────────────
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: titleH,
              color: const Color(0xBB000000),
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.02),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: size.height * 0.05,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'INVENTORY',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: size.height * 0.060,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 4,
                      ),
                    ),
                  ),
                  // Hint powerup counter
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A4A2A),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.lightbulb,
                          color: Color(0xFFFFD700),
                          size: 18,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'x${player.hintCount} Hints',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Category filter chips ───────────────────────────────────────
          Positioned(
            top: titleH + 6,
            left: 0,
            right: 0,
            child: SizedBox(
              height: size.height * 0.075,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.015,
                  vertical: 6,
                ),
                children: _categories.map((cat) {
                  final active = (_selectedCategory ?? 'All') == cat;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedCategory = cat),
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: active
                            ? const Color(0xFFFFD700)
                            : const Color(0x441A3A5C),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: active
                              ? const Color(0xFFFFD700)
                              : Colors.white24,
                        ),
                      ),
                      child: Text(
                        cat,
                        style: TextStyle(
                          color: active ? Colors.black : Colors.white,
                          fontWeight: active
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // ── Word cards grid ─────────────────────────────────────────────
          Positioned(
            top: titleH + size.height * 0.085,
            left: 0,
            right: 0,
            bottom: 0,
            child: filtered.isEmpty
                ? Center(
                    child: Text(
                      'No words collected yet.\nExplore levels to find words!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: size.height * 0.03,
                      ),
                    ),
                  )
                : GridView.builder(
                    padding: EdgeInsets.all(size.width * 0.015),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 1.5,
                    ),
                    itemCount: filtered.length,
                    itemBuilder: (_, i) => _WordCard(word: filtered[i]),
                  ),
          ),
        ],
      ),
    );
  }
}

// ── Word card ─────────────────────────────────────────────────────────────────
class _WordCard extends StatefulWidget {
  final dynamic word;
  const _WordCard({required this.word});

  @override
  State<_WordCard> createState() => _WordCardState();
}

class _WordCardState extends State<_WordCard> {
  bool _flipped = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _flipped = !_flipped),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: _flipped ? const Color(0xFF1A4A2A) : const Color(0xFF1A2A45),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: _flipped ? const Color(0xFF4CAF50) : const Color(0xFF3A6EA5),
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _flipped ? widget.word.english : widget.word.cebuano,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFFFFD700),
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              _flipped ? widget.word.cebuano : widget.word.english,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70, fontSize: 11),
            ),
            const SizedBox(height: 2),
            Text(
              widget.word.category,
              style: const TextStyle(color: Colors.white38, fontSize: 9),
            ),
          ],
        ),
      ),
    );
  }
}
