import 'package:rizzlt_flutter_starter/constants/enums/env_enum.dart';
import 'package:rizzlt_flutter_starter/core/bootstrap/app_config_service.dart';
import 'package:rizzlt_flutter_starter/core/logger/config.dart';
import 'package:rizzlt_flutter_starter/core/logger/index.dart';

class LoggerBootstrap {
  static late final LoggerBootstrap _instance = LoggerBootstrap._internal();
  static LoggerBootstrap get instance => _instance;
  final AppConfigService _appConfigService;
  bool _initialized = false;
  LoggerBootstrap._internal() : _appConfigService = AppConfigService.instance;

  Future<void> init() async {
    if (_initialized) return;
    final LogConfig config = _getConfigForEnv();
    await Log.init(config);
    await _configOutputs();
    _initialized = true;
    Log.logger.i(
        'Logging system initialization completed, environment: ${_appConfigService.env} ');
  }

  LogConfig _getConfigForEnv() {
    switch (_appConfigService.env) {
      case EnvEnum.development:
        return LogConfig.development;
      case EnvEnum.test:
        return LogConfig.test;
      case EnvEnum.production:
        return LogConfig.production;
      default:
        return LogConfig.development;
    }
  }

  _configOutputs() {
    final env = _appConfigService.environment;

    // Add different outputs based on environment
    if (env == EnvEnum.production) {
      // Production environment configuration
      if (_appConfigService.enableCrashReporting) {
        // Log.addOutput(CrashlyticsOutput());
      }

      // If remote logging service is configured
      // if (_appConfigService.remoteLoggingEndpoint.isNotEmpty) {
      //   Log.addOutput(NetworkOutput(
      //     endpoint: _appConfigService.remoteLoggingEndpoint,
      //   ));
      // }
    } else if (env == EnvEnum.development) {
      // Development environment configuration
      // if (!kIsWeb) {
      //   // Non-Web platform
      //   Log.addOutput(DatabaseOutput(maxEntries: 5000));
      // }

      // Development environment may need more detailed console output
      // Log.addOutput(ConsoleLogOutput());
    }

    // Test environment configuration
    if (env == EnvEnum.test) {
      // Test environment may need special test outputs
      // Log.addOutput(TestLogOutput());
    }

    // Common configuration: if analytics is enabled
    if (_appConfigService.enableAnalytics) {
      // Log.addOutput(AnalyticsOutput());
    }
  }

  Future<void> close() async {
    if (!_initialized) return;
    await Log.close();
    _initialized = true;
  }
}
