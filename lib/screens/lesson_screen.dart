import 'package:flutter/material.dart';

import '../content/models.dart';
import '../l10n/app_localizations.dart';
import '../state/app_state.dart';
import '../theme/tokens.dart';
import '../widgets/common.dart';
import 'quiz_screen.dart';

/// 02 Lesson card.
class LessonScreen extends StatefulWidget {
  const LessonScreen({
    super.key,
    required this.chapter,
    this.startIndex = 0,
    this.review = false,
  });

  final Chapter chapter;
  final int startIndex;

  /// Opened from a quiz's "Review card": doesn't lead on to the quiz.
  final bool review;

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  late int _index = widget.startIndex.clamp(0, widget.chapter.cards.length - 1);

  Chapter get _chapter => widget.chapter;
  bool get _isLast => _index == _chapter.cards.length - 1;

  void _next() {
    final state = AppScope.read(context);
    if (!widget.review) state.setCardIndex(_chapter, _index + 1);
    if (!_isLast) {
      setState(() => _index++);
    } else if (widget.review) {
      Navigator.of(context).pop();
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(builder: (_) => QuizScreen(chapter: _chapter)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final c = context.colors;
    final card = _chapter.cards[_index];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(Metrics.gutter, 16, Metrics.gutter, 0),
              child: FlowHeader(
                leading: SquareIconButton(
                  icon: Icons.chevron_left_rounded,
                  tooltip: l.back,
                  onPressed: () => Navigator.of(context).pop(),
                ),
                caption: l.lessonHeader(_chapter.number, _chapter.title.of(context)),
                progress: Semantics(
                  label: l.cardOf(_index + 1, _chapter.cards.length),
                  child: SegmentedProgress(done: _index + 1, total: _chapter.cards.length),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                key: ValueKey(_index),
                padding: const EdgeInsetsDirectional.fromSTEB(Metrics.gutter, 28, Metrics.gutter, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Semantics(
                      header: true,
                      child: Text(card.title.of(context), style: context.text.displayMedium!.copyWith(color: c.forest)),
                    ),
                    const SizedBox(height: 14),
                    Text(card.body.of(context), style: context.text.bodyLarge!.copyWith(fontSize: 19)),
                    if (card.tiers.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      _Tiers(tiers: card.tiers),
                    ],
                    if (card.points.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      for (final p in card.points) _Point(text: p.of(context)),
                    ],
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(Metrics.gutter, 8, Metrics.gutter, 16),
              child: Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: AppButton(
                      label: l.previous,
                      variant: ButtonVariant.quiet,
                      onPressed: _index == 0 ? null : () => setState(() => _index--),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 8,
                    child: AppButton(
                      label: !_isLast
                          ? l.nextCard
                          : widget.review
                              ? l.back
                              : l.goToQuiz,
                      onPressed: _next,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Stacked, progressively inset tiers joined by a thin connector:
/// forest, then lake, then card.
class _Tiers extends StatelessWidget {
  const _Tiers({required this.tiers});

  final List<Tier> tiers;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final styles = [
      (c.forest, Colors.white, const Color(0xFFD7E3DD), null),
      (c.lake, Colors.white, const Color(0xFFDCE8F0), null),
      (c.card, c.forest, c.inkSecondary, c.border),
    ];
    return Column(
      children: [
        for (var i = 0; i < tiers.length; i++) ...[
          if (i > 0)
            Container(width: 2, height: 22, color: c.outline),
          Padding(
            padding: EdgeInsetsDirectional.symmetric(horizontal: 16.0 * i),
            child: Builder(builder: (context) {
              final (bg, heading, sub, border) = styles[i % styles.length];
              final tier = tiers[i];
              return Container(
                width: double.infinity,
                padding: const EdgeInsetsDirectional.fromSTEB(22, 18, 22, 18),
                decoration: BoxDecoration(
                  color: bg,
                  borderRadius: BorderRadius.circular(Metrics.cardRadius),
                  border: border == null ? null : Border.all(color: border, width: 1.5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(tier.heading.of(context), style: context.text.titleLarge!.copyWith(color: heading)),
                    const SizedBox(height: 6),
                    Text(tier.subtitle.of(context), style: context.text.bodyLarge!.copyWith(color: sub)),
                    const SizedBox(height: 4),
                    Text(
                      tier.detail.of(context),
                      style: context.text.bodyLarge!.copyWith(color: bg == c.card ? c.ink : Colors.white),
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ],
    );
  }
}

class _Point extends StatelessWidget {
  const _Point({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.only(top: 10, end: 14),
            child: Container(width: 8, height: 8, decoration: BoxDecoration(color: c.lake, shape: BoxShape.circle)),
          ),
          Expanded(child: Text(text, style: context.text.bodyLarge)),
        ],
      ),
    );
  }
}
