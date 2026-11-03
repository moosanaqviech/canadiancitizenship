import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../content/chapters.dart';
import '../l10n/app_localizations.dart';
import '../monetization/monetization.dart';
import '../state/app_state.dart';
import '../theme/tokens.dart';
import '../widgets/answer_row.dart';
import '../widgets/common.dart';
import 'mock_test_screen.dart';

/// 04b Mock test results.
class MockResultsScreen extends StatelessWidget {
  const MockResultsScreen({
    super.key,
    required this.result,
    required this.number,
    required this.answers,
  });

  final MockResult result;
  final int number;

  /// Question id → chosen option (null if unanswered).
  final Map<String, int?> answers;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final c = context.colors;
    final wrong = result.wrongIds.map((id) => questionsById[id]!).toList();
    final minutes = math.max(1, (result.seconds / 60).ceil());

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsetsDirectional.fromSTEB(Metrics.gutter, 16, Metrics.gutter, 0),
              sliver: SliverList.list(children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        l.resultsHeader(number),
                        style: context.text.titleLarge!.copyWith(color: c.inkSecondary),
                      ),
                    ),
                    SquareIconButton(
                      icon: Icons.close_rounded,
                      tooltip: l.close,
                      onPressed: () {
                        // Leaving the results is the natural break for a
                        // full-screen ad; never before the score is seen.
                        MonetizationScope.read(context).showInterstitial();
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Center(
                  child: Semantics(
                    label: l.scoreOutOf(result.score, MockRules.questions),
                    excludeSemantics: true,
                    child: SizedBox.square(
                      dimension: 220,
                      child: CustomPaint(
                        painter: _ScoreRing(
                          value: result.score / MockRules.questions,
                          passMark: MockRules.passMark / MockRules.questions,
                          color: result.passed ? c.maple : c.lake,
                          track: c.mist,
                          tick: c.forest,
                        ),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${result.score}',
                                style: context.text.displayLarge!.copyWith(fontSize: 64, color: c.forest, height: 1),
                              ),
                              Text(l.ofTotal(MockRules.questions),
                                  style: context.text.bodyLarge!.copyWith(color: c.inkSecondary, fontSize: 19)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Semantics(
                  header: true,
                  child: Text(
                    result.passed ? l.youPassed : l.notYetPassed,
                    textAlign: TextAlign.center,
                    style: context.text.displayMedium!.copyWith(color: result.passed ? c.mapleText : c.forest),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  l.resultsMeta(MockRules.passMark, minutes, MockRules.duration.inMinutes),
                  textAlign: TextAlign.center,
                  style: context.text.bodyLarge!.copyWith(color: c.inkSecondary, fontSize: 18),
                ),
                const SizedBox(height: 22),
                AppCard(
                  child: wrong.isEmpty
                      ? Text(l.nothingToReview, style: context.text.bodyLarge)
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Eyebrow(l.toReview(wrong.length)),
                            for (var i = 0; i < wrong.length; i++) ...[
                              if (i > 0) Divider(height: 1, color: c.mist),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsetsDirectional.only(top: 10, end: 16),
                                      child: Container(
                                        width: 12,
                                        height: 12,
                                        decoration: BoxDecoration(color: c.amberBorder, shape: BoxShape.circle),
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(chapterOf(wrong[i]).title.of(context), style: context.text.titleMedium),
                                          Text(
                                            wrong[i].subject.of(context),
                                            style: context.text.bodyMedium!.copyWith(color: c.inkSecondary, fontSize: 16),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                ),
              ]),
            ),
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(Metrics.gutter, 24, Metrics.gutter, 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (wrong.isNotEmpty) ...[
                      SizedBox(
                        width: double.infinity,
                        child: AppButton(
                          label: l.reviewAnswers(wrong.length),
                          onPressed: () => Navigator.of(context).push(MaterialPageRoute<void>(
                            builder: (_) => AnswerReviewScreen(ids: result.wrongIds, answers: answers),
                          )),
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                    SizedBox(
                      width: double.infinity,
                      child: AppButton(
                        label: l.anotherMock,
                        variant: ButtonVariant.secondary,
                        // No ad here: the next test's timer would run behind it.
                        onPressed: () => Navigator.of(context).pushReplacement(
                          MaterialPageRoute<void>(builder: (_) => const MockTestScreen()),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Score ring with a small tick at the pass mark.
class _ScoreRing extends CustomPainter {
  _ScoreRing({
    required this.value,
    required this.passMark,
    required this.color,
    required this.track,
    required this.tick,
  });

  final double value;
  final double passMark;
  final Color color;
  final Color track;
  final Color tick;

  @override
  void paint(Canvas canvas, Size size) {
    const stroke = 22.0;
    final center = size.center(Offset.zero);
    final radius = size.shortestSide / 2 - stroke / 2 - 8;
    final rect = Rect.fromCircle(center: center, radius: radius);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, paint..color = track);
    if (value > 0) {
      canvas.drawArc(rect, -math.pi / 2, math.pi * 2 * value, false, paint..color = color);
    }

    final angle = -math.pi / 2 + math.pi * 2 * passMark;
    final dir = Offset(math.cos(angle), math.sin(angle));
    canvas.drawLine(
      center + dir * (radius + stroke / 2 + 6),
      center + dir * (radius + stroke / 2 - 4),
      Paint()
        ..color = tick
        ..strokeWidth = 4
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_ScoreRing old) => old.value != value || old.color != color;
}

/// Walks through mock-test answers that need another look.
class AnswerReviewScreen extends StatelessWidget {
  const AnswerReviewScreen({super.key, required this.ids, required this.answers});

  final List<String> ids;
  final Map<String, int?> answers;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final c = context.colors;
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsetsDirectional.fromSTEB(Metrics.gutter, 16, Metrics.gutter, 32),
          children: [
            Row(
              children: [
                SquareIconButton(
                  icon: Icons.chevron_left_rounded,
                  tooltip: l.back,
                  onPressed: () => Navigator.of(context).pop(),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Semantics(
                    header: true,
                    child: Text(l.reviewTitle, style: context.text.headlineLarge!.copyWith(color: c.forest)),
                  ),
                ),
              ],
            ),
            for (final id in ids) ...[
              const SizedBox(height: 28),
              Builder(builder: (context) {
                final q = questionsById[id]!;
                final chosen = answers[id];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Eyebrow(chapterOf(q).title.of(context)),
                    const SizedBox(height: 6),
                    Text(q.prompt.of(context), style: context.text.titleLarge),
                    const SizedBox(height: 14),
                    for (var i = 0; i < q.options.length; i++)
                      if (i == q.correct || i == chosen) ...[
                        AnswerRow(
                          index: i,
                          label: q.options[i].of(context),
                          state: i == q.correct ? AnswerState.correct : AnswerState.incorrect,
                        ),
                        const SizedBox(height: 10),
                      ],
                    Text(q.explanation.of(context), style: context.text.bodyLarge!.copyWith(color: c.inkSecondary)),
                  ],
                );
              }),
            ],
          ],
        ),
      ),
    );
  }
}
