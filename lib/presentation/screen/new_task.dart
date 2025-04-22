import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/presentation/screen/item.dart';
import '../../domain/entity_task.dart';
import '../cubit/task_bloc.dart';
import '../cubit/task_state.dart';

class NewTasksScreen extends StatelessWidget {
  const NewTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskCubit, TaskState>(
      builder: (context, state) {
        final tasks =
            state.filteredTasks
                .where((task) => task.status == TaskStatus.newtask)
                .toList();

        if (tasks.isEmpty) {
          return const Center(child: Text('Không có công việc mới'));
        }

        return ListView.separated(
          padding: const EdgeInsets.all(8),
          itemCount: tasks.length,
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemBuilder: (context, index) => TaskItem(task: tasks[index]),
        );
      },
    );
  }
}
