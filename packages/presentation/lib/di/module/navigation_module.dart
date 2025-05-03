import 'package:presentation/foundation/navigation/app_router.dart';
import 'package:presentation/foundation/navigation/navigation_service.dart';
import 'package:rizzlt_flutter_starter/di/service_locator.dart';

class NavigationModule {
  static Future<void> configureNavigationModuleInjection() async {
    getIt.registerLazySingleton<NavigationService>(
        () => NavigationService(AppRouter.router));
  }
}
