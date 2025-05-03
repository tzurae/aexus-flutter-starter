import 'package:flutter/material.dart';
import 'package:presentation/foundation/error/global_error.dart';
import 'package:presentation/shared/enum/global_error_type.dart';

class ErrorDisplayWidget extends StatelessWidget {
  final GlobalError error;
  final VoidCallback? onRetry;
  final bool fullScreen;

  const ErrorDisplayWidget({
    required this.error,
    super.key,
    this.onRetry,
    this.fullScreen = false,
  });

  @override
  Widget build(BuildContext context) {
    IconData iconData;
    Color iconColor;

    switch (error.type) {
      case GlobalErrorType.network:
        iconData = Icons.wifi_off;
        iconColor = Colors.orange;
        break;
      case GlobalErrorType.authentication:
        iconData = Icons.lock;
        iconColor = Colors.red;
        break;
      case GlobalErrorType.serverDown:
        iconData = Icons.cloud_off;
        iconColor = Colors.red;
        break;
      case GlobalErrorType.permission:
        iconData = Icons.no_accounts;
        iconColor = Colors.orange;
        break;
      case GlobalErrorType.unknown:
      default:
        iconData = Icons.error_outline;
        iconColor = Colors.red;
        break;
    }

    if (fullScreen) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                iconData,
                size: 64,
                color: iconColor,
              ),
              const SizedBox(height: 16),
              Text(
                error.message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              if (error.actionLabel != null) ...[
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: error.onAction ?? onRetry,
                  child: Text(error.actionLabel!),
                ),
              ],
            ],
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Row(
        children: [
          Icon(
            iconData,
            color: iconColor,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              error.message,
              style: TextStyle(color: Colors.red.shade800),
            ),
          ),
          if (error.actionLabel != null)
            TextButton(
              onPressed: error.onAction ?? onRetry,
              child: Text(
                error.actionLabel!,
                style: TextStyle(color: Colors.red.shade800),
              ),
            ),
        ],
      ),
    );
  }
}
