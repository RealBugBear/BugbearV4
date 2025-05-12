// lib/core/widgets/custom_button.dart

import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: const ButtonStyle(
        // WidgetStatePropertyAll statt MaterialStatePropertyAll
        shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        ),
        padding: WidgetStatePropertyAll<EdgeInsets>(
          EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        ),
        textStyle: WidgetStatePropertyAll<TextStyle>(
          TextStyle(fontSize: 16),
        ),
      ),
      child: Text(text),
    );
  }
}
