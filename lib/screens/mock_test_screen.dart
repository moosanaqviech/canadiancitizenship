import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../content/chapters.dart';
import '../content/models.dart';
import '../l10n/app_localizations.dart';
import '../state/app_state.dart';
import '../theme/tokens.dart';
import '../widgets/answer_row.dart';
import '../widgets/common.dart';
import 'mock_results_screen.dart';

/// Draws a mock test: one question from every chapter, then the rest at
/// random, shuffled.
List<Question> drawMockQuestions([math.Random? random]) {
  final rnd = random ?? math.Random();
  final picked = <Question>[];
  for (final ch in chapters) {
    picked.add(ch.questions[rnd.nextInt(ch.questions.length)]);
  }
  final rest = [
    for (final ch in chapters) ...ch.questions.where((q) => !picked.contains(q)),
  ]..shuffle(rnd);
  picked.addAll(rest.take(MockRules.questions - picked.length));
  return picked.take(MockRules.questions).toList()..shuffle(rnd);
}

/// 04a Mock test in progress: 20 questions, 45 minutes, calm timer, flags.
class MockTestScreen extends StatefulWidget {
  const MockTestScreen({super.key, this.questions});

  /// Fixed questions (tests); drawn at random when null.
  final List<Question>? questions;

  @override
  State<MockTestScreen> createState() => _MockTestScreenState();
}

class _MockTestScreenState extends State<MockTestScreen> {
  late final List<Question> _questions = widget.questions ?? drawMockQuestions();
  late final List<int?> _answers = List.filled(_questions.length, null);
  final Set<int> _flags = {};
  final _stopwatch = Stopwatch()..start();
  Timer? _ticker;
  int _index = 0;
  bool _done = false;

  Duration get _remaining {
    final left = MockRules.duration - _stopwatch.elapsed;
    return left.isNegative ? Duration.zero : left;
  }

