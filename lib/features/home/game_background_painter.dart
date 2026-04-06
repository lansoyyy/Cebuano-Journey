import 'package:flutter/material.dart';

/// Enhanced pixel-art day scene — Main Menu & Options screens.
class GameBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size s) {
    _drawSky(canvas, s);
    _drawMountains(canvas, s, const Color(0xFFAACAD8), 0.20, 0.56);
    _drawMountains(canvas, s, const Color(0xFF5898B4), 0.33, 0.64);
    _drawLake(canvas, s);
    _drawForest(canvas, s);
    _drawGrass(canvas, s);
    _drawGround(canvas, s);
  }

  void _drawSky(Canvas canvas, Size s) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, s.width, s.height),
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFBEECFD), Color(0xFF8DCDE6), Color(0xFF5FAAD0)],
          stops: [0.0, 0.50, 1.0],
        ).createShader(Rect.fromLTWH(0, 0, s.width, s.height)),
    );
  }

  void _drawMountains(Canvas canvas, Size s, Color color, double peak, double base) {
    final path = Path()
      ..moveTo(0, s.height * base)
      ..lineTo(s.width * 0.07, s.height * peak)
      ..lineTo(s.width * 0.15, s.height * (peak + 0.10))
      ..lineTo(s.width * 0.24, s.height * (peak - 0.05))
      ..lineTo(s.width * 0.34, s.height * (peak + 0.12))
      ..lineTo(s.width * 0.46, s.height * (peak - 0.04))
      ..lineTo(s.width * 0.57, s.height * (peak + 0.10))
      ..lineTo(s.width * 0.67, s.height * (peak - 0.03))
      ..lineTo(s.width * 0.77, s.height * (peak + 0.08))
      ..lineTo(s.width * 0.87, s.height * (peak + 0.03))
      ..lineTo(s.width * 0.94, s.height * (peak + 0.06))
      ..lineTo(s.width, s.height * (peak + 0.08))
      ..lineTo(s.width, s.height * base)
      ..close();
    canvas.drawPath(path, Paint()..color = color);
  }

  void _drawLake(Canvas canvas, Size s) {
    canvas.drawRect(
      Rect.fromLTWH(0, s.height * 0.57, s.width, s.height * 0.13),
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF82C2DC), Color(0xFF4896BA)],
        ).createShader(Rect.fromLTWH(0, s.height * 0.57, s.width, s.height * 0.13)),
    );
    // Shimmer highlight at water surface
    canvas.drawRect(
      Rect.fromLTWH(0, s.height * 0.57, s.width, s.height * 0.010),
      Paint()..color = const Color(0x66FFFFFF),
    );
    // Subtle reflection dashes
    final reflectPaint = Paint()
      ..color = const Color(0x22FFFFFF)
      ..strokeWidth = 1.2;
    for (double x = 0; x < s.width; x += s.width * 0.06) {
      canvas.drawLine(
        Offset(x, s.height * 0.625),
        Offset(x + s.width * 0.035, s.height * 0.625),
        reflectPaint,
      );
    }
  }

  void _drawForest(Canvas canvas, Size s) {
    // [centerX, topY, halfWidth] as fractions
    const trees = <List<double>>[
      [0.01, 0.50, 0.075], [0.07, 0.56, 0.062],
      [0.13, 0.44, 0.090], [0.20, 0.52, 0.072],
      [0.27, 0.46, 0.082], [0.34, 0.59, 0.055],
      [0.60, 0.57, 0.055], [0.67, 0.46, 0.082],
      [0.73, 0.54, 0.072], [0.80, 0.43, 0.090],
      [0.87, 0.52, 0.072], [0.93, 0.48, 0.082],
      [0.99, 0.55, 0.062],
    ];
    final groundY = s.height * 0.760;
    final darkGreen = Paint()..color = const Color(0xFF1D4C18);
    final midGreen = Paint()..color = const Color(0xFF276520);

    for (final t in trees) {
      final cx = s.width * t[0];
      final ty = s.height * t[1];
      final hw = s.width * t[2];
      canvas.drawPath(
        Path()
          ..moveTo(cx - hw, groundY)
          ..lineTo(cx, ty)
          ..lineTo(cx + hw, groundY)
          ..close(),
        darkGreen,
      );
      canvas.drawPath(
        Path()
          ..moveTo(cx - hw * 0.25, groundY)
          ..lineTo(cx, ty)
          ..lineTo(cx + hw * 0.70, groundY)
          ..close(),
        midGreen,
      );
    }
  }

  void _drawGrass(Canvas canvas, Size s) {
    canvas.drawRect(
      Rect.fromLTWH(0, s.height * 0.758, s.width, s.height * 0.055),
      Paint()..color = const Color(0xFF4CAF50),
    );
    final tuffPaint = Paint()..color = const Color(0xFF378C36);
    for (int i = 0; i < 28; i++) {
      final x = s.width * i / 28.0 + s.width * 0.005;
      canvas.drawRect(
        Rect.fromLTWH(x, s.height * 0.742, s.width * 0.017, s.height * 0.028),
        tuffPaint,
      );
    }
  }

  void _drawGround(Canvas canvas, Size s) {
    canvas.drawRect(
      Rect.fromLTWH(0, s.height * 0.800, s.width, s.height * 0.200),
      Paint()..color = const Color(0xFF7A4E2D),
    );
    canvas.drawRect(
      Rect.fromLTWH(0, s.height * 0.860, s.width, s.height * 0.016),
      Paint()..color = const Color(0xFF5C3A1E),
    );
    canvas.drawRect(
      Rect.fromLTWH(0, s.height * 0.932, s.width, s.height * 0.016),
      Paint()..color = const Color(0xFF5C3A1E),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Dark night-scene background used by Inventory screen.
class DarkBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size s) {
    // Night sky
    canvas.drawRect(
      Rect.fromLTWH(0, 0, s.width, s.height),
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF0A0F2E), Color(0xFF0D1B4B), Color(0xFF0F2060)],
        ).createShader(Rect.fromLTWH(0, 0, s.width, s.height)),
    );

    // Stars
    final starPaint = Paint()..color = const Color(0xCCFFFFFF);
    final stars = [
      const Offset(0.05, 0.08), const Offset(0.12, 0.15), const Offset(0.22, 0.05),
      const Offset(0.35, 0.12), const Offset(0.48, 0.07), const Offset(0.60, 0.18),
      const Offset(0.72, 0.06), const Offset(0.85, 0.14), const Offset(0.93, 0.09),
      const Offset(0.18, 0.22), const Offset(0.55, 0.20), const Offset(0.78, 0.25),
    ];
    for (final st in stars) {
      canvas.drawRect(
        Rect.fromLTWH(st.dx * s.width, st.dy * s.height, 3, 3),
        starPaint,
      );
    }

    // Dark city/tree silhouette
    final silhouettePaint = Paint()..color = const Color(0xFF050B1A);
    final sp = Path()
      ..moveTo(0, s.height)
      ..lineTo(0, s.height * 0.55)
      ..lineTo(s.width * 0.04, s.height * 0.55)
      ..lineTo(s.width * 0.04, s.height * 0.40)
      ..lineTo(s.width * 0.07, s.height * 0.40)
      ..lineTo(s.width * 0.07, s.height * 0.55)
      ..lineTo(s.width * 0.10, s.height * 0.55)
      ..lineTo(s.width * 0.10, s.height * 0.35)
      ..lineTo(s.width * 0.13, s.height * 0.35)
      ..lineTo(s.width * 0.13, s.height * 0.55)
      ..lineTo(s.width * 0.18, s.height * 0.50)
      ..lineTo(s.width * 0.22, s.height * 0.38)
      ..lineTo(s.width * 0.26, s.height * 0.50)
      ..lineTo(s.width * 0.30, s.height * 0.55)
      ..lineTo(s.width * 0.70, s.height * 0.55)
      ..lineTo(s.width * 0.73, s.height * 0.42)
      ..lineTo(s.width * 0.76, s.height * 0.55)
      ..lineTo(s.width * 0.80, s.height * 0.55)
      ..lineTo(s.width * 0.80, s.height * 0.38)
      ..lineTo(s.width * 0.83, s.height * 0.38)
      ..lineTo(s.width * 0.83, s.height * 0.55)
      ..lineTo(s.width * 0.88, s.height * 0.48)
      ..lineTo(s.width * 0.93, s.height * 0.55)
      ..lineTo(s.width, s.height * 0.55)
      ..lineTo(s.width, s.height)
      ..close();
    canvas.drawPath(sp, silhouettePaint);

    // Ground
    canvas.drawRect(
      Rect.fromLTWH(0, s.height * 0.80, s.width, s.height * 0.20),
      Paint()..color = const Color(0xFF3D2B1A),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
