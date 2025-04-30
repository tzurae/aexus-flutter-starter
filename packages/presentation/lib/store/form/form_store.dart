import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation/enum/resource_state.dart';
import 'package:presentation/services/api_handler_service.dart';
import 'package:presentation/store/form/form_state.dart';
import 'package:rizzlt_flutter_starter/di/service_locator.dart';
import 'package:rizzlt_flutter_starter/main.dart';

class MyFormStore extends Cubit<MyFormState> {
  final ApiHandlerService _apiHandler;

  MyFormStore(this._apiHandler) : super(MyFormState.initial());

  factory MyFormStore.create() {
    return MyFormStore(getIt<ApiHandlerService>());
  }

  void setUserId(String value) {
    emit(state.copyWith(userEmail: value));
    validateUserEmail(value);
  }

  void setPassword(String value) {
    emit(state.copyWith(password: value));
    validatePassword(value);
  }

  void setConfirmPassword(String value) {
    emit(state.copyWith(confirmPassword: value));
    validateConfirmPassword(value);
  }

  void validateUserEmail(String value) {
    if (value.isEmpty) {
      updateFormErrorState(userEmail: "Email can't be empty");
    } else if (!isEmail(value)) {
      updateFormErrorState(userEmail: 'Please enter a valid email address');
    } else {
      updateFormErrorState(clearUserEmail: true);
    }
  }

  void validatePassword(String value) {
    if (value.isEmpty) {
      updateFormErrorState(password: "Password can't be empty");
    } else if (value.length < 6) {
      updateFormErrorState(
          password: "Password must be at-least 6 characters long");
    } else {
      updateFormErrorState(clearPassword: true);
    }
  }

  void validateConfirmPassword(String value) {
    if (value.isEmpty) {
      updateFormErrorState(confirmPassword: "Confirm password can't be empty");
    } else if (value != state.password) {
      updateFormErrorState(confirmPassword: "Password doesn't match");
    } else {
      updateFormErrorState(clearConfirmPassword: true);
    }
  }

  void updateFormErrorState({
    String? userEmail,
    String? password,
    String? confirmPassword,
    bool clearUserEmail = false,
    bool clearPassword = false,
    bool clearConfirmPassword = false,
  }) {
    emit(state.copyWith(
      formErrorState: state.formErrorState.copyWith(
        userEmail: userEmail,
        password: password,
        confirmPassword: confirmPassword,
        clearUserEmail: clearUserEmail,
        clearPassword: clearPassword,
        clearConfirmPassword: clearConfirmPassword,
      ),
    ));
  }

  void validateAll() {
    validateUserEmail(state.userEmail);
    validatePassword(state.password);
    if (state.confirmPassword.isNotEmpty) {
      validateConfirmPassword(state.confirmPassword);
    }
  }

  void reset() {
    emit(MyFormState.initial());
  }

  void resetFormErrors() {
    emit(state.copyWith(
      formErrorState: FormErrorState.initial(),
    ));
  }

  void resetUserEmailError() {
    updateFormErrorState(clearUserEmail: true);
  }

  void resetPasswordError() {
    updateFormErrorState(clearPassword: true);
  }

  void resetConfirmPasswordError() {
    updateFormErrorState(clearConfirmPassword: true);
  }

  void resetGlobalError() {
    emit(state.copyWith(
      status: ResourceState.init,
      errorMsg: null,
    ));
  }

  void resetAllErrors() {
    emit(state.copyWith(
      status: ResourceState.init,
      errorMsg: null,
      formErrorState: FormErrorState.initial(),
    ));
  }

  @override
  void emitError(String message) {
    emit(state.copyWith(
      status: ResourceState.error,
      errorMsg: message,
    ));
  }

  @override
  void resetError() {
    resetAllErrors();
  }

  @override
  void resetState() {
    emit(MyFormState.initial());
  }
}
