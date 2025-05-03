import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:presentation/features/language/language_state.dart';
import 'package:presentation/features/language/language_store.dart';
import 'package:presentation/features/theme/theme_state.dart';
import 'package:presentation/features/theme/theme_store.dart';
import 'package:presentation/foundation/error/global_error_listener.dart';
import 'package:presentation/foundation/navigation/app_router.dart';
import 'package:presentation/foundation/store/error/global_error_store.dart';
import 'package:presentation/shared/constants/app_theme.dart';
import 'package:presentation/shared/constants/strings.dart';
import 'package:presentation/shared/utils/locale/app_localization.dart';
import 'package:rizzlt_flutter_starter/di/service_locator.dart';

class MyApp extends StatelessWidget {
  final ThemeStore _themeStore = getIt<ThemeStore>();
  final LanguageStore _languageStore = getIt<LanguageStore>();
  final GlobalErrorStore _globalErrorCubit = getIt<GlobalErrorStore>();

  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _themeStore),
        BlocProvider.value(value: _languageStore),
        BlocProvider.value(value: _globalErrorCubit),
      ],
      child: GlobalErrorListener(
        child: BlocBuilder<ThemeStore, ThemeState>(
          builder: (context, themeState) {
            return BlocBuilder<LanguageStore, LanguageState>(
              builder: (context, languageState) {
                return MaterialApp.router(
                  debugShowCheckedModeBanner: false,
                  title: Strings.appName,
                  themeMode: themeState.themeMode,
                  theme: AppThemeData.lightThemeData,
                  darkTheme: AppThemeData.darkThemeData,
                  routerConfig: AppRouter.router,
                  locale: languageState.currentLocale,
                  supportedLocales: languageState.supportedLocales
                      .map((localeDTO) =>
                          Locale(localeDTO.languageCode, localeDTO.countryCode))
                      .toList(),
                  localizationsDelegates: [
                    // A class which loads the translations from JSON files
                    AppLocalizations.delegate,
                    // Built-in localization of basic text for Material widgets
                    GlobalMaterialLocalizations.delegate,
                    // Built-in localization for text direction LTR/RTL
                    GlobalWidgetsLocalizations.delegate,
                    // Built-in localization of basic text for Cupertino widgets
                    GlobalCupertinoLocalizations.delegate,
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
