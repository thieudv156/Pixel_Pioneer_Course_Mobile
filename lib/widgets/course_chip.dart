import 'package:flutter/material.dart';

class CourseChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const CourseChip({
    super.key,
    required this.label,
    required this.onTap, Color? backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      label: Text(label),
      onPressed: onTap,
      backgroundColor: Colors.purple[70],
      labelStyle: const TextStyle(color: Colors.purple),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: const BorderSide(color: Colors.purple),
      ),
    );
  }
}
