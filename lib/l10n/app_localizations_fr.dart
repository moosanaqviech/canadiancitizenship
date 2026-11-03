// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Examen de citoyenneté 2026';

  @override
  String get navJourney => 'Parcours';

  @override
  String get navPractise => 'Pratique';

  @override
  String get navMock => 'Examen simulé';

  @override
  String get navReadiness => 'Préparation';

  @override
  String get settings => 'Paramètres';

  @override
  String get back => 'Retour';

  @override
  String get close => 'Fermer';

  @override
  String get yourJourney => 'Votre parcours';

  @override
  String chaptersDone(int done, int total) {
    return '$done chapitres sur $total terminés';
  }

  @override
  String chapterLabel(int number) {
    return 'Chapitre $number';
  }

  @override
  String regionSeason(String region, String season) {
    String _temp0 = intl.Intl.selectLogic(season, {
      'spring': 'au printemps',
      'summer': 'en été',
      'autumn': 'en automne',
      'other': 'en hiver',
    });
    return '$region $_temp0';
  }

  @override
  String cardProgress(int current, int total, int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'environ $minutes minutes restantes',
      one: 'environ 1 minute restante',
    );
    return 'Carte $current sur $total · $_temp0';
  }

  @override
  String get lessonDoneQuizNext => 'Leçon terminée · quiz à faire';

  @override
  String get startLesson => 'Commencer la leçon';

  @override
  String get continueLesson => 'Continuer la leçon';

  @override
  String get startQuiz => 'Commencer le quiz du chapitre';

  @override
  String get statusDone => 'terminé';

  @override
  String get statusInProgress => 'en cours';

  @override
  String get statusNotStarted => 'pas commencé';

  @override
  String get allDoneTitle => 'Tous les chapitres sont terminés';

  @override
  String get allDoneBody =>
      'Les examens simulés sont le meilleur moyen de vérifier si vous êtes prêt.';

  @override
  String get takeMockTest => 'Faire un examen simulé';

  @override
  String lessonHeader(int number, String title) {
    return 'Chapitre $number · $title';
  }

  @override
  String get previous => 'Précédent';

  @override
  String get nextCard => 'Carte suivante';

  @override
  String get goToQuiz => 'Passer au quiz';

  @override
  String cardOf(int current, int total) {
    return 'Carte $current sur $total';
  }

  @override
  String quizHeader(int number, int current, int total) {
    return 'Quiz du chapitre $number · question $current sur $total';
  }

  @override
  String get answerCorrect => 'Bonne réponse';

  @override
  String get answerYours => 'Votre réponse';

  @override
  String get answerSelected => 'Sélectionnée';

  @override
  String get thatsRight => 'C’est exact.';

  @override
  String get notQuite => 'Pas tout à fait, et c’est comme ça qu’on apprend.';

  @override
  String get nextQuestion => 'Question suivante';

  @override
  String get seeResults => 'Voir les résultats';

  @override
  String get reviewCard => 'Revoir la carte';

  @override
  String get quizHint =>
      'Choisissez une réponse. Les quiz de chapitre n’ont pas de minuterie.';

  @override
  String quizDoneTitle(int number) {
    return 'Quiz du chapitre $number terminé';
  }

  @override
  String quizScore(int score, int total) {
    return '$score bonnes réponses sur $total';
  }

  @override
  String get quizDoneBody =>
      'Chaque erreur est une réponse que vous connaîtrez la prochaine fois.';

  @override
  String get backToJourney => 'Retour au parcours';

  @override
  String get tryAgain => 'Réessayer';

  @override
  String get practiseTitle => 'Pratique';

  @override
  String get practiseSubtitle =>
      'Les quiz de chapitre n’ont pas de minuterie. Refaites-les aussi souvent que vous le voulez.';

  @override
  String bestScore(int score, int total) {
    return 'Meilleur : $score sur $total';
  }

  @override
  String get notTried => 'Pas encore essayé';

  @override
  String get mockTitle => 'Examen simulé';

  @override
  String get mockIntroBody =>
      '20 questions de tous les chapitres, 45 minutes, réussite à 15. Le même format que le vrai examen.';

  @override
  String get mockIntroCalm =>
      'La minuterie vous aide à gérer votre temps. Vous pouvez marquer des questions et y revenir avant de terminer.';

  @override
  String get startMockTest => 'Commencer l’examen simulé';

  @override
  String get pastResults => 'Résultats précédents';

  @override
  String pastResultRow(int number) {
    return 'Examen simulé $number';
  }

  @override
  String scoreOutOf(int score, int total) {
    return '$score sur $total';
  }

  @override
  String get passedShort => 'réussi';

  @override
  String get notYetShort => 'pas encore';

  @override
  String mockQuestionOf(int current, int total) {
    return 'Question $current sur $total';
  }

  @override
  String minLeft(int minutes) {
    return '$minutes min restantes';
  }

  @override
  String get flagToReview => 'Marquer pour revoir';

  @override
  String get flagged => 'Marquée pour revoir';

  @override
  String get mockFooter =>
      'Même format que le vrai examen : 20 questions, réussite à 15.';

  @override
  String get finishTest => 'Terminer l’examen';

  @override
  String reviewFlagged(int count) {
    return 'Revoir les questions marquées ($count)';
  }

  @override
  String get flaggedQuestions => 'Questions marquées';

  @override
  String questionNumber(int number) {
    return 'Question $number';
  }

  @override
  String get finishConfirmTitle => 'Terminer l’examen?';

  @override
  String finishConfirmBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count questions n’ont pas encore de réponse.',
      one: '1 question n’a pas encore de réponse.',
    );
    return '$_temp0';
  }

  @override
  String get keepGoing => 'Continuer';

  @override
  String get leaveTitle => 'Quitter l’examen simulé?';

  @override
  String get leaveBody => 'Vos réponses ne seront pas enregistrées.';

  @override
  String get leave => 'Quitter';

  @override
  String get timeUpTitle => 'Le temps est écoulé';

  @override
  String get timeUpBody =>
      'Vos réponses sont enregistrées. Voyons vos résultats.';

  @override
  String get seeMyResults => 'Voir mes résultats';

  @override
  String resultsHeader(int number) {
    return 'Examen simulé $number · résultats';
  }

  @override
  String ofTotal(int total) {
    return 'sur $total';
  }

  @override
  String get youPassed => 'Réussi';

  @override
  String get notYetPassed => 'Pas encore, mais vous approchez';

  @override
  String resultsMeta(int pass, int minutes, int total) {
    return 'Note de passage $pass · terminé en $minutes minutes sur $total';
  }

  @override
  String toReview(int count) {
    return '$count à revoir';
  }

  @override
  String reviewAnswers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Revoir les $count réponses',
      one: 'Revoir la réponse',
    );
    return '$_temp0';
  }

  @override
  String get anotherMock => 'Faire un autre examen simulé';

  @override
  String get nothingToReview =>
      'Rien à revoir. Toutes vos réponses étaient bonnes.';

  @override
  String get reviewTitle => 'Réponses à revoir';

  @override
  String get readinessEyebrow => 'Bilan de préparation';

  @override
  String get readyTitle => 'Vous êtes prêt pour l’examen';

  @override
  String readyBody(int a, int b, int c) {
    return 'Vos 3 derniers examens simulés : $a, $b et $c sur 20. La note de passage est 15.';
  }

  @override
  String get notReadyTitle => 'Vous y arrivez';

  @override
  String get notReadyNone =>
      'Faites un examen simulé pour voir où vous en êtes. Trois réussites de suite et vous êtes prêt.';

  @override
  String notReadySome(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Réussissez vos $count prochains examens simulés de suite pour être prêt.',
      one: 'Réussissez votre prochain examen simulé pour être prêt.',
    );
    return '$_temp0 La note de passage est 15.';
  }

  @override
  String get brushUp => 'à revoir';

  @override
  String get noAnswersYet => 'pas encore de réponses';

  @override
  String refresher(String topic) {
    return 'Révision de 10 minutes : $topic';
  }

  @override
  String get topicRights => 'Droits et responsabilités';

  @override
  String get topicHistory => 'Histoire du Canada';

  @override
  String get topicGovernment => 'Gouvernement et élections';

  @override
  String get topicJustice => 'Justice et symboles';

  @override
  String get topicEconomy => 'Économie et régions';

  @override
  String get settingsTitle => 'Paramètres';

  @override
  String get language => 'Langue';

  @override
  String get textSize => 'Taille du texte';

  @override
  String textSizeValue(int size) {
    return 'Texte de $size points';
  }

  @override
  String get textSizePreview =>
      'Le Canada compte trois ordres de gouvernement : fédéral, provincial ou territorial, et municipal.';

  @override
  String get higherContrast => 'Contraste élevé';

  @override
  String get higherContrastSub => 'Texte et bordures plus foncés';

  @override
  String get calmMotion => 'Mouvement calme';

  @override
  String get calmMotionSub =>
      'Suit le réglage de réduction des animations de votre appareil';

  @override
  String get disclaimer =>
      'Cette application est indépendante. Elle n’est ni affiliée à IRCC ou au gouvernement du Canada, ni approuvée par eux. Les leçons s’appuient sur le guide officiel Découvrir le Canada.';

  @override
  String get removeAdsTitle => 'Retirer les publicités';

  @override
  String get removeAdsSub =>
      'Un seul paiement, sans abonnement. Aucune publicité pendant les leçons ou les tests.';

  @override
  String removeAdsButton(String price) {
    return 'Retirer les publicités · $price';
  }

  @override
  String get removeAdsUnavailable => 'Boutique indisponible pour le moment';

  @override
  String get purchasePending => 'Achat en attente…';

  @override
  String get restorePurchase => 'Restaurer l’achat';

  @override
  String get adsRemoved =>
      'Publicités retirées. Merci de soutenir l’application.';

  @override
  String get privacyChoices => 'Choix de confidentialité';

  @override
  String get privacyChoicesSub =>
      'Modifier l’utilisation de vos données par les publicités';

  @override
  String get privacyPolicy => 'Politique de confidentialité';

  @override
  String get privacyPolicySub => 'S’ouvre dans votre navigateur';
}
