// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:todo_bloc/blocs/tab/tab.dart';
import 'package:todo_bloc/models/models.dart';

class TabBloc extends Bloc<TabEvent, AppTab> {
  TabBloc({AppTab initialState = AppTab.todos}) : super(initialState);

  @override
  Stream<AppTab> mapEventToState(TabEvent event) async* {
    if (event is UpdateTab) {
      yield event.tab;
    }
  }
}
