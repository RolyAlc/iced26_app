import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:iced26/core/constants/app_strings.dart';
import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/presentation/app/theme/app_icons.dart';
import 'package:iced26/presentation/features/schedule/viewmodel/schedule_viewmodel.dart';

const double _kFabIconSize = 22.0;
const double _kFabPaddingH = 20.0;
const double _kFabPaddingV = 14.0;
const double _kFabElevation = 3.0;

/// Píldora flotante para alternar entre vista lista y agenda en el schedule.
class ScheduleViewFab extends ConsumerWidget {
  const ScheduleViewFab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final format = ref.watch(selectedScheduleViewFormatProvider);
    final colors = Theme.of(context).colorScheme;
    final isAgenda = format == ScheduleViewFormat.agenda;

    final icon = isAgenda ? AppIcons.viewList : AppIcons.viewAgenda;
    final label = isAgenda
        ? AppStrings.scheduleViewFormatList
        : AppStrings.scheduleViewFormatAgenda;

    return Material(
      color: colors.primaryContainer,
      elevation: _kFabElevation,
      shadowColor: colors.shadow,
      borderRadius: BorderRadius.circular(AppRadius.full),
      clipBehavior: Clip.antiAlias,
      child: Tooltip(
        message: label,
        child: InkWell(
          onTap: () {
            ref.read(selectedScheduleViewFormatProvider.notifier).toggle();
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: _kFabPaddingH,
              vertical: _kFabPaddingV,
            ),
            child: AnimatedSwitcher(
              duration: AppDuration.fast,
              child: Row(
                // ValueKey explícito — AnimatedSwitcher necesita keys distintas
                // para identificar los hijos y animar la transición correctamente.
                key: ValueKey(isAgenda),
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icon,
                    size: _kFabIconSize,
                    color: colors.onPrimaryContainer,
                  ),
                  const SizedBox(width: AppSpacing.s),
                  Text(
                    label,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: colors.onPrimaryContainer,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
