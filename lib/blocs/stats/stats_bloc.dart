import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:todo_bloc/blocs/blocs.dart';
import 'package:todo_bloc/blocs/stats/stats.dart';

class StatsBloc extends Bloc<StatsEvent, StatsState> {
  final TodosBloc todosBloc;
  late StreamSubscription todosSubscription;

  StatsBloc({required this.todosBloc}) : super(StatsLoading()) {
    if (todosBloc.state is TodosLoaded) {
      add(UpdateStats((todosBloc.state as TodosLoaded).todos));
    }
    todosSubscription = todosBloc.stream.listen((state) {
      if (state is TodosLoaded) {
        add(UpdateStats(state.todos));
      }
    });
  }

  @override
  Stream<StatsState> mapEventToState(StatsEvent event) async* {
    if (event is UpdateStats) {
      var numActive =
          event.todos.where((todo) => !todo.complete).toList().length;
      var numCompleted =
          event.todos.where((todo) => todo.complete).toList().length;

      yield StatsLoaded(numActive, numCompleted);
    }
  }

  @override
  Future<void> close() {
    todosSubscription.cancel();
    return super.close();
  }
}
