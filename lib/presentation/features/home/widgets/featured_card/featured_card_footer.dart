import 'package:flutter/material.dart';
import 'package:iced26/core/constants/design_tokens.dart';

import 'package:iced26/presentation/app/theme/app_icons.dart';
import 'package:iced26/presentation/features/home/viewmodel/models/event_ui_model.dart';
import 'package:iced26/presentation/features/home/widgets/featured_card/widgets/info_row.dart';
import 'package:iced26/presentation/features/home/widgets/featured_card/widgets/save_button.dart';

/// Pie de la tarjeta de evento destacado — widget puramente presentacional.
///
/// No sabe nada de providers. El estado de guardado y la acción de toggle
/// vienen del padre ([FeaturedCard]).
class FeaturedCardFooter extends StatelessWidget {
  const FeaturedCardFooter({
    super.key,
    required this.event,
    required this.isSaved,
    required this.onToggle,
  });

  final EventUIModel event;
  final bool isSaved;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _EventInfo(event: event)),
        SaveButton(isSaved: isSaved, onTap: onToggle),
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
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: colors.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppSpacing.xxs),
        InfoRow(
          icon: AppIcons.scheduleOutline,
          text: event.duration,
          color: colors.primary,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colors.onSurfaceVariant.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }
}
