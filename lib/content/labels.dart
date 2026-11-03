import 'package:flutter/widgets.dart';

import '../l10n/app_localizations.dart';
import 'models.dart';

String topicName(AppLocalizations l, Topic t) => switch (t) {
      Topic.rights => l.topicRights,
      Topic.history => l.topicHistory,
      Topic.government => l.topicGovernment,
      Topic.justiceSymbols => l.topicJustice,
      Topic.economyRegions => l.topicEconomy,
    };

/// "Prairies in summer" / « Prairies en été ».
String placeOf(BuildContext context, Chapter c) =>
    AppLocalizations.of(context).regionSeason(c.region.of(context), c.season.name);
