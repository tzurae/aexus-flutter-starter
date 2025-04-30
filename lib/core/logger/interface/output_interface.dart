import 'package:rizzlt_flutter_starter/core/logger/log_event.dart';

abstract class LogOutput {
  Future<void> init();
  Future<void> output(LogEvent event);
  Future<void> close();
}
