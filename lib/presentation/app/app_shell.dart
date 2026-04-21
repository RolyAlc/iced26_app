import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:iced26/presentation/app/state/navigation_provider.dart';
import 'package:iced26/presentation/app/widgets/app_navigation_bar.dart';
import 'package:iced26/presentation/features/home/view/home_view.dart';
import 'package:iced26/presentation/features/schedule/view/schedule_view.dart';
import 'package:iced26/presentation/core/ui_engine/ui_metrics.dart';

/// Shell principal de la aplicación que maneja la navegación entre pantallas.
class AppShell extends ConsumerWidget {
  const AppShell({super.key});

  /// Construye el shell principal con la navegación entre pantallas.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(navigationProvider);

    /// Notifica los cambios de métricas de la UI.
    return NotificationListener<UIMetricsNotification>(
      onNotification: (notification) {
        final metricsNotifier = ref.read(uiMetricsProvider.notifier);

        if (notification.navBarHeight != null) {
          if (ref.read(uiMetricsProvider).navBarHeight !=
              notification.navBarHeight) {
            metricsNotifier.update(
              (state) =>
                  state.copyWith(navBarHeight: notification.navBarHeight),
            );
          }
        }
        return true;
      },
      child: Scaffold(
        extendBody: true,
        body: IndexedStack(
          index: currentIndex,
          children: const [
            HomeView(),
            ScheduleView(),
            Center(child: Text('Search (Próximamente)')),
            Center(child: Text('Diary (Próximamente)')),
            Center(child: Text('Settings (Próximamente)')),
          ],
        ),
        bottomNavigationBar: const AppNavigationBar(),
      ),
    );
  }
}
