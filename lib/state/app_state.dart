import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../content/chapters.dart';
import '../content/models.dart';

/// Mock test rules, matching the real test.
abstract final class MockRules {
  static const questions = 20;
  static const passMark = 15;
  static const duration = Duration(minutes: 45);
}

/// In-app text sizes offered by the Settings slider.
const textSizes = [17.0, 19.0, 22.0, 25.0];

class MockResult {
  const MockResult({
    required this.score,
    required this.seconds,
    required this.wrongIds,
  });

  final int score;
  final int seconds;
  final List<String> wrongIds;

  bool get passed => score >= MockRules.passMark;

  Map<String, Object> toJson() =>
      {'score': score, 'seconds': seconds, 'wrong': wrongIds};

  factory MockResult.fromJson(Map<String, dynamic> j) => MockResult(
        score: j['score'] as int,
        seconds: j['seconds'] as int,
        wrongIds: (j['wrong'] as List).cast<String>(),
      );
}

enum LeafStage { notStarted, inProgress, chapterDone, testReady }

/// Topic score used on the readiness screen.
class TopicScore {
  const TopicScore(this.topic, this.correct, this.total);

  final Topic topic;
  final int correct;
  final int total;

  /// Answers needed before a topic can be flagged for brushing up.
  static const minAnswersToJudge = 5;

  int? get percent => total == 0 ? null : (correct * 100 / total).round();
  bool get needsBrushUp => total >= minAnswersToJudge && percent! < 80;
}

class AppState extends ChangeNotifier {
  AppState(this._prefs) {
    _load();
  }

  final SharedPreferences? _prefs;

  Locale? _locale;
  int _textSizeIndex = 0;
  bool _highContrast = false;

  /// Next card index per chapter; equals card count when the lesson is done.
  final Map<String, int> _cardProgress = {};

  /// Best quiz score per chapter (presence means the quiz was completed).
  final Map<String, int> _quizBest = {};

  /// Per-question [correct, attempts].
  final Map<String, List<int>> _answerLog = {};
  final List<MockResult> _mockHistory = [];

  Locale? get locale => _locale;
  int get textSizeIndex => _textSizeIndex;
  double get textSize => textSizes[_textSizeIndex];
  bool get highContrast => _highContrast;
  List<MockResult> get mockHistory => List.unmodifiable(_mockHistory);

  // Settings -----------------------------------------------------------------

  void setLocale(Locale locale) {
    _locale = locale;
    _save();
  }

  void setTextSizeIndex(int i) {
    _textSizeIndex = i.clamp(0, textSizes.length - 1);
    _save();
  }

  void setHighContrast(bool v) {
    _highContrast = v;
    _save();
  }

  // Progress -----------------------------------------------------------------

  int cardIndex(Chapter c) => (_cardProgress[c.id] ?? 0).clamp(0, c.cards.length);
  bool lessonDone(Chapter c) => cardIndex(c) >= c.cards.length;
  bool quizDone(Chapter c) => _quizBest.containsKey(c.id);
  int? quizBest(Chapter c) => _quizBest[c.id];
  bool chapterDone(Chapter c) => lessonDone(c) && quizDone(c);
  bool chapterStarted(Chapter c) => cardIndex(c) > 0 || quizDone(c);

  int get chaptersDone => chapters.where(chapterDone).length;

  /// The first chapter that isn't done, or null when all are.
  Chapter? get currentChapter {
    for (final c in chapters) {
      if (!chapterDone(c)) return c;
    }
    return null;
  }

  /// Rough minutes left in a chapter: a minute per card plus the quiz.
  int minutesLeft(Chapter c) {
    final cardsLeft = c.cards.length - cardIndex(c);
    return cardsLeft + (quizDone(c) ? 0 : 2);
  }

  void setCardIndex(Chapter c, int index) {
    final clamped = index.clamp(0, c.cards.length);
    if (clamped <= cardIndex(c)) return;
    _cardProgress[c.id] = clamped;
    _save();
  }

