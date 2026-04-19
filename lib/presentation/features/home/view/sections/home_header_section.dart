import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:iced26/presentation/app/widgets/smart_search_bar.dart';
import 'package:iced26/core/constants/assets.dart';
import 'package:iced26/presentation/app/state/search_provider.dart';

/// Sección de encabezado en la pantalla principal
/// Muestra el logo, la fecha y una barra de búsqueda.
class HomeHeaderSection extends ConsumerWidget {
  const HomeHeaderSection({
    super.key,
    required this.today,
    required this.infoLabel,
  });

  final DateTime today;
  final String infoLabel;

  /// Construye la sección del encabezado.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final searchNotifier = ref.watch(searchProvider.notifier);
    final String dateLabel = MaterialLocalizations.of(
      context,
    ).formatFullDate(today);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Fila superior: Logo e Información
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildLogo(),
            _buildInfoColumn(dateLabel, colorScheme, textTheme),
          ],
        ),
        const SizedBox(height: 8),
        SmartSearchBar(searchNotifier: searchNotifier),
      ],
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
        const SizedBox(height: 4),
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
