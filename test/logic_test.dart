import 'dart:math' as math;

import 'package:canada_citizenship/content/chapters.dart';
import 'package:canada_citizenship/content/models.dart';
import 'package:canada_citizenship/screens/mock_test_screen.dart';
import 'package:canada_citizenship/screens/quiz_screen.dart';
import 'package:canada_citizenship/state/app_state.dart';
import 'package:canada_citizenship/widgets/leaf.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

MockResult mock(int score) => MockResult(score: score, seconds: 600, wrongIds: const []);

void main() {
  group('content', () {
    test('12 chapters with well-formed bilingual questions', () {
      expect(chapters, hasLength(12));
      final ids = <String>{};
      for (final ch in chapters) {
        expect(ch.cards, isNotEmpty);
        expect(ch.questions, hasLength(10), reason: 'chapter ${ch.number}');
        for (final q in ch.questions) {
          expect(ids.add(q.id), isTrue, reason: 'duplicate id ${q.id}');
          expect(q.options, hasLength(4));
          expect(q.correct, inInclusiveRange(0, 3));
          for (final t in [q.prompt, q.explanation, q.subject, ...q.options]) {
            expect(t.en.trim(), isNotEmpty);
            expect(t.fr.trim(), isNotEmpty);
          }
        }
      }
    });
  });

  group('readiness', () {
    test('needs the last three mock tests passed', () {
      expect(isTestReady([]), isFalse);
      expect(isTestReady([mock(17), mock(18)]), isFalse);
      expect(isTestReady([mock(17), mock(18), mock(15)]), isTrue);
      expect(isTestReady([mock(10), mock(17), mock(18), mock(16)]), isTrue);
      expect(isTestReady([mock(17), mock(18), mock(14)]), isFalse);
    });

    test('topic scores aggregate per topic and flag weak ones', () {
      final scores = computeTopicScores({
        'ch1q1': [9, 10], // rights
        'ch11q1': [3, 5], // economy and regions
      });
      final rights = scores.firstWhere((s) => s.topic == Topic.rights);
      final economy = scores.firstWhere((s) => s.topic == Topic.economyRegions);
      final history = scores.firstWhere((s) => s.topic == Topic.history);
      expect(rights.percent, 90);
      expect(rights.needsBrushUp, isFalse);
      expect(economy.percent, 60);
      expect(economy.needsBrushUp, isTrue);
      expect(history.percent, isNull);
    });
  });

  group('progress', () {
    test('chapter is done after its lesson and quiz', () {
      final state = AppState(null);
      final ch = chapters.first;
      expect(state.currentChapter, ch);
      state.setCardIndex(ch, ch.cards.length);
      expect(state.chapterDone(ch), isFalse);
      state.recordQuiz(ch, 3);
      expect(state.chapterDone(ch), isTrue);
      expect(state.chaptersDone, 1);
      expect(state.currentChapter, chapters[1]);
    });

    test('card progress never moves backwards', () {
      final state = AppState(null);
      final ch = chapters.first;
      state.setCardIndex(ch, 2);
      state.setCardIndex(ch, 1);
      expect(state.cardIndex(ch), 2);
    });
  });

  test('mock test draws 20 distinct questions covering every chapter', () {
    final qs = drawMockQuestions(math.Random(1));
    expect(qs, hasLength(MockRules.questions));
    expect(qs.toSet(), hasLength(MockRules.questions));
    expect(qs.map(chapterOf).toSet(), hasLength(chapters.length));
  });

  test('review card points at the matching lesson card', () {
    final ch6 = chapters[5];
    final q = ch6.questions.first; // which level runs education?
    expect(bestCardFor(ch6, q, const Locale('en')), 1);
  });

  test('svg path parser produces the leaf outline', () {
    final p = parseSvgPath('M50 82C56 78 64 79 69 81L66 74H70V60Z');
    final b = p.getBounds();
    expect(b.left, 50);
    expect(b.bottom, 82);
  });
}
