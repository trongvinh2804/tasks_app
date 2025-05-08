import 'package:flutter/material.dart';
import '../../../domain/entity_task.dart';

class StatusUtils {
  static Color getStatusColor(TaskStatus status) {
    switch (status) {
      case TaskStatus.newTask:
        return Colors.black;
      case TaskStatus.inProgress:
        return Colors.red;
      case TaskStatus.done:
        return Colors.blue;
    }
  }

  static IconData getStatusIcon(TaskStatus status) {
    switch (status) {
      case TaskStatus.newTask:
        return Icons.new_releases;
      case TaskStatus.inProgress:
        return Icons.pending_actions;
      case TaskStatus.done:
        return Icons.task_alt;
    }
  }

  static String getStatusText(TaskStatus status) {
    switch (status) {
      case TaskStatus.newTask:
        return "Mới";
      case TaskStatus.inProgress:
        return "Đang xử lý";
      case TaskStatus.done:
        return "Hoàn tất";
    }
  }
}
