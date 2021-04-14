import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:todo_bloc/blocs/add_edit/add_edit.dart';
import 'package:todo_bloc/models/models.dart';

class AddEditBloc extends Bloc<AddEditEvent, AddEditState> {
  Todo todo;

  AddEditBloc({required this.todo})
      : super(TextLoaded(todo.task, todo.note, false));

  @override
  Stream<AddEditState> mapEventToState(AddEditEvent event) async* {
    if (event is UpdateAll) {
      var task = event.task;
      var note = event.note;

      if (task != todo.task || note != todo.note) {
        todo = todo.copyWith(task: task, note: note);
        yield TextLoaded(task, note, task.isEmpty);
      }
    } else if (event is UpdateTask) {
      var task = event.task;

      if (task != todo.task) {
        todo = todo.copyWith(task: task);
        yield TextLoaded(task, todo.note, task.isEmpty);
      }
    } else if (event is UpdateNote) {
      var note = event.note;

      if (note != todo.note) {
        todo = todo.copyWith(note: note);
        yield TextLoaded(todo.task, note, todo.task.isEmpty);
      }
    }
  }
}
