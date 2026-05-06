import 'package:flutter/material.dart';

import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/domain/entities/diary_note.dart';
import 'package:iced26/presentation/app/theme/app_icons.dart';

/// Card que muestra una nota personal del diario.
class DiaryNoteCard extends StatelessWidget {
  final DiaryNote note;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const DiaryNoteCard({
    super.key,
    required this.note,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.m),
        onTap: onEdit,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.m),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(note.content, style: theme.textTheme.bodyMedium),
              ),
              IconButton(
                icon: Icon(
                  AppIcons.close,
                  size: 18,
                  color: colors.onSurfaceVariant,
                ),
                onPressed: onDelete,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
