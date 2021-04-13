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

class ExtraActions extends StatelessWidget {
  ExtraActions({Key? key}) : super(key: ArchSampleKeys.extraActionsButton);

  @override
  Widget build(BuildContext context) {
    final todosBloc = BlocProvider.of<TodosBloc>(context);
    return BlocBuilder(
      bloc: todosBloc,
      builder: (BuildContext context, TodosState state) {
        if (state is TodosLoaded) {
          final allComplete = (todosBloc.state as TodosLoaded)
              .todos
              .every((todo) => todo.complete);
          return PopupMenuButton<ExtraAction>(
            key: BlocLibraryKeys.extraActionsPopupMenuButton,
            onSelected: (action) {
              switch (action) {
                case ExtraAction.clearCompleted:
                  todosBloc.add(ClearCompleted());
                  break;
                case ExtraAction.toggleAllComplete:
                  todosBloc.add(ToggleAll());
                  break;
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuItem<ExtraAction>>[
              PopupMenuItem<ExtraAction>(
                key: ArchSampleKeys.toggleAll,
                value: ExtraAction.toggleAllComplete,
                child: Text(
                  allComplete ? 'Mark all incomplete' : 'Mark all complete',
                ),
              ),
              PopupMenuItem<ExtraAction>(
                key: ArchSampleKeys.clearCompleted,
                value: ExtraAction.clearCompleted,
                child: Text(
                  'Clear completed',
                ),
              ),
            ],
          );
        }
        return Container(key: BlocLibraryKeys.extraActionsEmptyContainer);
      },
    );
  }
}
