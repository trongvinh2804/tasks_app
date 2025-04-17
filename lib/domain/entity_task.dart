enum TaskStatus { newtask, inprogress, done } // trạng thái của status

enum TaskPriority { low, medium, high } // định nghĩa mức độ ưu tiên

class Task {
  final String id;
  final String title;
  final String description;
  final TaskStatus status;
  final TaskPriority priority;
  final String color;
  final DateTime createDate;
  final DateTime datelineDate;
  final DateTime? editDate;

  // coonstructor
  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.priority,
    required this.color,
    required this.createDate,
    required this.datelineDate,
    this.editDate,
  });

  // dung bản sao khi update không thay đổi toàn bộ thuộc tính
  Task copyWith({
    String? id,
    String? title,
    String? description,
    TaskStatus? status,
    TaskPriority? priority,
    String? color,
    DateTime? createDate,
    DateTime? datelineDate,
    DateTime? editDate,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      color: color ?? this.color,
      createDate: createDate ?? this.createDate,
      datelineDate: datelineDate ?? this.datelineDate,
      editDate: editDate ?? this.editDate,
    );
  }

  // Task -> map để lưu
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'status': status.index, // chuyển thành index
      'priority': priority.index,
      'color': color,
      'createDate': createDate.toIso8601String(),
      'datelineDate':
          datelineDate.toIso8601String(), // datetime -> ISO08601 dạng string
      'editDate': editDate?.toIso8601String(),
    };
  }

  // đọc từ mapmap
  static Task fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      status: TaskStatus.values[map['status']], // index chuyẻn ngược lại
      priority: TaskPriority.values[map['priority']],
      color: map['color'],
      createDate: DateTime.parse(map['createDate']), // chuyển ngược lại
      datelineDate: DateTime.parse(map['datelineDate']),
      editDate:
          map['editDate'] != null ? DateTime.parse(map['editDate']) : null,
    );
  }
}
