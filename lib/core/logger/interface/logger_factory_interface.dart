import 'package:rizzlt_flutter_starter/core/logger/config.dart';
import 'package:rizzlt_flutter_starter/core/logger/interface/logger_interface.dart';
import 'package:rizzlt_flutter_starter/core/logger/interface/output_interface.dart';

abstract class LoggerFactoryInterface {
  /// 獲取帶標籤的日誌器
  LoggerInterface getLogger(String module, [String? subModule]);

  /// 獲取Default Logger
  LoggerInterface get logger;

  /// 初始化日誌系統
  Future<void> init(LogConfig config);

  /// 關閉日誌系統
  Future<void> close();

  /// 添加自定義輸出
  void addOutput(LogOutput output);
}
