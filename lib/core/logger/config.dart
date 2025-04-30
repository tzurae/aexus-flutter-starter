import 'package:rizzlt_flutter_starter/core/logger/enum/LogLevel.dart';

class LogConfig {
  final LogLevel level;
  final bool enableColors;
  final bool enableConsole;
  final bool writeToFile;
  final bool printTime;
  final bool sendToRemote;
  final String fileName;
  final int maxFileSize;
  final int maxHistoryFiles;

  const LogConfig({
    this.level = LogLevel.debug,
    this.enableColors = true,
    this.enableConsole = true,
    this.printTime = true,
    this.writeToFile = false,
    this.sendToRemote = false,
    this.fileName = 'app_logs',
    this.maxFileSize = 1024 * 1024 * 10, // 10MB
    this.maxHistoryFiles = 5,
  });

  /// 開發環境配置
  static const development = LogConfig(
    level: LogLevel.debug,
    enableColors: true,
    enableConsole: true,
    printTime: true,
    writeToFile: true,
    sendToRemote: false,
  );

  /// 生產環境配置
  static const production = LogConfig(
    level: LogLevel.warning,
    enableColors: false,
    enableConsole: false,
    printTime: true,
    writeToFile: true,
    sendToRemote: true,
  );

  /// 測試環境配置
  static const test = LogConfig(
    level: LogLevel.info,
    enableColors: true,
    enableConsole: true,
    printTime: true,
    writeToFile: false,
    sendToRemote: false,
  );
}
