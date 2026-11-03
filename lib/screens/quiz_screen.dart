import 'package:flutter/material.dart';

import '../content/models.dart';
import '../l10n/app_localizations.dart';
import '../state/app_state.dart';
import '../theme/tokens.dart';
import '../widgets/answer_row.dart';
import '../widgets/common.dart';
import '../widgets/leaf.dart';
import 'lesson_screen.dart';

/// 03 Chapter quiz: unanswered → correct / incorrect, no timer.
class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key, required this.chapter});

  final Chapter chapter;

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _index = 0;
  int? _chosen;
  int _score = 0;
  bool _finished = false;

  List<Question> get _questions => widget.chapter.questions;
  Question get _q => _questions[_index];

  void _choose(int i) {
    if (_chosen != null) return;
    final correct = i == _q.correct;
    AppScope.read(context).recordAnswer(_q, correct: correct);
    setState(() {
      _chosen = i;
      if (correct) _score++;
    });
  }

  void _next() {
    if (_index == _questions.length - 1) {
      AppScope.read(context).recordQuiz(widget.chapter, _score);
      setState(() => _finished = true);
    } else {
      setState(() {
        _index++;
        _chosen = null;
      });
    }
  }

  void _restart() => setState(() {
        _index = 0;
        _chosen = null;
        _score = 0;
        _finished = false;
      });

  void _reviewCard() {
    Navigator.of(context).push(MaterialPageRoute<void>(
      builder: (_) => LessonScreen(
        chapter: widget.chapter,
        startIndex: bestCardFor(widget.chapter, _q, Localizations.localeOf(context)),
        review: true,
      ),
    ));
  }

  AnswerState _stateOf(int i) {
    if (_chosen == null) return AnswerState.idle;
    if (i == _q.correct) return AnswerState.correct;
    if (i == _chosen) return AnswerState.incorrect;
    return AnswerState.idle;
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final c = context.colors;

    if (_finished) return _Summary(chapter: widget.chapter, score: _score, onRetry: _restart);

    final answered = _chosen != null;
    final wasRight = _chosen == _q.correct;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsetsDirectional.fromSTEB(Metrics.gutter, 16, Metrics.gutter, 0),
              sliver: SliverList.list(children: [
                FlowHeader(
                  leading: SquareIconButton(
                    icon: Icons.close_rounded,
                    tooltip: l.close,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  caption: l.quizHeader(widget.chapter.number, _index + 1, _questions.length),
                  progress: ProgressTrack(value: (_index + (answered ? 1 : 0)) / _questions.length),
                ),
                const SizedBox(height: 32),
                Semantics(
                  header: true,
                  child: Text(_q.prompt.of(context), style: context.text.headlineMedium!.copyWith(fontSize: 26)),
                ),
                const SizedBox(height: 22),
                for (var i = 0; i < _q.options.length; i++) ...[
                  AnswerRow(
                    index: i,
                    label: _q.options[i].of(context),
                    state: _stateOf(i),
                    onTap: answered ? null : () => _choose(i),
                  ),
                  const SizedBox(height: 12),
                ],
              ]),
            ),
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(Metrics.gutter, 16, Metrics.gutter, 16),
                child: Align(
                  alignment: AlignmentDirectional.bottomCenter,
                  child: !answered
                      ? Text(
                          l.quizHint,
                          textAlign: TextAlign.center,
                          style: context.text.bodyLarge!.copyWith(color: c.inkSecondary),
                        )
                      : Semantics(
                          liveRegion: true,
                          child: _Feedback(
                            right: wasRight,
                            explanation: _q.explanation.of(context),
                            isLast: _index == _questions.length - 1,
                            onNext: _next,
                            onReview: _reviewCard,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Feedback extends StatelessWidget {
  const _Feedback({
    required this.right,
    required this.explanation,
    required this.isLast,
    required this.onNext,
    required this.onReview,
  });

  final bool right;
  final String explanation;
  final bool isLast;
  final VoidCallback onNext;
  final VoidCallback onReview;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final c = context.colors;
    final nextLabel = isLast ? l.seeResults : l.nextQuestion;

    final text = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          right ? l.thatsRight : l.notQuite,
          style: context.text.headlineMedium!.copyWith(color: right ? c.forest : c.amberText),
        ),
        const SizedBox(height: 6),
        Text(explanation, style: context.text.bodyLarge!.copyWith(fontSize: 19)),
      ],
    );

    return AppCard(
      padding: const EdgeInsetsDirectional.fromSTEB(22, 24, 22, 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (right)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsetsDirectional.only(top: 2, end: 14),
                  child: MapleLeaf(stage: LeafStage.chapterDone, size: 36),
                ),
                Expanded(child: text),
              ],
            )
          else
            text,
          const SizedBox(height: 20),
          if (right)
            SizedBox(width: double.infinity, child: AppButton(label: nextLabel, onPressed: onNext))
          else
            Row(
              children: [
                Expanded(child: AppButton(label: l.reviewCard, variant: ButtonVariant.secondary, onPressed: onReview)),
                const SizedBox(width: 12),
                Expanded(child: AppButton(label: nextLabel, variant: ButtonVariant.dark, onPressed: onNext)),
              ],
            ),
        ],
      ),
    );
  }
}

class _Summary extends StatelessWidget {
  const _Summary({required this.chapter, required this.score, required this.onRetry});

  final Chapter chapter;
  final int score;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final c = context.colors;
    final total = chapter.questions.length;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(Metrics.gutter, 16, Metrics.gutter, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: SquareIconButton(
                  icon: Icons.close_rounded,
                  tooltip: l.close,
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              const Spacer(),
              const Center(child: MapleLeaf(stage: LeafStage.chapterDone, size: 96)),
              const SizedBox(height: 28),
              Semantics(
                header: true,
                child: Text(l.quizDoneTitle(chapter.number), style: context.text.displayMedium!.copyWith(color: c.forest)),
              ),
              const SizedBox(height: 8),
              Text(l.quizScore(score, total), style: context.text.titleLarge!.copyWith(color: c.forest)),
              const SizedBox(height: 8),
              Text(l.quizDoneBody, style: context.text.bodyLarge!.copyWith(color: c.inkSecondary)),
              const Spacer(flex: 2),
              SizedBox(
                width: double.infinity,
                child: AppButton(label: l.backToJourney, onPressed: () => Navigator.of(context).pop()),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: AppButton(label: l.tryAgain, variant: ButtonVariant.quiet, onPressed: onRetry),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Picks the lesson card that shares the most words with the question and its
/// correct answer, so "Review card" lands on the relevant explanation.
int bestCardFor(Chapter chapter, Question q, Locale locale) {
  Set<String> words(String s) => s
      .toLowerCase()
      .split(RegExp(r'[^\p{L}\p{N}]+', unicode: true))
      .where((w) => w.length > 3)
      .toSet();

  final target = words('${q.prompt.resolve(locale)} ${q.options[q.correct].resolve(locale)}');
  var best = 0, bestScore = -1;
  for (var i = 0; i < chapter.cards.length; i++) {
    final card = chapter.cards[i];
    final text = [
      card.title,
      card.body,
      ...card.points,
      for (final t in card.tiers) ...[t.heading, t.subtitle, t.detail],
    ].map((t) => t.resolve(locale)).join(' ');
    final score = words(text).intersection(target).length;
    if (score > bestScore) {
      best = i;
      bestScore = score;
    }
  }
  return best;
}
