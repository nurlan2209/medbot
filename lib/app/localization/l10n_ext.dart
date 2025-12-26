import 'package:flutter/widgets.dart';
import 'package:med_bot/l10n/app_localizations.dart';

extension L10nExt on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}
