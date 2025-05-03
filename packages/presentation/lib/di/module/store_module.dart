import 'dart:async';

import 'package:applications/applications.dart';
import 'package:applications/usecase/locale/get_locale_usecase.dart';
import 'package:applications/usecase/locale/set_locale_usecase.dart';
import 'package:applications/usecase/theme/get_theme_usecase.dart';
import 'package:applications/usecase/theme/set_theme_usecase.dart';
import 'package:presentation/features/auth/store/auth_store.dart';
import 'package:presentation/features/language/language_store.dart';
import 'package:presentation/features/post/store/post_store.dart';
import 'package:presentation/features/theme/theme_store.dart';
import 'package:presentation/foundation/services/api_handler_service.dart';
import 'package:presentation/foundation/store/error/global_error_store.dart';
import 'package:presentation/foundation/store/form/form_store.dart';
import 'package:rizzlt_flutter_starter/core/logger/interface/logger_interface.dart';
import 'package:rizzlt_flutter_starter/di/service_locator.dart';

class StoreModule {
  static Future<void> configureStoreModuleInjection() async {
    getIt.registerSingleton<GlobalErrorStore>(GlobalErrorStore());
    getIt.registerSingleton<ApiHandlerService>(ApiHandlerService(
      getIt<LoggerInterface>(),
      getIt<GlobalErrorStore>(),
    ));

    getIt.registerSingleton<AuthStore>(
      AuthStore(
        getIt<ApiHandlerService>(),
        getIt<LoginUseCase>(),
        getIt<IsLoggedInUseCase>(),
      ),
    );

    getIt.registerSingleton<PostListStore>(
      PostListStore(
        getIt<GetPostsUseCase>(),
      ),
    );

    getIt.registerSingleton<ThemeStore>(
      ThemeStore(
        getIt<ApiHandlerService>(),
        getIt<GetThemeUseCase>(),
        getIt<SetThemeUseCase>(),
      ),
    );

    getIt.registerSingleton<LanguageStore>(
      LanguageStore(
        getIt<ApiHandlerService>(),
        getIt<GetLocaleUseCase>(),
        getIt<SetLocaleUseCase>(),
      ),
    );

    getIt.registerSingleton<MyFormStore>(MyFormStore());
  }
}
