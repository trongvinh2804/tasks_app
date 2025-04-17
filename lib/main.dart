import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'data/task_store.dart';
import 'presentation/cubit/task_bloc.dart';
import 'presentation/screen/task_screen.dart';
import 'domain/entity_task.dart';

void main() {
  final store = TaskStore();
  runApp(MyApp(store: store));
}

class MyApp extends StatelessWidget {
  final TaskStore store;

  const MyApp({Key? key, required this.store}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TaskCubit(store),
      child: MaterialApp(
        title: 'Todo App',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: DefaultTabController(
          length: TaskStatus.values.length,
          child: const TaskScreen(),
        ),
      ),
    );
  }
}
