import 'package:flutter/material.dart';

import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/domain/entities/note_color.dart';
import 'package:iced26/presentation/shared/helpers/date_helper.dart';

/// Encabezado de la nota del diario que muestra la fecha y el color.
class DiaryEditorHeader extends StatelessWidget {
  const DiaryEditorHeader({
    super.key,
    required this.date,
    required this.onTapDate,
    required this.color,
    this.onDelete,
  });
  final DateTime date;
  final VoidCallback onTapDate;
  final NoteColor? color;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final paintColor = color != null ? AppNoteColors.colorOf(color!) : null;

    return Row(
      children: [
        GestureDetector(
          onTap: onTapDate,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.m,
              vertical: AppSpacing.s,
            ),
            decoration: BoxDecoration(
              color: paintColor != null
                  ? paintColor.withValues(alpha: 0.2)
                  : theme.colorScheme.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(AppRadius.full),
              border: paintColor != null
                  ? Border.all(color: paintColor, width: 1.5)
                  : null,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.calendar_today_rounded,
                  size: 16,
                  color: paintColor ?? theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: AppSpacing.s),
                Text(
                  DateHelper.formatFullDate(date),
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: paintColor ?? theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        const Spacer(),
        if (onDelete != null)
          IconButton(
            onPressed: onDelete,
            icon: Icon(
              Icons.delete_outline_rounded,
              color: theme.colorScheme.error,
            ),
          ),
        IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close_rounded),
        ),
      ],
    );
  }
}
