import 'package:rizzlt_flutter_starter/core/logger/config.dart';
import 'package:rizzlt_flutter_starter/core/logger/interface/output_interface.dart';
import 'package:rizzlt_flutter_starter/core/logger/log_event.dart';

// 負責管理輸出, 處理日誌事件
abstract class LogManagerInterface {
  Future<void> init(LogConfig config);
  void processLogEvent(LogEvent event);
  Future<void> close();
  void addOutput(LogOutput output);
  void removeOutput(LogOutput output);
}
