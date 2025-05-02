import 'dart:async';

import 'package:domains/auth/auth_repository.dart';
import 'package:domains/locale/locale_repository.dart';
import 'package:domains/post/post_repository.dart';
import 'package:domains/setting/setting_repository.dart';
import 'package:domains/theme/theme_repository.dart';
import 'package:infra/adapters/repository/auth/auth_repository_impl.dart';
import 'package:infra/adapters/repository/locale/locale_repository_impl.dart';
import 'package:infra/adapters/repository/post/post_repository_impl.dart';
import 'package:infra/adapters/repository/setting/setting_repository_impl.dart';
import 'package:infra/adapters/repository/theme/theme_repository_impl.dart';
import 'package:infra/datasources/local/interfaces/auth_local_datasource.dart';
import 'package:infra/datasources/local/interfaces/locale_local_datasource.dart';
import 'package:infra/datasources/local/interfaces/theme_local_datasource.dart';
import 'package:infra/datasources/remote/interfaces/auth_remote_datasource.dart';
import 'package:infra/datasources/remote/interfaces/post_remote_datasource.dart';
import 'package:rizzlt_flutter_starter/di/service_locator.dart';

class RepositoryModule {
  static Future<void> configureRepositoryModuleInjection() async {
    // repository:--------------------------------------------------------------
    getIt.registerSingleton<SettingRepository>(SettingRepositoryImpl(
      getIt<ThemeLocalDataSource>(),
      getIt<LocaleLocalDataSource>(),
    ));

    getIt.registerSingleton<ThemeRepository>(ThemeRepositoryImpl(
      getIt<ThemeLocalDataSource>(),
    ));

    getIt.registerSingleton<LocaleRepository>(LocaleRepositoryImpl(
      getIt<LocaleLocalDataSource>(),
    ));

    getIt.registerSingleton<AuthRepository>(AuthRepositoryImpl(
      getIt<AuthRemoteDataSource>(),
      getIt<AuthLocalDataSource>(),
    ));

    getIt.registerSingleton<PostRepository>(PostRepositoryImpl(
      getIt<PostRemoteDataSource>(),
    ));
  }
}
