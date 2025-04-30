import 'package:rizzlt_flutter_starter/core/logger/enum/LogLevel.dart';
import 'package:rizzlt_flutter_starter/core/logger/interface/log_manager_interface.dart';
import 'package:rizzlt_flutter_starter/core/logger/interface/logger_interface.dart';
import 'package:rizzlt_flutter_starter/core/logger/log_event.dart';

class BaseLogger implements LoggerInterface {
  final String? tag;
  final LogManagerInterface _logManager;

  BaseLogger(this._logManager, {this.tag});

  @override
  void log(
    LogLevel level,
    dynamic message, {
    dynamic error,
    StackTrace? stackTrace,
    Map<String, dynamic>? context,
  }) {
    final event = LogEvent(
      time: DateTime.now(),
      level: level,
      message: message.toString(),
      error: error,
      stackTrace: stackTrace,
      context: context,
      tag: tag,
    );

    _logManager.processLogEvent(event);
  }

  @override
  void d(dynamic message,
          {dynamic error,
          StackTrace? stackTrace,
          Map<String, dynamic>? context}) =>
      log(LogLevel.debug, message,
          error: error, stackTrace: stackTrace, context: context);

  @override
  void i(dynamic message,
          {dynamic error,
          StackTrace? stackTrace,
          Map<String, dynamic>? context}) =>
      log(LogLevel.info, message,
          error: error, stackTrace: stackTrace, context: context);

  @override
  void w(dynamic message,
          {dynamic error,
          StackTrace? stackTrace,
          Map<String, dynamic>? context}) =>
      log(LogLevel.warning, message,
          error: error, stackTrace: stackTrace, context: context);

  @override
  void e(dynamic message,
          {dynamic error,
          StackTrace? stackTrace,
          Map<String, dynamic>? context}) =>
      log(LogLevel.error, message,
          error: error, stackTrace: stackTrace, context: context);

  @override
  void f(dynamic message,
          {dynamic error,
          StackTrace? stackTrace,
          Map<String, dynamic>? context}) =>
      log(LogLevel.fatal, message,
          error: error, stackTrace: stackTrace, context: context);
}
