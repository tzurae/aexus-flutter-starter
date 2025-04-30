import 'package:dio/dio.dart';
import 'package:infra/clients/dio/dio_client.dart';
import 'package:infra/clients/dio/interceptors/retry_interceptor.dart';

extension DioRetryExtension on DioClient {
  void _ensureRetryInterceptor() {
    bool hasRetryInterceptor =
        dio.interceptors.any((i) => i is RetryInterceptor);
    if (!hasRetryInterceptor) {
      dio.interceptors.add(RetryInterceptor(dio: dio));
    }
  }

  Options _createRetryOptions({
    Options? options,
    int retries = 3,
    Duration retryInterval = const Duration(seconds: 1),
    RetryEvaluator? retryEvaluator,
  }) {
    final retryOptions = RetryOptions(
      retries: retries,
      retryInterval: retryInterval,
      retryEvaluator: retryEvaluator ?? RetryOptions.defaultRetryEvaluator,
    );

    final opts = options ?? Options();
    final Map<String, dynamic> extra = {...opts.extra ?? {}};
    extra[RetryOptions.extraKey] = retryOptions;

    return opts.copyWith(extra: extra);
  }

  Future<Response> getWithRetry(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
    int retries = 3,
    Duration retryInterval = const Duration(seconds: 1),
    RetryEvaluator? retryEvaluator,
  }) {
    _ensureRetryInterceptor();
    final retryOptions = _createRetryOptions(
      options: options,
      retries: retries,
      retryInterval: retryInterval,
      retryEvaluator: retryEvaluator,
    );

    return dio.get(
      path,
      queryParameters: queryParameters,
      options: retryOptions,
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
    );
  }

  Future<Response> postWithRetry(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    int retries = 3,
    Duration retryInterval = const Duration(seconds: 1),
    RetryEvaluator? retryEvaluator,
  }) {
    _ensureRetryInterceptor();
    final retryOptions = _createRetryOptions(
      options: options,
      retries: retries,
      retryInterval: retryInterval,
      retryEvaluator: retryEvaluator,
    );

    return dio.post(
      path,
      data: data,
      queryParameters: queryParameters,
      options: retryOptions,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }
}
