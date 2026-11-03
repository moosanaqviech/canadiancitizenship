import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../state/app_state.dart';
import '../theme/tokens.dart';

// The original five-lobe autumn leaf from identity/app-icon-lake-1024.svg,
// in its 100 × 100 design space. Not the flag's 11-point leaf.
const _bladeSvg =
    'M50 82C56 78 64 79 69 81L66 74C76 75 86 72 92 64C87 62 83 60 80 57C84 54 86 50 88 45'
    'C82 47 76 50 72 52C74 44 80 36 88 27C80 28 72 30 66 34C66 29 65 24 64 19C60 23 58 26 56 29'
    'C56 20 54 12 50 4C46 12 44 20 44 29C42 26 40 23 36 19C35 24 34 29 34 34C28 30 20 28 12 27'
    'C20 36 26 44 28 52C24 50 18 47 12 45C14 50 16 54 20 57C17 60 13 62 8 64C14 72 24 75 34 74'
    'L31 81C36 79 44 78 50 82Z';
const _stemSvg = 'M50 81C50.6 87 49.6 92 47 97';
const _veinsSvg =
    'M50 79V14M50 60L82 33M50 60L18 33M50 70L85 63M50 70L15 63';

final Path _blade = parseSvgPath(_bladeSvg);
final Path _stem = parseSvgPath(_stemSvg);
final Path _veins = parseSvgPath(_veinsSvg);

/// Bounds of the leaf artwork (blade + stem) in design space.
const _top = 4.0, _bottom = 97.0, _left = 8.0, _right = 92.0;

/// The maple leaf progress motif.
///
/// * [LeafStage.notStarted] — outline only.
/// * [LeafStage.inProgress] — fills with red from the stem up by [fill].
/// * [LeafStage.chapterDone] / [LeafStage.testReady] — fully red; test-ready
///   adds veins and a birch keyline so it reads on the lake.
class MapleLeaf extends StatelessWidget {
  const MapleLeaf({
    super.key,
    required this.stage,
    this.fill = 1,
    this.size = 48,
    this.semanticLabel,
  });

  final LeafStage stage;
  final double fill;
  final double size;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final leaf = CustomPaint(
      size: Size.square(size),
      painter: _LeafPainter(
        stage: stage,
        fill: fill.clamp(0, 1),
        maple: c.maple,
        outline: stage == LeafStage.notStarted ? c.outline : c.maple,
        keyline: c.birch,
        vein: const Color(0xFF9A2321),
      ),
    );
    if (semanticLabel == null) return ExcludeSemantics(child: leaf);
    return Semantics(label: semanticLabel, image: true, child: leaf);
  }
}

class _LeafPainter extends CustomPainter {
  _LeafPainter({
    required this.stage,
    required this.fill,
    required this.maple,
    required this.outline,
    required this.keyline,
    required this.vein,
  });

  final LeafStage stage;
  final double fill;
  final Color maple;
  final Color outline;
  final Color keyline;
  final Color vein;

  @override
  void paint(Canvas canvas, Size size) {
    const w = _right - _left, h = _bottom - _top;
    final scale = math.min(size.width / w, size.height / h);
    canvas.save();
    canvas.translate((size.width - w * scale) / 2, (size.height - h * scale) / 2);
    canvas.scale(scale);
    canvas.translate(-_left, -_top);

    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round;
    final solid = Paint()..color = maple;

    switch (stage) {
      case LeafStage.notStarted:
        canvas.drawPath(_blade, stroke..color = outline..strokeWidth = 3);
        canvas.drawPath(_stem, stroke);
      case LeafStage.inProgress:
        // Fill rises from the stem tip toward the top lobe.
        final y = _bottom - (_bottom - _top) * fill;
        canvas.save();
        canvas.clipRect(Rect.fromLTRB(0, y, 100, 100));
        canvas.drawPath(_blade, solid);
        canvas.restore();
        canvas.drawPath(_blade, stroke..color = outline..strokeWidth = 2.6);
        canvas.drawPath(_stem, stroke..strokeWidth = 3);
      case LeafStage.chapterDone:
        canvas.drawPath(_blade, solid);
        canvas.drawPath(_stem, stroke..color = maple..strokeWidth = 3);
      case LeafStage.testReady:
        canvas.drawPath(_stem, stroke..color = keyline..strokeWidth = 7);
        canvas.drawPath(_stem, stroke..color = maple..strokeWidth = 2.6);
        canvas.drawPath(_blade, solid);
        canvas.drawPath(_blade, stroke..color = keyline..strokeWidth = 3.4);
        canvas.drawPath(
            _veins,
            stroke
              ..color = vein.withValues(alpha: 0.85)
              ..strokeWidth = 1.2);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(_LeafPainter old) =>
      old.stage != stage ||
      old.fill != fill ||
      old.maple != maple ||
      old.outline != outline;
}

/// Gentle 2–5 s ease-in-out drift for the one animated element on a screen.
/// Shows [child] still when the device asks for reduced motion.
class LeafDrift extends StatefulWidget {
  const LeafDrift({super.key, required this.child, this.amplitude = 5});

  final Widget child;
  final double amplitude;

  @override
  State<LeafDrift> createState() => _LeafDriftState();
}

class _LeafDriftState extends State<LeafDrift>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 4000),
  );
  late final _curve =
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller.stop();
      _controller.value = 0.5;
    } else if (!_controller.isAnimating) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _curve.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _curve,
      builder: (context, child) {
        final t = _curve.value * 2 - 1; // -1 … 1
        return Transform.translate(
          offset: Offset(0, t * widget.amplitude),
          child: Transform.rotate(angle: t * 0.06, child: child),
        );
      },
      child: widget.child,
    );
  }
}

/// Minimal SVG path parser for absolute M, L, H, V, C and Z commands —
/// enough for the leaf artwork above.
Path parseSvgPath(String d) {
  final path = Path();
  final tokens = RegExp(r'[MLHVCZ]|-?\d*\.?\d+')
      .allMatches(d)
      .map((m) => m.group(0)!)
      .toList();
  var i = 0;
  var cmd = 'M';
  var x = 0.0, y = 0.0;
  double next() => double.parse(tokens[i++]);
  while (i < tokens.length) {
    if (RegExp(r'^[MLHVCZ]$').hasMatch(tokens[i])) cmd = tokens[i++];
    switch (cmd) {
      case 'M':
        x = next();
        y = next();
        path.moveTo(x, y);
        cmd = 'L';
      case 'L':
        x = next();
        y = next();
        path.lineTo(x, y);
      case 'H':
        x = next();
        path.lineTo(x, y);
      case 'V':
        y = next();
        path.lineTo(x, y);
      case 'C':
        final x1 = next(), y1 = next(), x2 = next(), y2 = next();
        x = next();
        y = next();
        path.cubicTo(x1, y1, x2, y2, x, y);
      case 'Z':
        path.close();
    }
  }
  return path;
}