  void recordAnswer(Question q, {required bool correct}) {
    final log = _answerLog.putIfAbsent(q.id, () => [0, 0]);
    if (correct) log[0]++;
    log[1]++;
    _save();
  }

  void recordQuiz(Chapter c, int score) {
    final best = _quizBest[c.id];
    if (best == null || score > best) _quizBest[c.id] = score;
    _save();
  }

  void recordMock(MockResult r) {
    _mockHistory.add(r);
    _save();
  }

  // Readiness ----------------------------------------------------------------

  List<TopicScore> get topicScores => computeTopicScores(_answerLog);

  bool get testReady => isTestReady(_mockHistory);

  LeafStage get overallStage {
    if (testReady) return LeafStage.testReady;
    if (chaptersDone == chapters.length) return LeafStage.chapterDone;
    if (chapters.any(chapterStarted)) return LeafStage.inProgress;
    return LeafStage.notStarted;
  }

  /// 0–1 share of all lesson cards and quizzes completed; drives how far the
  /// hero leaf has filled with red.
  double get overallProgress {
    var done = 0, total = 0;
    for (final c in chapters) {
      done += cardIndex(c) + (quizDone(c) ? 1 : 0);
      total += c.cards.length + 1;
    }
    return total == 0 ? 0 : done / total;
  }

  // Persistence --------------------------------------------------------------

  static const _key = 'app_state_v1';

  void _load() {
    final raw = _prefs?.getString(_key);
    if (raw == null) return;
    try {
      final j = jsonDecode(raw) as Map<String, dynamic>;
      final lang = j['locale'] as String?;
      _locale = lang == null ? null : Locale(lang);
      _textSizeIndex = (j['textSize'] as int? ?? 0).clamp(0, textSizes.length - 1);
      _highContrast = j['highContrast'] as bool? ?? false;
      _cardProgress.addAll((j['cards'] as Map? ?? {}).cast<String, int>());
      _quizBest.addAll((j['quiz'] as Map? ?? {}).cast<String, int>());
      (j['answers'] as Map? ?? {}).forEach((k, v) {
        _answerLog[k as String] = (v as List).cast<int>().toList();
      });
      _mockHistory.addAll((j['mocks'] as List? ?? [])
          .map((m) => MockResult.fromJson(m as Map<String, dynamic>)));
    } on Object {
      // Corrupt or outdated data: start fresh rather than crash.
    }
  }

  void _save() {
    notifyListeners();
    _prefs?.setString(
      _key,
      jsonEncode({
        'locale': _locale?.languageCode,
        'textSize': _textSizeIndex,
        'highContrast': _highContrast,
        'cards': _cardProgress,
        'quiz': _quizBest,
        'answers': _answerLog,
        'mocks': _mockHistory.map((m) => m.toJson()).toList(),
      }),
    );
  }
}

/// Ready when the last three mock tests all reached the pass mark.
bool isTestReady(List<MockResult> history) =>
    history.length >= 3 &&
    history.skip(history.length - 3).every((m) => m.passed);

List<TopicScore> computeTopicScores(Map<String, List<int>> answerLog) {
  final correct = {for (final t in Topic.values) t: 0};
  final total = {for (final t in Topic.values) t: 0};
  answerLog.forEach((id, log) {
    final q = questionsById[id];
    if (q == null) return;
    final topic = chapterOf(q).topic;
    correct[topic] = correct[topic]! + log[0];
    total[topic] = total[topic]! + log[1];
  });
  return [for (final t in Topic.values) TopicScore(t, correct[t]!, total[t]!)];
}

/// Makes [AppState] available to the widget tree.
class AppScope extends InheritedNotifier<AppState> {
  const AppScope({super.key, required AppState state, required super.child})
      : super(notifier: state);

  static AppState of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppScope>()!.notifier!;

  /// Read without subscribing to rebuilds (for callbacks).
  static AppState read(BuildContext context) =>
      context.getInheritedWidgetOfExactType<AppScope>()!.notifier!;
}
