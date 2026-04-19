import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iced26/presentation/app/widgets/error_screen.dart';
import 'package:iced26/presentation/app/widgets/loading_screen.dart';

/// Widget genérico para manejar estados asíncronos ('AsyncValue') de forma estándar en toda la aplicación.
///
/// Este widget facilita la visualización de estados de carga, errores o datos finales,
/// reduciendo código duplicado en las vistas.
class AppAsyncValueWidget<T> extends StatelessWidget {
  final AsyncValue<T> asyncValue;
  final Widget Function(T) data;
  final VoidCallback? onRetry;

  const AppAsyncValueWidget({
    super.key,
    required this.asyncValue,
    required this.data,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return asyncValue.when(
      data: data,
      loading: () => const LoadingScreen(),
      error: (error, stackTrace) => ErrorScreen(
        error: error.toString(),
        // TODO: Actualizar 'ErrorScreen' para que acepte 'onRetry' si es necesario en el futuro.
      ),
    );
  }
}
