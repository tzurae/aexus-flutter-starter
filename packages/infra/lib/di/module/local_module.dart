import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:infra/datasources/local/constants/db_constants.dart';
import 'package:infra/datasources/local/impl/auth_local_datasource_impl.dart';
import 'package:infra/datasources/local/impl/locale_local_datasource_impl.dart';
import 'package:infra/datasources/local/impl/theme_local_datasource_impl.dart';
import 'package:infra/datasources/local/interfaces/auth_local_datasource.dart';
import 'package:infra/datasources/local/interfaces/locale_local_datasource.dart';
import 'package:infra/datasources/local/interfaces/theme_local_datasource.dart';
import 'package:infra/datasources/local/sembast/sembast_client.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rizzlt_flutter_starter/di/service_locator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalModule {
  static Future<void> configureLocalModuleInjection() async {
    // preference manager:------------------------------------------------------
    // Register SharedPreferences first
    getIt.registerSingletonAsync<SharedPreferences>(
        SharedPreferences.getInstance);
    // Ensure SharedPreferences is ready before registering dependents
    await getIt.isReady<SharedPreferences>();

    // Remove SharedPreferenceHelper registration
    // getIt.registerSingleton<SharedPreferenceHelper>(
    //   SharedPreferenceHelper(await getIt.getAsync<SharedPreferences>()),
    // );

    // Register Local Data Sources
    getIt.registerLazySingleton<AuthLocalDataSource>(
      () => AuthLocalDataSourceImpl(getIt<SharedPreferences>()),
    );
    getIt.registerLazySingleton<ThemeLocalDataSource>(
      () => ThemeLocalDataSourceImpl(getIt<SharedPreferences>()),
    );
    getIt.registerLazySingleton<LocaleLocalDataSource>(
      () => LocaleLocalDataSourceImpl(getIt<SharedPreferences>()),
    );

    // database:----------------------------------------------------------------

    getIt.registerSingletonAsync<SembastClient>(
      () async => SembastClient.provideDatabase(
        databaseName: DBConstants.DB_NAME,
        databasePath: kIsWeb
            ? "/assets/db"
            : (await getApplicationDocumentsDirectory()).path,
      ),
    );

    // data sources:------------------------------------------------------------
    // getIt.registerSingleton(
    //     PostDataSource(await getIt.getAsync<SembastClient>()));
  }
}
