import 'package:rizzlt_flutter_starter/core/logger/log_event.dart';

abstract class LogFormatter {
  String format(LogEvent event);
}
