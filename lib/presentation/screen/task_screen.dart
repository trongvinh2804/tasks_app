// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entity_task.dart';
import '../cubit/task_bloc.dart';
import '../cubit/task_state.dart';

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
        body: Column(
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
            Expanded(
              child: BlocBuilder<TaskCubit, TaskState>(
                builder: (context, state) {
                  final tasks = state.filteredTasks;
                  if (tasks.isEmpty) {
                    return const Center(child: Text('Không có công việc nào'));
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.all(8),
                    itemCount: tasks.length,
                    separatorBuilder:
                        (context, index) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      return Card(
                        elevation: 2,
                        // ignore: deprecated_member_use
                        color: Color(int.parse(task.color)).withOpacity(0.9),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(8),
                          onLongPress: () => _showEditTaskDialog(context, task),
                          title: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  task.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text(task.description),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.calendar_today, size: 16),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Deadline: ${task.datelineDate.toLocal().toString().split(" ")[0]}',
                                    style: const TextStyle(
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          trailing: DropdownButton<TaskStatus>(
                            value: task.status,
                            underline: const SizedBox(),
                            onChanged: (newStatus) {
                              if (newStatus != null) {
                                context.read<TaskCubit>().updateStatus(
                                  task.id,
                                  newStatus,
                                );
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
                                          _getStatusIcon(status),
                                          color: _getStatusColor(status),
                                          size: 16,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          _getStatusText(status),
                                          style: TextStyle(
                                            color: _getStatusColor(status),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showAddTaskDialog(context);
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
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
                          spacing: 8,
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

  // lấy cái màu
  Color _getStatusColor(TaskStatus status) {
    switch (status) {
      case TaskStatus.newtask:
        return Colors.black;
      case TaskStatus.inprogress:
        return Colors.orange;
      case TaskStatus.done:
        return Colors.indigo;
    }
  }

  // lấy cái icon
  IconData _getStatusIcon(TaskStatus status) {
    switch (status) {
      case TaskStatus.newtask:
        return Icons.new_releases;
      case TaskStatus.inprogress:
        return Icons.pending_actions;
      case TaskStatus.done:
        return Icons.task_alt;
    }
  }

  // lấy cái tên status
  String _getStatusText(TaskStatus status) {
    switch (status) {
      case TaskStatus.newtask:
        return "Mới";
      case TaskStatus.inprogress:
        return "Đang xử lý";
      case TaskStatus.done:
        return "Hoàn tất";
    }
  }

  // show cái dialog sửa
  void _showEditTaskDialog(BuildContext context, Task task) {
    final titleController = TextEditingController(text: task.title);
    final descriptionController = TextEditingController(text: task.description);
    DateTime selectedDate = task.datelineDate;
    String selectedColor = task.color;
    TaskPriority selectedPriority = task.priority;

    showDialog(
      context: context,
      builder:
          (context) => StatefulBuilder(
            builder:
                (context, setState) => AlertDialog(
                  title: const Text('Chỉnh sửa công việc'),
                  content: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
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
                          spacing: 8,
                          children: [
                            _colorChoice(
                              '0xFF2196F3',
                              selectedColor,
                              (color) => selectedColor = color,
                            ),
                            _colorChoice(
                              '0xFF4CAF50',
                              selectedColor,
                              (color) => selectedColor = color,
                            ),
                            _colorChoice(
                              '0xFFFFC107',
                              selectedColor,
                              (color) => selectedColor = color,
                            ),
                            _colorChoice(
                              '0xFFE91E63',
                              selectedColor,
                              (color) => selectedColor = color,
                            ),
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
                          context.read<TaskCubit>().updateTask(
                            taskId: task.id,
                            title: titleController.text,
                            description: descriptionController.text,
                            priority: selectedPriority,
                            color: selectedColor,
                            deadlineDate: selectedDate,
                          );
                          Navigator.pop(context);
                        }
                      },
                      child: const Text('Lưu'),
                    ),
                  ],
                ),
          ),
    );
  }
}
