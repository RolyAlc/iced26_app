import 'package:flutter/material.dart';

import 'package:iced26/core/constants/app_strings.dart';
import 'package:iced26/presentation/app/theme/app_icons.dart';

/// Tile que muestra una búsqueda reciente.
class RecentQueryTile extends StatelessWidget {
  const RecentQueryTile({
    super.key,
    required this.query,
    required this.onTap,
    required this.onRemove,
  });
  final String query;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(AppIcons.history, size: 20, color: colors.onSurfaceVariant),
      title: Text(query, style: theme.textTheme.bodyMedium),
      trailing: IconButton(
        tooltip: AppStrings.searchRemoveRecent,
        icon: Icon(AppIcons.close, size: 18, color: colors.onSurfaceVariant),
        onPressed: onRemove,
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
      ),
      onTap: onTap,
    );
  }
}
