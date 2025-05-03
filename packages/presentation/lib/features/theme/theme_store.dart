import 'package:applications/core/no_params.dart';
import 'package:applications/mapper/theme_mapper.dart';
import 'package:applications/usecase/theme/get_theme_usecase.dart';
import 'package:applications/usecase/theme/set_theme_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation/features/theme/theme_state.dart';
import 'package:presentation/foundation/extensions/api_handling_Cubit.dart';
import 'package:presentation/foundation/services/api_handler_service.dart';
import 'package:presentation/shared/enum/resource_state.dart';

class ThemeStore extends Cubit<ThemeState> {
  final ApiHandlerService _apiHandler;
  final GetThemeUseCase _getThemeUseCase;
  final SetThemeUseCase _setThemeUseCase;

  ThemeStore(
    this._apiHandler,
    this._getThemeUseCase,
    this._setThemeUseCase,
  ) : super(ThemeState.initial()) {
    init();
  }

  Future<void> init() async {
    await handleApiRequest<ThemeMode>(
      apiHandler: _apiHandler,
      apiCall: () async {
        return await _getThemeUseCase(params: const NoParams());
      },
      loadingStateBuilder: (state) =>
          state.copyWith(toggleThemeStatus: ResourceState.loading),
      successStateBuilder: (state, mode) => state.copyWith(
        toggleThemeStatus: ResourceState.success,
        themeMode: mode,
        availableThemes: ThemeMapper.getAllThemeModes(mode),
      ),
      errorStateBuilder: (state, errorMessage) => state.copyWith(
        toggleThemeStatus: ResourceState.error,
        errorMessage: errorMessage,
      ),
      context: 'ThemeStore.init',
      handleAsGlobal: true,
    );
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    await handleApiRequest<void>(
      apiHandler: _apiHandler,
      apiCall: () async {
        await _setThemeUseCase(params: mode);
      },
      loadingStateBuilder: (state) =>
          state.copyWith(toggleThemeStatus: ResourceState.loading),
      successStateBuilder: (state, _) => state.copyWith(
        toggleThemeStatus: ResourceState.success,
        themeMode: mode,
        availableThemes: ThemeMapper.getAllThemeModes(mode),
      ),
      errorStateBuilder: (state, errorMessage) => state.copyWith(
        toggleThemeStatus: ResourceState.error,
        errorMessage: errorMessage,
      ),
      context: 'ThemeStore.setThemeStore',
      handleAsGlobal: true,
    );
  }

  Future<void> toggleDarkMode() async {
    final newMode = state.isDarkMode ? ThemeMode.light : ThemeMode.dark;
    await setThemeMode(newMode);
  }

  bool isPlatformDark(BuildContext context) =>
      MediaQuery.platformBrightnessOf(context) == Brightness.dark;

  @override
  void emitError(String message) {
    emit(state.copyWith(
      toggleThemeStatus: ResourceState.error,
      errorMessage: message,
      isLoading: false,
    ));
  }

  @override
  void resetError() {
    if (state.hasError) {
      emit(state.copyWith(
        toggleThemeStatus: ResourceState.init,
        errorMessage: null,
      ));
    }
  }
}
