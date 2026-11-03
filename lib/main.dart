import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'l10n/app_localizations.dart';
import 'monetization/monetization.dart';
import 'screens/shell.dart';
import 'state/app_state.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _registerFontLicenses();
  final prefs = await SharedPreferences.getInstance();
  final monetization = Monetization(prefs);
  runApp(CitizenshipApp(state: AppState(prefs), monetization: monetization));
  // Consent, ads and the store load in the background.
  monetization.init();
}

/// The bundled fonts are SIL OFL 1.1; their licences ship with the app.
void _registerFontLicenses() {
  LicenseRegistry.addLicense(() async* {
    for (final (family, file) in [('Figtree', 'OFL-Figtree.txt'), ('Noto Sans', 'OFL-NotoSans.txt')]) {
      yield LicenseEntryWithLineBreaks([family], await rootBundle.loadString('assets/fonts/$file'));
    }
  });
}

class CitizenshipApp extends StatelessWidget {
  CitizenshipApp({super.key, required this.state, Monetization? monetization})
    : monetization = monetization ?? Monetization.disabled();

  final AppState state;
  final Monetization monetization;

  @override
  Widget build(BuildContext context) {
    return MonetizationScope(
      monetization: monetization,
      child: AppScope(
        state: state,
        child: ListenableBuilder(
          listenable: state,
          builder: (context, _) => MaterialApp(
            onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
            debugShowCheckedModeBanner: false,
            theme: buildTheme(highContrast: state.highContrast),
            locale: state.locale,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            builder: (context, child) {
              // In-app text size multiplies on top of the system text size.
              final mq = MediaQuery.of(context);
              final factor = state.textSize / textSizes.first;
              return MediaQuery(
                data: mq.copyWith(textScaler: TextScaler.linear(mq.textScaler.scale(17) / 17 * factor)),
                child: child!,
              );
            },
            home: const Shell(),
          ),
        ),
      ),
    );
  }
}
