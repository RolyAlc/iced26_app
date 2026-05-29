import 'package:flutter/material.dart';

import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/l10n/app_localizations.dart';
import 'package:iced26/presentation/features/search/widgets/recent_query_tile.dart';
import 'package:iced26/presentation/features/search/widgets/section_label.dart';

/// Sección que muestra las búsquedas recientes.
class RecentSearchesSection extends StatelessWidget {
  const RecentSearchesSection({
    super.key,
    required this.queries,
    required this.onQueryTap,
    required this.onRemove,
    required this.onClearAll,
  });
  final List<String> queries;
  final ValueChanged<String> onQueryTap;
  final ValueChanged<String> onRemove;
  final VoidCallback onClearAll;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SectionLabel(label: l10n.searchRecentTitle),
            GestureDetector(
              onTap: onClearAll,
              child: Text(
                l10n.searchClearAll,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: colors.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        ...queries.map(
          (query) => RecentQueryTile(
            query: query,
            onTap: () => onQueryTap(query),
            onRemove: () => onRemove(query),
          ),
        ),
      ],
    );
  }
}
