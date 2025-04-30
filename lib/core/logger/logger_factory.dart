import 'package:rizzlt_flutter_starter/core/logger/BaseLogger.dart';
import 'package:rizzlt_flutter_starter/core/logger/config.dart';
import 'package:rizzlt_flutter_starter/core/logger/interface/log_manager_interface.dart';
import 'package:rizzlt_flutter_starter/core/logger/interface/logger_factory_interface.dart';
import 'package:rizzlt_flutter_starter/core/logger/interface/logger_interface.dart';
import 'package:rizzlt_flutter_starter/core/logger/interface/output_interface.dart';
import 'package:rizzlt_flutter_starter/core/logger/log_manager.dart';

class LoggerFactory implements LoggerFactoryInterface {
  static final LoggerFactoryInterface _instance = LoggerFactory._internal();
  final LogManagerInterface _logManager = LogManager();

  LoggerFactory._internal();

  static LoggerFactoryInterface get instance => _instance;

  @override
  LoggerInterface getLogger(String module, [String? subModule]) {
    final tag = subModule != null ? '$module.$subModule' : module;
    return BaseLogger(_logManager, tag: tag);
  }

  @override
  LoggerInterface get logger => BaseLogger(_logManager, tag: 'APP');

  @override
  Future<void> init(LogConfig config) async {
    await _logManager.init(config);
  }

  @override
  Future<void> close() async {
    await _logManager.close();
  }

  @override
  void addOutput(LogOutput output) {
    _logManager.addOutput(output);
  }
}
