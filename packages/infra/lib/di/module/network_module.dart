import 'package:event_bus/event_bus.dart';
import 'package:infra/clients/dio/dio_client.dart';
import 'package:infra/clients/dio/dio_configs.dart';
import 'package:infra/clients/dio/interceptors/auth_interceptor.dart';
import 'package:infra/clients/dio/interceptors/logging_interceptor.dart';
import 'package:infra/clients/supabase/supabase_client.dart';
import 'package:infra/datasources/local/interfaces/auth_local_datasource.dart';
import 'package:infra/datasources/remote/constants/endpoints.dart';
import 'package:infra/datasources/remote/impl/auth_remote_datasource_impl.dart';
import 'package:infra/datasources/remote/impl/post_remote_datasource_impl.dart';
import 'package:infra/datasources/remote/interfaces/auth_remote_datasource.dart';
import 'package:infra/datasources/remote/interfaces/post_remote_datasource.dart';
import 'package:rizzlt_flutter_starter/di/service_locator.dart';

class NetworkModule {
  static Future<void> configureNetworkModuleInjection() async {
    // event bus:---------------------------------------------------------------
    getIt.registerSingleton<EventBus>(EventBus());

    // interceptors:------------------------------------------------------------
    getIt.registerSingleton<LoggingInterceptor>(LoggingInterceptor());
    getIt.registerSingleton<AuthInterceptor>(
      AuthInterceptor(
        accessToken: () async =>
            await getIt<AuthLocalDataSource>().getAuthToken(),
      ),
    );

    // dio:---------------------------------------------------------------------
    getIt.registerSingleton<DioConfigs>(
      const DioConfigs(
        baseUrl: Endpoints.baseUrl,
        connectionTimeout: Endpoints.connectionTimeout,
        receiveTimeout: Endpoints.receiveTimeout,
      ),
    );
    getIt.registerSingleton<DioClient>(
      DioClient(dioConfigs: getIt())
        ..addInterceptors(
          [
            getIt<AuthInterceptor>(),
            getIt<LoggingInterceptor>(),
          ],
        ),
    );
    // supabase:------------------------------------------
    getIt.registerSingleton<SupabaseClientWrapper>(SupabaseClientWrapper());

    getIt.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(getIt<SupabaseClientWrapper>()),
    );

    getIt.registerLazySingleton<PostRemoteDataSource>(
      () => PostRemoteDataSourceImpl(getIt<DioClient>()),
    );
  }
}
