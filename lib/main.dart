import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_bloc/run_app.dart';

import 'common/repository_local_storage/repository_local_storage.dart';
import 'common/todos_repository_local_storage/todos_repository_local_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runBlocLibraryApp(LocalStorageRepository(
    localStorage: KeyValueStorage(
      'todo_bloc',
      await SharedPreferences.getInstance(),
    ),
  ));
}
