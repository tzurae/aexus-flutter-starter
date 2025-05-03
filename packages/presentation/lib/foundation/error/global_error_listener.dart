import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation/foundation/error/global_error.dart';
import 'package:presentation/foundation/store/error/global_error_store.dart';
import 'package:presentation/shared/enum/error_severity.dart';
import 'package:presentation/shared/enum/global_error_type.dart';

class GlobalErrorListener extends StatelessWidget {
  final Widget child;

  const GlobalErrorListener({
    super.key,
    required this.child,
  });

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
    switch (error.severity) {
      case ErrorSeverity.critical:
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
                  child: const Text('Confirm'),
                ),
            ],
          ),
        );
        break;

      case ErrorSeverity.error:
      case ErrorSeverity.warning:
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
        return 'Network Error';
      case GlobalErrorType.authentication:
        return 'Auth Error';
      case GlobalErrorType.serverDown:
        return 'Server Error';
      case GlobalErrorType.permission:
        return 'Permission Error';
      case GlobalErrorType.unknown:
      default:
        return 'Unknown Error';
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
