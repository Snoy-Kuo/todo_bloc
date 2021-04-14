// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_bloc/blocs/blocs.dart';
import 'package:todo_bloc/common/todos_app_core/todos_app_core.dart';
import 'package:todo_bloc/l10n/l10n.dart';
import 'package:todo_bloc/models/models.dart';
import 'package:todo_bloc/widgets/widgets.dart';

class MockTodosBloc extends MockBloc<TodosEvent, TodosState>
    implements TodosBloc {}

class MockFilteredTodosBloc
    extends MockBloc<FilteredTodosEvent, FilteredTodosState>
    implements FilteredTodosBloc {}

void main() {
  setUpAll(() {
    registerFallbackValue<TodosState>(TodosLoading());
    registerFallbackValue<TodosEvent>(LoadTodos());
    registerFallbackValue<FilteredTodosState>(FilteredTodosLoading());
    registerFallbackValue<FilteredTodosEvent>(
        UpdateFilter(VisibilityFilter.all));
  });

  group('FilteredTodos', () {
    late TodosBloc todosBloc;
    late FilteredTodosBloc filteredTodosBloc;

    setUp(() {
      todosBloc = MockTodosBloc();
      filteredTodosBloc = MockFilteredTodosBloc();
    });

    testWidgets('should show loading indicator when state is TodosLoading',
        (WidgetTester tester) async {
      when(() => filteredTodosBloc.state).thenAnswer(
        (_) => FilteredTodosLoading(),
      );
      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<TodosBloc>.value(value: todosBloc),
            BlocProvider<FilteredTodosBloc>.value(value: filteredTodosBloc),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: FilteredTodos(),
            ),
            localizationsDelegates: l10nDelegates,
          ),
        ),
      );
      await tester.pump(Duration(seconds: 1));
      expect(find.byKey(ArchSampleKeys.todosLoading), findsOneWidget);
    });

    testWidgets(
        'should show empty list when state is TodosLoaded with no todos',
        (WidgetTester tester) async {
      when(() => todosBloc.state).thenAnswer((_) => TodosLoaded([]));
      when(() => filteredTodosBloc.state).thenAnswer(
        (_) => FilteredTodosLoaded([], VisibilityFilter.all),
      );
      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<TodosBloc>.value(value: todosBloc),
            BlocProvider<FilteredTodosBloc>.value(value: filteredTodosBloc),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: FilteredTodos(),
            ),
            localizationsDelegates: l10nDelegates,
          ),
        ),
      );
      await tester.pumpAndSettle();
      final todoListFinder = find.byKey(ArchSampleKeys.todoList);
      expect(todoListFinder, findsOneWidget);
      expect(
          (todoListFinder.evaluate().first.widget as ListView)
              .semanticChildCount,
          0);
    });

    testWidgets('should show todos when state is TodosLoaded with todos',
        (WidgetTester tester) async {
      when(() => todosBloc.state)
          .thenAnswer((_) => TodosLoaded([Todo('wash car')]));
      when(() => filteredTodosBloc.state).thenAnswer(
        (_) => FilteredTodosLoaded([Todo('wash car')], VisibilityFilter.all),
      );
      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<TodosBloc>.value(value: todosBloc),
            BlocProvider<FilteredTodosBloc>.value(value: filteredTodosBloc),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: FilteredTodos(),
            ),
            localizationsDelegates: l10nDelegates,
          ),
        ),
      );
      await tester.pumpAndSettle();
      final todoListFinder = find.byKey(ArchSampleKeys.todoList);
      expect(todoListFinder, findsOneWidget);
      expect(
          (todoListFinder.evaluate().first.widget as ListView)
              .semanticChildCount,
          1);
    });

    testWidgets('should add OnCheckboxChanged when checkbox tapped',
        (WidgetTester tester) async {
      when(() => todosBloc.state)
          .thenAnswer((_) => TodosLoaded([Todo('wash car', id: '0')]));
      when(() => filteredTodosBloc.state).thenAnswer(
        (_) => FilteredTodosLoaded(
            [Todo('wash car', id: '0')], VisibilityFilter.all),
      );
      when(() => todosBloc
              .add(UpdateTodo(Todo('wash car', id: '0', complete: true))))
          .thenReturn(null);
      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<TodosBloc>.value(value: todosBloc),
            BlocProvider<FilteredTodosBloc>.value(value: filteredTodosBloc),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: FilteredTodos(),
            ),
            localizationsDelegates: l10nDelegates,
          ),
        ),
      );
      await tester.pumpAndSettle();
      final todoFinder = find.byKey(ArchSampleKeys.todoItem('0'));
      expect(todoFinder, findsOneWidget);
      final checkboxFinder = find.byKey(ArchSampleKeys.todoItemCheckbox('0'));
      expect(checkboxFinder, findsOneWidget);
      await tester.tap(checkboxFinder);
      verify(
        () => todosBloc.add(
          UpdateTodo(
            Todo('wash car', id: '0', complete: true),
          ),
        ),
      ).called(1);
    });

    testWidgets('should add DeleteTodo when dismissed',
        (WidgetTester tester) async {
      when(() => filteredTodosBloc.state).thenReturn(
        FilteredTodosLoaded([Todo('wash car', id: '0')], VisibilityFilter.all),
      );
      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<TodosBloc>.value(value: todosBloc),
            BlocProvider<FilteredTodosBloc>.value(value: filteredTodosBloc),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: FilteredTodos(),
            ),
            localizationsDelegates: l10nDelegates,
          ),
        ),
      );
      await tester.pumpAndSettle();
      final todoFinder = find.byKey(ArchSampleKeys.todoItem('0'));
      expect(todoFinder, findsOneWidget);
      (tester.widget(find.byKey(ArchSampleKeys.todoItem('0'))) as Dismissible)
          .onDismissed!(DismissDirection.horizontal);
      verify(
        () => todosBloc.add(
          DeleteTodo(
            Todo('wash car', id: '0'),
          ),
        ),
      ).called(1);
    });

    testWidgets('should add AddTodo when dismissed and Undo Tapped',
        (WidgetTester tester) async {
      when(() => filteredTodosBloc.state).thenReturn(
        FilteredTodosLoaded([Todo('wash car', id: '0')], VisibilityFilter.all),
      );
      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<TodosBloc>.value(value: todosBloc),
            BlocProvider<FilteredTodosBloc>.value(value: filteredTodosBloc),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: FilteredTodos(),
            ),
            localizationsDelegates: l10nDelegates,
          ),
        ),
      );
      await tester.pumpAndSettle();
      final todoFinder = find.byKey(ArchSampleKeys.todoItem('0'));
      expect(todoFinder, findsOneWidget);
      (tester.widget(find.byKey(ArchSampleKeys.todoItem('0'))) as Dismissible)
          .onDismissed!(DismissDirection.horizontal);
      await tester.pumpAndSettle();
      verify(
        () => todosBloc.add(
          DeleteTodo(
            Todo('wash car', id: '0'),
          ),
        ),
      ).called(1);
      expect(find.text('Undo'), findsOneWidget);
      await tester.tap(find.text('Undo'));
      verify(
        () => todosBloc.add(
          AddTodo(
            Todo('wash car', id: '0'),
          ),
        ),
      ).called(1);
    });

    testWidgets('should Navigate to DetailsScreen when todo tapped',
        (WidgetTester tester) async {
      when(() => todosBloc.state)
          .thenAnswer((_) => TodosLoaded([Todo('wash car', id: '0')]));
      when(() => filteredTodosBloc.state).thenAnswer(
        (_) => FilteredTodosLoaded(
            [Todo('wash car', id: '0')], VisibilityFilter.all),
      );
      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<TodosBloc>.value(value: todosBloc),
            BlocProvider<FilteredTodosBloc>.value(value: filteredTodosBloc),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: FilteredTodos(),
            ),
            localizationsDelegates: l10nDelegates,
          ),
        ),
      );
      await tester.pumpAndSettle();
      final todoFinder = find.byKey(ArchSampleKeys.todoItem('0'));
      expect(todoFinder, findsOneWidget);
      await tester.tap(todoFinder);
      await tester.pumpAndSettle();
      expect(find.byKey(ArchSampleKeys.todoDetailsScreen), findsOneWidget);
    });

    testWidgets('should add DeleteTodo when todo deleted from DetailsScreen',
        (WidgetTester tester) async {
      when(() => todosBloc.state)
          .thenAnswer((_) => TodosLoaded([Todo('wash car', id: '0')]));
      when(() => filteredTodosBloc.state).thenAnswer(
        (_) => FilteredTodosLoaded(
            [Todo('wash car', id: '0')], VisibilityFilter.all),
      );
      when(() => todosBloc.add(DeleteTodo(Todo('wash car', id: '0'))))
          .thenReturn(null);
      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<TodosBloc>.value(value: todosBloc),
            BlocProvider<FilteredTodosBloc>.value(value: filteredTodosBloc),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: FilteredTodos(),
            ),
            localizationsDelegates: l10nDelegates,
          ),
        ),
      );
      await tester.pumpAndSettle();
      final todoFinder = find.byKey(ArchSampleKeys.todoItem('0'));
      expect(todoFinder, findsOneWidget);
      await tester.tap(todoFinder);
      await tester.pumpAndSettle();
      expect(find.byKey(ArchSampleKeys.todoDetailsScreen), findsOneWidget);
      await tester.tap(find.byKey(ArchSampleKeys.deleteTodoButton));
      await tester.pumpAndSettle();
      verify(
        () => todosBloc.add(
          DeleteTodo(
            Todo('wash car', id: '0'),
          ),
        ),
      ).called(1);
    });

    testWidgets(
        'should add AddTodo when todo deleted from DetailsScreen and Undo Tapped',
        (WidgetTester tester) async {
      when(() => todosBloc.state)
          .thenAnswer((_) => TodosLoaded([Todo('wash car', id: '0')]));
      when(() => filteredTodosBloc.state).thenAnswer(
        (_) => FilteredTodosLoaded(
            [Todo('wash car', id: '0')], VisibilityFilter.all),
      );
      when(() => todosBloc.add(DeleteTodo(Todo('wash car', id: '0'))))
          .thenReturn(null);
      when(() => todosBloc.add(AddTodo(Todo('wash car', id: '0'))))
          .thenReturn(null);
      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<TodosBloc>.value(value: todosBloc),
            BlocProvider<FilteredTodosBloc>.value(value: filteredTodosBloc),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: FilteredTodos(),
            ),
            localizationsDelegates: l10nDelegates,
          ),
        ),
      );
      await tester.pumpAndSettle();
      final todoFinder = find.byKey(ArchSampleKeys.todoItem('0'));
      expect(todoFinder, findsOneWidget);
      await tester.tap(todoFinder);
      await tester.pumpAndSettle();
      expect(find.byKey(ArchSampleKeys.todoDetailsScreen), findsOneWidget);
      await tester.tap(find.byKey(ArchSampleKeys.deleteTodoButton));
      await tester.pumpAndSettle();
      verify(
        () => todosBloc.add(
          DeleteTodo(
            Todo('wash car', id: '0'),
          ),
        ),
      ).called(1);
      await tester.tap(find.text('Undo'));
      verify(
        () => todosBloc.add(
          AddTodo(
            Todo('wash car', id: '0'),
          ),
        ),
      ).called(1);
    });
  });
}
