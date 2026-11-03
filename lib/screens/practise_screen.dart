import 'package:flutter/material.dart';

import '../content/chapters.dart';
import '../l10n/app_localizations.dart';
import '../state/app_state.dart';
import '../theme/tokens.dart';
import 'quiz_screen.dart';

/// Practise tab: retake any chapter quiz.
class PractiseScreen extends StatelessWidget {
  const PractiseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final c = context.colors;
    final state = AppScope.of(context);

    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsetsDirectional.fromSTEB(Metrics.gutter, 32, Metrics.gutter, 32),
        children: [
          Semantics(
            header: true,
            child: Text(l.practiseTitle, style: context.text.displayMedium!.copyWith(color: c.forest)),
          ),
          const SizedBox(height: 8),
          Text(l.practiseSubtitle, style: context.text.bodyLarge!.copyWith(color: c.inkSecondary)),
          const SizedBox(height: 20),
          for (final ch in chapters) ...[
            Material(
              color: c.card,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Metrics.answerRadius),
                side: BorderSide(color: c.border, width: 1.5),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(Metrics.answerRadius),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(builder: (_) => QuizScreen(chapter: ch)),
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: Metrics.answerMinHeight + 12),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(18, 12, 12, 12),
                    child: Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(color: c.forest, shape: BoxShape.circle),
                          child: Text(
                            '${ch.number}',
                            style: context.text.labelMedium!.copyWith(color: Colors.white, fontSize: 16),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(ch.title.of(context), style: context.text.titleMedium),
                              Text(
                                state.quizBest(ch) == null
                                    ? l.notTried
                                    : l.bestScore(state.quizBest(ch)!, ch.questions.length),
                                style: context.text.bodyMedium!.copyWith(color: c.inkSecondary),
                              ),
                            ],
                          ),
                        ),
                        Icon(Icons.chevron_right_rounded, color: c.inkSecondary),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }
}
