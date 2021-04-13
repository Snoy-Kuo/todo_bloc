// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_bloc/common/todos_repository_core/todos_repository_core.dart';

class KeyValueStorage implements TodosRepository {
  final String key;
  final SharedPreferences store;
  final JsonCodec codec;

  const KeyValueStorage(this.key, this.store, [this.codec = json]);

  @override
  Future<List<TodoEntity>> loadTodos() async {
    final String? value = store.getString(key);
    if (value == null) throw Exception('No local todos.');

    return codec
        .decode(value)['todos']
        .cast<Map<String, dynamic>>()
        .map<TodoEntity>(TodoEntity.fromMap)
        .toList(growable: false);
  }

  @override
  Future<bool> saveTodos(List<TodoEntity> todos) {
    return store.setString(
      key,
      codec.encode({
        'todos': todos.map((todo) => todo.toMap()).toList(),
      }),
    );
  }
}
