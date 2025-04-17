import '../../domain/entity_task.dart';

class TaskState {
  final List<Task> tasks;
  final String searchText;
  final TaskStatus? filterStatus;

  // constructor
  TaskState({
    required this.tasks,
    this.searchText = '',
    this.filterStatus = TaskStatus.newtask,
  });

  List<Task> get filteredTasks {
    final filtered =
        tasks.where((task) {
          final matchesStatus =
              filterStatus == null || task.status == filterStatus;
          final matchesSearch =
              searchText.isEmpty ||
              task.title.toLowerCase().contains(searchText.toLowerCase()) ||
              task.description.toLowerCase().contains(searchText.toLowerCase());
          return matchesStatus && matchesSearch;
        }).toList();
    // sắp xếp
    filtered.sort((a, b) => b.priority.index.compareTo(a.priority.index));

    return filtered;
  }

  TaskState copyWith({
    List<Task>? tasks,
    String? searchText,
    TaskStatus? filterStatus,
  }) {
    return TaskState(
      tasks: tasks ?? this.tasks,
      searchText: searchText ?? this.searchText,
      filterStatus: filterStatus ?? this.filterStatus,
    );
  }
}
