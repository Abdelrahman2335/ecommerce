import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  const CustomIconButton(
      {super.key,
      required this.onPressed,
      required this.icon,
      required this.isInCart,
      required this.onBoolean,
      required this.onBooleanIcon,
      this.color});
  final VoidCallback? onPressed;
  final VoidCallback onBoolean;

  final Widget icon;
  final Widget onBooleanIcon;
  final bool isInCart;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: isInCart ? onBoolean : onPressed,
      icon: isInCart ? onBooleanIcon : icon,
      color: color,
    );
  }
}
