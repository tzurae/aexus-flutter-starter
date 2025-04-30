import 'package:presentation/di/module/navigation_module.dart';
import 'package:presentation/di/module/store_module.dart';

class PresentationLayerInjection {
  static Future<void> configurePresentationLayerInjection() async {
    await StoreModule.configureStoreModuleInjection();
    await NavigationModule.configureNavigationModuleInjection();
  }
}
