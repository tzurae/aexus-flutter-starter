import '../enum/LogLevel.dart';

// 創建日誌
abstract class LoggerInterface {
  void log(
    LogLevel level,
    dynamic message, {
    dynamic error,
    StackTrace? stackTrace,
    Map<String, dynamic>? context,
  });

  void d(dynamic message,
          {dynamic error,
          StackTrace? stackTrace,
          Map<String, dynamic>? context}) =>
      log(LogLevel.debug, message,
          error: error, stackTrace: stackTrace, context: context);
  void e(dynamic message,
          {dynamic error,
          StackTrace? stackTrace,
          Map<String, dynamic>? context}) =>
      log(LogLevel.error, message,
          error: error, stackTrace: stackTrace, context: context);
  void i(dynamic message,
          {dynamic error,
          StackTrace? stackTrace,
          Map<String, dynamic>? context}) =>
      log(LogLevel.info, message,
          error: error, stackTrace: stackTrace, context: context);
  void w(dynamic message,
          {dynamic error,
          StackTrace? stackTrace,
          Map<String, dynamic>? context}) =>
      log(LogLevel.warning, message,
          error: error, stackTrace: stackTrace, context: context);
  void f(dynamic message,
          {dynamic error,
          StackTrace? stackTrace,
          Map<String, dynamic>? context}) =>
      log(LogLevel.fatal, message,
          error: error, stackTrace: stackTrace, context: context);
}
