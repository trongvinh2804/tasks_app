import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/presentation/screen/color_choose.dart';
import 'package:todo_app/presentation/screen/customButton.dart';
import 'package:todo_app/presentation/screen/customTextField.dart';
import 'package:todo_app/presentation/screen/custom_dropdown.dart';
import '../../domain/entity_task.dart';
import '../cubit/task_bloc.dart';

class EditTaskDialog extends StatefulWidget {
  final Task task;

  const EditTaskDialog({super.key, required this.task});

  @override
  State<EditTaskDialog> createState() => _EditTaskDialogState();
}

class _EditTaskDialogState extends State<EditTaskDialog> {
  late final TextEditingController titleController;
  late final TextEditingController descriptionController;
  late DateTime selectedDate;
  late String selectedColor;
  late TaskPriority selectedPriority;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.task.title);
    descriptionController = TextEditingController(
      text: widget.task.description,
    );
    selectedDate = widget.task.datelineDate;
    selectedColor = widget.task.color;
    selectedPriority = widget.task.priority;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: const Text('Chỉnh sửa công việc'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextField(
              controller: titleController,
              label: 'Tiêu đề',
              autoFocus: true,
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 8),
            CustomTextField(
              controller: descriptionController,
              label: 'Mô tả',
              maxLines: 3,
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 8),
            const SizedBox(height: 8),
            CustomDropdown(
              value: selectedPriority,
              label: 'Độ ưu tiên',
              onChanged: (value) {
                if (value != null) {
                  setState(() => selectedPriority = value);
                }
              },
            ),
            const SizedBox(height: 8),
            ListTile(
              title: const Text('Chọn deadline'),
              subtitle: Text(
                '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => _selectDate(context),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                ColorChoice(
                  color: '0xFFBBDEFB',
                  selectedColor: selectedColor,
                  onColorSelected:
                      (color) => setState(() => selectedColor = color),
                ),
                ColorChoice(
                  color: '0xFFC8E6C9',
                  selectedColor: selectedColor,
                  onColorSelected:
                      (color) => setState(() => selectedColor = color),
                ),
                ColorChoice(
                  color: '0xFFFFF9C4',
                  selectedColor: selectedColor,
                  onColorSelected:
                      (color) => setState(() => selectedColor = color),
                ),
                ColorChoice(
                  color: '0xFFF8BBD0',
                  selectedColor: selectedColor,
                  onColorSelected:
                      (color) => setState(() => selectedColor = color),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        CustomButton(
          onPressed: _handleEditTask,
          text: 'Lưu',
          width: double.infinity,
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await context.read<TaskCubit>().selectDate(
      context,
      selectedDate,
    );
    if (picked != null) {
      setState(() => selectedDate = picked);
    }
  }

  void _handleEditTask() {
    if (titleController.text.isNotEmpty) {
      context.read<TaskCubit>().updateTask(
        taskId: widget.task.id,
        title: titleController.text,
        description: descriptionController.text,
        priority: selectedPriority,
        color: selectedColor,
        deadlineDate: selectedDate,
      );
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}
