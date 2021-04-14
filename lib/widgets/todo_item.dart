// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:todo_bloc/common/todos_app_core/todos_app_core.dart';
import 'package:todo_bloc/l10n/l10n.dart';
import 'package:todo_bloc/models/models.dart';

class TodoItem extends StatelessWidget {
  final DismissDirectionCallback onDismissed;
  final GestureTapCallback onTap;
  final ValueChanged<bool?>? onCheckboxChanged;
  final Todo todo;

  TodoItem({
    Key? key,
    required this.onDismissed,
    required this.onTap,
    required this.onCheckboxChanged,
    required this.todo,
  }) : super(key: key);

  Widget _slideBackground(BuildContext context, {required bool toRight}) {
    return Container(
      color: Colors.red,
      child: Align(
        child: Row(
          mainAxisAlignment:
          toRight ? MainAxisAlignment.start : MainAxisAlignment.end,
          children: <Widget>[
            SizedBox(
              width: toRight ? 20 : 0,
            ),
            Icon(
              Icons.delete,
              color: Colors.white,
            ),
            Text(
              l10n(context).delete,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: toRight ? TextAlign.left : TextAlign.right,
            ),
            SizedBox(
              width: toRight ? 0 : 20,
            ),
          ],
        ),
        alignment: toRight ? Alignment.centerLeft : Alignment.centerRight,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ArchSampleKeys.todoItem(todo.id),
      onDismissed: onDismissed,
      background: _slideBackground(context, toRight: true),
      secondaryBackground: _slideBackground(context, toRight: false),
      child: ListTile(
        onTap: onTap,
        leading: Checkbox(
          key: ArchSampleKeys.todoItemCheckbox(todo.id),
          value: todo.complete,
          onChanged: onCheckboxChanged,
        ),
        title: Hero(
          tag: '${todo.id}__heroTag',
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Text(
              todo.task,
              key: ArchSampleKeys.todoItemTask(todo.id),
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
        ),
        subtitle: todo.note.isNotEmpty
            ? Text(
                todo.note,
                key: ArchSampleKeys.todoItemNote(todo.id),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.subtitle1,
              )
            : null,
      ),
    );
  }
}
