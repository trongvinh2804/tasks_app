import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/presentation/widgets/another_screen/color_choose.dart';
import 'package:todo_app/presentation/widgets/custom_screen/custom_Button.dart';
import 'package:todo_app/presentation/widgets/custom_screen/custom_TextField.dart';
import 'package:todo_app/presentation/widgets/custom_screen/custom_dropdown.dart';
import '../../../domain/entity_task.dart';
import '../../screen_task/view_model/screen_task_bloc.dart';

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
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Container(
        width: screenWidth * 0.9,
        constraints: BoxConstraints(maxHeight: screenHeight * 0.9),
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Thêm công việc mới',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(height: 16),
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
                    color: '0xFFFFF5F5',
                    selectedColor: selectedColor,
                    onColorSelected:
                        (color) => setState(() => selectedColor = color),
                  ),
                  ColorChoice(
                    color: '0xFFF1F8E9',
                    selectedColor: selectedColor,
                    onColorSelected:
                        (color) => setState(() => selectedColor = color),
                  ),
                  ColorChoice(
                    color: '0xFFFFFDE7',
                    selectedColor: selectedColor,
                    onColorSelected:
                        (color) => setState(() => selectedColor = color),
                  ),
                  ColorChoice(
                    color: '	0xFFFFF8E1',
                    selectedColor: selectedColor,
                    onColorSelected:
                        (color) => setState(() => selectedColor = color),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              CustomButton(
                text: "Thêm",
                onPressed: _handleAddTask,
                width: double.infinity,
              ),
            ],
          ),
        ),
      ),
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
