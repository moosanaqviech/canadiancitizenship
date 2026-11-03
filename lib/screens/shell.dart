import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../monetization/ad_banner.dart';
import '../theme/tokens.dart';
import 'journey_screen.dart';
import 'mock_intro_screen.dart';
import 'practise_screen.dart';
import 'readiness_screen.dart';

/// Tab host: Journey · Practise · Mock test · Readiness.
class Shell extends StatefulWidget {
  const Shell({super.key});

  static void selectTab(BuildContext context, int index) =>
      context.findAncestorStateOfType<_ShellState>()?._select(index);

  static const journey = 0, practise = 1, mock = 2, readiness = 3;

  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> {
  int _index = 0;

  void _select(int i) => setState(() => _index = i);

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: const [
          JourneyScreen(),
          PractiseScreen(),
          MockIntroScreen(),
          ReadinessScreen(),
        ],
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Only the tab screens carry a banner; lessons, quizzes and mock
          // tests are pushed over the shell and stay ad-free.
          const AdBanner(),
          _NavBar(
            index: _index,
            onSelect: _select,
            items: [
              (Icons.landscape_outlined, l.navJourney),
              (Icons.check_box_outlined, l.navPractise),
              (Icons.timer_outlined, l.navMock),
              (Icons.bar_chart_rounded, l.navReadiness),
            ],
          ),
        ],
      ),
    );
  }
}

class _NavBar extends StatelessWidget {
  const _NavBar({required this.index, required this.onSelect, required this.items});

  final int index;
  final ValueChanged<int> onSelect;
  final List<(IconData, String)> items;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: c.card,
        border: Border(top: BorderSide(color: c.border.withValues(alpha: 0.7))),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              for (var i = 0; i < items.length; i++)
                Expanded(
                  child: Semantics(
                    selected: i == index,
                    button: true,
                    label: items[i].$2,
                    excludeSemantics: true,
                    child: InkWell(
                      onTap: () => onSelect(i),
                      borderRadius: BorderRadius.circular(16),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(minHeight: 64),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(items[i].$1, size: 28, color: i == index ? c.forest : c.inkSecondary),
                            const SizedBox(height: 4),
                            Text(
                              items[i].$2,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: context.text.labelMedium!.copyWith(
                                fontSize: 15,
                                color: i == index ? c.forest : c.inkSecondary,
                                fontWeight: i == index ? FontWeight.w800 : FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
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
