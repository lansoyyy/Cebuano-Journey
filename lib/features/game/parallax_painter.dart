import 'package:flutter/material.dart';

/// Draws all parallax background layers for the nature/platformer level.
class ParallaxPainter extends CustomPainter {
  final double worldX;
  final double cloudDrift;

  const ParallaxPainter({required this.worldX, required this.cloudDrift});

  void _tile(
    Canvas c,
    double offset,
    double tileW,
    void Function(Canvas c, double o) draw,
  ) {
    final o = offset % tileW;
    draw(c, o);
    draw(c, o - tileW);
    draw(c, o + tileW);
  }

  @override
  void paint(Canvas canvas, Size s) {
    final gY = s.height * 0.64;

    // 1. Sky gradient
    canvas.drawRect(
      Rect.fromLTWH(0, 0, s.width, s.height),
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF87CEEB), Color(0xFF5BB3D4)],
        ).createShader(Rect.fromLTWH(0, 0, s.width, s.height)),
    );

    // 2. Clouds (very slow drift)
    _tile(canvas, -cloudDrift * 0.4, s.width, (c, o) => _drawClouds(c, s, o));
    // 3. Far mountains (0.06x)
    _tile(
      canvas,
      -worldX * 0.06,
      s.width,
      (c, o) => _drawFarMountains(c, s, o, gY),
    );
    // 4. Mid hills (0.18x)
    _tile(
      canvas,
      -worldX * 0.18,
      s.width,
      (c, o) => _drawMidHills(c, s, o, gY),
    );
    // 5. Near trees (0.38x)
    _tile(
      canvas,
      -worldX * 0.38,
      s.width,
      (c, o) => _drawNearTrees(c, s, o, gY),
    );
    // 6. Ground (static fills)
    _drawGround(canvas, s, gY);
    // 7. Grass tufts (0.78x)
    _tile(
      canvas,
      -worldX * 0.78,
      s.width,
      (c, o) => _drawGrassTufts(c, s, o, gY),
    );
  }

  // ── Clouds ─────────────────────────────────────────────────────────────────
  void _drawClouds(Canvas c, Size s, double o) {
    final p = Paint()..color = const Color(0xCCFFFFFF);
    void cloud(double x, double y, double w, double h) {
      c.drawRect(Rect.fromLTWH(o + x, y, w, h), p);
      c.drawRect(
        Rect.fromLTWH(o + x + w * 0.15, y - h * 0.5, w * 0.7, h * 0.5),
        p,
      );
    }

    cloud(s.width * 0.05, s.height * 0.08, s.width * 0.12, s.height * 0.05);
    cloud(s.width * 0.30, s.height * 0.05, s.width * 0.10, s.height * 0.045);
    cloud(s.width * 0.58, s.height * 0.10, s.width * 0.14, s.height * 0.055);
    cloud(s.width * 0.80, s.height * 0.07, s.width * 0.09, s.height * 0.04);
  }

  // ── Far mountains ──────────────────────────────────────────────────────────
  void _drawFarMountains(Canvas c, Size s, double o, double gY) {
    final p = Paint()..color = const Color(0xFF8AB4C8);
    // Blocky pixel-art mountain shapes
    void peak(double x, double peakH, double w) {
      final top = gY - peakH;
      c.drawRect(Rect.fromLTWH(o + x, top, w, peakH), p);
      // blocky stepped sides
      c.drawRect(
        Rect.fromLTWH(o + x - w * 0.3, top + peakH * 0.3, w * 0.3, peakH * 0.7),
        p,
      );
      c.drawRect(
        Rect.fromLTWH(o + x + w, top + peakH * 0.3, w * 0.3, peakH * 0.7),
        p,
      );
    }

    peak(s.width * 0.05, s.height * 0.30, s.width * 0.10);
    peak(s.width * 0.26, s.height * 0.38, s.width * 0.14);
    peak(s.width * 0.52, s.height * 0.28, s.width * 0.09);
    peak(s.width * 0.68, s.height * 0.34, s.width * 0.12);
    peak(s.width * 0.88, s.height * 0.26, s.width * 0.08);
  }

  // ── Mid hills ──────────────────────────────────────────────────────────────
  void _drawMidHills(Canvas c, Size s, double o, double gY) {
    final p = Paint()..color = const Color(0xFF4A7A9B);
    final path = Path()
      ..moveTo(o, gY)
      ..lineTo(o + s.width * 0.00, gY - s.height * 0.14)
      ..lineTo(o + s.width * 0.12, gY - s.height * 0.22)
      ..lineTo(o + s.width * 0.20, gY - s.height * 0.14)
      ..lineTo(o + s.width * 0.30, gY - s.height * 0.26)
      ..lineTo(o + s.width * 0.42, gY - s.height * 0.18)
      ..lineTo(o + s.width * 0.55, gY - s.height * 0.30)
      ..lineTo(o + s.width * 0.66, gY - s.height * 0.20)
      ..lineTo(o + s.width * 0.75, gY - s.height * 0.28)
      ..lineTo(o + s.width * 0.88, gY - s.height * 0.16)
      ..lineTo(o + s.width * 1.00, gY - s.height * 0.14)
      ..lineTo(o + s.width * 1.00, gY)
      ..close();
    c.drawPath(path, p);
  }

  // ── Near trees silhouette ──────────────────────────────────────────────────
  void _drawNearTrees(Canvas c, Size s, double o, double gY) {
    final dark = Paint()..color = const Color(0xFF1E4D1A);
    // Draw pixel trees
    void tree(double x, double h, double w) {
      final trunkW = w * 0.22;
      final trunkH = h * 0.38;
      // trunk
      c.drawRect(
        Rect.fromLTWH(o + x + w / 2 - trunkW / 2, gY - trunkH, trunkW, trunkH),
        Paint()..color = const Color(0xFF5C3317),
      );
      // foliage (blocky layers)
      c.drawRect(Rect.fromLTWH(o + x, gY - h, w, h * 0.6), dark);
      c.drawRect(
        Rect.fromLTWH(o + x + w * 0.1, gY - h * 1.2, w * 0.8, h * 0.3),
        dark,
      );
      c.drawRect(
        Rect.fromLTWH(o + x + w * 0.2, gY - h * 1.45, w * 0.6, h * 0.28),
        dark,
      );
    }

    tree(s.width * 0.08, s.height * 0.26, s.width * 0.08);
    tree(s.width * 0.22, s.height * 0.30, s.width * 0.10);
    tree(s.width * 0.42, s.height * 0.24, s.width * 0.07);
    tree(s.width * 0.60, s.height * 0.32, s.width * 0.11);
    tree(s.width * 0.78, s.height * 0.22, s.width * 0.07);
  }

  // ── Ground layers ──────────────────────────────────────────────────────────
  void _drawGround(Canvas c, Size s, double gY) {
    // Grass
    c.drawRect(
      Rect.fromLTWH(0, gY - 2, s.width, s.height * 0.050),
      Paint()..color = const Color(0xFF4CAF50),
    );
    // Top dirt
    c.drawRect(
      Rect.fromLTWH(0, gY + s.height * 0.03, s.width, s.height * 0.12),
      Paint()..color = const Color(0xFF8B5A2B),
    );
    // Mid dirt
    c.drawRect(
      Rect.fromLTWH(0, gY + s.height * 0.15, s.width, s.height * 0.12),
      Paint()..color = const Color(0xFF6B3F1A),
    );
    // Deep dirt
    c.drawRect(
      Rect.fromLTWH(0, gY + s.height * 0.27, s.width, s.height),
      Paint()..color = const Color(0xFF3B1F06),
    );
    // Pixel blocks on dirt top
    final blockP = Paint()..color = const Color(0xFF7A4E2D);
    for (int i = 0; i < 30; i++) {
      c.drawRect(
        Rect.fromLTWH(
          s.width / 30 * i,
          gY + s.height * 0.046,
          s.width / 30 - 1,
          s.height * 0.016,
        ),
        blockP,
      );
    }
  }

  // ── Grass tufts (scrolling decoration) ────────────────────────────────────
  void _drawGrassTufts(Canvas c, Size s, double o, double gY) {
    final p = Paint()..color = const Color(0xFF388E3C);
    final p2 = Paint()..color = const Color(0xFF2E7D32);
    for (int i = 0; i < 18; i++) {
      final x = o + s.width * (i / 18.0);
      final h = (i % 3 == 0) ? s.height * 0.028 : s.height * 0.020;
      c.drawRect(
        Rect.fromLTWH(x, gY - h, s.width * 0.018, h),
        i % 2 == 0 ? p : p2,
      );
      c.drawRect(
        Rect.fromLTWH(
          x + s.width * 0.010,
          gY - h * 1.3,
          s.width * 0.010,
          h * 0.5,
        ),
        p2,
      );
    }
  }

  @override
  bool shouldRepaint(ParallaxPainter old) =>
      old.worldX != worldX || old.cloudDrift != cloudDrift;
}

