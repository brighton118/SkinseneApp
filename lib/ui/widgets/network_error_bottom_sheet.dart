import 'package:flutter/material.dart';

class NetworkErrorBottomSheet {
  /// Displays a non-dismissible bottom sheet requesting the user to retry.
  /// Returns `true` if the user elected to retry, or `false` if they force-cancelled.
  static Future<bool?> show(BuildContext context) {
    return showModalBottomSheet<bool>(
      context: context,
      isDismissible: false,
      enableDrag: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
      ),
      builder: (BuildContext ctx) {
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) {},
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Icon(
                    Icons.cloud_off_rounded,
                    size: 48,
                    color: Theme.of(ctx).colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Connection lost',
                    textAlign: TextAlign.center,
                    style: Theme.of(ctx).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Please ensure you have internet access to analyze your results. Your progress is saved safely.',
                    textAlign: TextAlign.center,
                    style: Theme.of(ctx).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: () {
                      Navigator.of(ctx).pop(true);
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