  @override
  void initState() {
    super.initState();
    // Minute-level display, so a gentle 1 s tick is plenty.
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_remaining == Duration.zero) {
        _timeUp();
      } else {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  Future<void> _timeUp() async {
    _ticker?.cancel();
    final l = AppLocalizations.of(context);
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(l.timeUpTitle),
        content: Text(l.timeUpBody),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(l.seeMyResults)),
        ],
      ),
    );
    if (mounted) _finish();
  }

  Future<void> _confirmFinish() async {
    final unanswered = _answers.where((a) => a == null).length;
    if (unanswered > 0) {
      final l = AppLocalizations.of(context);
      final finish = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(l.finishConfirmTitle),
          content: Text(l.finishConfirmBody(unanswered)),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(false), child: Text(l.keepGoing)),
            TextButton(onPressed: () => Navigator.of(context).pop(true), child: Text(l.finishTest)),
          ],
        ),
      );
      if (finish != true) return;
    }
    _finish();
  }

  void _finish() {
    if (_done) return;
    _done = true;
    _ticker?.cancel();
    _stopwatch.stop();

    final state = AppScope.read(context);
    var score = 0;
    final wrong = <String>[];
    for (var i = 0; i < _questions.length; i++) {
      final q = _questions[i];
      final right = _answers[i] == q.correct;
      state.recordAnswer(q, correct: right);
      if (right) {
        score++;
      } else {
        wrong.add(q.id);
      }
    }
    final result = MockResult(
      score: score,
      seconds: math.min(_stopwatch.elapsed.inSeconds, MockRules.duration.inSeconds),
      wrongIds: wrong,
    );
    state.recordMock(result);

    Navigator.of(context).pushReplacement(MaterialPageRoute<void>(
      builder: (_) => MockResultsScreen(
        result: result,
        number: state.mockHistory.length,
        answers: {for (var i = 0; i < _questions.length; i++) _questions[i].id: _answers[i]},
      ),
    ));
  }

  Future<bool> _confirmLeave() async {
    final l = AppLocalizations.of(context);
    final leave = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l.leaveTitle),
        content: Text(l.leaveBody),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: Text(l.keepGoing)),
          TextButton(onPressed: () => Navigator.of(context).pop(true), child: Text(l.leave)),
        ],
      ),
    );
    return leave ?? false;
  }

  void _showFlagged() {
    final l = AppLocalizations.of(context);
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: context.colors.card,
      showDragHandle: true,
      builder: (sheet) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsetsDirectional.fromSTEB(Metrics.gutter, 0, Metrics.gutter, 16),
          children: [
            Text(l.flaggedQuestions, style: sheet.text.titleLarge),
            const SizedBox(height: 8),
            for (final i in _flags.toList()..sort())
              ListTile(
                minTileHeight: Metrics.answerMinHeight,
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.flag_outlined, color: sheet.colors.lake),
                title: Text(l.questionNumber(i + 1), style: sheet.text.titleMedium),
                subtitle: Text(
                  _questions[i].prompt.of(sheet),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: sheet.text.bodyMedium,
                ),
                onTap: () {
                  Navigator.of(sheet).pop();
                  setState(() => _index = i);
                },
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final c = context.colors;
    final q = _questions[_index];
    final isLast = _index == _questions.length - 1;
    final flagged = _flags.contains(_index);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final navigator = Navigator.of(context);
        if (await _confirmLeave()) navigator.pop();
      },
      child: Scaffold(
        body: Column(
          children: [
            _Header(
              index: _index,
              total: _questions.length,
              answers: _answers,
              minutesLeft: (_remaining.inSeconds / 60).ceil(),
              onClose: () => Navigator.of(context).maybePop(),
            ),
            Expanded(
              child: SafeArea(
                top: false,
                child: CustomScrollView(
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsetsDirectional.fromSTEB(Metrics.gutter, 28, Metrics.gutter, 0),
                      sliver: SliverList.list(children: [
                        Semantics(
                          header: true,
                          child: Text(q.prompt.of(context), style: context.text.headlineMedium!.copyWith(fontSize: 26)),
                        ),
                        const SizedBox(height: 22),
                        for (var i = 0; i < q.options.length; i++) ...[
                          AnswerRow(
                            index: i,
                            radio: true,
                            label: q.options[i].of(context),
                            state: _answers[_index] == i ? AnswerState.selected : AnswerState.idle,
                            onTap: () => setState(() => _answers[_index] = i),
                          ),
                          const SizedBox(height: 12),
                        ],
                        const SizedBox(height: 8),
                        Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: TextButton.icon(
                            onPressed: () => setState(() => flagged ? _flags.remove(_index) : _flags.add(_index)),
                            style: TextButton.styleFrom(
                              foregroundColor: c.lake,
                              minimumSize: const Size(Metrics.tapTarget, Metrics.tapTarget),
                              textStyle: context.text.labelLarge,
                            ),
                            icon: Icon(flagged ? Icons.flag_rounded : Icons.outlined_flag_rounded),
                            label: Text(flagged ? l.flagged : l.flagToReview),
                          ),
                        ),
                        if (_flags.isNotEmpty)
                          Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: TextButton(
                              onPressed: _showFlagged,
                              style: TextButton.styleFrom(
                                foregroundColor: c.forest,
                                minimumSize: const Size(Metrics.tapTarget, Metrics.tapTarget),
                                textStyle: context.text.bodyLarge!.copyWith(fontWeight: FontWeight.w600),
                              ),
                              child: Text(l.reviewFlagged(_flags.length)),
                            ),
                          ),
                      ]),
                    ),
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(Metrics.gutter, 16, Metrics.gutter, 16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              l.mockFooter,
                              textAlign: TextAlign.center,
                              style: context.text.bodyLarge!.copyWith(color: c.inkSecondary),
                            ),
                            const SizedBox(height: 16),
                            Row(
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
                                    label: isLast ? l.finishTest : l.nextQuestion,
                                    variant: ButtonVariant.dark,
                                    onPressed: isLast ? _confirmFinish : () => setState(() => _index++),
                                  ),
                                ),
                              ],
                            ),
                          ],
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

class _Header extends StatelessWidget {
  const _Header({
    required this.index,
    required this.total,
    required this.answers,
    required this.minutesLeft,
    required this.onClose,
  });

  final int index;
  final int total;
  final List<int?> answers;
  final int minutesLeft;

  /// Leaving asks for confirmation (see PopScope); without this button iOS
  /// users would have no way out, since the back swipe is blocked.
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final c = context.colors;
    final onDark = context.text.bodyLarge!.copyWith(color: const Color(0xFFD7E3DD));

    return ColoredBox(
      color: c.forest,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(Metrics.gutter, 20, Metrics.gutter, 22),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: onClose,
                    tooltip: l.close,
                    icon: const Icon(Icons.close_rounded, color: Colors.white),
                    style: IconButton.styleFrom(minimumSize: const Size(Metrics.tapTarget, Metrics.tapTarget)),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l.mockTitle, style: context.text.headlineMedium!.copyWith(color: Colors.white)),
                        Text(l.mockQuestionOf(index + 1, total), style: onDark),
                      ],
                    ),
                  ),
                  // Calm timer: no red, no pulsing, minutes only.
                  Container(
                    padding: const EdgeInsetsDirectional.fromSTEB(16, 10, 18, 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2C5E48),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.schedule_rounded, color: Colors.white, size: 22),
                        const SizedBox(width: 10),
                        Text(
                          l.minLeft(minutesLeft),
                          style: context.text.labelLarge!.copyWith(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              ExcludeSemantics(
                child: Row(
                  children: [
                    for (var i = 0; i < total; i++) ...[
                      if (i > 0) const SizedBox(width: 4),
                      Expanded(
                        child: Container(
                          height: 8,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: i == index
                                ? c.birch
                                : answers[i] != null
                                    ? const Color(0xFF86BAD8)
                                    : const Color(0xFF3B6A55),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
