// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/presentation/widgets/dialog/add_dialog.dart';
import 'package:todo_app/presentation/widgets/custom_screen/custom_TextField.dart';
import 'package:todo_app/presentation/screen_task/task_screen/screen_task_done.dart';
import 'package:todo_app/presentation/screen_task/task_screen/screen_task_in_progress.dart';
import 'package:todo_app/presentation/screen_task/task_screen/screen_task_new.dart';
import '../../domain/entity_task.dart';
import 'view_model/screen_task_bloc.dart';

class TaskScreen extends StatelessWidget {
  const TaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "TASK",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          bottom: TabBar(
            onTap: (index) {
              final status = TaskStatus.values[index];
              context.read<TaskCubit>().setFilterStatus(status);
            },
            indicatorColor: Colors.blue,
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(
                child: Container(
                  padding: EdgeInsets.only(top: 4),
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
        body: SafeArea(
          child: Container(
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
