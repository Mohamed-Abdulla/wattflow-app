import 'package:flutter/material.dart';

import '../../app/theme/app_sizes.dart';
import '../../app/theme/app_spacing.dart';

class ResponsiveContainer extends StatelessWidget {
  const ResponsiveContainer({required this.child, super.key});
  final Widget child;
  @override
  Widget build(BuildContext context) => Center(
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: AppSizes.maxContentWidth),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: child,
      ),
    ),
  );
}

class AppCard extends StatelessWidget {
  const AppCard({required this.child, this.onTap, super.key});
  final Widget child;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) => Card(
    child: InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: child,
      ),
    ),
  );
}

class EmptyState extends StatelessWidget {
  const EmptyState({
    required this.title,
    required this.message,
    this.action,
    super.key,
  });
  final String title;
  final String message;
  final Widget? action;
  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.devices_other_outlined,
          size: 56,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: AppSpacing.sm),
        Text(message),
        if (action != null) ...[const SizedBox(height: AppSpacing.xl), action!],
      ],
    ),
  );
}

class ErrorState extends StatelessWidget {
  const ErrorState({
    this.title = 'Could not load data',
    required this.message,
    required this.onRetry,
    super.key,
  });
  final String title;
  final String message;
  final VoidCallback onRetry;
  @override
  Widget build(BuildContext context) => EmptyState(
    title: title,
    message: message,
    action: OutlinedButton.icon(
      onPressed: onRetry,
      icon: const Icon(Icons.refresh),
      label: const Text('Try again'),
    ),
  );
}
