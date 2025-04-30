import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:infra/clients/supabase/supabase_client.dart';
import 'package:rizzlt_flutter_starter/core/bootstrap/app_config_service.dart';
import 'package:rizzlt_flutter_starter/core/bootstrap/logger/logger_bootstrap.dart';
import 'package:rizzlt_flutter_starter/di/service_locator.dart';

class AppBootstrap {
  static final AppBootstrap _instance = AppBootstrap._internal();
  static AppBootstrap get instance => _instance;
  AppBootstrap._internal();

  Future<void> initialize() async {
    // 1. infra
    await WidgetsFlutterBinding.ensureInitialized();
    await _setPreferredOrientations();
    await SupabaseClientWrapper.initialize();

    // 2. config
    await AppConfigService.instance.init();

    // 3. log
    await LoggerBootstrap.instance.init();

    // 4. layers
    await ServiceLocator.configureDependencies();
  }

  Future<void> _setPreferredOrientations() async {
    return SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }
}
