import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/player_provider.dart';
import '../../data/cebuano_word_bank.dart';
import '../../core/models/word_token.dart';
import '../game/parallax_painter.dart';

// ── View mode ─────────────────────────────────────────────────────────────────
enum _ViewMode { byCategory, byLevel }

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
  _ViewMode _viewMode = _ViewMode.byCategory;

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

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // ── Animated background ──────────────────────────────────────────
          CustomPaint(
            painter: UrbanParallaxPainter(scrollX: _scrollX),
            child: const SizedBox.expand(),
          ),
          Container(color: const Color(0x66000000)),

          // ── Title bar ────────────────────────────────────────────────────
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
                        fontSize: size.height * 0.055,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 4,
                      ),
                    ),
                  ),
                  // Word count badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A3A5C),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: Text(
                      '${allCollected.length}/${CebuanoWordBank.words.length} words',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: size.height * 0.018,
                      ),
                    ),
                  ),
                  SizedBox(width: size.width * 0.015),
                  // Hint counter
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A4A2A),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.lightbulb, color: Color(0xFFFFD700), size: 18),
                        const SizedBox(width: 4),
                        Text(
                          'x${player.hintCount} Hints',
                          style: const TextStyle(color: Colors.white, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── View-mode toggle ─────────────────────────────────────────────
          Positioned(
            top: titleH + 6,
            left: size.width * 0.015,
            right: size.width * 0.015,
            child: _ViewToggle(
              current: _viewMode,
              onChanged: (m) => setState(() => _viewMode = m),
              size: size,
            ),
          ),

          // ── Content area ─────────────────────────────────────────────────
          Positioned(
            top: titleH + size.height * 0.075,
            left: 0,
            right: 0,
            bottom: 0,
            child: _viewMode == _ViewMode.byCategory
                ? _CategoryView(
                    allCollected: allCollected,
                    categories: _categories,
                    selectedCategory: _selectedCategory,
                    onCategoryChanged: (c) =>
                        setState(() => _selectedCategory = c),
                    size: size,
                  )
                : _ByLevelView(
                    allCollected: allCollected,
                    size: size,
                  ),
          ),
        ],
      ),
    );
  }
}

// ── View-mode toggle ──────────────────────────────────────────────────────────
class _ViewToggle extends StatelessWidget {
  final _ViewMode current;
  final ValueChanged<_ViewMode> onChanged;
  final Size size;
  const _ViewToggle({
    required this.current,
    required this.onChanged,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _ToggleBtn(
          label: 'By Category',
          icon: Icons.category,
          active: current == _ViewMode.byCategory,
          onTap: () => onChanged(_ViewMode.byCategory),
          size: size,
        ),
        SizedBox(width: size.width * 0.01),
        _ToggleBtn(
          label: 'By Level',
          icon: Icons.layers,
          active: current == _ViewMode.byLevel,
          onTap: () => onChanged(_ViewMode.byLevel),
          size: size,
        ),
      ],
    );
  }
}

