import 'package:canada_citizenship/main.dart';
import 'package:canada_citizenship/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<AppState> pumpApp(WidgetTester tester, {Locale locale = const Locale('en')}) async {
  tester.view.physicalSize = const Size(1170, 2532);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
  final state = AppState(null)..setLocale(locale);
  await tester.pumpWidget(CitizenshipApp(state: state));
  // The hero leaf drifts forever, so pump frames instead of settling.
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 500));
  return state;
}

void main() {
  testWidgets('journey shows progress and the next chapter', (tester) async {
    await pumpApp(tester);
    expect(find.text('0 of 12 chapters done'), findsOneWidget);
    expect(find.text('Start lesson'), findsOneWidget);
    expect(find.text('Journey'), findsOneWidget);
  });

  testWidgets('French locale translates the UI', (tester) async {
    await pumpApp(tester, locale: const Locale('fr'));
    expect(find.text('0 chapitres sur 12 terminés'), findsOneWidget);
    expect(find.text('Parcours'), findsOneWidget);
  });

  testWidgets('wrong answer shows amber state and reveals the correct one', (tester) async {
    await pumpApp(tester);
    await tester.tap(find.text('Practise'));
    await tester.pump();
    await tester.tap(find.text('How Canadians govern themselves'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('Choose one answer. There’s no timer in chapter quizzes.'), findsOneWidget);
    await tester.tap(find.text('Federal government'));
    await tester.pump();

    expect(find.text('Your answer'), findsOneWidget);
    expect(find.text('Correct'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('Review card'), 200);
    expect(find.text('Not quite, and that’s how you learn it.'), findsOneWidget);
  });

  testWidgets('mock test shows a calm minute timer and flags', (tester) async {
    await pumpApp(tester);
    await tester.tap(find.text('Mock test').last);
    await tester.pump();
    await tester.tap(find.text('Start mock test'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('45 min left'), findsOneWidget);
    expect(find.text('Question 1 of 20'), findsOneWidget);
    final flag = find.text('Flag to review later');
    // Questions are random, so the flag can land at the screen edge; bring it
    // fully into view before tapping.
    await tester.scrollUntilVisible(flag, 200, scrollable: find.byType(Scrollable).last);
    await tester.ensureVisible(flag);
    await tester.pump(const Duration(milliseconds: 300));
    await tester.tap(flag);
    await tester.pump();
    expect(find.text('Review flagged (1)', skipOffstage: false), findsOneWidget);

    // Unmount to cancel the test's periodic timer.
    await tester.pumpWidget(const SizedBox());
  });
}
