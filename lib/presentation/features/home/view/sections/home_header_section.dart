import 'package:flutter/material.dart';

import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/core/constants/assets.dart';

/// Sección de encabezado scrollable — logo + info de conferencia.
/// La barra de búsqueda vive en el header pinned de AppPage.
class HomeHeaderSection extends StatelessWidget {
  const HomeHeaderSection({
    super.key,
    required this.today,
    required this.infoLabel,
  });

  final DateTime today;
  final String infoLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final String dateLabel = MaterialLocalizations.of(
      context,
    ).formatFullDate(today);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.l,
        vertical: AppSpacing.m,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildLogo(),
          _buildInfoColumn(dateLabel, colorScheme, textTheme),
        ],
      ),
    );
  }

  /// Sub-widget para el Logo
  Widget _buildLogo() {
    return Image.asset(Assets.logoIced26, height: 48, fit: BoxFit.contain);
  }

  /// Sub-widget para la información de fecha y etiqueta
  Widget _buildInfoColumn(
    String dateLabel,
    ColorScheme colors,
    TextTheme texts,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.calendar_month_outlined,
              size: 14,
              color: colors.primary,
            ),
            const SizedBox(width: 4),
            Text(
              dateLabel,
              style: texts.labelSmall?.copyWith(color: colors.onSurfaceVariant),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          infoLabel,
          style: texts.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: colors.primary,
          ),
        ),
      ],
    );
  }
}
