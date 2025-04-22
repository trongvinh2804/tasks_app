// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/presentation/screen/add_dailog.dart';
import 'package:todo_app/presentation/screen/customTextField.dart';
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
          title: Padding(
            padding: const EdgeInsets.only(left: 12),
            child: const Text(
              "TASK",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),

          bottom: TabBar(
            onTap: (index) {
              final status = TaskStatus.values[index];
              context.read<TaskCubit>().setfilterStatus(status);
            },
            tabs: [
              Tab(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.blue[100],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.new_releases),
                      SizedBox(width: 4),
                      Text("Mới"),
                    ],
                  ),
                ),
              ),
              Tab(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.orange[100],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.pending_actions),
                      SizedBox(width: 4),
                      Text("Đang"),
                    ],
                  ),
                ),
              ),
              Tab(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.green[100],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.task_alt),
                      SizedBox(width: 4),
                      Text("Hoàn tất"),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        body: Container(
          color: Colors.white70,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 24,
                  right: 24,
                  top: 12,
                  bottom: 12,
                ),
                child: CustomTextField(
                  controller: TextEditingController(),
                  label: 'Tìm kiếm...',
                  prefixIcon: Icon(Icons.search),
                  textCapitalization: TextCapitalization.sentences,
                  onChanged: (value) {
                    context.read<TaskCubit>().searchTask(value);
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
  showDialog(context: context, builder: (context) => const AddTaskDialog());
}
