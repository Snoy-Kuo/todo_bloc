import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_en.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_zh.dart';

export 'package:flutter_gen/gen_l10n/app_localizations.dart';

AppLocalizations l10n(BuildContext context) {
  return AppLocalizations.of(context)!;
}

Iterable<LocalizationsDelegate<dynamic>> get l10nDelegates =>
    AppLocalizations.localizationsDelegates;

@visibleForTesting
LocalizationsDelegate<AppLocalizations> get l10nDelegate =>
    AppLocalizations.delegate;

@visibleForTesting
AppLocalizations l10nTest({Locale locale = const Locale('en', '')}) {
  switch (locale.languageCode) {
    case 'zh':
      return AppLocalizationsZh();
    default:
      return AppLocalizationsEn();
  }
}

//TODO: wait for Dart 2.13
// https://medium.com/dartlang/announcing-dart-2-12-499a6e689c87
// typedef L10N = AppLocalizations;
