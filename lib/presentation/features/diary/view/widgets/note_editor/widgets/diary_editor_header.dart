import 'package:flutter/material.dart';
import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/presentation/helpers/date_helper.dart';

/// Header del editor que muestra la fecha y el botón de cerrar.
class DiaryEditorHeader extends StatelessWidget {
  final DateTime date;
  final VoidCallback onTapDate;
  final int colorIndex;

  const DiaryEditorHeader({
    super.key,
    required this.date,
    required this.onTapDate,
    required this.colorIndex,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = AppNoteColors.getColor(colorIndex);

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
              color: color == Colors.transparent
                  ? theme.colorScheme.surfaceContainerHigh
                  : color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(AppRadius.full),
              border: color == Colors.transparent
                  ? null
                  : Border.all(color: color, width: 1.5),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.calendar_today_rounded,
                  size: 16,
                  color: color == Colors.transparent
                      ? theme.colorScheme.onSurfaceVariant
                      : color,
                ),
                const SizedBox(width: AppSpacing.s),
                Text(
                  DateHelper.formatFullDate(date),
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: color == Colors.transparent
                        ? theme.colorScheme.onSurfaceVariant
                        : color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        const Spacer(),
        IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close_rounded),
        ),
      ],
    );
  }
}
