import 'package:flutter/widgets.dart';

import 'gen/app_localizations.dart';

export 'failure_messages.dart';
export 'gen/app_localizations.dart';

extension LocalizationsX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
