import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../theme/tokens.dart';

/// Visual state of an answer option.
///
/// Every judged state carries an icon and a word, never colour alone.
enum AnswerState {
  /// Mist border, letter or empty radio.
  idle,

  /// Mock test selection: lake, not judged.
  selected,

  /// Forest border + check, "Correct".
  correct,

  /// Amber border + ×, "Your answer".
  incorrect,
}

class AnswerRow extends StatelessWidget {
  const AnswerRow({
    super.key,
    required this.index,
    required this.label,
    required this.state,
    this.onTap,
    this.radio = false,
  });

  final int index;
  final String label;
  final AnswerState state;
  final VoidCallback? onTap;

  /// Mock test style (radio circles) instead of A–D letter badges.
  final bool radio;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l = AppLocalizations.of(context);
    final letter = String.fromCharCode(65 + index);

    final (fill, border, borderWidth) = switch (state) {
      AnswerState.idle => (c.card, c.border, 1.5),
      AnswerState.selected => (c.lakeTint, c.lake, 2.5),
      AnswerState.correct => (c.forestTint, c.forest, 2.5),
      AnswerState.incorrect => (c.amberFill, c.amberBorder, 2.5),
    };

    final stateWord = switch (state) {
      AnswerState.correct => l.answerCorrect,
      AnswerState.incorrect => l.answerYours,
      _ => null,
    };
    final stateColor = state == AnswerState.correct ? c.forest : c.amberText;

    final leading = switch (state) {
      AnswerState.correct => _Badge(color: c.forest, child: const Icon(Icons.check_rounded, color: Colors.white, size: 24)),
      AnswerState.incorrect => _Badge(color: c.amberText, child: const Icon(Icons.close_rounded, color: Colors.white, size: 24)),
      AnswerState.selected when radio => _Radio(selected: true, color: c.lake),
      _ when radio => _Radio(selected: false, color: c.outline),
      _ => _Badge(
          color: c.mist,
          child: Text(letter, style: context.text.labelMedium!.copyWith(color: c.forest, fontSize: 16)),
        ),
    };

    final emphasised = state != AnswerState.idle;
    final semantics = [
      if (!radio) letter,
      label,
      ?stateWord,
      if (state == AnswerState.selected) l.answerSelected,
    ].join(', ');

    return Semantics(
      button: onTap != null,
      selected: state != AnswerState.idle,
      label: semantics,
      excludeSemantics: true,
      child: Material(
        color: fill,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Metrics.answerRadius),
          side: BorderSide(color: border, width: borderWidth),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(Metrics.answerRadius),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: Metrics.answerMinHeight + 10),
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(18, 12, 18, 12),
              child: Row(
                children: [
                  leading,
                  const SizedBox(width: 18),
                  Expanded(
                    child: Text(
                      label,
                      style: context.text.bodyLarge!.copyWith(
                        fontSize: 19,
                        height: 1.35,
                        fontWeight: emphasised && state != AnswerState.incorrect ? FontWeight.w600 : FontWeight.w400,
                        color: state == AnswerState.incorrect ? c.amberText : c.ink,
                      ),
                    ),
                  ),
                  if (stateWord != null) ...[
                    const SizedBox(width: 12),
                    Text(
                      stateWord,
                      style: context.text.bodyMedium!.copyWith(fontWeight: FontWeight.w600, color: stateColor),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.color, required this.child});

  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: child,
    );
  }
}

class _Radio extends StatelessWidget {
  const _Radio({required this.selected, required this.color});

  final bool selected;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: selected ? color : null,
        border: Border.all(color: color, width: 2.5),
      ),
      alignment: Alignment.center,
      child: selected
          ? Container(width: 11, height: 11, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle))
          : null,
    );
  }
}
