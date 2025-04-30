import 'package:rizzlt_flutter_starter/core/logger/formatter/console_formatter.dart';
import 'package:rizzlt_flutter_starter/core/logger/interface/output_interface.dart';
import 'package:rizzlt_flutter_starter/core/logger/log_event.dart';

class ConsoleLogOutput extends LogOutput {
  final ConsoleFormatter _consoleFormatter;

  ConsoleLogOutput({required ConsoleFormatter consoleFormatter})
      : _consoleFormatter = consoleFormatter;

  @override
  Future<void> close() async {}

  @override
  Future<void> init() async {}

  @override
  Future<void> output(LogEvent event) async {
    final formattedMessage = _consoleFormatter.format(event);
    print(formattedMessage);
  }
}
