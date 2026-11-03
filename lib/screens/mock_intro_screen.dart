import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../state/app_state.dart';
import '../theme/tokens.dart';
import '../widgets/common.dart';
import 'mock_test_screen.dart';

/// Mock test tab: explains the format and lists past results.
class MockIntroScreen extends StatelessWidget {
  const MockIntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final c = context.colors;
    final history = AppScope.of(context).mockHistory;

    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsetsDirectional.fromSTEB(Metrics.gutter, 32, Metrics.gutter, 32),
        children: [
          Semantics(
            header: true,
            child: Text(l.mockTitle, style: context.text.displayMedium!.copyWith(color: c.forest)),
          ),
          const SizedBox(height: 16),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _Fact(icon: Icons.help_outline_rounded, label: '20'),
                    _Fact(icon: Icons.schedule_rounded, label: '45 min'),
                    _Fact(icon: Icons.check_circle_outline_rounded, label: '15 / 20'),
                  ],
                ),
                const SizedBox(height: 18),
                Text(l.mockIntroBody, style: context.text.bodyLarge),
                const SizedBox(height: 10),
                Text(l.mockIntroCalm, style: context.text.bodyLarge!.copyWith(color: c.inkSecondary)),
                const SizedBox(height: 22),
                SizedBox(
                  width: double.infinity,
                  child: AppButton(
                    label: l.startMockTest,
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(builder: (_) => const MockTestScreen()),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (history.isNotEmpty) ...[
            const SizedBox(height: 28),
            Eyebrow(l.pastResults),
            const SizedBox(height: 8),
            for (var i = history.length - 1; i >= 0; i--)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    Expanded(child: Text(l.pastResultRow(i + 1), style: context.text.titleMedium)),
                    Text(
                      '${l.scoreOutOf(history[i].score, MockRules.questions)} · '
                      '${history[i].passed ? l.passedShort : l.notYetShort}',
                      style: context.text.bodyLarge!.copyWith(
                        fontWeight: FontWeight.w600,
                        color: history[i].passed ? c.mapleText : c.inkSecondary,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ],
      ),
    );
  }
}

class _Fact extends StatelessWidget {
  const _Fact({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: c.lake, size: 28),
          const SizedBox(height: 4),
          Text(label, style: context.text.titleMedium!.copyWith(color: c.forest)),
        ],
      ),
    );
  }
}
