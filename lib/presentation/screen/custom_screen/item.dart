import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/presentation/screen/dailog/all_desc.dart';
import 'package:todo_app/presentation/screen/custom_screen/custom_card.dart';
import 'package:todo_app/presentation/screen/dailog/edit_dailog.dart';
import 'package:todo_app/presentation/screen/another_screen/status_untils.dart';
import '../../../domain/entity_task.dart';
import '../../cubit/task_bloc.dart';

class TaskItem extends StatelessWidget {
  final Task task;

  const TaskItem({super.key, required this.task});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () => _showEditTaskDialog(context),
      onDoubleTap: () => _showDescriptionDialog(context),
      child: CustomTaskCard(
        task: task,
        onLongPress: () => _showEditTaskDialog(context),
        trailing: _buildStatusDropdown(context),
      ),
    );
  }

  void _showDescriptionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => DescriptionDialog(
            title: task.title,
            description: task.description,
            deadline: task.datelineDate.toLocal().toString().split(" ")[0],
          ),
    );
  }

  Widget _buildStatusDropdown(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(4)),
      child: DropdownButton<TaskStatus>(
        value: task.status,
        underline: const SizedBox(),
        dropdownColor: Colors.white,
        icon: const Icon(Icons.arrow_drop_down),
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
        onChanged: (newStatus) {
          if (newStatus != null) {
            context.read<TaskCubit>().updateStatus(task.id, newStatus);
          }
        },
        items:
            TaskStatus.values.map((status) {
              return DropdownMenuItem(
                value: status,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      StatusUtils.getStatusIcon(status),
                      color: StatusUtils.getStatusColor(status),
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      StatusUtils.getStatusText(status),
                      style: TextStyle(
                        color: StatusUtils.getStatusColor(status),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
      ),
    );
  }

  void _showEditTaskDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => EditTaskDialog(task: task),
    );
  }
}
