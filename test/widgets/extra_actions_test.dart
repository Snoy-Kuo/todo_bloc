// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_bloc/bloc_library_keys.dart';
import 'package:todo_bloc/blocs/blocs.dart';
import 'package:todo_bloc/common/todos_app_core/todos_app_core.dart';
import 'package:todo_bloc/l10n/l10n.dart';
import 'package:todo_bloc/models/models.dart';
import 'package:todo_bloc/widgets/widgets.dart';

class MockTodosBloc extends MockBloc<TodosEvent, TodosState>
    implements TodosBloc {}

void main() {
  setUpAll(() {
    registerFallbackValue<TodosState>(TodosLoading());
    registerFallbackValue<TodosEvent>(LoadTodos());
  });
  group('ExtraActions', () {
    late TodosBloc todosBloc;

    setUp(() {
      todosBloc = MockTodosBloc();
    });

    testWidgets('renders an empty Container if state is not TodosLoaded',
        (WidgetTester tester) async {
      when(() => todosBloc.state).thenReturn(TodosLoading());
      await tester.pumpWidget(
        BlocProvider.value(
          value: todosBloc,
          child: MaterialApp(
            home: Scaffold(
              appBar: AppBar(
                actions: [ExtraActions()],
              ),
              body: Container(),
            ),
          ),
        ),
      );
      expect(find.byKey((BlocLibraryKeys.extraActionsEmptyContainer)),
          findsOneWidget);
    });

    testWidgets(
        'renders PopupMenuButton with mark all done if state is TodosLoaded with incomplete todos',
        (WidgetTester tester) async {
      when(() => todosBloc.state).thenReturn(TodosLoaded([Todo('walk dog')]));
      await tester.pumpWidget(
        BlocProvider.value(
          value: todosBloc,
          child: MaterialApp(
            home: Scaffold(
              appBar: AppBar(
                actions: [ExtraActions()],
              ),
              body: Container(),
            ),
            localizationsDelegates: l10nDelegates,
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(BlocLibraryKeys.extraActionsPopupMenuButton));
      await tester.pump();
      expect(find.byKey(ArchSampleKeys.toggleAll), findsOneWidget);
      expect(find.text('Clear completed'), findsOneWidget);
      expect(find.text('Mark all complete'), findsOneWidget);
    });

    testWidgets(
        'renders PopupMenuButton with mark all incomplete if state is TodosLoaded with complete todos',
        (WidgetTester tester) async {
      when(() => todosBloc.state)
          .thenReturn(TodosLoaded([Todo('walk dog', complete: true)]));
      await tester.pumpWidget(
        BlocProvider.value(
          value: todosBloc,
          child: MaterialApp(
            home: Scaffold(
              appBar: AppBar(
                actions: [ExtraActions()],
              ),
              body: Container(),
            ),
            localizationsDelegates: l10nDelegates,
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(BlocLibraryKeys.extraActionsPopupMenuButton));
      await tester.pump();
      expect(find.byKey(ArchSampleKeys.toggleAll), findsOneWidget);
      expect(find.text('Clear completed'), findsOneWidget);
      expect(find.text('Mark all incomplete'), findsOneWidget);
    });

    testWidgets('tapping clear completed adds ClearCompleted',
        (WidgetTester tester) async {
      when(() => todosBloc.state).thenReturn(TodosLoaded([
        Todo('walk dog'),
        Todo('take out trash', complete: true),
      ]));
      when(() => todosBloc.add(ClearCompleted())).thenReturn(null);
      await tester.pumpWidget(
        BlocProvider.value(
          value: todosBloc,
          child: MaterialApp(
            home: Scaffold(
              appBar: AppBar(
                actions: [ExtraActions()],
              ),
              body: Container(),
            ),
            localizationsDelegates: l10nDelegates,
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(BlocLibraryKeys.extraActionsPopupMenuButton));
      await tester.pump();
      expect(find.byKey(ArchSampleKeys.clearCompleted), findsOneWidget);
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(ArchSampleKeys.clearCompleted));
      verify(() => todosBloc.add(ClearCompleted())).called(1);
    });

    testWidgets('tapping toggle all adds ToggleAll',
        (WidgetTester tester) async {
      when(() => todosBloc.state).thenReturn(TodosLoaded([
        Todo('walk dog'),
        Todo('take out trash'),
      ]));
      when(() => todosBloc.add(ToggleAll())).thenReturn(null);
      await tester.pumpWidget(
        BlocProvider.value(
          value: todosBloc,
          child: MaterialApp(
            home: Scaffold(
              appBar: AppBar(
                actions: [ExtraActions()],
              ),
              body: Container(),
            ),
            localizationsDelegates: l10nDelegates,
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(BlocLibraryKeys.extraActionsPopupMenuButton));
      await tester.pump();
      expect(find.byKey(ArchSampleKeys.toggleAll), findsOneWidget);
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(ArchSampleKeys.toggleAll));
      verify(() => todosBloc.add(ToggleAll())).called(1);
    });
  });
}
