import 'package:flutter/material.dart';

import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/domain/entities/note_color.dart';
import 'package:iced26/presentation/app/theme/app_icons.dart';
import 'package:iced26/presentation/shared/helpers/date_helper.dart';

const _kDateIconSize = 16.0;
const _kColorBorderWidth = 1.5;

/// Encabezado del editor de notas: chip de fecha con color activo + botones de acción.
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
    final c = color;
    final paintColor = c != null ? AppNoteColors.colorOf(c) : null;

    return Row(
      children: [
        _buildDateChip(theme, paintColor),
        const Spacer(),
        if (onDelete != null)
          IconButton(
            onPressed: onDelete,
            icon: Icon(AppIcons.deleteOutline, color: theme.colorScheme.error),
          ),
        IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(AppIcons.close),
        ),
      ],
    );
  }

  Widget _buildDateChip(ThemeData theme, Color? paintColor) {
    final chipColor = paintColor ?? theme.colorScheme.onSurfaceVariant;

    return InkWell(
      onTap: onTapDate,
      borderRadius: BorderRadius.circular(AppRadius.full),
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
              ? Border.all(color: paintColor, width: _kColorBorderWidth)
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              AppIcons.calendarToday,
              size: _kDateIconSize,
              color: chipColor,
            ),
            const SizedBox(width: AppSpacing.s),
            Text(
              DateHelper.formatFullDate(date),
              style: theme.textTheme.labelLarge?.copyWith(
                color: chipColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
