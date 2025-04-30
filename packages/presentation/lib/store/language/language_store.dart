// packages/presentation/lib/store/language/language_store.dart
import 'package:applications/core/no_params.dart';
import 'package:applications/mapper/locale_mapper.dart';
import 'package:applications/usecase/locale/get_locale_usecase.dart';
import 'package:applications/usecase/locale/set_locale_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation/enum/resource_state.dart';
import 'package:presentation/extensions/api_handling_Cubit.dart';
import 'package:presentation/services/api_handler_service.dart';
import 'package:presentation/store/language/language_state.dart';

class LanguageStore extends Cubit<LanguageState> {
  final ApiHandlerService _apiHandler;
  final GetLocaleUseCase _getLocaleUseCase;
  final SetLocaleUseCase _setLocaleUseCase;

  LanguageStore(
    this._apiHandler,
    this._getLocaleUseCase,
    this._setLocaleUseCase,
  ) : super(LanguageState.initial()) {
    init();
  }

  Future<void> init() async {
    await handleApiRequest<Locale>(
      apiHandler: _apiHandler,
      apiCall: () async {
        return await _getLocaleUseCase(params: const NoParams());
      },
      loadingStateBuilder: (state) =>
          state.copyWith(status: ResourceState.loading),
      successStateBuilder: (state, locale) => state.copyWith(
        status: ResourceState.success,
        currentLocale: locale,
        supportedLocales: LocaleMapper.getSupportedLocales(locale),
      ),
      errorStateBuilder: (state, errorMessage) => state.copyWith(
        status: ResourceState.error,
      ),
      context: 'LanguageStore.init',
      handleAsGlobal: true,
    );
  }

  Future<void> changeLocale(LocaleDTO localeDTO) async {
    await handleApiRequest<void>(
      apiHandler: _apiHandler,
      apiCall: () async {
        final locale = LocaleMapper.toDomain(localeDTO);
        await _setLocaleUseCase(params: locale);
      },
      loadingStateBuilder: (state) =>
          state.copyWith(status: ResourceState.loading),
      successStateBuilder: (state, locale) => state.copyWith(
        status: ResourceState.success,
        currentLocale: LocaleMapper.toDomain(localeDTO),
      ),
      errorStateBuilder: (state, errorMessage) => state.copyWith(
        status: ResourceState.error,
      ),
      context: 'LanguageStore.changeLocale',
      handleAsGlobal: true,
    );
  }

  @override
  void emitError(String message) {
    emit(state.copyWith(
      status: ResourceState.error,
      errorMsg: message,
      isLoading: false,
    ));
  }

  @override
  void resetError() {
    if (state.hasError) {
      emit(state.copyWith(
        status: ResourceState.init,
        errorMsg: null,
      ));
    }
  }
}
