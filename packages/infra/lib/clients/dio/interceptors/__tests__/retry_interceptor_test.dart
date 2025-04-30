import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:infra/clients/dio/interceptors/retry_interceptor.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

class MockRequestOptions extends Mock implements RequestOptions {}

class MockErrorInterceptorHandler extends Mock
    implements ErrorInterceptorHandler {}

class FakeDioException extends Fake implements DioException {}

class FakeResponse extends Fake implements Response {}

void main() {
  late MockDio dio;
  late MockErrorInterceptorHandler handler;
  late RetryInterceptor interceptor;
  late RequestOptions requestOptions;

  setUpAll(() {
    registerFallbackValue(FakeDioException());
    registerFallbackValue(FakeResponse());
    registerFallbackValue(MockRequestOptions());
  });

  setUp(() {
    dio = MockDio();
    handler = MockErrorInterceptorHandler();
    requestOptions = RequestOptions(
      path: '/test',
      extra: <String, dynamic>{},
    );

    // Default interceptor configuration
    interceptor = RetryInterceptor(dio: dio);
  });

  group('RetryInterceptor', () {
    test('should not retry when retries is set to 0', () async {
      // Arrange
      final options = RetryOptions.noRetry();
      final interceptor = RetryInterceptor(dio: dio, options: options);
      final error = DioException(
        requestOptions: requestOptions,
        type: DioExceptionType.connectionTimeout,
      );

      // Act
      await interceptor.onError(error, handler);

      // Assert
      verifyNever(() => dio.request(
            any(),
            cancelToken: any(named: 'cancelToken'),
            data: any(named: 'data'),
            options: any(named: 'options'),
            queryParameters: any(named: 'queryParameters'),
            onReceiveProgress: any(named: 'onReceiveProgress'),
            onSendProgress: any(named: 'onSendProgress'),
          ));
      verify(() => handler.reject(error)).called(1);
    });

    test('should retry when error matches retry criteria', () async {
      // Arrange
      final error = DioException(
        requestOptions: requestOptions,
        type: DioExceptionType.connectionTimeout,
      );

      when(() => dio.request(
                any(),
                cancelToken: any(named: 'cancelToken'),
                data: any(named: 'data'),
                options: any(named: 'options'),
                queryParameters: any(named: 'queryParameters'),
                onReceiveProgress: any(named: 'onReceiveProgress'),
                onSendProgress: any(named: 'onSendProgress'),
              ))
          .thenAnswer((_) async =>
              Response(requestOptions: requestOptions, statusCode: 200));

      // Act
      await interceptor.onError(error, handler);

      // Assert
      verify(() => dio.request(
            any(),
            cancelToken: any(named: 'cancelToken'),
            data: any(named: 'data'),
            options: any(named: 'options'),
            queryParameters: any(named: 'queryParameters'),
            onReceiveProgress: any(named: 'onReceiveProgress'),
            onSendProgress: any(named: 'onSendProgress'),
          )).called(1);
    });

    test('should not retry when error is cancel type', () async {
      // Arrange
      final error = DioException(
        requestOptions: requestOptions,
        type: DioExceptionType.cancel,
      );

      // Act
      await interceptor.onError(error, handler);

      // Assert
      verifyNever(() => dio.request(
            any(),
            cancelToken: any(named: 'cancelToken'),
            data: any(named: 'data'),
            options: any(named: 'options'),
            queryParameters: any(named: 'queryParameters'),
            onReceiveProgress: any(named: 'onReceiveProgress'),
            onSendProgress: any(named: 'onSendProgress'),
          ));
      verify(() => handler.reject(error)).called(1);
    });

    test('should not retry on bad response with default evaluator', () async {
      // Arrange
      final error = DioException(
        requestOptions: requestOptions,
        type: DioExceptionType.badResponse,
        response: Response(requestOptions: requestOptions, statusCode: 400),
      );

      // Act
      await interceptor.onError(error, handler);

      // Assert
      verifyNever(() => dio.request(
            any(),
            cancelToken: any(named: 'cancelToken'),
            data: any(named: 'data'),
            options: any(named: 'options'),
            queryParameters: any(named: 'queryParameters'),
            onReceiveProgress: any(named: 'onReceiveProgress'),
            onSendProgress: any(named: 'onSendProgress'),
          ));
      verify(() => handler.reject(error)).called(1);
    });

    test('should retry on bad response with legacyMode', () async {
      // Arrange
      final options = RetryOptions.legacyMode();
      final interceptor = RetryInterceptor(dio: dio, options: options);
      final error = DioException(
        requestOptions: requestOptions,
        type: DioExceptionType.badResponse,
        response: Response(requestOptions: requestOptions, statusCode: 400),
      );

      when(() => dio.request(
                any(),
                cancelToken: any(named: 'cancelToken'),
                data: any(named: 'data'),
                options: any(named: 'options'),
                queryParameters: any(named: 'queryParameters'),
                onReceiveProgress: any(named: 'onReceiveProgress'),
                onSendProgress: any(named: 'onSendProgress'),
              ))
          .thenAnswer((_) async =>
              Response(requestOptions: requestOptions, statusCode: 200));

      // Act
      await interceptor.onError(error, handler);

      // Assert
      verify(() => dio.request(
            any(),
            cancelToken: any(named: 'cancelToken'),
            data: any(named: 'data'),
            options: any(named: 'options'),
            queryParameters: any(named: 'queryParameters'),
            onReceiveProgress: any(named: 'onReceiveProgress'),
            onSendProgress: any(named: 'onSendProgress'),
          )).called(1);
    });

    test('should decrement retry count on each retry', () async {
      // Arrange
      final options = RetryOptions(retries: 3, retryInterval: Duration.zero);
      final interceptor = RetryInterceptor(dio: dio, options: options);
      final error = DioException(
        requestOptions: requestOptions.copyWith(extra: {}),
        type: DioExceptionType.connectionTimeout,
      );

      when(() => dio.request(
            any(),
            cancelToken: any(named: 'cancelToken'),
            data: any(named: 'data'),
            options: any(named: 'options'),
            queryParameters: any(named: 'queryParameters'),
            onReceiveProgress: any(named: 'onReceiveProgress'),
            onSendProgress: any(named: 'onSendProgress'),
          )).thenAnswer((_) {
        final retryCount =
            RetryOptions.fromExtra(error.requestOptions, options).retries;
        // Only succeed on the last retry
        if (retryCount == 1) {
          return Future.value(
              Response(requestOptions: requestOptions, statusCode: 200));
        }
        throw DioException(
          requestOptions: error.requestOptions,
          type: DioExceptionType.connectionTimeout,
        );
      });

      // Act
      await interceptor.onError(error, handler);

      // Assert - should retry 3 times (original attempt + 3 retries)
      verify(() => dio.request(
            any(),
            cancelToken: any(named: 'cancelToken'),
            data: any(named: 'data'),
            options: any(named: 'options'),
            queryParameters: any(named: 'queryParameters'),
            onReceiveProgress: any(named: 'onReceiveProgress'),
            onSendProgress: any(named: 'onSendProgress'),
          )).called(3);
    });

    test('should respect retry interval', () async {
      // Arrange
      final retryInterval = Duration(milliseconds: 100);
      final options = RetryOptions(retries: 1, retryInterval: retryInterval);
      final interceptor = RetryInterceptor(dio: dio, options: options);
      final error = DioException(
        requestOptions: requestOptions,
        type: DioExceptionType.connectionTimeout,
      );

      when(() => dio.request(
                any(),
                cancelToken: any(named: 'cancelToken'),
                data: any(named: 'data'),
                options: any(named: 'options'),
                queryParameters: any(named: 'queryParameters'),
                onReceiveProgress: any(named: 'onReceiveProgress'),
                onSendProgress: any(named: 'onSendProgress'),
              ))
          .thenAnswer((_) async =>
              Response(requestOptions: requestOptions, statusCode: 200));

      // Act and measure time
      final stopwatch = Stopwatch()..start();
      await interceptor.onError(error, handler);
      stopwatch.stop();

      // Assert - should wait at least the retry interval
      expect(stopwatch.elapsedMilliseconds,
          greaterThanOrEqualTo(retryInterval.inMilliseconds));
      verify(() => dio.request(
            any(),
            cancelToken: any(named: 'cancelToken'),
            data: any(named: 'data'),
            options: any(named: 'options'),
            queryParameters: any(named: 'queryParameters'),
            onReceiveProgress: any(named: 'onReceiveProgress'),
            onSendProgress: any(named: 'onSendProgress'),
          )).called(1);
    });

    test('should use custom retry evaluator when provided', () async {
      // Arrange - custom evaluator that only retries on 503 status code
      bool customEvaluator(DioException error) {
        return error.response?.statusCode == 503;
      }

      final options = RetryOptions(retries: 1, retryEvaluator: customEvaluator);
      final interceptor = RetryInterceptor(dio: dio, options: options);

      // 503 error - should retry
      final error503 = DioException(
        requestOptions: requestOptions,
        type: DioExceptionType.badResponse,
        response: Response(requestOptions: requestOptions, statusCode: 503),
      );

      // 400 error - should not retry
      final error400 = DioException(
        requestOptions: requestOptions,
        type: DioExceptionType.badResponse,
        response: Response(requestOptions: requestOptions, statusCode: 400),
      );

      when(() => dio.request(
                any(),
                cancelToken: any(named: 'cancelToken'),
                data: any(named: 'data'),
                options: any(named: 'options'),
                queryParameters: any(named: 'queryParameters'),
                onReceiveProgress: any(named: 'onReceiveProgress'),
                onSendProgress: any(named: 'onSendProgress'),
              ))
          .thenAnswer((_) async =>
              Response(requestOptions: requestOptions, statusCode: 200));

      // Act - test 503 error
      await interceptor.onError(error503, handler);

      // Assert - should retry
      verify(() => dio.request(
            any(),
            cancelToken: any(named: 'cancelToken'),
            data: any(named: 'data'),
            options: any(named: 'options'),
            queryParameters: any(named: 'queryParameters'),
            onReceiveProgress: any(named: 'onReceiveProgress'),
            onSendProgress: any(named: 'onSendProgress'),
          )).called(1);

      // Reset mocks
      reset(dio);
      reset(handler);

      // Act - test 400 error
      await interceptor.onError(error400, handler);

      // Assert - should not retry
      verifyNever(() => dio.request(
            any(),
            cancelToken: any(named: 'cancelToken'),
            data: any(named: 'data'),
            options: any(named: 'options'),
            queryParameters: any(named: 'queryParameters'),
            onReceiveProgress: any(named: 'onReceiveProgress'),
            onSendProgress: any(named: 'onSendProgress'),
          ));
      verify(() => handler.reject(error400)).called(1);
    });
  });
}
