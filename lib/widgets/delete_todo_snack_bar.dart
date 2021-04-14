import 'package:flutter/material.dart';
import 'package:todo_bloc/l10n/l10n.dart';
import 'package:todo_bloc/models/models.dart';

class DeleteTodoSnackBar extends SnackBar {
  DeleteTodoSnackBar(
      {Key? key,
      required AppLocalizations localizations,
      required Todo todo,
      required VoidCallback onUndo})
      : super(
          key: key,
          content: Text(
            localizations.deletedTodoTask(todo.task),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          duration: Duration(seconds: 2),
          action: SnackBarAction(
            label: localizations.undo,
            onPressed: onUndo,
          ),
        );
}
