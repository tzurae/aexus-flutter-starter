import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation/foundation/error/global_error.dart';
import 'package:rizzlt_flutter_starter/core/logger/interface/logger_interface.dart';
import 'package:rizzlt_flutter_starter/core/logger/logger_factory.dart';

class GlobalErrorState {
  final GlobalError? error;
  final bool hasError;
  GlobalErrorState({this.error}) : hasError = error != null;

  factory GlobalErrorState.initial() => GlobalErrorState();
  factory GlobalErrorState.withError(GlobalError error) =>
      GlobalErrorState(error: error);

  GlobalErrorState copyWith({GlobalError? error}) {
    return GlobalErrorState(error: error ?? this.error);
  }
}

class GlobalErrorStore extends Cubit<GlobalErrorState> {
  final LoggerInterface _logger =
      LoggerFactory.instance.getLogger('GlobalErrorStore');
  GlobalErrorStore() : super(GlobalErrorState.initial());

  void setError(GlobalError error) {
    _logger.e(
      'Global Error: ${error.type} - ${error.message}',
      error: error.originalError,
      stackTrace: error.stackTrace,
    );
    emit(GlobalErrorState.withError(error));
  }

  void reset() {
    if (state.hasError) {
      emit(GlobalErrorState.initial());
    }
  }

  void handleError(dynamic error, {StackTrace? stackTrace, String? context}) {
    GlobalError appError;

    if (error is GlobalError) {
      appError = error;
    } else {
      if (error.toString().contains('SocketException') ||
          error.toString().contains('Connection refused')) {
        appError = GlobalError.network('網絡連接失敗，請檢查您的網絡設置',
            originalError: error, stackTrace: stackTrace);
      } else if (error.toString().contains('401') ||
          error.toString().contains('Unauthorized')) {
        appError = GlobalError.authentication('您的登入狀態已過期，請重新登入',
            originalError: error, stackTrace: stackTrace);
      } else {
        appError = GlobalError.unknown('發生未知錯誤，請稍後重試',
            originalError: error, stackTrace: stackTrace);
      }
    }

    setError(appError);
  }
}
