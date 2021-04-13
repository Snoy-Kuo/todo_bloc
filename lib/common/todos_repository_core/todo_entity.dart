// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class TodoEntity extends Equatable {
  final bool complete;
  final String id;
  final String note;
  final String task;

  const TodoEntity(this.task, this.id, this.note, this.complete);

  @override
  List<Object?> get props => [task, id, note, complete];

  Map<String, dynamic> toMap() {
    return {
      'complete': complete,
      'task': task,
      'note': note,
      'id': id,
    };
  }

  static TodoEntity fromMap(Map<String, dynamic> map) {
    return TodoEntity(
      map['task'] as String,
      map['id'] as String,
      map['note'] as String,
      map['complete'] as bool,
    );
  }
}
