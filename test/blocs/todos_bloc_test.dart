// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_bloc/blocs/blocs.dart';
import 'package:todo_bloc/common/todos_repository_core/todos_repository_core.dart';
import 'package:todo_bloc/common/todos_repository_local_storage/todos_repository_local_storage.dart';
import 'package:todo_bloc/models/models.dart';

class MockTodosRepository extends Mock implements LocalStorageRepository {}

void main() {
  setUpAll(() {
    registerFallbackValue<TodosState>(TodosLoading());
    registerFallbackValue<TodosEvent>(LoadTodos());
    registerFallbackValue<List<TodoEntity>>([]);
  });

  group('TodosBloc', () {
    late LocalStorageRepository todosRepository;
    late TodosBloc todosBloc;

    setUp(() {
      todosRepository = MockTodosRepository();
      when(() => todosRepository.loadTodos())
          .thenAnswer((_) => Future.value([]));
      when(() => todosRepository.saveTodos(any()))
          .thenAnswer((_) => Future.value([]));
      todosBloc = TodosBloc(todosRepository: todosRepository);
    });

    test('todosBloc initial state is TodosLoading', () {
      expect(todosBloc.state, TodosLoading());
    });

    blocTest<TodosBloc, TodosState>(
      'should emit TodosNotLoaded if repository throws',
      build: () {
        when(() => todosRepository.loadTodos()).thenThrow(Exception('oops'));
        return todosBloc;
      },
      act: (bloc) => bloc..add(LoadTodos()),
      expect: () => [
        TodosNotLoaded(),
      ],
    );

    blocTest<TodosBloc, TodosState>(
      'should add a todo to the list in response to an AddTodo Event',
      build: () => todosBloc,
      act: (bloc) =>
          bloc..add(LoadTodos())..add(AddTodo(Todo('Hallo', id: '0'))),
      expect: () => [
        TodosLoaded([]),
        TodosLoaded([Todo('Hallo', id: '0')]),
      ],
    );

    blocTest<TodosBloc, TodosState>(
      'should remove from the list in response to a DeleteTodo Event',
      build: () => todosBloc,
      act: (bloc) {
        final todo = Todo('Hallo', id: '0');
        bloc..add(LoadTodos())..add(AddTodo(todo))..add(DeleteTodo(todo));
      },
      expect: () => [
        TodosLoaded([]),
        TodosLoaded([Todo('Hallo', id: '0')]),
        TodosLoaded([]),
      ],
    );

    blocTest<TodosBloc, TodosState>(
      'should update a todo in response to an UpdateTodoAction',
      build: () => todosBloc,
      act: (bloc) {
        final todo = Todo('Hallo', id: '0');
        bloc
          ..add(LoadTodos())
          ..add(AddTodo(todo))
          ..add(UpdateTodo(todo.copyWith(task: 'Tschüss')));
      },
      expect: () => [
        TodosLoaded([]),
        TodosLoaded([Todo('Hallo', id: '0')]),
        TodosLoaded([Todo('Tschüss', id: '0')]),
      ],
    );

    blocTest<TodosBloc, TodosState>(
      'should clear completed todos',
      build: () => todosBloc,
      act: (bloc) {
        final todo1 = Todo('Hallo', id: '0');
        final todo2 = Todo('Tschüss', complete: true, id: '1');
        bloc
          ..add(LoadTodos())
          ..add(AddTodo(todo1))
          ..add(AddTodo(todo2))
          ..add(ClearCompleted());
      },
      expect: () => [
        TodosLoaded([]),
        TodosLoaded([Todo('Hallo', id: '0')]),
        TodosLoaded([
          Todo('Hallo', id: '0'),
          Todo('Tschüss', id: '1', complete: true),
        ]),
        TodosLoaded([Todo('Hallo', id: '0')]),
      ],
    );

    blocTest<TodosBloc, TodosState>(
      'should mark all as completed if some todos are incomplete',
      build: () => todosBloc,
      act: (bloc) {
        final todo1 = Todo('Hallo', id: '0');
        final todo2 = Todo('Tschüss', complete: true, id: '1');
        bloc
          ..add(LoadTodos())
          ..add(AddTodo(todo1))
          ..add(AddTodo(todo2))
          ..add(ToggleAll());
      },
      expect: () => [
        TodosLoaded([]),
        TodosLoaded([Todo('Hallo', id: '0')]),
        TodosLoaded([
          Todo('Hallo', id: '0'),
          Todo('Tschüss', id: '1', complete: true),
        ]),
        TodosLoaded([
          Todo('Hallo', id: '0', complete: true),
          Todo('Tschüss', id: '1', complete: true),
        ]),
      ],
    );

    blocTest<TodosBloc, TodosState>(
      'should mark all as incomplete if all todos are complete',
      build: () => todosBloc,
      act: (bloc) {
        final todo1 = Todo('Hallo', complete: true, id: '0');
        final todo2 = Todo('Tschüss', complete: true, id: '1');
        bloc
          ..add(LoadTodos())
          ..add(AddTodo(todo1))
          ..add(AddTodo(todo2))
          ..add(ToggleAll());
      },
      expect: () => [
        TodosLoaded([]),
        TodosLoaded([Todo('Hallo', id: '0', complete: true)]),
        TodosLoaded([
          Todo('Hallo', id: '0', complete: true),
          Todo('Tschüss', id: '1', complete: true),
        ]),
        TodosLoaded([
          Todo('Hallo', id: '0'),
          Todo('Tschüss', id: '1'),
        ]),
      ],
    );
  });
}
