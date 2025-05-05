import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation/features/auth/store/auth_store.dart';

class LoginViewModel extends Cubit<LoginViewState> {
  final AuthStore _authStore;
  LoginViewModel(this._authStore) : super(LoginViewState.initial());
  void setEmail(String value) {
    emit(state.copyWith(email: value).validateEmail());
  }

  void setPassword(String value) {
    emit(state.copyWith(password: value).validatePassword());
  }

  Future<void> login() async {
    final validatedState = state.validateEmail().validatePassword();
    emit(validatedState);
    if (validatedState.canLogin) {
      await _authStore.login(
        validatedState.email,
        validatedState.password,
      );
    }
  }

  void validateAll() {
    emit(state.validateEmail().validatePassword());
  }

  void reset() {
    emit(LoginViewState.initial());
  }
}

class LoginViewState {
  final String email;
  final String password;

  final String? emailError;
  final String? passwordError;

  LoginViewState({
    required this.email,
    required this.password,
    this.emailError,
    this.passwordError,
  });

  factory LoginViewState.initial() => LoginViewState(
        email: '',
        password: '',
        emailError: null,
        passwordError: null,
      );

  LoginViewState validateEmail() {
    String? error;
    if (email.isEmpty) {
      error = "Email can't be empty";
    } else if (!_isEmail(email)) {
      error = 'Please enter a valid email address';
    }
    return copyWith(
      emailError: error,
      clearEmailError: error == null,
    );
  }

  LoginViewState validatePassword() {
    String? error;
    if (password.isEmpty) {
      error = "Password can't be empty";
    } else if (password.length < 6) {
      error = 'Password must be at-least 6 characters long';
    }
    return copyWith(
      passwordError: error,
      clearPasswordError: error == null,
    );
  }

  bool _isEmail(String value) {
    return RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+').hasMatch(value);
  }

  bool get canLogin =>
      emailError == null &&
      passwordError == null &&
      email.isNotEmpty &&
      password.isNotEmpty;

  LoginViewState copyWith({
    String? email,
    String? password,
    String? emailError,
    String? passwordError,
    bool clearEmailError = false,
    bool clearPasswordError = false,
  }) {
    return LoginViewState(
      email: email ?? this.email,
      password: password ?? this.password,
      emailError: clearEmailError ? null : (emailError ?? this.emailError),
      passwordError:
          clearPasswordError ? null : (passwordError ?? this.passwordError),
    );
  }
}
