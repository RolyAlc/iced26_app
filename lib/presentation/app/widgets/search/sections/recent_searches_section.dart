import 'package:flutter/material.dart';

import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/presentation/app/widgets/search/widgets/recent_query_tile.dart';
import 'package:iced26/presentation/app/widgets/search/widgets/section_label.dart';

/// Sección que muestra las búsquedas recientes.
class RecentSearchesSection extends StatelessWidget {
  final List<String> queries;
  final ValueChanged<String> onQueryTap;
  final ValueChanged<String> onRemove;
  final VoidCallback onClearAll;

  const RecentSearchesSection({
    super.key,
    required this.queries,
    required this.onQueryTap,
    required this.onRemove,
    required this.onClearAll,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SectionLabel(label: 'Recent'),
            TextButton(
              onPressed: onClearAll,
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'Clear all',
                style: theme.textTheme.labelSmall?.copyWith(
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
