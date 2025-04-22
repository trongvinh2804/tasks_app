import 'package:flutter/material.dart';
import '../../domain/entity_task.dart';

class StatusUtils {
  static Color getStatusColor(TaskStatus status) {
    switch (status) {
      case TaskStatus.newtask:
        return Colors.black;
      case TaskStatus.inprogress:
        return Colors.orange;
      case TaskStatus.done:
        return Colors.indigo;
    }
  }

  static IconData getStatusIcon(TaskStatus status) {
    switch (status) {
      case TaskStatus.newtask:
        return Icons.new_releases;
      case TaskStatus.inprogress:
        return Icons.pending_actions;
      case TaskStatus.done:
        return Icons.task_alt;
    }
  }

  static String getStatusText(TaskStatus status) {
    switch (status) {
      case TaskStatus.newtask:
        return "Mới";
      case TaskStatus.inprogress:
        return "Đang xử lý";
      case TaskStatus.done:
        return "Hoàn tất";
    }
  }
}
