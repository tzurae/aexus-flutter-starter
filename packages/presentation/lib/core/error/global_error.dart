import 'dart:ui';

import 'package:presentation/enum/error_severity.dart';
import 'package:presentation/enum/global_error_type.dart';

class GlobalError {
  final GlobalErrorType type;
  final String message;
  final ErrorSeverity severity;
  final String? code;
  final dynamic originalError;
  final StackTrace? stackTrace;

  // extra information for UI to display
  final String? actionLabel;
  final VoidCallback? onAction;

  const GlobalError({
    required this.type,
    required this.message,
    this.severity = ErrorSeverity.error,
    this.code,
    this.originalError,
    this.stackTrace,
    this.actionLabel,
    this.onAction,
  });
  // 創建網絡錯誤
  factory GlobalError.network(String message,
      {String? code, dynamic originalError, StackTrace? stackTrace}) {
    return GlobalError(
      type: GlobalErrorType.network,
      message: message,
      code: code,
      originalError: originalError,
      stackTrace: stackTrace,
      actionLabel: '重試',
    );
  }

  // 創建認證錯誤
  factory GlobalError.authentication(String message,
      {String? code, dynamic originalError, StackTrace? stackTrace}) {
    return GlobalError(
      type: GlobalErrorType.authentication,
      message: message,
      code: code,
      originalError: originalError,
      stackTrace: stackTrace,
      actionLabel: '登入',
    );
  }

  // 創建服務器錯誤
  factory GlobalError.serverDown(String message,
      {String? code, dynamic originalError, StackTrace? stackTrace}) {
    return GlobalError(
      type: GlobalErrorType.serverDown,
      message: message,
      severity: ErrorSeverity.critical,
      code: code,
      originalError: originalError,
      stackTrace: stackTrace,
    );
  }

  // 創建權限錯誤
  factory GlobalError.permission(String message,
      {String? code, dynamic originalError, StackTrace? stackTrace}) {
    return GlobalError(
      type: GlobalErrorType.permission,
      message: message,
      code: code,
      originalError: originalError,
      stackTrace: stackTrace,
    );
  }

  // 創建未知錯誤
  factory GlobalError.unknown(String message,
      {String? code, dynamic originalError, StackTrace? stackTrace}) {
    return GlobalError(
      type: GlobalErrorType.unknown,
      message: message,
      code: code,
      originalError: originalError,
      stackTrace: stackTrace,
    );
  }

  @override
  String toString() =>
      'GlobalError(type: $type, message: $message, code: $code)';
}
