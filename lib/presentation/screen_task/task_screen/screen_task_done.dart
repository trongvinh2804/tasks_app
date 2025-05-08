import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/presentation/widgets/custom_screen/custom_item.dart';
import '../../../domain/entity_task.dart';
import '../view_model/screen_task_bloc.dart';
import '../view_model/screen_task_state.dart';

class DoneTasksScreen extends StatelessWidget {
  const DoneTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskCubit, TaskState>(
      builder: (context, state) {
        final tasks =
            state.filteredTasks
                .where((task) => task.status == TaskStatus.done)
                .toList();

        if (tasks.isEmpty) {
          return const Center(child: Text('Không có công việc hoàn thành'));
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
