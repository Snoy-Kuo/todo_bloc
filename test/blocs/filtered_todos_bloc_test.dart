// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_bloc/blocs/blocs.dart';
import 'package:todo_bloc/common/todos_repository_local_storage/todos_repository_local_storage.dart';
import 'package:todo_bloc/models/models.dart';

class MockTodosBloc extends MockBloc<TodosEvent, TodosState>
    implements TodosBloc {}

class MockTodosRepository extends Mock implements LocalStorageRepository {}

void main() {
  setUpAll(() {
    registerFallbackValue<TodosState>(TodosLoading());
    registerFallbackValue<TodosEvent>(LoadTodos());
  });

  group('FilteredTodosBloc', () {
    blocTest<FilteredTodosBloc, FilteredTodosState>(
      'adds TodosUpdated when TodosBloc.state emits TodosLoaded',
      build: () {
        final todosBloc = MockTodosBloc();
        when(() => todosBloc.state).thenReturn(
          TodosLoaded([Todo('Wash Dishes', id: '0')]),
        );
        whenListen(
          todosBloc,
          Stream<TodosState>.fromIterable([
            TodosLoaded([Todo('Wash Dishes', id: '0')]),
          ]),
        );
        return FilteredTodosBloc(todosBloc: todosBloc);
      },
      expect: () => [
        FilteredTodosLoaded(
          [Todo('Wash Dishes', id: '0')],
          VisibilityFilter.all,
        )
      ],
    );

    blocTest<FilteredTodosBloc, FilteredTodosState>(
      'should update the VisibilityFilter when filter is active',
      build: () {
        final todosBloc = MockTodosBloc();
        when(() => todosBloc.state)
            .thenReturn(TodosLoaded([Todo('Wash Dishes', id: '0')]));
        return FilteredTodosBloc(todosBloc: todosBloc);
      },
      act: (FilteredTodosBloc bloc) async =>
          bloc.add(UpdateFilter(VisibilityFilter.active)),
      expect: () => [
        FilteredTodosLoaded(
          [Todo('Wash Dishes', id: '0')],
          VisibilityFilter.all,
        ),
        FilteredTodosLoaded(
          [Todo('Wash Dishes', id: '0')],
          VisibilityFilter.active,
        )
      ],
    );

    blocTest<FilteredTodosBloc, FilteredTodosState>(
      'should update the VisibilityFilter when filter is completed',
      build: () {
        final todosBloc = MockTodosBloc();
        when(() => todosBloc.state)
            .thenReturn(TodosLoaded([Todo('Wash Dishes', id: '0')]));
        return FilteredTodosBloc(todosBloc: todosBloc);
      },
      act: (FilteredTodosBloc bloc) async =>
          bloc.add(UpdateFilter(VisibilityFilter.completed)),
      expect: () => [
        FilteredTodosLoaded(
          [Todo('Wash Dishes', id: '0')],
          VisibilityFilter.all,
        ),
        FilteredTodosLoaded([], VisibilityFilter.completed),
      ],
    );
  });
}
