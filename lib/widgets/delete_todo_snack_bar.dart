import 'package:flutter/material.dart';
import 'package:todo_bloc/l10n/l10n.dart';
import 'package:todo_bloc/models/models.dart';

class DeleteTodoSnackBar extends SnackBar {
  DeleteTodoSnackBar(
      {Key? key,
      required BuildContext context,
      required Todo todo,
      required VoidCallback onUndo})
      : super(
          key: key,
          content: Text(
            l10n(context).deletedTodoTask(todo.task),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          duration: Duration(seconds: 2),
          action: SnackBarAction(
            label: l10n(context).undo,
            onPressed: onUndo,
          ),
        );
}
