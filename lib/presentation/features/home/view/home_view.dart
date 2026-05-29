import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:iced26/di/bootstrap.dart';
import 'package:iced26/presentation/features/home/view/home_content.dart';
import 'package:iced26/presentation/shared/widgets/error_screen.dart';
import 'package:iced26/presentation/shared/widgets/loading_screen.dart';

/// Vista principal de la pantalla de inicio.
///
/// Solo gestiona los estados de carga/error/datos del bootstrap.
/// El contenido real vive en [HomeContent].
class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bootstrapAsync = ref.watch(bootstrapProvider);

    return bootstrapAsync.when(
      data: (_) => const HomeContent(),
      loading: () => const LoadingScreen(),
      error: (err, stack) => ErrorScreen(error: err.toString()),
    );
  }
}
