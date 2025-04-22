// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/presentation/screen/done_task.dart';
import 'package:todo_app/presentation/screen/in_progress.dart';
import 'package:todo_app/presentation/screen/new_task.dart';
import '../../domain/entity_task.dart';
import '../cubit/task_bloc.dart';

class TaskScreen extends StatelessWidget {
  const TaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Task"),
          bottom: TabBar(
            onTap: (index) {
              final status = TaskStatus.values[index];
              context.read<TaskCubit>().setfilterStatus(status);
            },
            tabs: const [
              Tab(icon: Icon(Icons.new_releases), text: "Mới"),
              Tab(icon: Icon(Icons.pending_actions), text: "Đang xử lý"),
              Tab(icon: Icon(Icons.task_alt), text: "Hoàn tất"),
            ],
          ),
        ),
        body: Container(
          color: Colors.white70,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'Tìm kiếm...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  onChanged: (value) {
                    context.read<TaskCubit>().setSearchText(value);
                  },
                ),
              ),
              const Expanded(
                child: TabBarView(
                  children: [
                    NewTasksScreen(),
                    InProgressScreen(),
                    DoneTasksScreen(),
                  ],
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showAddTaskDialog(context),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

// show cái dialog thêm
void _showAddTaskDialog(BuildContext context) {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  String selectedColor = '0xFF2196F3';
  TaskPriority selectedPriority = TaskPriority.medium;

  showDialog(
    context: context,
    builder:
        (context) => StatefulBuilder(
          builder:
              (context, setState) => AlertDialog(
                title: const Text('Thêm công việc mới'),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        autofocus: true,
                        controller: titleController,
                        decoration: const InputDecoration(
                          labelText: 'Tiêu đề',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: descriptionController,
                        decoration: const InputDecoration(
                          labelText: 'Mô tả',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<TaskPriority>(
                        value: selectedPriority,
                        decoration: const InputDecoration(
                          labelText: 'Độ ưu tiên',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          selectedPriority = value!;
                        },
                        items:
                            TaskPriority.values.map((priority) {
                              return DropdownMenuItem(
                                value: priority,
                                child: Text(priority.name),
                              );
                            }).toList(),
                      ),
                      const SizedBox(height: 8),
                      ListTile(
                        title: const Text('Chọn deadline'),
                        subtitle: Text(
                          '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                        ),
                        trailing: const Icon(Icons.calendar_today),
                        onTap: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: selectedDate,
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(
                              const Duration(days: 365),
                            ),
                          );
                          if (picked != null) {
                            selectedDate = picked;
                          }
                        },
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 6,
                        children: [
                          _colorChoice('0xFF2196F3', selectedColor, (color) {
                            setState(() => selectedColor = color);
                          }),
                          _colorChoice('0xFF4CAF50', selectedColor, (color) {
                            setState(() => selectedColor = color);
                          }),
                          _colorChoice('0xFFFFC107', selectedColor, (color) {
                            setState(() => selectedColor = color);
                          }),
                          _colorChoice('0xFFE91E63', selectedColor, (color) {
                            setState(() => selectedColor = color);
                          }),
                        ],
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Hủy'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (titleController.text.isNotEmpty) {
                        context.read<TaskCubit>().addTask(
                          title: titleController.text,
                          description: descriptionController.text,
                          priority: selectedPriority,
                          color: selectedColor,
                          deadlineDate: selectedDate,
                        );
                        Navigator.pop(context);
                      }
                    },
                    child: const Text('Thêm'),
                  ),
                ],
              ),
        ),
  );
}

// chọn màu cho cái task
Widget _colorChoice(
  String color,
  String selectedColor,
  Function(String) onSelect,
) {
  return GestureDetector(
    onTap: () => onSelect(color),
    child: Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: Color(int.parse(color)),
        shape: BoxShape.circle,
        border: Border.all(
          color: color == selectedColor ? Colors.black : Colors.transparent,
          width: 2,
        ),
      ),
    ),
  );
}
