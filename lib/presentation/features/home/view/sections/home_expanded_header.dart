import 'package:flutter/material.dart';

import 'package:iced26/core/constants/assets.dart';
import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/presentation/app/state/search_provider.dart';
import 'package:iced26/presentation/app/theme/app_icons.dart';
import 'package:iced26/presentation/shared/widgets/smart_search_bar.dart';

const double _kLogoHeight = 48.0;
const double _kDateIconSize = 14.0;

/// Header expandido de la pantalla de inicio: logo, fecha, infoLabel y barra de búsqueda.
class HomeExpandedHeader extends StatelessWidget {
  const HomeExpandedHeader({
    super.key,
    required this.infoLabel,
    required this.today,
    required this.searchNotifier,
  });

  final String infoLabel;
  final DateTime today;
  final Search searchNotifier;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final dateLabel = MaterialLocalizations.of(context).formatFullDate(today);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppLayout.horizontalPadding(context),
            vertical: AppSpacing.m,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildLogo(),
              _buildDateInfo(theme, colorScheme, dateLabel),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l),
          child: SmartSearchBar(searchNotifier: searchNotifier),
        ),
      ],
    );
  }

  Widget _buildLogo() {
    return Image.asset(
      Assets.logoIced26,
      height: _kLogoHeight,
      fit: BoxFit.contain,
    );
  }

  Widget _buildDateInfo(
    ThemeData theme,
    ColorScheme colorScheme,
    String dateLabel,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              AppIcons.calendarOutline,
              size: _kDateIconSize,
              color: colorScheme.primary,
            ),
            const SizedBox(width: AppSpacing.xs),
            Text(
              dateLabel,
              style: theme.textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          infoLabel,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.primary,
          ),
        ),
      ],
    );
  }
}
