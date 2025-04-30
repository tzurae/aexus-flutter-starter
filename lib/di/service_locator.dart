import 'package:applications/applications.dart';
import 'package:get_it/get_it.dart';
import 'package:infra/di/data_layer_injection.dart';
import 'package:presentation/di/presentation_layer_injection.dart';
import 'package:rizzlt_flutter_starter/core/logger/index.dart';
import 'package:rizzlt_flutter_starter/core/logger/interface/logger_interface.dart';

final getIt = GetIt.instance;

class ServiceLocator {
  static Future<void> configureDependencies() async {
    // 1. core components injection
    _registerCoreComponents();

    // 2. layers injection
    await DataLayerInjection.configureDataLayerInjection();
    await ApplicationLayerInjection.configureApplicationLayerInjection();
    await PresentationLayerInjection.configurePresentationLayerInjection();
  }

  static void _registerCoreComponents() {
    getIt.registerSingleton<LoggerInterface>(Log.logger);
  }
}
