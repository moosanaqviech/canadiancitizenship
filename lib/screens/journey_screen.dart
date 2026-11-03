import 'package:flutter/material.dart';

import '../content/chapters.dart';
import '../content/labels.dart';
import '../content/models.dart';
import '../l10n/app_localizations.dart';
import '../state/app_state.dart';
import '../theme/tokens.dart';
import '../widgets/common.dart';
import '../widgets/landscape.dart';
import '../widgets/leaf.dart';
import 'lesson_screen.dart';
import 'quiz_screen.dart';
import 'settings_screen.dart';
import 'shell.dart';

/// 01 Home / chapter journey.
class JourneyScreen extends StatelessWidget {
  const JourneyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final c = context.colors;
    final state = AppScope.of(context);
    final current = state.currentChapter;

    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsetsDirectional.fromSTEB(Metrics.gutter, 24, Metrics.gutter, 32),
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l.yourJourney, style: context.text.bodyLarge!.copyWith(color: c.inkSecondary, fontSize: 18)),
                    const SizedBox(height: 4),
                    Semantics(
                      header: true,
                      child: Text(
                        l.chaptersDone(state.chaptersDone, chapters.length),
                        style: context.text.displayMedium!.copyWith(color: c.forest, fontSize: 28),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              SquareIconButton(
                icon: Icons.settings_outlined,
                tooltip: l.settings,
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(builder: (_) => const SettingsScreen()),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _Hero(stage: state.overallStage, fill: state.overallProgress),
          const SizedBox(height: 20),
          if (current != null) _ContinueCard(chapter: current) else _AllDoneCard(),
          const SizedBox(height: 16),
          for (final ch in chapters) _ChapterRow(chapter: ch),
        ],
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero({required this.stage, required this.fill});

  final LeafStage stage;
  final double fill;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: AspectRatio(
        aspectRatio: 830 / 400,
        child: LayoutBuilder(
          builder: (context, box) => Stack(
            children: [
              const Positioned.fill(
                child: ExcludeSemantics(
                  child: CustomPaint(painter: LandscapePainter(sun: Color(0xFFF6EFE2))),
                ),
              ),
              PositionedDirectional(
                start: box.maxWidth * 0.33,
                top: box.maxHeight * 0.14,
                child: LeafDrift(
                  child: MapleLeaf(
                    stage: stage,
                    // Show a sliver of red as soon as anything is started.
                    fill: 0.15 + fill * 0.85,
                    size: box.maxHeight * 0.3,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ContinueCard extends StatelessWidget {
  const _ContinueCard({required this.chapter});

  final Chapter chapter;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final c = context.colors;
    final state = AppScope.of(context);
    final index = state.cardIndex(chapter);
    final lessonDone = state.lessonDone(chapter);

    final status = lessonDone
        ? l.lessonDoneQuizNext
        : l.cardProgress(index + 1, chapter.cards.length, state.minutesLeft(chapter));
    final action = lessonDone
        ? l.startQuiz
        : index == 0
            ? l.startLesson
            : l.continueLesson;

    return AppCard(
      padding: const EdgeInsetsDirectional.fromSTEB(22, 24, 22, 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Eyebrow('${l.chapterLabel(chapter.number)} · ${placeOf(context, chapter)}'),
          const SizedBox(height: 8),
          Text(chapter.title.of(context), style: context.text.headlineMedium!.copyWith(fontSize: 24)),
          const SizedBox(height: 6),
          Text(status, style: context.text.bodyLarge!.copyWith(color: c.inkSecondary)),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: AppButton(
              label: action,
              onPressed: () => openChapter(context, chapter),
            ),
          ),
        ],
      ),
    );
  }
}

/// Opens the lesson, or the quiz once the lesson is finished.
void openChapter(BuildContext context, Chapter chapter) {
  final state = AppScope.read(context);
  Navigator.of(context).push(MaterialPageRoute<void>(
    builder: (_) => state.lessonDone(chapter)
        ? QuizScreen(chapter: chapter)
        : LessonScreen(chapter: chapter, startIndex: state.cardIndex(chapter)),
  ));
}

class _AllDoneCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l.allDoneTitle, style: context.text.headlineMedium!.copyWith(fontSize: 24)),
          const SizedBox(height: 6),
          Text(l.allDoneBody, style: context.text.bodyLarge!.copyWith(color: context.colors.inkSecondary)),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: AppButton(label: l.takeMockTest, onPressed: () => Shell.selectTab(context, Shell.mock)),
          ),
        ],
      ),
    );
  }
}

class _ChapterRow extends StatelessWidget {
  const _ChapterRow({required this.chapter});

  final Chapter chapter;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final c = context.colors;
    final state = AppScope.of(context);
    final done = state.chapterDone(chapter);
    final isCurrent = state.currentChapter == chapter;
    final started = state.chapterStarted(chapter);

    final status = done
        ? l.statusDone
        : isCurrent && started
            ? l.statusInProgress
            : null;

    final Widget marker;
    if (done) {
      marker = const MapleLeaf(stage: LeafStage.chapterDone, size: 34);
    } else if (isCurrent) {
      marker = Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: c.mapleTint,
          border: Border.all(color: c.maple, width: 3.5),
        ),
      );
    } else {
      marker = Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: c.outline, width: 2.5)),
      );
    }

    final subtitle = [placeOf(context, chapter), ?status].join(' · ');

    return Semantics(
      button: true,
      label: '${chapter.number} · ${chapter.title.of(context)}, $subtitle',
      excludeSemantics: true,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => openChapter(context, chapter),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              SizedBox(width: 52, child: Center(child: marker)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${chapter.number} · ${chapter.title.of(context)}',
                      style: context.text.titleMedium!.copyWith(
                        fontSize: 20,
                        color: isCurrent ? c.forest : c.ink,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(subtitle, style: context.text.bodyMedium!.copyWith(color: c.inkSecondary, fontSize: 16)),
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
