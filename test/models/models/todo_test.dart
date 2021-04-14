// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter_test/flutter_test.dart';
import 'package:todo_bloc/common/todos_repository_core/todos_repository_core.dart';
import 'package:todo_bloc/models/models.dart';

void main() {
  group('Todo', () {
    test('is correctly generated from TodoEntity', () {
      expect(
        Todo.fromEntity(TodoEntity('task', 'id', 'note', true)),
        Todo('task', id: 'id', note: 'note', complete: true),
      );
    });
  });
}
