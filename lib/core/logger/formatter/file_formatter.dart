import 'package:intl/intl.dart';
import 'package:rizzlt_flutter_starter/core/logger/interface/log_formatter_interface.dart';
import 'package:rizzlt_flutter_starter/core/logger/log_event.dart';

class FileFormatter implements LogFormatter {
  final DateFormat _timeFormat = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');

  @override
  String format(LogEvent event) {
    final buffer = StringBuffer();

    // 添加時間
    buffer.write('${_timeFormat.format(event.time)} ');

    // 添加日誌級別
    buffer.write('[${event.level.toString().split('.').last.toUpperCase()}] ');

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
}
