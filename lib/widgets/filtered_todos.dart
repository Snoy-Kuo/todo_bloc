// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_bloc/bloc_library_keys.dart';
import 'package:todo_bloc/blocs/blocs.dart';
import 'package:todo_bloc/common/todos_app_core/todos_app_core.dart';
import 'package:todo_bloc/models/models.dart';
import 'package:todo_bloc/screens/screens.dart';
import 'package:todo_bloc/widgets/widgets.dart';

class FilteredTodos extends StatelessWidget {
  FilteredTodos({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final todosBloc = BlocProvider.of<TodosBloc>(context);

    return BlocBuilder<FilteredTodosBloc, FilteredTodosState>(
      builder: (
        BuildContext context,
        FilteredTodosState state,
      ) {
        if (state is FilteredTodosLoading) {
          return LoadingIndicator(key: ArchSampleKeys.todosLoading);
        } else if (state is FilteredTodosLoaded) {
          final todos = state.filteredTodos;
          return ListView.builder(
            key: ArchSampleKeys.todoList,
            itemCount: todos.length,
            itemBuilder: (BuildContext context, int index) {
              final todo = todos[index];
              return TodoItem(
                todo: todo,
                onDismissed: (_) {
                  todosBloc.add(DeleteTodo(todo));
                  ScaffoldMessenger.of(context).showSnackBar(DeleteTodoSnackBar(
                      key: ArchSampleKeys.snackbar,
                      todo: todo,
                      onUndo: () => todosBloc.add(AddTodo(todo))));
                },
                onTap: () async {
                  final removedTodo = await Navigator.of(context).push<Todo>(
                    MaterialPageRoute(builder: (_) {
                      return DetailsScreen(id: todo.id);
                    }),
                  );
                  if (removedTodo != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        DeleteTodoSnackBar(
                            key: ArchSampleKeys.snackbar,
                            todo: todo,
                            onUndo: () => todosBloc.add(AddTodo(todo))));
                  }
                },
                onCheckboxChanged: (_) {
                  todosBloc.add(
                    UpdateTodo(todo.copyWith(complete: !todo.complete)),
                  );
                },
              );
            },
          );
        } else {
          return Container(key: BlocLibraryKeys.filteredTodosEmptyContainer);
        }
      },
    );
  }
}
