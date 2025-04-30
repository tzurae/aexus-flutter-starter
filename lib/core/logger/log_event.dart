import 'enum/LogLevel.dart';

class LogEvent {
  final DateTime time;
  final LogLevel level;
  final String message;
  final dynamic error;
  final StackTrace? stackTrace;
  final Map<String, dynamic>? context;
  final String? tag;

  LogEvent({
    required this.time,
    required this.level,
    required this.message,
    this.error,
    this.stackTrace,
    this.context,
    this.tag,
  });
}
