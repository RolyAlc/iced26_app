import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iced26/presentation/app/state/navigation_provider.dart';
import 'package:iced26/presentation/app/ui_metrics.dart';
import 'package:iced26/presentation/features/diary/view/diary_view.dart';
import 'package:iced26/presentation/features/home/view/home_view.dart';
import 'package:iced26/presentation/features/schedule/view/schedule_view.dart';
import 'package:iced26/presentation/features/settings/view/settings_view.dart';
import 'package:iced26/presentation/shared/widgets/app_navigation_bar.dart';

/// Shell principal de la aplicación que maneja la navegación entre pantallas.
class AppShell extends ConsumerWidget {
  const AppShell({super.key});

  /// Construye el shell principal con la navegación entre pantallas.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentFeature = ref.watch(navigationProvider);
    final orientation = MediaQuery.orientationOf(context);

    final body = IndexedStack(
      index: currentFeature.index,
      children: const [
        HomeView(),
        ScheduleView(),
        Center(child: Text('Search (Próximamente)')),
        DiaryView(),
        SettingsView(),
      ],
    );

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
      child: orientation == Orientation.landscape
          ? Scaffold(
              body: Row(
                children: [
                  const AppNavigationRail(),
                  Expanded(
                    child: SafeArea(left: false, top: false, child: body),
                  ),
                ],
              ),
            )
          : Scaffold(
              extendBody: true,
              body: body,
              bottomNavigationBar: const AppNavigationBar(),
            ),
    );
  }
}
