// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/presentation/screen/dailog/add_dailog.dart';
import 'package:todo_app/presentation/screen/custom_screen/customTextField.dart';
import 'package:todo_app/presentation/screen/task_screen/done_task.dart';
import 'package:todo_app/presentation/screen/task_screen/in_progress.dart';
import 'package:todo_app/presentation/screen/task_screen/new_task.dart';
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
            padding: const EdgeInsets.only(left: 8),
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
                  padding: EdgeInsets.only(top: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.new_releases, size: 18),
                      Align(
                        child: Text(
                          "Mới",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Tab(
                child: Container(
                  padding: EdgeInsets.only(top: 4),
                  decoration: BoxDecoration(
                    color: Colors.orange[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.pending_actions, size: 18),
                      Align(
                        child: Text(
                          "Đang xử lý",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Tab(
                child: Container(
                  padding: EdgeInsets.only(top: 4),
                  decoration: BoxDecoration(
                    color: Colors.green[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.done, size: 18),
                      Align(
                        child: Text(
                          "Hoàn tất",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ),
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
                  left: 16,
                  right: 16,
                  top: 12,
                  bottom: 36,
                ),
                child: CustomTextField(
                  controller: TextEditingController(),
                  label: 'Tìm kiếm...',
                  prefixIcon: Icon(Icons.search),
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
