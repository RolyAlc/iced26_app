import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:iced26/presentation/shared/widgets/error_screen.dart';
import 'package:iced26/presentation/shared/widgets/loading_screen.dart';

/// Widget genérico que envuelve un AsyncValue mostrando estado de carga,
/// error o datos con UI adaptada al tema (Light/Dark/HighContrast).
class AppAsyncValueWidget<T> extends StatelessWidget {
  const AppAsyncValueWidget({
    super.key,
    required this.asyncValue,
    required this.data,
    this.onRetry,
  });
  final AsyncValue<T> asyncValue;
  final Widget Function(T) data;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return asyncValue.when(
      data: data,
      loading: () => const LoadingScreen(),
      error: (error, stackTrace) =>
          ErrorScreen(error: error.toString(), onRetry: onRetry),
    );
  }
}
