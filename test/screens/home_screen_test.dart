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
import 'package:todo_bloc/screens/screens.dart';

class MockTodosBloc extends MockBloc<TodosEvent, TodosState>
    implements TodosBloc {}

class MockFilteredTodosBloc
    extends MockBloc<FilteredTodosEvent, FilteredTodosState>
    implements FilteredTodosBloc {}

class MockTabBloc extends MockBloc<TabEvent, AppTab> implements TabBloc {}

class MockStatsBloc extends MockBloc<StatsEvent, StatsState>
    implements StatsBloc {}

void main() {
  setUpAll(() {
    registerFallbackValue<TodosState>(TodosLoading());
    registerFallbackValue<TodosEvent>(LoadTodos());
    registerFallbackValue<FilteredTodosState>(FilteredTodosLoading());
    registerFallbackValue<FilteredTodosEvent>(
        UpdateFilter(VisibilityFilter.all));
    registerFallbackValue<AppTab>(AppTab.todos);
    registerFallbackValue<TabEvent>(UpdateTab(AppTab.todos));
    registerFallbackValue<StatsState>(StatsLoading());
    registerFallbackValue<StatsEvent>(UpdateStats([]));
  });

  group('HomeScreen', () {
    late TodosBloc todosBloc;
    late FilteredTodosBloc filteredTodosBloc;
    late TabBloc tabBloc;
    late StatsBloc statsBloc;

    setUp(() {
      todosBloc = MockTodosBloc();
      filteredTodosBloc = MockFilteredTodosBloc();
      tabBloc = MockTabBloc();
      statsBloc = MockStatsBloc();
    });

    testWidgets('renders correctly', (WidgetTester tester) async {
      when(() => todosBloc.state).thenAnswer((_) => TodosLoaded([]));
      when(() => tabBloc.state).thenAnswer((_) => AppTab.todos);
      when(() => filteredTodosBloc.state)
          .thenReturn(FilteredTodosLoaded([], VisibilityFilter.all));
      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<TodosBloc>.value(
              value: todosBloc,
            ),
            BlocProvider<FilteredTodosBloc>.value(
              value: filteredTodosBloc,
            ),
            BlocProvider<TabBloc>.value(
              value: tabBloc,
            ),
            BlocProvider<StatsBloc>.value(
              value: statsBloc,
            ),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: HomeScreen(),
            ),
            localizationsDelegates: l10nDelegates,
            supportedLocales: [Locale('en')],
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byKey(ArchSampleKeys.addTodoFab), findsOneWidget);
      expect(find.text('Todo Bloc'), findsOneWidget);
    });

    testWidgets('Navigates to /addTodo when Floating Action Button is tapped',
        (WidgetTester tester) async {
      when(() => todosBloc.state).thenAnswer((_) => TodosLoaded([]));
      when(() => tabBloc.state).thenAnswer((_) => AppTab.todos);
      when(() => filteredTodosBloc.state)
          .thenReturn(FilteredTodosLoaded([], VisibilityFilter.all));
      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<TodosBloc>.value(
              value: todosBloc,
            ),
            BlocProvider<FilteredTodosBloc>.value(
              value: filteredTodosBloc,
            ),
            BlocProvider<TabBloc>.value(
              value: tabBloc,
            ),
            BlocProvider<StatsBloc>.value(
              value: statsBloc,
            ),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: HomeScreen(),
            ),
            localizationsDelegates: l10nDelegates,
            routes: {
              ArchSampleRoutes.addTodo: (context) {
                return AddEditScreen(
                  key: ArchSampleKeys.addTodoScreen,
                  onSave: (task, note) {},
                  isEditing: false,
                  todo: Todo(''),
                );
              },
            },
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(ArchSampleKeys.addTodoFab));
      await tester.pumpAndSettle();
      expect(find.byType(AddEditScreen), findsOneWidget);
    });
  });
}
