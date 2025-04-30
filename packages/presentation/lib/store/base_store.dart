// import 'package:mobx/mobx.dart';
// import 'package:presentation/enum/resource_state.dart';
// import 'package:presentation/store/error/error_store.dart';
// import 'package:rizzlt_flutter_starter/core/logger/index.dart';
// import 'package:rizzlt_flutter_starter/core/logger/interface/logger_interface.dart';
// import 'package:rizzlt_flutter_starter/di/service_locator.dart';
//
// mixin BaseStore<T> on Store {
//   final LoggerInterface logger = Log.getLogger(T.toString());
//   final ErrorStore globalErrorStore = getIt<ErrorStore>();
//
//   @observable
//   ResourceState state = ResourceState.init;
//
//   @computed
//   bool get isLoading => state == ResourceState.loading;
//   @computed
//   bool get hasError => state == ResourceState.error;
//   @computed
//   bool get isEmpty => state == ResourceState.empty;
//   @computed
//   bool get isSuccess => state == ResourceState.success;
//   @observable
//   String? apiErrorMessage;
//
//   @action
//   void setLoading() {
//     state = ResourceState.loading;
//   }
//
//   @action
//   void setSuccess() {
//     state = ResourceState.success;
//   }
//
//   @action
//   void setEmpty() {
//     state = ResourceState.empty;
//   }
//
//   @action
//   void setApiError(String message, {bool isGlobalError = false}) {
//     apiErrorMessage = message;
//     state = ResourceState.error;
//     if (isGlobalError) {
//       globalErrorStore.errorMessage = message;
//     }
//   }
//
//   @action
//   void resetApiError() {
//     if (state == ResourceState.error) {
//       apiErrorMessage = null;
//       state = ResourceState.init;
//     }
//   }
// }
