import 'dart:async';

import 'package:rizzlt_flutter_starter/core/logger/config.dart';
import 'package:rizzlt_flutter_starter/core/logger/enum/LogLevel.dart';
import 'package:rizzlt_flutter_starter/core/logger/formatter/console_formatter.dart';
import 'package:rizzlt_flutter_starter/core/logger/interface/log_manager_interface.dart';
import 'package:rizzlt_flutter_starter/core/logger/interface/output_interface.dart';
import 'package:rizzlt_flutter_starter/core/logger/log_event.dart';
import 'package:rizzlt_flutter_starter/core/logger/outputs/console_output.dart';

class LogManager implements LogManagerInterface {
  final List<LogOutput> _outputs = [];
  LogConfig _config = LogConfig.development;

  // 使用 StreamController 處理日誌事件
  final StreamController<LogEvent> _logEventController =
      StreamController<LogEvent>.broadcast();

  LogManager() {
    _logEventController.stream.listen(_handleLogEvent);
  }

  @override
  Future<void> init(LogConfig config) async {
    _config = config;

    // 清除現有輸出
    await close();
    _outputs.clear();

    // 根據配置添加輸出
    if (config.enableConsole) {
      _outputs.add(ConsoleLogOutput(
        consoleFormatter: ConsoleFormatter(),
      ));
    }

    // if (config.writeToFile) {
    //   _outputs.add(FileLogOutput(
    //     fileName: config.fileName,
    //     maxFileSize: config.maxFileSize,
    //     maxHistoryFiles: config.maxHistoryFiles,
    //   ));
    // }

    // 初始化所有輸出
    for (var output in _outputs) {
      await output.init();
    }
  }

  @override
  void processLogEvent(LogEvent event) {
    if (_shouldLog(event.level)) {
      _logEventController.add(event);
    }
  }

  Future<void> _handleLogEvent(LogEvent event) async {
    for (var output in _outputs) {
      await output.output(event);
    }
  }

  bool _shouldLog(LogLevel level) {
    return level.index >= _config.level.index;
  }

  @override
  Future<void> close() async {
    for (var output in _outputs) {
      await output.close();
    }
  }

  @override
  void addOutput(LogOutput output) {
    _outputs.add(output);
    output.init();
  }

  @override
  void removeOutput(LogOutput output) {
    _outputs.remove(output);
    output.close();
  }
}
