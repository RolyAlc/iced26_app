import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:iced26/di/domain_providers.dart';
import 'package:iced26/presentation/app/theme/app_icons.dart';
import 'package:iced26/presentation/features/home/viewmodel/models/event_ui_model.dart';
import 'package:iced26/presentation/features/home/widgets/featured_card/widgets/info_row.dart';
import 'package:iced26/presentation/features/home/widgets/featured_card/widgets/save_button.dart';

/// Pie de la tarjeta de evento destacado.
class FeaturedCardFooter extends ConsumerWidget {
  const FeaturedCardFooter({super.key, required this.event});
  final EventUIModel event;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteIds = ref.watch(
      favoriteIdsProvider.select((ids) => ids.value ?? <String>{}),
    );
    final isSaved = favoriteIds.contains(event.id);

    return Row(
      children: [
        Expanded(child: _EventInfo(event: event)),
        SaveButton(
          isSaved: isSaved,
          onTap: () =>
              ref.read(toggleFavoriteUseCaseProvider).execute(event.id),
        ),
      ],
    );
  }
}

/// Información del evento (sala y duración).
class _EventInfo extends StatelessWidget {
  const _EventInfo({required this.event});
  final EventUIModel event;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InfoRow(
          icon: AppIcons.meetingRoomOutline,
          text: event.room,
          color: colors.primary,
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: colors.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 2),
        InfoRow(
          icon: AppIcons.scheduleOutline,
          text: event.duration,
          color: colors.primary,
          style: theme.textTheme.bodySmall?.copyWith(
            color: colors.onSurfaceVariant.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }
}
