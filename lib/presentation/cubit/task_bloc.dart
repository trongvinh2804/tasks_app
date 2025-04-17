// ignore: depend_on_referenced_packages
import 'package:flutter_bloc/flutter_bloc.dart';
// ignore: depend_on_referenced_packages
import 'package:uuid/uuid.dart';
import '../../data/task_store.dart';
import '../../domain/entity_task.dart';
import 'task_state.dart';

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
    final newtask = Task(
      id: const Uuid().v4(),
      title: title,
      description: description,
      status: TaskStatus.newtask,
      priority: priority,
      color: color,
      createDate: DateTime.now(),
      datelineDate: deadlineDate,
    );

    final updated = [...state.tasks, newtask];
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

  void setSearchText(String text) {
    emit(state.copyWith(searchText: text));
  }

  // set lại cái trạng thái
  void setfilterStatus(TaskStatus? status) {
    emit(state.copyWith(filterStatus: status));
  }
}
