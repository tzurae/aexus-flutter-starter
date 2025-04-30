import 'package:presentation/core/store/error_parser.dart';
import 'package:presentation/store/error/global_error_store.dart';
import 'package:rizzlt_flutter_starter/core/logger/interface/logger_interface.dart';
import 'package:rizzlt_flutter_starter/main.dart';

typedef ApiResult<S, E> = Result<S, E>;

class ApiHandlerService {
  final LoggerInterface _logger;
  final GlobalErrorStore _globalErrorStore;

  ApiHandlerService(
    this._logger,
    this._globalErrorStore,
  );

  Future<ApiResult<T, String>> execute<T>(
    Future<T> Function() action, {
    String? context,
    bool handleGlobal = false,
    ErrorParser? errorParser,
  }) async {
    final logContext = context ?? action.runtimeType.toString();
    _logger.i('$logContext: String operation...');

    try {
      final T result = await action();
      _logger.i('$logContext: String operation success');
      return ApiResult.success(result);
    } catch (e, stackTrace) {
      final errorMessage = errorParser?.call(e) ?? e.toString();
      _logger.i(
        '$logContext: Operation failed. Error: $errorMessage',
        error: e,
        stackTrace: stackTrace,
      );
      if (handleGlobal) {
        _logger.i(
          '$logContext: Forwarding error to GlobalErrorStore',
          error: e,
          stackTrace: stackTrace,
        );
        _globalErrorStore.handleError(
          e,
          stackTrace: stackTrace,
          context: logContext,
        );
      }
      return ApiResult.error(errorMessage);
    }
  }
}
