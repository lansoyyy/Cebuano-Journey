import 'package:flutter/material.dart';

/// Draws all parallax background layers for the nature/platformer level.
class ParallaxPainter extends CustomPainter {
  final double worldX;
  final double cloudDrift;
  final int world;

  const ParallaxPainter({
    required this.worldX,
    required this.cloudDrift,
    this.world = 1,
  });

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
    switch (world) {
      case 2:
        _paintCity(canvas, s, gY);
      case 3:
        _paintFiesta(canvas, s, gY);
      case 4:
        _paintBeach(canvas, s, gY);
      default:
        _paintNature(canvas, s, gY);
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // WORLD 1 — Nature / Forest (original)
  // ─────────────────────────────────────────────────────────────────────────
  void _paintNature(Canvas canvas, Size s, double gY) {
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
    _tile(canvas, -cloudDrift * 0.4, s.width, (c, o) => _drawClouds(c, s, o));
    _tile(canvas, -worldX * 0.06, s.width, (c, o) => _drawFarMountains(c, s, o, gY));
    _tile(canvas, -worldX * 0.18, s.width, (c, o) => _drawMidHills(c, s, o, gY));
    _tile(canvas, -worldX * 0.38, s.width, (c, o) => _drawNearTrees(c, s, o, gY));
    _drawGround(canvas, s, gY);
    _tile(canvas, -worldX * 0.78, s.width, (c, o) => _drawGrassTufts(c, s, o, gY));
  }

  // ─────────────────────────────────────────────────────────────────────────
  // WORLD 2 — City / Urban
  // ─────────────────────────────────────────────────────────────────────────
  void _paintCity(Canvas canvas, Size s, double gY) {
    // Sky — golden hour / dusk
    canvas.drawRect(
      Rect.fromLTWH(0, 0, s.width, s.height),
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1A1A3E), Color(0xFF4A3060)],
        ).createShader(Rect.fromLTWH(0, 0, s.width, s.height)),
    );
    // Stars
    _drawStars(canvas, s);
    // Far buildings (slow)
    _tile(canvas, -worldX * 0.08, s.width, (c, o) => _drawFarBuildings(c, s, o, gY));
    // Near buildings (faster)
    _tile(canvas, -worldX * 0.30, s.width, (c, o) => _drawNearBuildings(c, s, o, gY));
    // Road / pavement ground
    _drawCityGround(canvas, s, gY);
  }

  void _drawStars(Canvas c, Size s) {
    final p = Paint()..color = const Color(0xAAFFFFFF);
    final positions = [
      [0.05, 0.05], [0.15, 0.10], [0.25, 0.04], [0.35, 0.08],
      [0.45, 0.03], [0.55, 0.07], [0.65, 0.05], [0.75, 0.09],
      [0.85, 0.04], [0.92, 0.12], [0.10, 0.15], [0.60, 0.12],
      [0.80, 0.14], [0.40, 0.15], [0.70, 0.03],
    ];
    for (final pos in positions) {
      c.drawCircle(Offset(s.width * pos[0], s.height * pos[1]), 1.5, p);
    }
  }

  void _drawFarBuildings(Canvas c, Size s, double o, double gY) {
    final dark = Paint()..color = const Color(0xFF2A2A4A);
    final win = Paint()..color = const Color(0xAAFFD700);
    void building(double x, double h, double w) {
      final top = gY - h;
      c.drawRect(Rect.fromLTWH(o + x, top, w, h), dark);
      // windows
      for (double wy = top + h * 0.10; wy < gY - h * 0.05; wy += h * 0.15) {
        for (double wx = o + x + w * 0.12; wx < o + x + w - w * 0.15; wx += w * 0.28) {
          c.drawRect(Rect.fromLTWH(wx, wy, w * 0.16, h * 0.09), win);
        }
      }
    }
    building(s.width * 0.02, s.height * 0.28, s.width * 0.09);
    building(s.width * 0.14, s.height * 0.38, s.width * 0.07);
    building(s.width * 0.24, s.height * 0.22, s.width * 0.10);
    building(s.width * 0.38, s.height * 0.32, s.width * 0.08);
    building(s.width * 0.50, s.height * 0.42, s.width * 0.06);
    building(s.width * 0.60, s.height * 0.26, s.width * 0.09);
    building(s.width * 0.73, s.height * 0.36, s.width * 0.08);
    building(s.width * 0.85, s.height * 0.30, s.width * 0.07);
  }

  void _drawNearBuildings(Canvas c, Size s, double o, double gY) {
    final mid = Paint()..color = const Color(0xFF3A3A5E);
    final win = Paint()..color = const Color(0xCCFFEE88);
    void building(double x, double h, double w) {
      final top = gY - h;
      c.drawRect(Rect.fromLTWH(o + x, top, w, h), mid);
      for (double wy = top + h * 0.12; wy < gY - h * 0.06; wy += h * 0.18) {
        for (double wx = o + x + w * 0.10; wx < o + x + w - w * 0.12; wx += w * 0.30) {
          c.drawRect(Rect.fromLTWH(wx, wy, w * 0.18, h * 0.11), win);
        }
      }
    }
    building(s.width * 0.00, s.height * 0.22, s.width * 0.12);
    building(s.width * 0.16, s.height * 0.30, s.width * 0.10);
    building(s.width * 0.30, s.height * 0.20, s.width * 0.14);
    building(s.width * 0.48, s.height * 0.28, s.width * 0.10);
    building(s.width * 0.62, s.height * 0.24, s.width * 0.12);
    building(s.width * 0.78, s.height * 0.32, s.width * 0.09);
    building(s.width * 0.90, s.height * 0.20, s.width * 0.11);
  }

  void _drawCityGround(Canvas c, Size s, double gY) {
    // Sidewalk
    c.drawRect(
      Rect.fromLTWH(0, gY - 2, s.width, s.height * 0.050),
      Paint()..color = const Color(0xFF888888),
    );
    // Road markings
    final linePaint = Paint()..color = const Color(0xFFFFFF88);
    for (int i = 0; i < 12; i++) {
      c.drawRect(
        Rect.fromLTWH(s.width / 12 * i + s.width * 0.02, gY + s.height * 0.02,
            s.width * 0.05, s.height * 0.008),
        linePaint,
      );
    }
    c.drawRect(
      Rect.fromLTWH(0, gY + s.height * 0.04, s.width, s.height * 0.60),
      Paint()..color = const Color(0xFF555555),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // WORLD 3 — Fiesta / Festival
  // ─────────────────────────────────────────────────────────────────────────
  void _paintFiesta(Canvas canvas, Size s, double gY) {
    // Warm festive sky
    canvas.drawRect(
      Rect.fromLTWH(0, 0, s.width, s.height),
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFFF6B35), Color(0xFFFFD75E)],
        ).createShader(Rect.fromLTWH(0, 0, s.width, s.height)),
    );
    // Clouds (tinted warm)
    _tile(canvas, -cloudDrift * 0.4, s.width, (c, o) => _drawFiestaClouds(c, s, o));
    // Far barangay houses
    _tile(canvas, -worldX * 0.08, s.width, (c, o) => _drawFarHouses(c, s, o, gY));
    // Bunting banners
    _tile(canvas, -worldX * 0.20, s.width, (c, o) => _drawBanners(c, s, o, gY));
    // Near decorations
    _tile(canvas, -worldX * 0.40, s.width, (c, o) => _drawNearDecor(c, s, o, gY));
    // Festive ground
    _drawFiestaGround(canvas, s, gY);
    _tile(canvas, -worldX * 0.78, s.width, (c, o) => _drawGrassTufts(c, s, o, gY));
  }

  void _drawFiestaClouds(Canvas c, Size s, double o) {
    final p = Paint()..color = const Color(0x99FFEECC);
    void cloud(double x, double y, double w, double h) {
      c.drawRect(Rect.fromLTWH(o + x, y, w, h), p);
      c.drawRect(Rect.fromLTWH(o + x + w * 0.15, y - h * 0.5, w * 0.7, h * 0.5), p);
    }
    cloud(s.width * 0.05, s.height * 0.07, s.width * 0.12, s.height * 0.05);
    cloud(s.width * 0.35, s.height * 0.04, s.width * 0.10, s.height * 0.045);
    cloud(s.width * 0.65, s.height * 0.09, s.width * 0.14, s.height * 0.055);
  }

  void _drawFarHouses(Canvas c, Size s, double o, double gY) {
    final wallP = Paint()..color = const Color(0xFFE8C07A);
    final roofP = Paint()..color = const Color(0xFFCC4422);
    void house(double x, double h, double w) {
      c.drawRect(Rect.fromLTWH(o + x, gY - h, w, h), wallP);
      // triangular-ish roof (blocky)
      final roofW = w * 1.2;
      c.drawRect(Rect.fromLTWH(o + x - w * 0.1, gY - h - h * 0.3, roofW, h * 0.3), roofP);
    }
    house(s.width * 0.05, s.height * 0.18, s.width * 0.10);
    house(s.width * 0.20, s.height * 0.22, s.width * 0.08);
    house(s.width * 0.38, s.height * 0.16, s.width * 0.12);
    house(s.width * 0.55, s.height * 0.20, s.width * 0.09);
    house(s.width * 0.72, s.height * 0.18, s.width * 0.11);
    house(s.width * 0.88, s.height * 0.22, s.width * 0.08);
  }

  void _drawBanners(Canvas c, Size s, double o, double gY) {
    // String of colorful triangular flags
    final colors = [
      const Color(0xFFFF3333), const Color(0xFF33CCFF),
      const Color(0xFFFFFF00), const Color(0xFF33FF66),
      const Color(0xFFFF66CC),
    ];
    final stringY = gY - s.height * 0.28;
    final p = Paint()..color = const Color(0xFF884400);
    // horizontal string line
    c.drawLine(Offset(o, stringY), Offset(o + s.width, stringY), p..strokeWidth = 1.5);
    for (int i = 0; i < 14; i++) {
      final fx = o + s.width * (i / 14.0) + s.width * 0.02;
      final fp = Paint()..color = colors[i % colors.length];
      // triangle flag
      final path = Path()
        ..moveTo(fx, stringY)
        ..lineTo(fx + s.width * 0.028, stringY)
        ..lineTo(fx + s.width * 0.014, stringY + s.height * 0.04)
        ..close();
      c.drawPath(path, fp);
    }
  }

  void _drawNearDecor(Canvas c, Size s, double o, double gY) {
    // Bamboo poles with lights
    final bamboo = Paint()..color = const Color(0xFF6B8E23);
    final light = Paint()..color = const Color(0xFFFFFF00);
    for (int i = 0; i < 5; i++) {
      final x = o + s.width * (i / 5.0 + 0.05);
      c.drawRect(Rect.fromLTWH(x, gY - s.height * 0.25, s.width * 0.012, s.height * 0.25), bamboo);
      c.drawCircle(Offset(x + s.width * 0.006, gY - s.height * 0.26), s.height * 0.015, light);
    }
  }

  void _drawFiestaGround(Canvas c, Size s, double gY) {
    c.drawRect(Rect.fromLTWH(0, gY - 2, s.width, s.height * 0.050),
        Paint()..color = const Color(0xFF8B6914));
    c.drawRect(Rect.fromLTWH(0, gY + s.height * 0.03, s.width, s.height * 0.60),
        Paint()..color = const Color(0xFF6B4E10));
    // cobblestone pattern
    final stoneP = Paint()..color = const Color(0xFF7A5820);
    for (int i = 0; i < 24; i++) {
      c.drawRect(
        Rect.fromLTWH(s.width / 24 * i, gY + s.height * 0.01, s.width / 24 - 2, s.height * 0.020),
        stoneP,
      );
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // WORLD 4 — Beach / Barangay
  // ─────────────────────────────────────────────────────────────────────────
  void _paintBeach(Canvas canvas, Size s, double gY) {
    // Bright tropical sky
    canvas.drawRect(
      Rect.fromLTWH(0, 0, s.width, s.height),
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF00BFFF), Color(0xFF87FFEE)],
        ).createShader(Rect.fromLTWH(0, 0, s.width, s.height)),
    );
    // Sun
    canvas.drawCircle(
      Offset(s.width * 0.85, s.height * 0.12),
      s.height * 0.07,
      Paint()..color = const Color(0xFFFFEE00),
    );
    _tile(canvas, -cloudDrift * 0.4, s.width, (c, o) => _drawClouds(c, s, o));
    // Ocean waves (far)
    _tile(canvas, -worldX * 0.06, s.width, (c, o) => _drawOcean(c, s, o, gY));
    // Palm trees
    _tile(canvas, -worldX * 0.35, s.width, (c, o) => _drawPalmTrees(c, s, o, gY));
    // Sand ground
    _drawSandGround(canvas, s, gY);
  }

  void _drawOcean(Canvas c, Size s, double o, double gY) {
    final ocean = Paint()..color = const Color(0xFF0077B6);
    final wave = Paint()..color = const Color(0xFF90E0EF);
    c.drawRect(Rect.fromLTWH(o, gY - s.height * 0.30, s.width, s.height * 0.15), ocean);
    // wave lines
    for (int i = 0; i < 6; i++) {
      final wy = gY - s.height * 0.28 + s.height * 0.022 * i;
      c.drawRect(Rect.fromLTWH(o + s.width * (i * 0.12), wy, s.width * 0.08, s.height * 0.006), wave);
    }
  }

  void _drawPalmTrees(Canvas c, Size s, double o, double gY) {
    final trunk = Paint()..color = const Color(0xFF8B6914);
    final leaf = Paint()..color = const Color(0xFF228B22);
    void palm(double x, double h, double w) {
      // curved trunk (approximated with rects)
      c.drawRect(Rect.fromLTWH(o + x + w * 0.4, gY - h, w * 0.12, h), trunk);
      c.drawRect(Rect.fromLTWH(o + x + w * 0.42, gY - h - h * 0.05, w * 0.10, h * 0.10), trunk);
      // fronds
      void frond(double fx, double fy, double fw, double fh) {
        c.drawRect(Rect.fromLTWH(o + x + fx, gY - h - fh, fw, fh * 0.20), leaf);
      }
      frond(w * 0.0, -h * 0.00, w * 0.50, h * 0.22);
      frond(w * 0.25, -h * 0.06, w * 0.55, h * 0.18);
      frond(w * 0.50, -h * 0.03, w * 0.50, h * 0.22);
      c.drawRect(Rect.fromLTWH(o + x + w * 0.28, gY - h - h * 0.20, w * 0.44, h * 0.18), leaf);
    }
    palm(s.width * 0.05, s.height * 0.32, s.width * 0.10);
    palm(s.width * 0.28, s.height * 0.28, s.width * 0.09);
    palm(s.width * 0.52, s.height * 0.34, s.width * 0.11);
    palm(s.width * 0.73, s.height * 0.26, s.width * 0.09);
    palm(s.width * 0.90, s.height * 0.30, s.width * 0.08);
  }

  void _drawSandGround(Canvas c, Size s, double gY) {
    c.drawRect(Rect.fromLTWH(0, gY - 2, s.width, s.height * 0.050),
        Paint()..color = const Color(0xFFD2B48C));
    c.drawRect(Rect.fromLTWH(0, gY + s.height * 0.03, s.width, s.height),
        Paint()..color = const Color(0xFFC2A06A));
    // pebble dots
    final pebble = Paint()..color = const Color(0xFFAA8844);
    for (int i = 0; i < 20; i++) {
      c.drawCircle(
        Offset(s.width / 20 * i + s.width * 0.025, gY + s.height * 0.015),
        s.height * 0.006,
        pebble,
      );
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Shared drawing helpers (Nature / Fiesta reuse)
  // ─────────────────────────────────────────────────────────────────────────

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
    void peak(double x, double peakH, double w) {
      final top = gY - peakH;
      c.drawRect(Rect.fromLTWH(o + x, top, w, peakH), p);
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
    void tree(double x, double h, double w) {
      final trunkW = w * 0.22;
      final trunkH = h * 0.38;
      c.drawRect(
        Rect.fromLTWH(o + x + w / 2 - trunkW / 2, gY - trunkH, trunkW, trunkH),
        Paint()..color = const Color(0xFF5C3317),
      );
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
    c.drawRect(
      Rect.fromLTWH(0, gY - 2, s.width, s.height * 0.050),
      Paint()..color = const Color(0xFF4CAF50),
    );
    c.drawRect(
      Rect.fromLTWH(0, gY + s.height * 0.03, s.width, s.height * 0.12),
      Paint()..color = const Color(0xFF8B5A2B),
    );
    c.drawRect(
      Rect.fromLTWH(0, gY + s.height * 0.15, s.width, s.height * 0.12),
      Paint()..color = const Color(0xFF6B3F1A),
    );
    c.drawRect(
      Rect.fromLTWH(0, gY + s.height * 0.27, s.width, s.height),
      Paint()..color = const Color(0xFF3B1F06),
    );
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
      old.worldX != worldX || old.cloudDrift != cloudDrift || old.world != world;
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
