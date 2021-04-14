import 'package:equatable/equatable.dart';

abstract class AddEditEvent extends Equatable {
  const AddEditEvent();
}

class UpdateTask extends AddEditEvent {
  final String task;

  const UpdateTask(this.task);

  @override
  List<Object> get props => [task];
}

class UpdateNote extends AddEditEvent {
  final String note;

  const UpdateNote( this.note);

  @override
  List<Object> get props => [note];
}

class UpdateAll extends AddEditEvent {
  final String task;
  final String note;

  const UpdateAll(this.task, this.note);

  @override
  List<Object> get props => [task, note];
}
