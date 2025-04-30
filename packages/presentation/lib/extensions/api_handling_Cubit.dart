import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation/core/store/error_parser.dart';
import 'package:presentation/services/api_handler_service.dart';
import 'package:rizzlt_flutter_starter/main.dart';

extension ApiHandlingCubit<State extends Object> on Cubit<State> {
  Future<void> handleApiRequest<T>({
    required ApiHandlerService apiHandler,
    required Future<T> Function() apiCall,
    required State Function(State currentState) loadingStateBuilder,
    required State Function(State currentState, T data) successStateBuilder,
    required State Function(State currentState, String errorMessage)
        errorStateBuilder,
    String? context,
    bool handleAsGlobal = false,
    ErrorParser? errorParser,
  }) async {
    emit(loadingStateBuilder(state));
    final Result<T, String> result = await apiHandler.execute<T>(apiCall,
        context: context,
        handleGlobal: handleAsGlobal,
        errorParser: errorParser);

    result.when((data) {
      emit(successStateBuilder(state, data));
    }, (errorMessage) {
      emit(errorStateBuilder(state, errorMessage));
    });
  }
}
