import 'package:flutter/widgets.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';
import 'package:intl/intl.dart';

import '../l10n/gen/app_localizations.dart';

abstract final class Languages {
  static List<Locale> get appLocales => AppLocalizations.supportedLocales;

  static String nativeName(String code) => _capitalized(
    LocaleNamesLocalizationsDelegate.nativeLocaleNames[code] ?? code,
    code,
  );

  static String localizedName(BuildContext context, String code) =>
      _capitalized(
        LocaleNames.of(context)?.nameOf(code) ?? nativeName(code),
        Localizations.localeOf(context).languageCode,
      );

  static String _capitalized(String name, String locale) =>
      toBeginningOfSentenceCase(name, locale);
}
