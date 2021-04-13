// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:equatable/equatable.dart';
import 'package:todo_bloc/common/todos_app_core/todos_app_core.dart';
import 'package:todo_bloc/common/todos_repository_core/todos_repository_core.dart';

enum AppTab { todos, stats }

enum ExtraAction { toggleAllComplete, clearCompleted }

class Todo extends Equatable {
  final bool complete;
  final String id;
  final String note;
  final String task;

  Todo(this.task, {this.complete = false, this.note = '', String? id})
      : id = id ?? Uuid().generateV4();

  @override
  List<Object?> get props => [task, id, note, complete];

  TodoEntity toEntity() {
    return TodoEntity(task, id, note, complete);
  }

  static Todo fromEntity(TodoEntity entity) {
    return Todo(
      entity.task,
      complete: entity.complete,
      note: entity.note,
      id: entity.id,
    );
  }

  Todo copyWith({bool? complete, String? id, String? note, String? task}) {
    return Todo(
      task ?? this.task,
      complete: complete ?? this.complete,
      id: id ?? this.id,
      note: note ?? this.note,
    );
  }
}
