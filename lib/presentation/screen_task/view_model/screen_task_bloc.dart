// ignore: depend_on_referenced_packages
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// ignore: depend_on_referenced_packages
import 'package:uuid/uuid.dart';
import '../../../data/task_store.dart';
import '../../../domain/entity_task.dart';
import 'screen_task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  final TaskStore taskStore;
  TaskCubit(this.taskStore) : super(TaskState(tasks: [])) {
    loadTasks();
  }

  // load dữ liệu
  Future<void> loadTasks() async {
    final loadedTasks = await taskStore.getTasks();
    emit(state.copyWith(tasks: loadedTasks));
  }

  // thêm 1 cái task
  Future<void> addTask({
    required String title,
    required String description,
    required TaskPriority priority,
    required String color,
    required DateTime deadlineDate,
  }) async {
    final newTask = Task(
      id: const Uuid().v4(),
      title: title,
      description: description,
      status: TaskStatus.newTask,
      priority: priority,
      color: color,
      createDate: DateTime.now(),
      datelineDate: deadlineDate,
    );

    final updated = [...state.tasks, newTask];
    emit(state.copyWith(tasks: updated));
    await taskStore.saveTasks(updated);
  }

  // cập nhật status
  Future<void> updateStatus(String taskId, TaskStatus newStatus) async {
    final updatedTasks =
        state.tasks.map((task) {
          if (task.id == taskId) {
            return task.copyWith(status: newStatus, editDate: DateTime.now());
          }
          return task;
        }).toList();

    emit(state.copyWith(tasks: updatedTasks));
    await taskStore.saveTasks(updatedTasks);
  }

  // xoa task
  Future<void> deleteTask(String taskId) async {
    final updatedTasks =
        state.tasks.where((task) => task.id != taskId).toList();
    emit(state.copyWith(tasks: updatedTasks));
    await taskStore.saveTasks(updatedTasks);
  }

  // tìm kiếm task
  Future<void> searchTask(String searchText) async {
    if (searchText.isEmpty) {
      emit(
        state.copyWith(
          tasks: await taskStore.getTasks(),
          searchText: searchText,
        ),
      );
      return;
    }

    final allTasks = await taskStore.getTasks(); // Lấy tất cả tasks từ storage
    final filteredTasks =
        allTasks.where((task) {
          return task.title.toLowerCase().contains(searchText.toLowerCase()) ||
              task.description.toLowerCase().contains(searchText.toLowerCase());
        }).toList();

    filteredTasks.sort((a, b) => b.priority.index.compareTo(a.priority.index));
    emit(state.copyWith(tasks: filteredTasks, searchText: searchText));
  }

  // sữa cái task
  Future<void> updateTask({
    required String taskId,
    String? title,
    String? description,
    TaskPriority? priority,
    String? color,
    DateTime? deadlineDate,
  }) async {
    final updatedTasks =
        state.tasks.map((task) {
          if (task.id == taskId) {
            return task.copyWith(
              title: title ?? task.title,
              description: description ?? task.description,
              priority: priority ?? task.priority,
              color: color ?? task.color,
              datelineDate: deadlineDate ?? task.datelineDate,
              editDate: DateTime.now(),
            );
          }
          return task;
        }).toList();

    emit(state.copyWith(tasks: updatedTasks));
    await taskStore.saveTasks(updatedTasks);
  }

  Future<DateTime?> selectDate(
    BuildContext context,
    DateTime initialDate,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    return picked;
  }

  void setSearchText(String text) {
    emit(state.copyWith(searchText: text));
  }

  // set lại cái trạng thái
  void setFilterStatus(TaskStatus? status) {
    emit(state.copyWith(filterStatus: status));
  }
}
