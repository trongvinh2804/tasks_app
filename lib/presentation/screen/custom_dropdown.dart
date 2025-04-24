import 'package:flutter/material.dart';
import '../../domain/entity_task.dart';

class CustomDropdown extends StatelessWidget {
  final TaskPriority value;
  final Function(TaskPriority?) onChanged;
  final String label;

  const CustomDropdown({
    super.key,
    required this.value,
    required this.onChanged,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<TaskPriority>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        contentPadding: const EdgeInsets.only(),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
      ),
      style: const TextStyle(fontSize: 14, color: Colors.black87),
      icon: const Icon(Icons.arrow_drop_down_circle_outlined),
      dropdownColor: Colors.white,
      elevation: 2,
      onChanged: onChanged,
      items:
          TaskPriority.values.map((priority) {
            return DropdownMenuItem<TaskPriority>(
              value: priority,
              child: Row(
                children: [
                  _buildPriorityIcon(priority),
                  const SizedBox(width: 8),
                  Text(_getPriorityText(priority)),
                ],
              ),
            );
          }).toList(),
    );
  }

  Widget _buildPriorityIcon(TaskPriority priority) {
    Color color;
    IconData icon;

    switch (priority) {
      case TaskPriority.high:
        color = Colors.red;
        icon = Icons.priority_high;
        break;
      case TaskPriority.medium:
        color = Colors.orange;
        icon = Icons.remove_circle_outline;
        break;
      case TaskPriority.low:
        color = Colors.green;
        icon = Icons.arrow_downward;
        break;
    }

    return Icon(icon, color: color, size: 18);
  }

  String _getPriorityText(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.high:
        return 'Cao';
      case TaskPriority.medium:
        return 'Trung bình';
      case TaskPriority.low:
        return 'Thấp';
    }
  }
}
