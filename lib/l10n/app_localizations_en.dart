// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Canadian Citizenship Test 2026';

  @override
  String get navJourney => 'Journey';

  @override
  String get navPractise => 'Practise';

  @override
  String get navMock => 'Mock test';

  @override
  String get navReadiness => 'Readiness';

  @override
  String get settings => 'Settings';

  @override
  String get back => 'Back';

  @override
  String get close => 'Close';

  @override
  String get yourJourney => 'Your journey';

  @override
  String chaptersDone(int done, int total) {
    return '$done of $total chapters done';
  }

  @override
  String chapterLabel(int number) {
    return 'Chapter $number';
  }

  @override
  String regionSeason(String region, String season) {
    String _temp0 = intl.Intl.selectLogic(season, {
      'spring': 'spring',
      'summer': 'summer',
      'autumn': 'autumn',
      'other': 'winter',
    });
    return '$region in $_temp0';
  }

  @override
  String cardProgress(int current, int total, int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'about $minutes minutes left',
      one: 'about 1 minute left',
    );
    return 'Card $current of $total · $_temp0';
  }

  @override
  String get lessonDoneQuizNext => 'Lesson done · quiz next';

  @override
  String get startLesson => 'Start lesson';

  @override
  String get continueLesson => 'Continue lesson';

  @override
  String get startQuiz => 'Start chapter quiz';

  @override
  String get statusDone => 'done';

  @override
  String get statusInProgress => 'in progress';

  @override
  String get statusNotStarted => 'not started';

  @override
  String get allDoneTitle => 'Every chapter is done';

  @override
  String get allDoneBody =>
      'Mock tests are the best way to check you’re ready.';

  @override
  String get takeMockTest => 'Take a mock test';

  @override
  String lessonHeader(int number, String title) {
    return 'Chapter $number · $title';
  }

  @override
  String get previous => 'Previous';

  @override
  String get nextCard => 'Next card';

  @override
  String get goToQuiz => 'Go to the quiz';

  @override
  String cardOf(int current, int total) {
    return 'Card $current of $total';
  }

  @override
  String quizHeader(int number, int current, int total) {
    return 'Chapter $number quiz · question $current of $total';
  }

  @override
  String get answerCorrect => 'Correct';

  @override
  String get answerYours => 'Your answer';

  @override
  String get answerSelected => 'Selected';

  @override
  String get thatsRight => 'That’s right.';

  @override
  String get notQuite => 'Not quite, and that’s how you learn it.';

  @override
  String get nextQuestion => 'Next question';

  @override
  String get seeResults => 'See results';

  @override
  String get reviewCard => 'Review card';

  @override
  String get quizHint =>
      'Choose one answer. There’s no timer in chapter quizzes.';

  @override
  String quizDoneTitle(int number) {
    return 'Chapter $number quiz done';
  }

  @override
  String quizScore(int score, int total) {
    return '$score of $total correct';
  }

  @override
  String get quizDoneBody =>
      'Every question you miss is one you’ll know next time.';

  @override
  String get backToJourney => 'Back to journey';

  @override
  String get tryAgain => 'Try again';

  @override
  String get practiseTitle => 'Practise';

  @override
  String get practiseSubtitle =>
      'Chapter quizzes have no timer. Retake any chapter as often as you like.';

  @override
  String bestScore(int score, int total) {
    return 'Best: $score of $total';
  }

  @override
  String get notTried => 'Not tried yet';

  @override
  String get mockTitle => 'Mock test';

  @override
  String get mockIntroBody =>
      '20 questions from every chapter, 45 minutes, pass with 15. The same format as the real test.';

  @override
  String get mockIntroCalm =>
      'The timer is there to help you pace yourself. You can flag questions and come back to them before you finish.';

  @override
  String get startMockTest => 'Start mock test';

  @override
  String get pastResults => 'Past results';

  @override
  String pastResultRow(int number) {
    return 'Mock test $number';
  }

  @override
  String scoreOutOf(int score, int total) {
    return '$score of $total';
  }

  @override
  String get passedShort => 'passed';

  @override
  String get notYetShort => 'not yet';

  @override
  String mockQuestionOf(int current, int total) {
    return 'Question $current of $total';
  }

  @override
  String minLeft(int minutes) {
    return '$minutes min left';
  }

  @override
  String get flagToReview => 'Flag to review later';

  @override
  String get flagged => 'Flagged to review';

  @override
  String get mockFooter =>
      'Same format as the real test: 20 questions, pass with 15.';

  @override
  String get finishTest => 'Finish test';

  @override
  String reviewFlagged(int count) {
    return 'Review flagged ($count)';
  }

  @override
  String get flaggedQuestions => 'Flagged questions';

  @override
  String questionNumber(int number) {
    return 'Question $number';
  }

  @override
  String get finishConfirmTitle => 'Finish the test?';

  @override
  String finishConfirmBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count questions have no answer yet.',
      one: '1 question has no answer yet.',
    );
    return '$_temp0';
  }

  @override
  String get keepGoing => 'Keep going';

  @override
  String get leaveTitle => 'Leave the mock test?';

  @override
  String get leaveBody => 'Your answers so far won’t be saved.';

  @override
  String get leave => 'Leave';

  @override
  String get timeUpTitle => 'Time’s up';

  @override
  String get timeUpBody =>
      'Your answers have been saved. Let’s see how you did.';

  @override
  String get seeMyResults => 'See my results';

  @override
  String resultsHeader(int number) {
    return 'Mock test $number · results';
  }

  @override
  String ofTotal(int total) {
    return 'of $total';
  }

  @override
  String get youPassed => 'You passed';

  @override
  String get notYetPassed => 'Not yet, but you’re getting closer';

  @override
  String resultsMeta(int pass, int minutes, int total) {
    return 'Pass mark $pass · finished in $minutes of $total minutes';
  }

  @override
  String toReview(int count) {
    return '$count to review';
  }

  @override
  String reviewAnswers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Review the $count answers',
      one: 'Review the answer',
    );
    return '$_temp0';
  }

  @override
  String get anotherMock => 'Take another mock test';

  @override
  String get nothingToReview => 'Nothing to review. Every answer was right.';

  @override
  String get reviewTitle => 'Answers to review';

  @override
  String get readinessEyebrow => 'Readiness check';

  @override
  String get readyTitle => 'You’re test-ready';

  @override
  String readyBody(int a, int b, int c) {
    return 'Your last 3 mock tests scored $a, $b and $c out of 20. The pass mark is 15.';
  }

  @override
  String get notReadyTitle => 'Getting there';

  @override
  String get notReadyNone =>
      'Take a mock test to see how ready you are. Pass three in a row and you’re test-ready.';

  @override
  String notReadySome(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Pass your next $count mock tests in a row to be test-ready.',
      one: 'Pass your next mock test to be test-ready.',
    );
    return '$_temp0 The pass mark is 15.';
  }

  @override
  String get brushUp => 'brush up';

  @override
  String get noAnswersYet => 'no answers yet';

  @override
  String refresher(String topic) {
    return '10-minute refresher: $topic';
  }

  @override
  String get topicRights => 'Rights and responsibilities';

  @override
  String get topicHistory => 'Canada’s history';

  @override
  String get topicGovernment => 'Government and elections';

  @override
  String get topicJustice => 'Justice and symbols';

  @override
  String get topicEconomy => 'Economy and regions';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get textSize => 'Text size';

  @override
  String textSizeValue(int size) {
    return '$size point text';
  }

  @override
  String get textSizePreview =>
      'Canada has three levels of government: federal, provincial or territorial, and municipal.';

  @override
  String get higherContrast => 'Higher contrast';

  @override
  String get higherContrastSub => 'Darker text and borders';

  @override
  String get calmMotion => 'Calm motion';

  @override
  String get calmMotionSub => 'Follows your device’s reduced-motion setting';

  @override
  String get disclaimer =>
      'This app is independent. It is not affiliated with or endorsed by IRCC or the Government of Canada. Lessons are based on the official guide, Discover Canada.';

  @override
  String get removeAdsTitle => 'Remove ads';

  @override
  String get removeAdsSub =>
      'One payment, no subscription. Ads never appear during lessons or tests.';

  @override
  String removeAdsButton(String price) {
    return 'Remove ads · $price';
  }

  @override
  String get removeAdsUnavailable => 'Store unavailable right now';

  @override
  String get purchasePending => 'Purchase pending…';

  @override
  String get restorePurchase => 'Restore purchase';

  @override
  String get adsRemoved => 'Ads removed. Thank you for supporting the app.';

  @override
  String get privacyChoices => 'Privacy choices';

  @override
  String get privacyChoicesSub => 'Change how ads use your data';

  @override
  String get privacyPolicy => 'Privacy policy';

  @override
  String get privacyPolicySub => 'Opens in your browser';
}
