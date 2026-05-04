import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

class AppLogger {
  /// Log a message in debug mode only.
  static void log(String message, {String name = 'AppLogger'}) {
    if (kDebugMode) {
      developer.log(message, name: name);
    }
  }

  /// Log an error in debug mode only.
  static void error(String message,
      {Object? error, StackTrace? stackTrace, String name = 'AppLogger'}) {
    if (kDebugMode) {
      developer.log(message, name: name, error: error, stackTrace: stackTrace);
    }
  }
}
