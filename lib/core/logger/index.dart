import 'package:rizzlt_flutter_starter/core/logger/config.dart';
import 'package:rizzlt_flutter_starter/core/logger/interface/logger_interface.dart';
import 'package:rizzlt_flutter_starter/core/logger/interface/output_interface.dart';
import 'package:rizzlt_flutter_starter/core/logger/logger_factory.dart';

class Log {
  /// 獲取帶標籤的日誌器
  ///
  /// [module] 模組名稱，例如 'USER', 'NETWORK', 'DOMAIN'
  /// [subModule] 子模組名稱，可選
  static LoggerInterface getLogger(String module, [String? subModule]) {
    return LoggerFactory.instance.getLogger(module, subModule);
  }

  /// 獲取主日誌器
  static LoggerInterface get logger => LoggerFactory.instance.logger;

  /// 初始化日誌系統
  static Future<void> init(LogConfig config) async {
    await LoggerFactory.instance.init(config);
  }

  /// 關閉日誌系統
  static Future<void> close() async {
    await LoggerFactory.instance.close();
  }

  /// 添加自定義輸出
  static void addOutput(LogOutput output) {
    LoggerFactory.instance.addOutput(output);
  }
}
