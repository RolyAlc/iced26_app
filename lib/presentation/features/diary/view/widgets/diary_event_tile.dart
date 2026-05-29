import 'package:flutter/material.dart';

import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/domain/entities/event.dart';
import 'package:iced26/presentation/app/theme/app_icons.dart';

/// Tile que muestra un evento del diario.
class DiaryEventTile extends StatelessWidget {
  const DiaryEventTile({super.key, required this.event});
  final Event event;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final locale = Localizations.localeOf(context).languageCode;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        children: [
          Icon(AppIcons.scheduleOff, size: 16, color: colors.primary),
          const SizedBox(width: AppSpacing.s),
          Expanded(
            child: Text(
              event.title.resolve(locale),
              style: theme.textTheme.bodyMedium,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (event.filterTime != null)
            Text(
              event.filterTime!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
        ],
      ),
    );
  }
}
