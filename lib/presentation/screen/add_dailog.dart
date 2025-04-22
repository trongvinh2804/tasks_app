import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/presentation/screen/color_choose.dart';
import 'package:todo_app/presentation/screen/customButton.dart';
import 'package:todo_app/presentation/screen/customTextField.dart';
import 'package:todo_app/presentation/screen/custom_dropdown.dart';
import '../../domain/entity_task.dart';
import '../cubit/task_bloc.dart';

class AddTaskDialog extends StatefulWidget {
  const AddTaskDialog({super.key});

  @override
  State<AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  String selectedColor = '0xFFBBDEFB';
  TaskPriority selectedPriority = TaskPriority.medium;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Thêm công việc mới'),
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
              spacing: 6,
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
          onPressed: () => Navigator.pop(context),
          text: 'Hủy',
          isPrimary: false,
          width: 80,
        ),
        CustomButton(onPressed: _handleAddTask, text: 'Thêm', width: 80),
      ],
    );
  }

  void _handleAddTask() {
    if (titleController.text.isNotEmpty) {
      context.read<TaskCubit>().addTask(
        title: titleController.text,
        description: descriptionController.text,
        priority: selectedPriority,
        color: selectedColor,
        deadlineDate: selectedDate,
      );
      Navigator.pop(context);
    }
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

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}
