import 'package:applications/dto/login_params_dto.dart';
import 'package:applications/usecase/auth/is_logged_in_usecase.dart';
import 'package:applications/usecase/auth/login_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation/features/auth/store/auth_state.dart';
import 'package:presentation/foundation/extensions/api_handling_Cubit.dart';
import 'package:presentation/foundation/services/api_handler_service.dart';
import 'package:presentation/shared/enum/resource_state.dart';

class AuthStore extends Cubit<AuthState> {
  final ApiHandlerService _apiHandler;
  final IsLoggedInUseCase _isLoggedInUseCase;
  final LoginUseCase _loginUseCase;

  AuthStore(
    this._apiHandler,
    this._loginUseCase,
    this._isLoggedInUseCase,
  ) : super(AuthState.initial()) {
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    await handleApiRequest<bool>(
      apiHandler: _apiHandler,
      apiCall: () async {
        return await _isLoggedInUseCase.call(params: null);
      },
      loadingStateBuilder: (state) => state.copyWith(
          loginStatus: ResourceState.loading, clearLoginError: true),
      successStateBuilder: (state, _) =>
          state.copyWith(loginStatus: ResourceState.success, isLoggedIn: true),
      errorStateBuilder: (state, errorMessage) => state.copyWith(
        loginStatus: ResourceState.error,
        loginErrorMessage: errorMessage,
        isLoggedIn: false,
      ),
      context: 'AuthStore.checkLoginStatus',
      handleAsGlobal: true,
    );
  }

  Future<void> login(
    String email,
    String password,
  ) async {
    await handleApiRequest<bool>(
      apiHandler: _apiHandler,
      apiCall: () async {
        final loginParams = LoginParamsDTO(email: email, password: password);
        return await _loginUseCase.call(params: loginParams);
      },
      loadingStateBuilder: (state) => state.copyWith(
          loginStatus: ResourceState.loading, clearLoginError: true),
      successStateBuilder: (state, _) =>
          state.copyWith(loginStatus: ResourceState.success, isLoggedIn: true),
      errorStateBuilder: (state, errorMessage) => state.copyWith(
        loginStatus: ResourceState.error,
        loginErrorMessage: errorMessage,
        isLoggedIn: false,
      ),
      context: 'AuthStore.login',
      handleAsGlobal: false,
    );
  }

  void logout() {
    emit(state.copyWith(isLoggedIn: false));
  }

  @override
  void emitError(String message) {
    emit(state.copyWith(
      loginStatus: ResourceState.error,
      loginErrorMessage: message,
    ));
  }

  @override
  void resetError() {
    if (state.hasLoginError) {
      emit(state.copyWith(
        loginStatus: ResourceState.init,
        loginErrorMessage: null,
      ));
    }
  }
}
