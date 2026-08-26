import 'package:flutter/material.dart';

import '../error/app_failure.dart';

abstract final class AppSnackBar {
  static void show(
    BuildContext context,
    String message, {
    bool isError = false,
  }) {
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) return;

    final colors = Theme.of(context).colorScheme;
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          backgroundColor: isError ? colors.error : colors.inverseSurface,
          action: SnackBarAction(
            label: 'Dismiss',
            textColor: isError ? colors.onError : colors.onInverseSurface,
            onPressed: messenger.hideCurrentSnackBar,
          ),
        ),
      );
  }

  static void showError(
    BuildContext context,
    Object error, {
    String fallback = 'Something went wrong. Please try again.',
  }) {
    show(
      context,
      userFacingErrorMessage(error, fallback: fallback),
      isError: true,
    );
  }
}
