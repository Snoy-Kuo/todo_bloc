// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_bloc/blocs/blocs.dart';
import 'package:todo_bloc/common/todos_app_core/todos_app_core.dart';
import 'package:todo_bloc/common/todos_repository_core/todos_repository_core.dart';
import 'package:todo_bloc/models/models.dart';
import 'package:todo_bloc/screens/screens.dart';

void runBlocLibraryApp(TodosRepository repository) {
  Bloc.observer = BlocObserver();
  runApp(
    BlocProvider<TodosBloc>(
      create: (context) {
        return TodosBloc(todosRepository: repository)..add(LoadTodos());
      },
      child: App(),
    ),
  );
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final todosBloc = BlocProvider.of<TodosBloc>(context);

    return MaterialApp(
      title: 'Todo Bloc',
      theme: ArchSampleTheme.theme,
      routes: {
        ArchSampleRoutes.home: (context) {
          return MultiBlocProvider(
            providers: [
              BlocProvider<TabBloc>(
                create: (context) => TabBloc(),
              ),
              BlocProvider<FilteredTodosBloc>(
                create: (context) => FilteredTodosBloc(todosBloc: todosBloc),
              ),
              BlocProvider<StatsBloc>(
                create: (context) => StatsBloc(todosBloc: todosBloc),
              ),
            ],
            child: HomeScreen(),
          );
        },
        ArchSampleRoutes.addTodo: (context) {
          return AddEditScreen(
            key: ArchSampleKeys.addTodoScreen,
            onSave: (task, note) {
              todosBloc.add(AddTodo(Todo(task, note: note)));
            },
            isEditing: false,
          );
        },
      },
    );
  }
}
