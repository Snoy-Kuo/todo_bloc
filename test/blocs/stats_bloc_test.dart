// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_bloc/blocs/blocs.dart';
import 'package:todo_bloc/models/models.dart';

class MockTodosBloc extends MockBloc<TodosEvent, TodosState>
    implements TodosBloc {}

void main() {
  setUpAll(() {
    registerFallbackValue<TodosState>(TodosLoading());
    registerFallbackValue<TodosEvent>(LoadTodos());
  });

  group('StatsBloc', () {
    final todo1 = Todo('Hallo');
    final todo2 = Todo('Hallo2', complete: true);
    late TodosBloc todosBloc;
    late StatsBloc statsBloc;

    setUp(() {
      todosBloc = MockTodosBloc();
      when(() => todosBloc.state).thenReturn(TodosLoading());
      statsBloc = StatsBloc(todosBloc: todosBloc);
    });

    test('todosBloc initial state is TodosLoading', () {
      expect(todosBloc.state, TodosLoading());
    });

    test('statsBloc initial state is StatsLoading', () {
      expect(statsBloc.state, StatsLoading());
    });

    blocTest<StatsBloc, StatsState>(
      'should update the stats properly when TodosBloc emits TodosLoaded',
      build: () {
        when(() => todosBloc.state).thenReturn(TodosLoaded());
        return statsBloc;
      },
      act: (bloc) => bloc..add(UpdateStats([])),
      expect: () => [StatsLoaded(0, 0)],
    );

    blocTest<StatsBloc, StatsState>(
      'should update the stats properly when Todos are empty',
      build: () => statsBloc,
      act: (bloc) => bloc.add(UpdateStats([])),
      expect: () => [StatsLoaded(0, 0)],
    );

    blocTest<StatsBloc, StatsState>(
      'should update the stats properly when Todos contains one active todo',
      build: () => statsBloc,
      act: (bloc) => bloc.add(UpdateStats([todo1])),
      expect: () => [StatsLoaded(1, 0)],
    );

    blocTest<StatsBloc, StatsState>(
      'should update the stats properly when Todos contains one active todo and one completed todo',
      build: () => statsBloc,
      act: (bloc) => bloc.add(UpdateStats([todo1, todo2])),
      expect: () => [StatsLoaded(1, 1)],
    );
  });
}
