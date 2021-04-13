import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

export 'package:flutter_gen/gen_l10n/app_localizations.dart';

AppLocalizations l10n(BuildContext context) {
  return AppLocalizations.of(context)!;
}

//TODO: wait for Dart 2.13
// https://medium.com/dartlang/announcing-dart-2-12-499a6e689c87
// typedef L10N = AppLocalizations;
