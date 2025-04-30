import 'package:presentation/enum/resource_state.dart';

class FormErrorState {
  final String? userEmail;
  final String? password;
  final String? confirmPassword;

  const FormErrorState({
    this.userEmail,
    this.password,
    this.confirmPassword,
  });

  factory FormErrorState.initial() => const FormErrorState();

  FormErrorState copyWith({
    String? userEmail,
    String? password,
    String? confirmPassword,
    bool clearUserEmail = false,
    bool clearPassword = false,
    bool clearConfirmPassword = false,
  }) {
    return FormErrorState(
      userEmail: clearUserEmail ? null : (userEmail ?? this.userEmail),
      password: clearPassword ? null : (password ?? this.password),
      confirmPassword: clearConfirmPassword
          ? null
          : (confirmPassword ?? this.confirmPassword),
    );
  }

  bool get hasErrorsInLogin => userEmail != null || password != null;

  bool get hasErrorsInRegister =>
      userEmail != null || password != null || confirmPassword != null;

  bool get hasErrorInForgotPassword => userEmail != null;
}

// FormState - 表單狀態
class MyFormState {
  final String userEmail;
  final String password;
  final String confirmPassword;
  final FormErrorState formErrorState;

  MyFormState({
    required this.userEmail,
    required this.password,
    required this.confirmPassword,
    required this.formErrorState,
  });

  factory MyFormState.initial() => MyFormState(
        userEmail: '',
        password: '',
        confirmPassword: '',
        formErrorState: FormErrorState.initial(),
      );

  MyFormState copyWith({
    ResourceState? status,
    String? userEmail,
    String? password,
    String? confirmPassword,
    bool? success,
    FormErrorState? formErrorState,
    String? errorMsg,
  }) {
    return MyFormState(
      userEmail: userEmail ?? this.userEmail,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      formErrorState: formErrorState ?? this.formErrorState,
    );
  }

  bool get canLogin =>
      !formErrorState.hasErrorsInLogin &&
      userEmail.isNotEmpty &&
      password.isNotEmpty;

  bool get canRegister =>
      !formErrorState.hasErrorsInRegister &&
      userEmail.isNotEmpty &&
      password.isNotEmpty &&
      confirmPassword.isNotEmpty;

  bool get canForgetPassword =>
      !formErrorState.hasErrorInForgotPassword && userEmail.isNotEmpty;

  bool get hasError =>
      formErrorState.hasErrorInForgotPassword ||
      formErrorState.hasErrorsInRegister ||
      formErrorState.hasErrorsInLogin;
}
