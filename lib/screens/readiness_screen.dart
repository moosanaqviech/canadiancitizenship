import 'package:flutter/material.dart';

import '../content/chapters.dart';
import '../content/labels.dart';
import '../l10n/app_localizations.dart';
import '../state/app_state.dart';
import '../theme/tokens.dart';
import '../widgets/common.dart';
import '../widgets/landscape.dart';
import '../widgets/leaf.dart';
import 'lesson_screen.dart';
import 'shell.dart';

/// 05 Readiness check.
class ReadinessScreen extends StatelessWidget {
  const ReadinessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final c = context.colors;
    final state = AppScope.of(context);
    final history = state.mockHistory;
    final ready = state.testReady;
    final scores = state.topicScores;

    final String body;
    if (ready) {
      final last = history.skip(history.length - 3).map((m) => m.score).toList();
      body = l.readyBody(last[0], last[1], last[2]);
    } else if (history.isEmpty) {
      body = l.notReadyNone;
    } else {
      var streak = 0;
      for (final m in history.reversed) {
        if (!m.passed) break;
        streak++;
      }
      body = l.notReadySome(3 - streak);
    }

    final weak = scores.where((s) => s.needsBrushUp).toList()
      ..sort((a, b) => a.percent!.compareTo(b.percent!));

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: _Hero(stage: ready ? LeafStage.testReady : state.overallStage, fill: state.overallProgress)),
        SliverPadding(
          padding: const EdgeInsetsDirectional.fromSTEB(Metrics.gutter, 28, Metrics.gutter, 0),
          sliver: SliverList.list(children: [
            Eyebrow(l.readinessEyebrow),
            const SizedBox(height: 8),
            Semantics(
              header: true,
              child: Text(
                ready ? l.readyTitle : l.notReadyTitle,
                style: context.text.displayLarge!.copyWith(color: ready ? c.mapleText : c.forest),
              ),
            ),
            const SizedBox(height: 10),
            Text(body, style: context.text.bodyLarge!.copyWith(color: c.inkSecondary, fontSize: 19)),
            const SizedBox(height: 22),
            AppCard(
              child: Column(
                children: [
                  for (var i = 0; i < scores.length; i++) ...[
                    if (i > 0) const SizedBox(height: 18),
                    _TopicBar(score: scores[i]),
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
            child: Align(
              alignment: AlignmentDirectional.bottomCenter,
              child: SizedBox(
                width: double.infinity,
                child: weak.isNotEmpty
                    ? AppButton(
                        label: l.refresher(topicName(l, weak.first.topic)),
                        onPressed: () => Navigator.of(context).push(MaterialPageRoute<void>(
                          builder: (_) => LessonScreen(
                            chapter: chapters.firstWhere((ch) => ch.topic == weak.first.topic),
                            review: true,
                          ),
                        )),
                      )
                    : AppButton(
                        label: l.takeMockTest,
                        variant: ready ? ButtonVariant.secondary : ButtonVariant.primary,
                        onPressed: () => Shell.selectTab(context, Shell.mock),
                      ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero({required this.stage, required this.fill});

  final LeafStage stage;
  final double fill;

  @override
  Widget build(BuildContext context) {
    final onLake = stage == LeafStage.testReady || stage == LeafStage.chapterDone;
    final top = MediaQuery.paddingOf(context).top;
    return SizedBox(
      height: 260 + top,
      child: LayoutBuilder(
        builder: (context, box) {
          final leafSize = 96.0;
          final lakeY = box.maxHeight * 0.72;
          return Stack(
            children: [
              const Positioned.fill(
                child: ExcludeSemantics(child: CustomPaint(painter: LandscapePainter.warm())),
              ),
              if (onLake)
                Positioned(
                  left: box.maxWidth / 2 - 82,
                  top: lakeY + 40,
                  child: Container(
                    width: 164,
                    height: 18,
                    decoration: BoxDecoration(
                      color: const Color(0xFF235777),
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                ),
              Positioned(
                left: box.maxWidth / 2 - leafSize / 2,
                top: onLake ? lakeY - leafSize * 0.35 : top + 24,
                child: LeafDrift(
                  amplitude: onLake ? 2 : 5,
                  child: Transform.rotate(
                    angle: onLake ? 0.35 : 0,
                    child: MapleLeaf(stage: stage, fill: 0.15 + fill * 0.85, size: leafSize),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _TopicBar extends StatelessWidget {
  const _TopicBar({required this.score});

  final TopicScore score;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final c = context.colors;
    final pct = score.percent;
    final value = pct == null
        ? l.noAnswersYet
        : score.needsBrushUp
            ? '$pct% · ${l.brushUp}'
            : '$pct%';
    return Semantics(
      label: '${topicName(l, score.topic)}, $value',
      excludeSemantics: true,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(child: Text(topicName(l, score.topic), style: context.text.bodyLarge!.copyWith(fontSize: 18))),
              const SizedBox(width: 12),
              Text(
                value,
                style: context.text.bodyLarge!.copyWith(
                  fontWeight: pct == null ? FontWeight.w400 : FontWeight.w700,
                  color: pct == null ? c.inkSecondary : c.ink,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ProgressTrack(value: (pct ?? 0) / 100, height: 10),
        ],
      ),
    );
  }
}
