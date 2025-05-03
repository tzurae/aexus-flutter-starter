import 'package:presentation/shared/enum/resource_state.dart';

class AuthState {
  final bool isLoggedIn;
  final ResourceState loginStatus;
  final String? loginErrorMessage;

  AuthState._({
    required this.isLoggedIn,
    required this.loginStatus,
    this.loginErrorMessage,
  }) : super();

  factory AuthState.initial() => AuthState._(
        isLoggedIn: false,
        loginStatus: ResourceState.init,
        loginErrorMessage: null,
      );

  AuthState copyWith({
    bool? isLoggedIn,
    ResourceState? loginStatus,
    String? loginErrorMessage,
    // Helper to easily clear error
    bool clearLoginError = false,
  }) {
    return AuthState._(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      loginStatus: loginStatus ?? this.loginStatus,
      loginErrorMessage: clearLoginError
          ? null
          : (loginErrorMessage ?? this.loginErrorMessage),
    );
  }

  bool get isLoggingIn => loginStatus == ResourceState.loading;
  bool get hasLoginError =>
      loginStatus == ResourceState.error && loginErrorMessage != null;
}
