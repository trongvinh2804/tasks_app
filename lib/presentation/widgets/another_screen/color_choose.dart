import 'package:flutter/material.dart';

class ColorChoice extends StatelessWidget {
  final String color;
  final String selectedColor;
  final Function(String) onColorSelected;

  const ColorChoice({
    super.key,
    required this.color,
    required this.selectedColor,
    required this.onColorSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onColorSelected(color),
      child: Container(
        width: 36,
        height: 36,
        margin: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Color(int.parse(color)),
          shape: BoxShape.circle,
          border: Border.all(
            color:
                color == selectedColor
                    ? Color.fromARGB(20, 60, 65, 65)
                    : Colors.transparent,
            width: 3,
          ),
        ),
      ),
    );
  }
}
