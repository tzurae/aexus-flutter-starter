import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation/core/error/global_error.dart';
import 'package:presentation/enum/error_severity.dart';
import 'package:presentation/enum/global_error_type.dart';
import 'package:presentation/store/error/global_error_store.dart';

class GlobalErrorListener extends StatelessWidget {
  final Widget child;

  const GlobalErrorListener({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<GlobalErrorStore, GlobalErrorState>(
      listenWhen: (previous, current) => !previous.hasError && current.hasError,
      listener: (context, state) {
        if (state.hasError) {
          _showErrorDialog(context, state.error!);
        }
      },
      child: child,
    );
  }

  void _showErrorDialog(BuildContext context, GlobalError error) {
    // 根據錯誤嚴重程度選擇不同的顯示方式
    switch (error.severity) {
      case ErrorSeverity.critical:
        // 嚴重錯誤使用對話框
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: Text(_getErrorTitle(error)),
            content: Text(error.message),
            actions: [
              if (error.actionLabel != null)
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    if (error.onAction != null) {
                      error.onAction!();
                    }
                  },
                  child: Text(error.actionLabel!),
                )
              else
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    context.read<GlobalErrorStore>().reset();
                  },
                  child: const Text('確定'),
                ),
            ],
          ),
        );
        break;

      case ErrorSeverity.error:
      case ErrorSeverity.warning:
        // 一般錯誤和警告使用Snackbar
        final snackBar = SnackBar(
          content: Text(error.message),
          backgroundColor: _getErrorColor(error),
          action: error.actionLabel != null
              ? SnackBarAction(
                  label: error.actionLabel!,
                  textColor: Colors.white,
                  onPressed: () {
                    if (error.onAction != null) {
                      error.onAction!();
                    }
                    context.read<GlobalErrorStore>().reset();
                  },
                )
              : null,
          duration: const Duration(seconds: 5),
        );

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);
        break;

      case ErrorSeverity.info:
        // 信息性提示使用輕量級Snackbar
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(error.message),
              backgroundColor: Colors.blue,
              duration: const Duration(seconds: 3),
            ),
          );
        break;
    }
  }

  String _getErrorTitle(GlobalError error) {
    switch (error.type) {
      case GlobalErrorType.network:
        return '網絡錯誤';
      case GlobalErrorType.authentication:
        return '認證錯誤';
      case GlobalErrorType.serverDown:
        return '服務器錯誤';
      case GlobalErrorType.permission:
        return '權限錯誤';
      case GlobalErrorType.unknown:
      default:
        return '錯誤';
    }
  }

  Color _getErrorColor(GlobalError error) {
    switch (error.severity) {
      case ErrorSeverity.critical:
        return Colors.red.shade800;
      case ErrorSeverity.error:
        return Colors.red.shade600;
      case ErrorSeverity.warning:
        return Colors.orange.shade700;
      case ErrorSeverity.info:
        return Colors.blue.shade600;
      default:
        return Colors.red.shade600;
    }
  }
}