class _ToggleBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool active;
  final VoidCallback onTap;
  final Size size;
  const _ToggleBtn({
    required this.label,
    required this.icon,
    required this.active,
    required this.onTap,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.025,
          vertical: size.height * 0.008,
        ),
        decoration: BoxDecoration(
          color: active ? const Color(0xFFFFD700) : const Color(0x441A3A5C),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: active ? const Color(0xFFFFD700) : Colors.white24,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: active ? Colors.black : Colors.white70,
              size: size.height * 0.022,
            ),
            SizedBox(width: size.width * 0.008),
            Text(
              label,
              style: TextStyle(
                color: active ? Colors.black : Colors.white,
                fontWeight: active ? FontWeight.bold : FontWeight.normal,
                fontSize: size.height * 0.019,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── By-Category view (original behaviour) ────────────────────────────────────
class _CategoryView extends StatelessWidget {
  final List<WordToken> allCollected;
  final List<String> categories;
  final String? selectedCategory;
  final ValueChanged<String?> onCategoryChanged;
  final Size size;

  const _CategoryView({
    required this.allCollected,
    required this.categories,
    required this.selectedCategory,
    required this.onCategoryChanged,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final filtered =
        selectedCategory == null || selectedCategory == 'All'
            ? allCollected
            : allCollected.where((w) => w.category == selectedCategory).toList();

    return Column(
      children: [
        // Category chips
        SizedBox(
          height: size.height * 0.055,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.015),
            children: categories.map((cat) {
              final active = (selectedCategory ?? 'All') == cat;
              return GestureDetector(
                onTap: () => onCategoryChanged(cat),
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                  decoration: BoxDecoration(
                    color: active
                        ? const Color(0xFFFFD700)
                        : const Color(0x441A3A5C),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: active ? const Color(0xFFFFD700) : Colors.white24,
                    ),
                  ),
                  child: Text(
                    cat,
                    style: TextStyle(
                      color: active ? Colors.black : Colors.white,
                      fontWeight:
                          active ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        // Grid
        Expanded(
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
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
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
    );
  }
}

// ── By-Level view ─────────────────────────────────────────────────────────────
class _ByLevelView extends StatefulWidget {
  final List<WordToken> allCollected;
  final Size size;

  const _ByLevelView({required this.allCollected, required this.size});

  @override
  State<_ByLevelView> createState() => _ByLevelViewState();
}

class _ByLevelViewState extends State<_ByLevelView> {
  // Tracks which level sections are expanded.
  final Set<int> _expanded = {1}; // Level 1 open by default

  @override
  Widget build(BuildContext context) {
    // Group collected words by level
    final Map<int, List<WordToken>> byLevel = {};
    for (final word in widget.allCollected) {
      final lvl = CebuanoWordBank.levelForWord(word.id);
      byLevel.putIfAbsent(lvl, () => []).add(word);
    }

    if (byLevel.isEmpty) {
      return Center(
        child: Text(
          'No words collected yet.\nExplore levels to find words!',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white54, fontSize: widget.size.height * 0.03),
        ),
      );
    }

    final sortedLevels = byLevel.keys.toList()..sort();

    return ListView.builder(
      padding: EdgeInsets.symmetric(
        horizontal: widget.size.width * 0.015,
        vertical: widget.size.height * 0.01,
      ),
      itemCount: sortedLevels.length,
      itemBuilder: (_, i) {
        final lvl = sortedLevels[i];
        final words = byLevel[lvl]!;
        final isOpen = _expanded.contains(lvl);

        // Map global difficulty level to World / Level label
        final world = ((lvl - 1) ~/ 5) + 1;
        final levelInWorld = ((lvl - 1) % 5) + 1;
        final label = 'World $world  –  Level $levelInWorld';

        return Container(
          margin: EdgeInsets.only(bottom: widget.size.height * 0.012),
          decoration: BoxDecoration(
            color: const Color(0x55000000),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isOpen ? const Color(0xFFFFD700) : Colors.white24,
              width: isOpen ? 1.5 : 1,
            ),
          ),
          child: Column(
            children: [
              // Section header — tap to expand/collapse
              GestureDetector(
                onTap: () => setState(() {
                  if (isOpen) {
                    _expanded.remove(lvl);
                  } else {
                    _expanded.add(lvl);
                  }
                }),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: widget.size.width * 0.03,
                    vertical: widget.size.height * 0.015,
                  ),
                  decoration: BoxDecoration(
                    color: isOpen
                        ? const Color(0x33FFD700)
                        : const Color(0x221A3A5C),
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(12),
                      topRight: const Radius.circular(12),
                      bottomLeft: Radius.circular(isOpen ? 0 : 12),
                      bottomRight: Radius.circular(isOpen ? 0 : 12),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.layers,
                        color: const Color(0xFFFFD700),
                        size: widget.size.height * 0.03,
                      ),
                      SizedBox(width: widget.size.width * 0.015),
                      Expanded(
                        child: Text(
                          label,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: widget.size.height * 0.026,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      // Word count badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A3A5C),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${words.length} word${words.length == 1 ? '' : 's'}',
                          style: TextStyle(
                            color: const Color(0xFFFFD700),
                            fontSize: widget.size.height * 0.018,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(width: widget.size.width * 0.01),
                      Icon(
                        isOpen ? Icons.expand_less : Icons.expand_more,
                        color: Colors.white70,
                        size: widget.size.height * 0.03,
                      ),
                    ],
                  ),
                ),
              ),

              // Expandable word grid
              AnimatedCrossFade(
                duration: const Duration(milliseconds: 250),
                crossFadeState: isOpen
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                firstChild: const SizedBox.shrink(),
                secondChild: Padding(
                  padding: EdgeInsets.all(widget.size.width * 0.015),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 1.5,
                    ),
                    itemCount: words.length,
                    itemBuilder: (_, j) => _WordCard(word: words[j]),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ── Word card (flip to reveal translation) ────────────────────────────────────
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
