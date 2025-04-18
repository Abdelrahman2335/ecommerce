import 'package:flutter/material.dart';
import 'package:ecommerce/core/constants/global_keys.dart';

class SnackBarHelper {
  static void show({
    required String message,
    Duration duration = const Duration(seconds: 2),
  }) {

    /// Important to know that we are using Scaffold global Key
    /// This allow us to don't use context + make the work more easy and effectuation.

    final messenger = AppKeys.scaffoldMessengerKey.currentState;
    messenger?.clearSnackBars();
    messenger?.showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}
