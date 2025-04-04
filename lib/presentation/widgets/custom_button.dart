import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final void Function()? pressed;
  final String text;
  final num? bottomWidth;
  final ButtonStyle? buttonStyle;

  const CustomButton({
    super.key,
    required this.pressed,
    required this.text,
    this.bottomWidth,
    this.buttonStyle,
  });

  @override
  Widget build(BuildContext context) {
    Size mediaQuery = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    num number = bottomWidth ?? 0.4;
    return Center(
      child: SizedBox(
        width: mediaQuery.width * number,
        child: ElevatedButton(
          style: buttonStyle ??
              ElevatedButton.styleFrom(
                overlayColor: const Color(0xFFFFE9E9),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(21),
                ),
                padding: const EdgeInsets.all(12),
                backgroundColor: theme.primaryColor,
              ),
          onPressed: pressed,
          child: Text(
            text,
            style: theme.textTheme.labelLarge,
          ),
        ),
      ),
    );
  }
}
