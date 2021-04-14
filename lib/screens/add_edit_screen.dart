// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_bloc/blocs/add_edit/add_edit.dart';
import 'package:todo_bloc/common/todos_app_core/todos_app_core.dart';
import 'package:todo_bloc/l10n/l10n.dart';
import 'package:todo_bloc/models/models.dart';

typedef OnSaveCallback = void Function(String task, String note);

class AddEditScreen extends StatelessWidget {
  final bool isEditing;
  final OnSaveCallback onSave;
  final Todo todo;

  AddEditScreen({
    Key? key,
    required this.onSave,
    required this.isEditing,
    required this.todo,
  }) : super(key: key ?? ArchSampleKeys.addTodoScreen);

  @override
  Widget build(BuildContext context) {
    final addEditBloc = AddEditBloc(todo: todo);
    return BlocBuilder(
        bloc: addEditBloc,
        builder: (BuildContext context, AddEditState state) {
          final textTheme = Theme.of(context).textTheme;
          final TextLoaded loadedState = state as TextLoaded;
          return Scaffold(
            appBar: AppBar(
              title: Text(
                isEditing ? l10n(context).editTodo : l10n(context).addTodo,
              ),
            ),
            body: Padding(
              padding: EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  TextFormField(
                    initialValue: isEditing ? loadedState.task : '',
                    key: ArchSampleKeys.taskField,
                    autofocus: !isEditing,
                    style: textTheme.headline5,
                    decoration: InputDecoration(
                        hintText: l10n(context).inputTodoHint,
                        errorText: loadedState.error
                            ? l10n(context).inputTodoEmptyWarning
                            : null),
                    onChanged: (val) {
                      addEditBloc.add(UpdateTask(val));
                    },
                  ),
                  TextFormField(
                    initialValue: isEditing ? loadedState.note : '',
                    key: ArchSampleKeys.noteField,
                    maxLines: 10,
                    style: textTheme.subtitle1,
                    decoration: InputDecoration(
                      hintText: l10n(context).additionalNotes,
                    ),
                    onChanged: (val) {
                      addEditBloc.add(UpdateNote(val));
                    },
                  )
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              key: isEditing
                  ? ArchSampleKeys.saveTodoFab
                  : ArchSampleKeys.saveNewTodo,
              tooltip:
                  isEditing ? l10n(context).saveChanges : l10n(context).addTodo,
              child: Icon(isEditing ? Icons.check : Icons.add),
              onPressed: () {
                if (!loadedState.error) {
                  onSave(loadedState.task, loadedState.note);
                  Navigator.pop(context);
                }
              },
            ),
          );
        });
  }
}
