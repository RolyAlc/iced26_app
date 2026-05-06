import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:iced26/presentation/app/state/navigation_provider.dart';
import 'package:iced26/presentation/app/widgets/app_navigation_bar.dart';
import 'package:iced26/presentation/features/home/view/home_view.dart';
import 'package:iced26/presentation/features/schedule/view/schedule_view.dart';
import 'package:iced26/presentation/features/diary/view/diary_view.dart';
import 'package:iced26/presentation/features/settings/view/settings_view.dart';
import 'package:iced26/presentation/core/ui_engine/ui_metrics.dart';

/// Shell principal de la aplicación que maneja la navegación entre pantallas.
class AppShell extends ConsumerWidget {
  const AppShell({super.key});

  /// Construye el shell principal con la navegación entre pantallas.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentFeature = ref.watch(navigationProvider);

    return NotificationListener<UIMetricsNotification>(
      onNotification: (notification) {
        if (notification.navBarHeight != null) {
          if (ref.read(uiMetricsProvider).navBarHeight !=
              notification.navBarHeight) {
            ref
                .read(uiMetricsProvider.notifier)
                .updateNavBarHeight(notification.navBarHeight!);
          }
        }
        return true;
      },
      child: Scaffold(
        extendBody: true,
        body: IndexedStack(
          index: currentFeature.index,
          children: [
            const HomeView(),
            const ScheduleView(),
            const Center(child: Text('Search (Próximamente)')),
            const DiaryView(),
            const SettingsView(),
          ],
        ),
        bottomNavigationBar: const AppNavigationBar(),
      ),
    );
  }
}
