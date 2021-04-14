import 'package:equatable/equatable.dart';

abstract class AddEditState extends Equatable {
  const AddEditState();

  @override
  List<Object> get props => [];
}

class TextLoaded extends AddEditState {
  final String task;
  final String note;
  final bool error;

  const TextLoaded(this.task, this.note, this.error);

  @override
  List<Object> get props => [task, note, error];
}