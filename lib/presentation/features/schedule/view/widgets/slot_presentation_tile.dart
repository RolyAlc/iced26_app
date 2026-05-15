import 'package:flutter/material.dart';

import 'package:iced26/domain/entities/person.dart';
import 'package:iced26/domain/entities/presentation.dart';
import 'package:iced26/presentation/app/theme/app_icons.dart';
import 'package:iced26/presentation/features/schedule/view/widgets/presentation_detail/presentation_detail_sheet.dart';

class SlotPresentationTile extends StatelessWidget {
  const SlotPresentationTile({
    super.key,
    required this.presentation,
    required this.peopleIndex,
  });
  final Presentation presentation;
  final Map<String, Person> peopleIndex;

  String? _speakerNames(String locale) {
    final names = presentation.speakers
        .map((s) => peopleIndex[s.personId]?.name.resolve(locale))
        .whereType<String>()
        .toList();
    return switch (names.length) {
      0 => null,
      1 => names.first,
      _ => '${names.first} & +${names.length - 1} more',
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final title = presentation.resolvedTitle(locale);
    final speakerNames = _speakerNames(locale);

    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(
            title,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: speakerNames != null
              ? Text(
                  speakerNames,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                )
              : null,
          trailing: Icon(
            AppIcons.chevronRight,
            color: theme.colorScheme.outline,
          ),
          onTap: () => showPresentationDetail(context, presentation),
        ),
        Divider(
          height: 1,
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.15),
        ),
      ],
    );
  }
}
