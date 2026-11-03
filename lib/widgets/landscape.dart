import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Flat illustrated lake scene: sky, rolling hills, a spruce tree line and
/// the lake. Purely decorative — excluded from semantics by callers.
class LandscapePainter extends CustomPainter {
  const LandscapePainter({
    this.skyTop = const Color(0xFFDCE6E5),
    this.skyBottom = const Color(0xFFE3EBE8),
    this.farHill = const Color(0xFFA9C1CB),
    this.nearHill = const Color(0xFF6E9AB0),
    this.trees = const Color(0xFF1F4D3A),
    this.lake = const Color(0xFF2E6A8E),
    this.ripple = const Color(0xFF5B8DAD),
    this.sun,
    this.treeLine = 0.78,
  });

  /// Warm sky used on the readiness screen.
  const LandscapePainter.warm()
      : this(
          skyTop: const Color(0xFFE6D8C3),
          skyBottom: const Color(0xFFF1E9DC),
          treeLine: 0.72,
        );

  final Color skyTop;
  final Color skyBottom;
  final Color farHill;
  final Color nearHill;
  final Color trees;
  final Color lake;
  final Color ripple;
  final Color? sun;

  /// Height (0–1) where the trees meet the water.
  final double treeLine;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final base = h * treeLine;

    canvas.drawRect(
      Offset.zero & size,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [skyTop, skyBottom],
        ).createShader(Offset.zero & size),
    );

    if (sun != null) {
      canvas.drawCircle(Offset(w * 0.67, h * 0.31), w * 0.055, Paint()..color = sun!);
    }

    Path hill(double y, double amp, double phase) {
      final p = Path()..moveTo(0, y);
      for (var i = 0; i <= 40; i++) {
        final x = w * i / 40;
        p.lineTo(x, y + math.sin(x / w * math.pi * 1.6 + phase) * amp);
      }
      return p
        ..lineTo(w, base + 1)
        ..lineTo(0, base + 1)
        ..close();
    }

    canvas.drawPath(hill(base - h * 0.26, h * 0.03, 0.4), Paint()..color = farHill);
    canvas.drawPath(hill(base - h * 0.18, h * 0.02, 2.1), Paint()..color = nearHill);

    // Spruce tree line: irregular triangles along the shore.
    final treePaint = Paint()..color = trees;
    final rnd = math.Random(7);
    final treeWidth = w / 26;
    final line = Path()..moveTo(0, base);
    for (var x = 0.0; x < w + treeWidth; x += treeWidth) {
      final peak = h * (0.08 + rnd.nextDouble() * 0.07);
      line
        ..lineTo(x + treeWidth / 2, base - peak)
        ..lineTo(x + treeWidth, base - h * 0.02);
    }
    line
      ..lineTo(w, base + 1)
      ..lineTo(0, base + 1)
      ..close();
    canvas.drawPath(line, treePaint);
    canvas.drawRect(Rect.fromLTRB(0, base - h * 0.02, w, base + 1), treePaint);

    canvas.drawRect(Rect.fromLTRB(0, base, w, h), Paint()..color = lake);

    final ripplePaint = Paint()
      ..color = ripple
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    final water = h - base;
    void rippleLine(double x0, double x1, double fy) => canvas.drawLine(
        Offset(w * x0, base + water * fy), Offset(w * x1, base + water * fy), ripplePaint);
    rippleLine(0.1, 0.27, 0.36);
    rippleLine(0.45, 0.63, 0.55);
    rippleLine(0.72, 0.86, 0.33);
    rippleLine(0.2, 0.34, 0.78);
  }

  @override
  bool shouldRepaint(LandscapePainter old) => false;
}
