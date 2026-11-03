import 'package:flutter/widgets.dart';

/// A piece of bilingual content. All study content ships in English and
/// French at launch.
class T {
  const T(this.en, this.fr);

  final String en;
  final String fr;

  String of(BuildContext context) => resolve(Localizations.localeOf(context));

  String resolve(Locale locale) => locale.languageCode == 'fr' ? fr : en;
}

enum Season { spring, summer, autumn, winter }

/// Groupings used on the readiness screen.
enum Topic { rights, history, government, justiceSymbols, economyRegions }

/// One level in a stacked "tiers" diagram on a lesson card (e.g. the three
/// levels of government).
class Tier {
  const Tier(this.heading, this.subtitle, this.detail);

  final T heading;
  final T subtitle;
  final T detail;
}

class LessonCard {
  const LessonCard({
    required this.title,
    required this.body,
    this.points = const [],
    this.tiers = const [],
  });

  final T title;
  final T body;
  final List<T> points;
  final List<Tier> tiers;
}

class Question {
  const Question({
    required this.id,
    required this.prompt,
    required this.options,
    required this.correct,
    required this.explanation,
    required this.subject,
  });

  final String id;
  final T prompt;
  final List<T> options;

  /// Index into [options].
  final int correct;
  final T explanation;

  /// Short label used in "to review" lists, e.g. "How a candidate wins a riding".
  final T subject;
}

class Chapter {
  const Chapter({
    required this.number,
    required this.title,
    required this.region,
    required this.season,
    required this.topic,
    required this.cards,
    required this.questions,
  });

  final int number;
  final T title;
  final T region;
  final Season season;
  final Topic topic;
  final List<LessonCard> cards;
  final List<Question> questions;

  String get id => 'ch$number';
}
