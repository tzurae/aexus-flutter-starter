import 'package:applications/di/usecase.dart';

class ApplicationLayerInjection {
  static Future<void> configureApplicationLayerInjection() async {
    await UseCaseModule.configureUseCaseModuleInjection();
  }
}
