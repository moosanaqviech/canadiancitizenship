// Renders Android adaptive-icon layers from the icon art in
// assets/icon/app-icon-lake.svg, using the same leaf paths as the app.
//
// Run with:  flutter test tool/render_icon_layers.dart
// Then:      dart run flutter_launcher_icons

import 'dart:io';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:canada_citizenship/widgets/leaf.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Adaptive icons are 108 dp with a 72 dp visible mask; 432 px = 108 dp @4x.
const _size = 432.0;

// The 100-unit square icon maps onto the 72 dp visible area.
const _unit = _size * 72 / 108 / 100;
const _inset = _size * 18 / 108;

const _lake = Color(0xFF2E6A8E);
const _water = Color(0xFF285E7E);
const _ripple = Color(0xFF3B79A0);
const _maple = Color(0xFFC62E2B);
const _birch = Color(0xFFF7F4EC);
const _vein = Color(0xFF9A2321);

final _blade = parseSvgPath(
    'M50 82C56 78 64 79 69 81L66 74C76 75 86 72 92 64C87 62 83 60 80 57C84 54 86 50 88 45'
    'C82 47 76 50 72 52C74 44 80 36 88 27C80 28 72 30 66 34C66 29 65 24 64 19C60 23 58 26 56 29'
    'C56 20 54 12 50 4C46 12 44 20 44 29C42 26 40 23 36 19C35 24 34 29 34 34C28 30 20 28 12 27'
    'C20 36 26 44 28 52C24 50 18 47 12 45C14 50 16 54 20 57C17 60 13 62 8 64C14 72 24 75 34 74'
    'L31 81C36 79 44 78 50 82Z');
final _stem = parseSvgPath('M50 81C50.6 87 49.6 92 47 97');
final _veins = parseSvgPath('M50 79V14M50 60L82 33M50 60L18 33M50 70L85 63M50 70L15 63');
final _ripples = parseSvgPath('M16 80H38M58 86H82M30 92H48');

Paint _stroke(Color color, double width) => Paint()
  ..style = PaintingStyle.stroke
  ..color = color
  ..strokeWidth = width
  ..strokeCap = StrokeCap.round
  ..strokeJoin = StrokeJoin.round;

/// Moves the canvas into icon units, then into the SVG's leaf group:
/// translate(50 45) rotate(-9) scale(0.64) translate(-50 -52).
void _intoLeafSpace(Canvas canvas) {
  canvas
    ..translate(_inset, _inset)
    ..scale(_unit)
    ..translate(50, 45)
    ..rotate(-9 * math.pi / 180)
    ..scale(0.64)
    ..translate(-50, -52);
}

void _background(Canvas canvas) {
  canvas.drawRect(const Rect.fromLTWH(0, 0, _size, _size), Paint()..color = _lake);
  canvas
    ..save()
    ..translate(_inset, _inset)
    ..scale(_unit);
  // Water band runs from y=71 to the bottom edge of the full 108 dp layer.
  canvas.drawRect(Rect.fromLTRB(-_inset / _unit, 71, 100 + _inset / _unit, 100 + _inset / _unit), Paint()..color = _water);
  canvas.drawPath(_ripples, _stroke(_ripple, 1.6));
  canvas.restore();
}

void _foreground(Canvas canvas) {
  canvas.save();
  _intoLeafSpace(canvas);
  canvas.drawPath(_stem, _stroke(_birch, 7));
  canvas.drawPath(_stem, _stroke(_maple, 2.6));
  canvas.drawPath(_blade, Paint()..color = _maple);
  canvas.drawPath(_blade, _stroke(_birch, 3.4));
  canvas.drawPath(_veins, _stroke(_vein.withValues(alpha: 0.85), 1.2));
  canvas.restore();
}

/// Single-colour silhouette for Android 13+ themed icons.
void _monochrome(Canvas canvas) {
  canvas.save();
  _intoLeafSpace(canvas);
  canvas.drawPath(_stem, _stroke(Colors.white, 3.4));
  canvas.drawPath(_blade, Paint()..color = Colors.white);
  canvas.restore();
}

Future<void> _render(String path, void Function(Canvas) paint) async {
  final recorder = ui.PictureRecorder();
  paint(Canvas(recorder));
  final image = await recorder.endRecording().toImage(_size.toInt(), _size.toInt());
  final png = await image.toByteData(format: ui.ImageByteFormat.png);
  File(path).writeAsBytesSync(png!.buffer.asUint8List());
}

void main() {
  testWidgets('render adaptive icon layers', (tester) async {
    await tester.runAsync(() async {
      await _render('assets/icon/adaptive-background.png', _background);
      await _render('assets/icon/adaptive-foreground.png', _foreground);
      await _render('assets/icon/adaptive-monochrome.png', _monochrome);
    });
  });
}
