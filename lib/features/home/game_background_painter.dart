import 'package:flutter/material.dart';

/// Shared day-scene pixel-art background used by Main Menu & Options screens.
class GameBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size s) {
    // Sky gradient
    final skyPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFADE8F4), Color(0xFF90C9E8), Color(0xFF5BA4CF)],
        stops: [0.0, 0.55, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, s.width, s.height));
    canvas.drawRect(Rect.fromLTWH(0, 0, s.width, s.height), skyPaint);

    _drawMountains(canvas, s, const Color(0xFF8EC5D6), 0.28, 0.58);
    _drawMountains(canvas, s, const Color(0xFF5B9AB5), 0.38, 0.65);

    // Dark-green forest silhouette
    final forestPaint = Paint()..color = const Color(0xFF1E4D1A);
    final fp = Path()
      ..moveTo(0, s.height)
      ..lineTo(0, s.height * 0.72)
      ..lineTo(s.width * 0.05, s.height * 0.58)
      ..lineTo(s.width * 0.10, s.height * 0.65)
      ..lineTo(s.width * 0.14, s.height * 0.52)
      ..lineTo(s.width * 0.18, s.height * 0.60)
      ..lineTo(s.width * 0.22, s.height * 0.48)
      ..lineTo(s.width * 0.26, s.height * 0.62)
      ..lineTo(s.width * 0.30, s.height * 0.72)
      ..lineTo(s.width * 0.65, s.height * 0.72)
      ..lineTo(s.width * 0.68, s.height * 0.55)
      ..lineTo(s.width * 0.72, s.height * 0.62)
      ..lineTo(s.width * 0.76, s.height * 0.50)
      ..lineTo(s.width * 0.80, s.height * 0.60)
      ..lineTo(s.width * 0.84, s.height * 0.68)
      ..lineTo(s.width, s.height * 0.68)
      ..lineTo(s.width, s.height)
      ..close();
    canvas.drawPath(fp, forestPaint);

    // Ground dirt
    canvas.drawRect(
      Rect.fromLTWH(0, s.height * 0.80, s.width, s.height * 0.20),
      Paint()..color = const Color(0xFF7A4E2D),
    );

    // Grass strip
    canvas.drawRect(
      Rect.fromLTWH(0, s.height * 0.78, s.width, s.height * 0.04),
      Paint()..color = const Color(0xFF4CAF50),
    );

    // Pixel grass tufts
    final tuffPaint = Paint()..color = const Color(0xFF388E3C);
    for (int i = 0; i < 20; i++) {
      canvas.drawRect(
        Rect.fromLTWH(
          s.width * (i / 20.0),
          s.height * 0.755,
          s.width * 0.02,
          s.height * 0.03,
        ),
        tuffPaint,
      );
    }
  }

  void _drawMountains(Canvas c, Size s, Color color, double peak, double base) {
    final paint = Paint()..color = color;
    final path = Path()
      ..moveTo(0, s.height * base)
      ..lineTo(s.width * 0.08, s.height * peak)
      ..lineTo(s.width * 0.18, s.height * (peak + 0.12))
      ..lineTo(s.width * 0.28, s.height * (peak - 0.04))
      ..lineTo(s.width * 0.40, s.height * (peak + 0.14))
      ..lineTo(s.width * 0.55, s.height * (peak - 0.06))
      ..lineTo(s.width * 0.68, s.height * (peak + 0.10))
      ..lineTo(s.width * 0.80, s.height * peak)
      ..lineTo(s.width * 0.90, s.height * (peak + 0.08))
      ..lineTo(s.width, s.height * (peak + 0.04))
      ..lineTo(s.width, s.height * base)
      ..close();
    c.drawPath(path, paint);
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
