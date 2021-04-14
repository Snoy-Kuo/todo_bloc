// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_bloc/blocs/blocs.dart';
import 'package:todo_bloc/models/models.dart';

void main() {
  group('TabBloc', () {
    blocTest<TabBloc, AppTab>(
      'should update the AppTab',
      build: () => TabBloc(),
      act: (bloc) =>
          bloc..add(UpdateTab(AppTab.stats))..add(UpdateTab(AppTab.todos)),
      expect: () => [AppTab.stats, AppTab.todos],
    );
  });
}
