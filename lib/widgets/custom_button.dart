import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final void Function()? pressed;
  final String text;

  const CustomButton({
    super.key,
    required this.pressed,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        overlayColor: const Color(0xFFFFE9E9),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(12),
        backgroundColor: theme.primaryColor,
      ),
      onPressed: pressed,
      child: Center(
        child: Text(
          text,
          style: theme.textTheme.labelLarge,
        ),
      ),
    );
  }
}
