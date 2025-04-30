import 'package:intl/intl.dart';
import 'package:rizzlt_flutter_starter/core/logger/enum/LogLevel.dart';
import 'package:rizzlt_flutter_starter/core/logger/interface/log_formatter_interface.dart';
import 'package:rizzlt_flutter_starter/core/logger/log_event.dart';

class ConsoleFormatter implements LogFormatter {
  final bool enableColors;
  final bool printTime;
  final DateFormat _timeFormat = DateFormat('HH:mm:ss.SSS');

  ConsoleFormatter({
    this.enableColors = true,
    this.printTime = true,
  });

  @override
  String format(LogEvent event) {
    final buffer = StringBuffer();

    // 添加時間
    if (printTime) {
      buffer.write('[${_timeFormat.format(event.time)}] ');
    }

    // 添加日誌級別
    buffer.write('${_getLevelEmoji(event.level)} ');
    buffer.write('${_getLevelString(event.level)}: ');

    // 添加標籤
    if (event.tag != null) {
      buffer.write('[${event.tag}] ');
    }

    // 添加消息
    buffer.write(event.message);

    // 添加上下文
    if (event.context != null && event.context!.isNotEmpty) {
      buffer.write(' - Context: ${event.context}');
    }

    // 添加錯誤和堆疊跟踪
    if (event.error != null) {
      buffer.write('\nError: ${event.error}');

      if (event.stackTrace != null) {
        buffer.write('\n${event.stackTrace}');
      }
    }

    return buffer.toString();
  }

  String _getLevelString(LogLevel level) {
    switch (level) {
      case LogLevel.trace:
        return enableColors ? '\x1B[37mTRACE\x1B[0m' : 'TRACE';
      case LogLevel.debug:
        return enableColors ? '\x1B[34mDEBUG\x1B[0m' : 'DEBUG';
      case LogLevel.info:
        return enableColors ? '\x1B[32mINFO\x1B[0m' : 'INFO';
      case LogLevel.warning:
        return enableColors ? '\x1B[33mWARN\x1B[0m' : 'WARN';
      case LogLevel.error:
        return enableColors ? '\x1B[31mERROR\x1B[0m' : 'ERROR';
      case LogLevel.fatal:
        return enableColors ? '\x1B[35mFATAL\x1B[0m' : 'FATAL';
      default:
        return 'UNKNOWN';
    }
  }

  String _getLevelEmoji(LogLevel level) {
    switch (level) {
      case LogLevel.trace:
        return '🔍';
      case LogLevel.debug:
        return '🐛';
      case LogLevel.info:
        return 'ℹ️';
      case LogLevel.warning:
        return '⚠️';
      case LogLevel.error:
        return '❌';
      case LogLevel.fatal:
        return '💀';
      default:
        return '❓';
    }
  }
}