/// Auto-scrolling urban night background for inventory/city screens.
class UrbanParallaxPainter extends CustomPainter {
  final double scrollX;

  const UrbanParallaxPainter({required this.scrollX});

  void _tile(
    Canvas c,
    double offset,
    double tileW,
    void Function(Canvas c, double o) draw,
  ) {
    final o = offset % tileW;
    draw(c, o);
    draw(c, o - tileW);
    draw(c, o + tileW);
  }

  @override
  void paint(Canvas canvas, Size s) {
    final groundY = s.height * 0.72;

    // Sky
    canvas.drawRect(
      Rect.fromLTWH(0, 0, s.width, s.height),
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF0D1B3E), Color(0xFF1A2F5A)],
        ).createShader(Rect.fromLTWH(0, 0, s.width, s.height)),
    );

    // Stars
    _tile(canvas, -scrollX * 0.02, s.width, (c, o) => _drawStars(c, s, o));
    _tile(
      canvas,
      -scrollX * 0.06,
      s.width,
      (c, o) => _drawFarBuildings(c, s, o, groundY),
    );
    _tile(
      canvas,
      -scrollX * 0.18,
      s.width,
      (c, o) => _drawMidBuildings(c, s, o, groundY),
    );
    _drawUrbanGround(canvas, s, groundY, -scrollX * 0.70);
  }

  void _drawStars(Canvas c, Size s, double o) {
    final p = Paint()..color = const Color(0x99FFFFFF);
    final positions = [0.05, 0.13, 0.22, 0.35, 0.48, 0.60, 0.72, 0.85, 0.93];
    final yPos = [0.06, 0.14, 0.08, 0.11, 0.05, 0.16, 0.09, 0.13, 0.07];
    for (int i = 0; i < positions.length; i++) {
      c.drawRect(
        Rect.fromLTWH(o + s.width * positions[i], s.height * yPos[i], 2, 2),
        p,
      );
    }
  }

  void _drawFarBuildings(Canvas c, Size s, double o, double gY) {
    final p = Paint()..color = const Color(0xFF2A3F6A);
    void bld(double x, double h, double w) {
      c.drawRect(Rect.fromLTWH(o + x, gY - h, w, h), p);
      // Windows
      final wp = Paint()..color = const Color(0x66B8D4E8);
      final cols = (w / 14).floor().clamp(1, 10);
      final rows = (h / 18).floor().clamp(1, 10);
      for (int r = 0; r < rows; r++) {
        for (int col = 0; col < cols; col++) {
          c.drawRect(
            Rect.fromLTWH(o + x + 4 + col * 14, gY - h + 5 + r * 18, 8, 10),
            wp,
          );
        }
      }
    }

    bld(s.width * 0.00, s.height * 0.55, s.width * 0.09);
    bld(s.width * 0.11, s.height * 0.68, s.width * 0.07);
    bld(s.width * 0.20, s.height * 0.50, s.width * 0.08);
    bld(s.width * 0.30, s.height * 0.72, s.width * 0.06);
    bld(s.width * 0.38, s.height * 0.60, s.width * 0.10);
    bld(s.width * 0.50, s.height * 0.65, s.width * 0.07);
    bld(s.width * 0.60, s.height * 0.55, s.width * 0.09);
    bld(s.width * 0.71, s.height * 0.70, s.width * 0.08);
    bld(s.width * 0.82, s.height * 0.58, s.width * 0.10);
    bld(s.width * 0.94, s.height * 0.62, s.width * 0.06);
  }

  void _drawMidBuildings(Canvas c, Size s, double o, double gY) {
    final p = Paint()..color = const Color(0xFF1A2A45);
    final litWin = Paint()..color = const Color(0xAAFFD080);
    final darkWin = Paint()..color = const Color(0x44405060);
    void bld(double x, double h, double w, List<int> litRows) {
      c.drawRect(Rect.fromLTWH(o + x, gY - h, w, h), p);
      final cols = (w / 12).floor().clamp(1, 8);
      final rows = (h / 16).floor().clamp(1, 12);
      for (int r = 0; r < rows; r++) {
        for (int col = 0; col < cols; col++) {
          c.drawRect(
            Rect.fromLTWH(o + x + 3 + col * 12, gY - h + 4 + r * 16, 7, 9),
            litRows.contains(r) ? litWin : darkWin,
          );
        }
      }
    }

    bld(s.width * 0.02, s.height * 0.48, s.width * 0.11, [1, 3, 5]);
    bld(s.width * 0.15, s.height * 0.55, s.width * 0.09, [0, 2, 4]);
    bld(s.width * 0.26, s.height * 0.42, s.width * 0.12, [1, 2]);
    bld(s.width * 0.42, s.height * 0.60, s.width * 0.08, [3, 5]);
    bld(s.width * 0.54, s.height * 0.50, s.width * 0.10, [0, 1, 4]);
    bld(s.width * 0.68, s.height * 0.58, s.width * 0.09, [2, 3]);
    bld(s.width * 0.80, s.height * 0.45, s.width * 0.11, [1, 4]);
    bld(s.width * 0.93, s.height * 0.52, s.width * 0.07, [0, 2]);
  }

  void _drawUrbanGround(Canvas c, Size s, double gY, double o) {
    // Sidewalk
    c.drawRect(
      Rect.fromLTWH(0, gY, s.width, s.height * 0.08),
      Paint()..color = const Color(0xFF4A4A4A),
    );
    // Sidewalk tiles
    final tp = Paint()..color = const Color(0xFF3A3A3A);
    final tileW = s.width / 20;
    final startOff = o % (tileW * 2);
    for (double x = startOff; x < s.width + tileW * 2; x += tileW) {
      c.drawRect(Rect.fromLTWH(x, gY + 1, 1, s.height * 0.075), tp);
    }
    // Road
    c.drawRect(
      Rect.fromLTWH(0, gY + s.height * 0.08, s.width, s.height * 0.28),
      Paint()..color = const Color(0xFF252525),
    );
    // Road markings
    final mp = Paint()..color = const Color(0xAAFFFFAA);
    final mW = s.width / 12;
    final mStart = (o * 0.5) % (mW * 2);
    for (double x = mStart; x < s.width + mW * 2; x += mW * 2) {
      c.drawRect(
        Rect.fromLTWH(x, gY + s.height * 0.115, mW * 0.7, s.height * 0.012),
        mp,
      );
    }
  }

  @override
  bool shouldRepaint(UrbanParallaxPainter old) => old.scrollX != scrollX;
}
