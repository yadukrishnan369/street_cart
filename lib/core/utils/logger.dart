import 'package:flutter/foundation.dart';
import 'dart:developer' as developer;

class AppLogger {
  /// Simple wrapper for deep developer logs
  static void log(
    String message, {
    String name = 'StreetCartLog',
    dynamic error,
  }) {
    if (kDebugMode) {
      developer.log(message, name: name, error: error);
    }
  }

  /// Print simple info
  static void info(String message) {
    if (kDebugMode) {
      debugPrint('INFO: $message');
    }
  }

  /// Print warning
  static void warn(String message) {
    if (kDebugMode) {
      debugPrint('WARN: $message');
    }
  }

  /// Print error with stack traces
  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      debugPrint('ERROR: $message');
      if (error != null) debugPrint('Exception: $error');
      if (stackTrace != null) debugPrint('StackTrace: $stackTrace');
    }
  }
}
