import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Canadian Citizenship Test 2026'**
  String get appTitle;

  /// No description provided for @navJourney.
  ///
  /// In en, this message translates to:
  /// **'Journey'**
  String get navJourney;

  /// No description provided for @navPractise.
  ///
  /// In en, this message translates to:
  /// **'Practise'**
  String get navPractise;

  /// No description provided for @navMock.
  ///
  /// In en, this message translates to:
  /// **'Mock test'**
  String get navMock;

  /// No description provided for @navReadiness.
  ///
  /// In en, this message translates to:
  /// **'Readiness'**
  String get navReadiness;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @yourJourney.
  ///
  /// In en, this message translates to:
  /// **'Your journey'**
  String get yourJourney;

  /// No description provided for @chaptersDone.
  ///
  /// In en, this message translates to:
  /// **'{done} of {total} chapters done'**
  String chaptersDone(int done, int total);

  /// No description provided for @chapterLabel.
  ///
  /// In en, this message translates to:
  /// **'Chapter {number}'**
  String chapterLabel(int number);

  /// No description provided for @regionSeason.
  ///
  /// In en, this message translates to:
  /// **'{region} in {season, select, spring{spring} summer{summer} autumn{autumn} other{winter}}'**
  String regionSeason(String region, String season);

  /// No description provided for @cardProgress.
  ///
  /// In en, this message translates to:
  /// **'Card {current} of {total} · {minutes, plural, =1{about 1 minute left} other{about {minutes} minutes left}}'**
  String cardProgress(int current, int total, int minutes);

  /// No description provided for @lessonDoneQuizNext.
  ///
  /// In en, this message translates to:
  /// **'Lesson done · quiz next'**
  String get lessonDoneQuizNext;

  /// No description provided for @startLesson.
  ///
  /// In en, this message translates to:
  /// **'Start lesson'**
  String get startLesson;

  /// No description provided for @continueLesson.
  ///
  /// In en, this message translates to:
  /// **'Continue lesson'**
  String get continueLesson;

  /// No description provided for @startQuiz.
  ///
  /// In en, this message translates to:
  /// **'Start chapter quiz'**
  String get startQuiz;

  /// No description provided for @statusDone.
  ///
  /// In en, this message translates to:
  /// **'done'**
  String get statusDone;

  /// No description provided for @statusInProgress.
  ///
  /// In en, this message translates to:
  /// **'in progress'**
  String get statusInProgress;

  /// No description provided for @statusNotStarted.
  ///
  /// In en, this message translates to:
  /// **'not started'**
  String get statusNotStarted;

  /// No description provided for @allDoneTitle.
  ///
  /// In en, this message translates to:
  /// **'Every chapter is done'**
  String get allDoneTitle;

  /// No description provided for @allDoneBody.
  ///
  /// In en, this message translates to:
  /// **'Mock tests are the best way to check you’re ready.'**
  String get allDoneBody;

  /// No description provided for @takeMockTest.
  ///
  /// In en, this message translates to:
  /// **'Take a mock test'**
  String get takeMockTest;

  /// No description provided for @lessonHeader.
  ///
  /// In en, this message translates to:
  /// **'Chapter {number} · {title}'**
  String lessonHeader(int number, String title);

  /// No description provided for @previous.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previous;

  /// No description provided for @nextCard.
  ///
  /// In en, this message translates to:
  /// **'Next card'**
  String get nextCard;

  /// No description provided for @goToQuiz.
  ///
  /// In en, this message translates to:
  /// **'Go to the quiz'**
  String get goToQuiz;

  /// No description provided for @cardOf.
  ///
  /// In en, this message translates to:
  /// **'Card {current} of {total}'**
  String cardOf(int current, int total);

  /// No description provided for @quizHeader.
  ///
  /// In en, this message translates to:
  /// **'Chapter {number} quiz · question {current} of {total}'**
  String quizHeader(int number, int current, int total);

  /// No description provided for @answerCorrect.
  ///
  /// In en, this message translates to:
  /// **'Correct'**
  String get answerCorrect;

  /// No description provided for @answerYours.
  ///
  /// In en, this message translates to:
  /// **'Your answer'**
  String get answerYours;

  /// No description provided for @answerSelected.
  ///
  /// In en, this message translates to:
  /// **'Selected'**
  String get answerSelected;

  /// No description provided for @thatsRight.
  ///
  /// In en, this message translates to:
  /// **'That’s right.'**
  String get thatsRight;

  /// No description provided for @notQuite.
  ///
  /// In en, this message translates to:
  /// **'Not quite, and that’s how you learn it.'**
  String get notQuite;

  /// No description provided for @nextQuestion.
  ///
  /// In en, this message translates to:
  /// **'Next question'**
  String get nextQuestion;

  /// No description provided for @seeResults.
  ///
  /// In en, this message translates to:
  /// **'See results'**
  String get seeResults;

  /// No description provided for @reviewCard.
  ///
  /// In en, this message translates to:
  /// **'Review card'**
  String get reviewCard;

  /// No description provided for @quizHint.
  ///
  /// In en, this message translates to:
  /// **'Choose one answer. There’s no timer in chapter quizzes.'**
  String get quizHint;

  /// No description provided for @quizDoneTitle.
  ///
  /// In en, this message translates to:
  /// **'Chapter {number} quiz done'**
  String quizDoneTitle(int number);

  /// No description provided for @quizScore.
  ///
  /// In en, this message translates to:
  /// **'{score} of {total} correct'**
  String quizScore(int score, int total);

  /// No description provided for @quizDoneBody.
  ///
  /// In en, this message translates to:
  /// **'Every question you miss is one you’ll know next time.'**
  String get quizDoneBody;

  /// No description provided for @backToJourney.
  ///
  /// In en, this message translates to:
  /// **'Back to journey'**
  String get backToJourney;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get tryAgain;

  /// No description provided for @practiseTitle.
  ///
  /// In en, this message translates to:
  /// **'Practise'**
  String get practiseTitle;

  /// No description provided for @practiseSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Chapter quizzes have no timer. Retake any chapter as often as you like.'**
  String get practiseSubtitle;

  /// No description provided for @bestScore.
  ///
  /// In en, this message translates to:
  /// **'Best: {score} of {total}'**
  String bestScore(int score, int total);

  /// No description provided for @notTried.
  ///
  /// In en, this message translates to:
  /// **'Not tried yet'**
  String get notTried;

  /// No description provided for @mockTitle.
  ///
  /// In en, this message translates to:
  /// **'Mock test'**
  String get mockTitle;

  /// No description provided for @mockIntroBody.
  ///
  /// In en, this message translates to:
  /// **'20 questions from every chapter, 45 minutes, pass with 15. The same format as the real test.'**
  String get mockIntroBody;

  /// No description provided for @mockIntroCalm.
  ///
  /// In en, this message translates to:
  /// **'The timer is there to help you pace yourself. You can flag questions and come back to them before you finish.'**
  String get mockIntroCalm;

  /// No description provided for @startMockTest.
  ///
  /// In en, this message translates to:
  /// **'Start mock test'**
  String get startMockTest;

  /// No description provided for @pastResults.
  ///
  /// In en, this message translates to:
  /// **'Past results'**
  String get pastResults;

  /// No description provided for @pastResultRow.
  ///
  /// In en, this message translates to:
  /// **'Mock test {number}'**
  String pastResultRow(int number);

  /// No description provided for @scoreOutOf.
  ///
  /// In en, this message translates to:
  /// **'{score} of {total}'**
  String scoreOutOf(int score, int total);

  /// No description provided for @passedShort.
  ///
  /// In en, this message translates to:
  /// **'passed'**
  String get passedShort;

  /// No description provided for @notYetShort.
  ///
  /// In en, this message translates to:
  /// **'not yet'**
  String get notYetShort;

  /// No description provided for @mockQuestionOf.
  ///
  /// In en, this message translates to:
  /// **'Question {current} of {total}'**
  String mockQuestionOf(int current, int total);

  /// No description provided for @minLeft.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min left'**
  String minLeft(int minutes);

  /// No description provided for @flagToReview.
  ///
  /// In en, this message translates to:
  /// **'Flag to review later'**
  String get flagToReview;

  /// No description provided for @flagged.
  ///
  /// In en, this message translates to:
  /// **'Flagged to review'**
  String get flagged;

  /// No description provided for @mockFooter.
  ///
  /// In en, this message translates to:
  /// **'Same format as the real test: 20 questions, pass with 15.'**
  String get mockFooter;

  /// No description provided for @finishTest.
  ///
  /// In en, this message translates to:
  /// **'Finish test'**
  String get finishTest;

  /// No description provided for @reviewFlagged.
  ///
  /// In en, this message translates to:
  /// **'Review flagged ({count})'**
  String reviewFlagged(int count);

  /// No description provided for @flaggedQuestions.
  ///
  /// In en, this message translates to:
  /// **'Flagged questions'**
  String get flaggedQuestions;

  /// No description provided for @questionNumber.
  ///
  /// In en, this message translates to:
  /// **'Question {number}'**
  String questionNumber(int number);

  /// No description provided for @finishConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Finish the test?'**
  String get finishConfirmTitle;

  /// No description provided for @finishConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 question has no answer yet.} other{{count} questions have no answer yet.}}'**
  String finishConfirmBody(int count);

  /// No description provided for @keepGoing.
  ///
  /// In en, this message translates to:
  /// **'Keep going'**
  String get keepGoing;

  /// No description provided for @leaveTitle.
  ///
  /// In en, this message translates to:
  /// **'Leave the mock test?'**
  String get leaveTitle;

  /// No description provided for @leaveBody.
  ///
  /// In en, this message translates to:
  /// **'Your answers so far won’t be saved.'**
  String get leaveBody;

  /// No description provided for @leave.
  ///
  /// In en, this message translates to:
  /// **'Leave'**
  String get leave;

  /// No description provided for @timeUpTitle.
  ///
  /// In en, this message translates to:
  /// **'Time’s up'**
  String get timeUpTitle;

  /// No description provided for @timeUpBody.
  ///
  /// In en, this message translates to:
  /// **'Your answers have been saved. Let’s see how you did.'**
  String get timeUpBody;

  /// No description provided for @seeMyResults.
  ///
  /// In en, this message translates to:
  /// **'See my results'**
  String get seeMyResults;

  /// No description provided for @resultsHeader.
  ///
  /// In en, this message translates to:
  /// **'Mock test {number} · results'**
  String resultsHeader(int number);

  /// No description provided for @ofTotal.
  ///
  /// In en, this message translates to:
  /// **'of {total}'**
  String ofTotal(int total);

  /// No description provided for @youPassed.
  ///
  /// In en, this message translates to:
  /// **'You passed'**
  String get youPassed;

  /// No description provided for @notYetPassed.
  ///
  /// In en, this message translates to:
  /// **'Not yet, but you’re getting closer'**
  String get notYetPassed;

  /// No description provided for @resultsMeta.
  ///
  /// In en, this message translates to:
  /// **'Pass mark {pass} · finished in {minutes} of {total} minutes'**
  String resultsMeta(int pass, int minutes, int total);

  /// No description provided for @toReview.
  ///
  /// In en, this message translates to:
  /// **'{count} to review'**
  String toReview(int count);

  /// No description provided for @reviewAnswers.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Review the answer} other{Review the {count} answers}}'**
  String reviewAnswers(int count);

  /// No description provided for @anotherMock.
  ///
  /// In en, this message translates to:
  /// **'Take another mock test'**
  String get anotherMock;

  /// No description provided for @nothingToReview.
  ///
  /// In en, this message translates to:
  /// **'Nothing to review. Every answer was right.'**
  String get nothingToReview;

  /// No description provided for @reviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Answers to review'**
  String get reviewTitle;

  /// No description provided for @readinessEyebrow.
  ///
  /// In en, this message translates to:
  /// **'Readiness check'**
  String get readinessEyebrow;

  /// No description provided for @readyTitle.
  ///
  /// In en, this message translates to:
  /// **'You’re test-ready'**
  String get readyTitle;

  /// No description provided for @readyBody.
  ///
  /// In en, this message translates to:
  /// **'Your last 3 mock tests scored {a}, {b} and {c} out of 20. The pass mark is 15.'**
  String readyBody(int a, int b, int c);

  /// No description provided for @notReadyTitle.
  ///
  /// In en, this message translates to:
  /// **'Getting there'**
  String get notReadyTitle;

  /// No description provided for @notReadyNone.
  ///
  /// In en, this message translates to:
  /// **'Take a mock test to see how ready you are. Pass three in a row and you’re test-ready.'**
  String get notReadyNone;

  /// No description provided for @notReadySome.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Pass your next mock test to be test-ready.} other{Pass your next {count} mock tests in a row to be test-ready.}} The pass mark is 15.'**
  String notReadySome(int count);

  /// No description provided for @brushUp.
  ///
  /// In en, this message translates to:
  /// **'brush up'**
  String get brushUp;

  /// No description provided for @noAnswersYet.
  ///
  /// In en, this message translates to:
  /// **'no answers yet'**
  String get noAnswersYet;

  /// No description provided for @refresher.
  ///
  /// In en, this message translates to:
  /// **'10-minute refresher: {topic}'**
  String refresher(String topic);

  /// No description provided for @topicRights.
  ///
  /// In en, this message translates to:
  /// **'Rights and responsibilities'**
  String get topicRights;

  /// No description provided for @topicHistory.
  ///
  /// In en, this message translates to:
  /// **'Canada’s history'**
  String get topicHistory;

  /// No description provided for @topicGovernment.
  ///
  /// In en, this message translates to:
  /// **'Government and elections'**
  String get topicGovernment;

  /// No description provided for @topicJustice.
  ///
  /// In en, this message translates to:
  /// **'Justice and symbols'**
  String get topicJustice;

  /// No description provided for @topicEconomy.
  ///
  /// In en, this message translates to:
  /// **'Economy and regions'**
  String get topicEconomy;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @textSize.
  ///
  /// In en, this message translates to:
  /// **'Text size'**
  String get textSize;

  /// No description provided for @textSizeValue.
  ///
  /// In en, this message translates to:
  /// **'{size} point text'**
  String textSizeValue(int size);

  /// No description provided for @textSizePreview.
  ///
  /// In en, this message translates to:
  /// **'Canada has three levels of government: federal, provincial or territorial, and municipal.'**
  String get textSizePreview;

  /// No description provided for @higherContrast.
  ///
  /// In en, this message translates to:
  /// **'Higher contrast'**
  String get higherContrast;

  /// No description provided for @higherContrastSub.
  ///
  /// In en, this message translates to:
  /// **'Darker text and borders'**
  String get higherContrastSub;

  /// No description provided for @calmMotion.
  ///
  /// In en, this message translates to:
  /// **'Calm motion'**
  String get calmMotion;

  /// No description provided for @calmMotionSub.
  ///
  /// In en, this message translates to:
  /// **'Follows your device’s reduced-motion setting'**
  String get calmMotionSub;

  /// No description provided for @disclaimer.
  ///
  /// In en, this message translates to:
  /// **'This app is independent. It is not affiliated with or endorsed by IRCC or the Government of Canada. Lessons are based on the official guide, Discover Canada.'**
  String get disclaimer;

  /// No description provided for @removeAdsTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove ads'**
  String get removeAdsTitle;

  /// No description provided for @removeAdsSub.
  ///
  /// In en, this message translates to:
  /// **'One payment, no subscription. Ads never appear during lessons or tests.'**
  String get removeAdsSub;

  /// No description provided for @removeAdsButton.
  ///
  /// In en, this message translates to:
  /// **'Remove ads · {price}'**
  String removeAdsButton(String price);

  /// No description provided for @removeAdsUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Store unavailable right now'**
  String get removeAdsUnavailable;

  /// No description provided for @purchasePending.
  ///
  /// In en, this message translates to:
  /// **'Purchase pending…'**
  String get purchasePending;

  /// No description provided for @restorePurchase.
  ///
  /// In en, this message translates to:
  /// **'Restore purchase'**
  String get restorePurchase;

  /// No description provided for @adsRemoved.
  ///
  /// In en, this message translates to:
  /// **'Ads removed. Thank you for supporting the app.'**
  String get adsRemoved;

  /// No description provided for @privacyChoices.
  ///
  /// In en, this message translates to:
  /// **'Privacy choices'**
  String get privacyChoices;

  /// No description provided for @privacyChoicesSub.
  ///
  /// In en, this message translates to:
  /// **'Change how ads use your data'**
  String get privacyChoicesSub;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get privacyPolicy;

  /// No description provided for @privacyPolicySub.
  ///
  /// In en, this message translates to:
  /// **'Opens in your browser'**
  String get privacyPolicySub;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
