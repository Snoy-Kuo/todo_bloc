// Provides a Mock repository that can be used for testing in place of the real
// thing.

import 'package:todo_bloc/models/models.dart';

import 'todos_repository_core.dart';

class MockRepository extends TodosRepository {
  List<TodoEntity> entities;
  final Duration delay;
  int saveCount = 0;

  MockRepository([List<Todo> todos = const [], this.delay = Duration.zero])
      : entities = todos.map((it) => it.toEntity()).toList();

  @override
  Future<List<TodoEntity>> loadTodos() async {
    return Future.delayed(delay, () => entities);
  }

  @override
  Future saveTodos(List<TodoEntity> todos) async {
    saveCount++;
    entities = todos;
  }

  static List<Todo> get defaultTodos {
    return [
      Todo('T1', id: '1', note: 'N1'),
      Todo('T2', id: '2'),
      Todo('T3', id: '3', complete: true),
    ];
  }
}
