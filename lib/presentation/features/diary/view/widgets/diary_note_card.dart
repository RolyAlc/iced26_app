import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/domain/entities/diary_note.dart';
import 'package:iced26/domain/entities/note_color.dart';
import 'package:iced26/l10n/app_localizations.dart';
import 'package:iced26/presentation/app/theme/app_icons.dart';
import 'package:iced26/presentation/shared/helpers/date_helper.dart';
import 'package:iced26/presentation/shared/widgets/app_card.dart';

/// Tarjeta de notas del diario que muestra el título, el contenido y el estado de ánimo.
class DiaryNoteCard extends StatelessWidget {
  const DiaryNoteCard({
    super.key,
    required this.note,
    required this.onDelete,
    required this.onEdit,
  });
  final DiaryNote note;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Dismissible(
        key: ValueKey(note.id),
        direction: DismissDirection.endToStart,
        background: const _DismissDeleteBackground(),
        confirmDismiss: (_) =>
            _showDeleteConfirmation(context, AppLocalizations.of(context)!),
        onDismissed: (_) => onDelete(),
        child: AppCard(
          onTap: onEdit,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.m,
            vertical: AppSpacing.sm,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (note.title != null && note.title!.isNotEmpty) ...[
                Text(
                  note.title!,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
              ],
              Text(
                note.content,
                style: theme.textTheme.bodyMedium,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppSpacing.s),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (note.color case final c?)
                    _MoodDot(color: c)
                  else
                    const SizedBox.shrink(),
                  Text(
                    DateHelper.formatTime(note.createdAt),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Muestra un diálogo de confirmación de eliminación.
  Future<bool> _showDeleteConfirmation(
    BuildContext context,
    AppLocalizations l10n,
  ) async {
    if (!context.mounted) return false;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(l10n.diaryDeleteNoteTitle),
          content: Text(l10n.diaryDeleteNoteConfirm),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: Text(l10n.cancel),
            ),
            TextButton(
              onPressed: () {
                HapticFeedback.mediumImpact();
                Navigator.pop(dialogContext, true);
              },
              child: Text(l10n.delete),
            ),
          ],
        );
      },
    );
    return confirmed ?? false;
  }
}

/// Indicador circular de color para la etiqueta de nota.
class _MoodDot extends StatelessWidget {
  const _MoodDot({required this.color});
  final NoteColor color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(color: color.color, shape: BoxShape.circle),
    );
  }
}

/// Fondo semitransparente con el icono de eliminar para el gesto Dismissible.
class _DismissDeleteBackground extends StatelessWidget {
  const _DismissDeleteBackground();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.m),
      child: ColoredBox(
        color: colors.error,
        child: Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(right: AppSpacing.l),
            child: Icon(AppIcons.deleteOutline, color: colors.onError),
          ),
        ),
      ),
    );
  }
}
