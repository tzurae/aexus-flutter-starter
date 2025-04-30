import 'dart:async';

import 'package:applications/usecase/auth/is_logged_in_usecase.dart';
import 'package:applications/usecase/auth/login_usecase.dart';
import 'package:applications/usecase/locale/get_locale_usecase.dart';
import 'package:applications/usecase/locale/set_locale_usecase.dart';
import 'package:applications/usecase/post/get_posts_usecase.dart';
import 'package:applications/usecase/theme/get_theme_usecase.dart';
import 'package:applications/usecase/theme/set_theme_usecase.dart';
import 'package:domains/auth/auth_repository.dart';
import 'package:domains/locale/locale_repository.dart';
import 'package:domains/post/post_repository.dart';
import 'package:domains/theme/theme_repository.dart';
import 'package:rizzlt_flutter_starter/di/service_locator.dart';

class UseCaseModule {
  static Future<void> configureUseCaseModuleInjection() async {
    // auth:--------------------------------------------------------------------
    getIt.registerSingleton<IsLoggedInUseCase>(
      IsLoggedInUseCase(getIt<AuthRepository>()),
    );
    getIt.registerSingleton<LoginUseCase>(
      LoginUseCase(getIt<AuthRepository>()),
    );

    // post:--------------------------------------------------------------------
    getIt.registerSingleton<GetPostsUseCase>(
      GetPostsUseCase(getIt<PostRepository>()),
    );
    // getIt.registerSingleton<FindPostByIdUseCase>(
    //   FindPostByIdUseCase(getIt<PostRepository>()),
    // );
    // getIt.registerSingleton<InsertPostUseCase>(
    //   InsertPostUseCase(getIt<PostRepository>()),
    // );
    // getIt.registerSingleton<UpdatePostUseCase>(
    //   UpdatePostUseCase(getIt<PostRepository>()),
    // );
    // getIt.registerSingleton<DeletePostUseCase>(
    //   DeletePostUseCase(getIt<PostRepository>()),
    // );

    // theme:-------------------------------------------------------------------
    getIt.registerSingleton<GetThemeUseCase>(
      GetThemeUseCase(getIt<ThemeRepository>()),
    );
    getIt.registerSingleton<SetThemeUseCase>(
      SetThemeUseCase(getIt<ThemeRepository>()),
    );

    // locale:------------------------------------------------------------------
    getIt.registerSingleton<GetLocaleUseCase>(
      GetLocaleUseCase(getIt<LocaleRepository>()),
    );
    getIt.registerSingleton<SetLocaleUseCase>(
      SetLocaleUseCase(getIt<LocaleRepository>()),
    );
  }
}
