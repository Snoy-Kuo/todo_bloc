// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_bloc/l10n/l10n.dart';

void main() {
  group('FlutterBlocLocalizations', () {
    late AppLocalizations localizations;
    late LocalizationsDelegate<dynamic> delegate;

    setUp(() {
      delegate = l10nDelegate;
    });

    test('App Title is correct', () {
      localizations = l10nTest(locale: Locale('en'));
      expect(localizations.appTitle, 'Todo Bloc');

      localizations = l10nTest(locale: Locale('zh'));
      expect(localizations.appTitle, '待辦事項 Bloc');

      localizations = l10nTest(locale: Locale('fr'));
      expect(localizations.appTitle, 'Todo Bloc');
    });

    test('shouldReload returns false', () {
      expect(delegate.shouldReload(delegate), false);
    });

    test('isSupported returns true for english', () {
      expect(delegate.isSupported(Locale('en', 'US')), true);
    });

    test('isSupported returns true for chinese', () {
      expect(delegate.isSupported(Locale('zh')), true);
    });

    test('isSupported returns false for french', () {
      expect(delegate.isSupported(Locale('fr', 'FR')), false);
    });
  });
}
