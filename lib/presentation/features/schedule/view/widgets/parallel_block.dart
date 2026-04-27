import 'package:flutter/material.dart';

import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/domain/entities/event.dart';
import 'package:iced26/domain/entities/event_type.dart';
import 'package:iced26/presentation/app/widgets/app_bottom_sheet.dart';
import 'package:iced26/presentation/helpers/event_type_style.dart';
import 'package:iced26/presentation/features/schedule/view/widgets/event_card.dart';
import 'package:iced26/presentation/features/schedule/view/widgets/event_detail_sheet.dart';
import 'package:iced26/presentation/features/schedule/viewmodel/models/schedule_state.dart';
import 'package:iced26/presentation/widgets/app_card.dart';

/// Bloque de eventos paralelos.
class ParallelBlock extends StatelessWidget {
  final ParallelGroupItem group;

  const ParallelBlock({super.key, required this.group});

  String get _typeLabel =>
      group.type == EventType.workshop ? 'Workshops' : 'Sessions';
  String get _title => '${group.events.length} Parallel $_typeLabel';

  void _showSheet(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    AppBottomSheet.show(
      context: context,
      title: _title,
      child: Column(
        children: group.events
            .map((e) => _ParallelEventOption(event: e, locale: locale))
            .toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = resolveTypeStyle(context, group.type);
    final time = group.events.isNotEmpty ? group.events.first.filterTime : null;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: AppCard(
        onTap: () => _showSheet(context),
        borderRadius: AppRadius.m,
        bordered: true,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.m),
          child: Row(
            children: [
              TypeIcon(style: style, badge: group.events.length),
              const SizedBox(width: AppSpacing.m),
              Expanded(
                child: _ParallelContent(title: _title, time: time),
              ),
              const SizedBox(width: AppSpacing.s),
              Icon(Icons.expand_more, color: theme.colorScheme.outline),
            ],
          ),
        ),
      ),
    );
  }
}

/// Contenido del bloque paralelo.
class _ParallelContent extends StatelessWidget {
  final String title;
  final String? time;

  const _ParallelContent({required this.title, this.time});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        if (time != null)
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.xs),
            child: Text(
              time!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
      ],
    );
  }
}

/// Opción de evento paralelo en un sheet.
class _ParallelEventOption extends StatelessWidget {
  final Event event;
  final String locale;

  const _ParallelEventOption({required this.event, required this.locale});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        event.title.resolve(locale),
        style: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: event.filterTime != null
          ? Text(
              event.filterTime!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            )
          : null,
      trailing: Icon(Icons.chevron_right, color: theme.colorScheme.outline),
      onTap: () => showDetailSheet(context, event),
    );
  }
}
