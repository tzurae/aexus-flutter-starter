import 'dart:async';
import 'dart:io'; // For SocketException
// import 'package:dio/dio.dart'; // Uncomment if using Dio

typedef ErrorParser = String Function(dynamic error);

/// A default error parser function that attempts to convert common exceptions
/// into more user-friendly messages.
///
/// This is a basic example. Enhance it based on your app's specific needs,
/// error types, and consider localization.
String defaultErrorParser(dynamic error) {
  // --- Placeholder for Localization ---
  // You would typically get your localization delegate here
  // final l10n = AppLocalizations.of(context); // Needs context or a static way

  if (error is String) {
    return error; // Already a string message
  }

  // Example: Handling SocketException (Network issues)
  if (error is SocketException) {
    // return l10n.networkError; // Example with localization
    return 'Network error: Please check your connection and try again.';
  }

  // Example: Handling FormatException (Data parsing issues)
  if (error is FormatException) {
    // return l10n.invalidDataFormat; // Example with localization
    return 'Invalid data format received from the server.';
  }

  // Example: Handling TimeoutException
  if (error is TimeoutException) {
    // return l10n.requestTimeout; // Example with localization
    return 'The request timed out. Please try again.';
  }

  /*
  // Example: Handling DioError (if using Dio)
  if (error is DioError) {
    switch (error.type) {
      case DioErrorType.connectTimeout:
      case DioErrorType.sendTimeout:
      case DioErrorType.receiveTimeout:
        // return l10n.requestTimeout;
        return "The connection timed out. Please try again.";
      case DioErrorType.response:
        // Handle specific HTTP status codes
        final statusCode = error.response?.statusCode;
        if (statusCode == 401) {
          // return l10n.unauthorizedError;
          // You might also trigger a global logout action here
          return "Authentication failed. Please log in again.";
        } else if (statusCode == 404) {
          // return l10n.notFoundError;
          return "The requested resource was not found.";
        } else if (statusCode != null && statusCode >= 500) {
          // return l10n.serverError;
          return "Server error occurred. Please try again later.";
        } else {
          // Try to get message from response data if available
          // String? serverMessage = error.response?.data?['message'];
          // if (serverMessage != null) return serverMessage;
          // return l10n.httpError(statusCode ?? -1); // Pass status code
          return "An HTTP error occurred (${statusCode ?? 'unknown'}). Please try again.";
        }
      case DioErrorType.cancel:
        return "The request was cancelled.";
      case DioErrorType.other:
        if (error.error is SocketException) {
          // return l10n.networkError;
           return "Network error: Please check your connection and try again.";
        }
        // return l10n.unknownNetworkError;
        return "An unknown network error occurred.";
    }
  }
  */

  // Example: Handling a custom business logic exception
  // if (error is InsufficientBalanceException) {
  //   return l10n.insufficientBalance;
  //   return "You do not have enough balance for this operation.";
  // }

  // Fallback for unknown errors
  // return l10n.unknownError; // Example with localization
  return 'An unexpected error occurred. Please try again.';

  // Optionally, in debug mode, you might want to return more details:
  // assert(() {
  //   errorMessage = error.toString();
  //   return true;
  // }());
  // return errorMessage;
}
