import 'package:flutter/material.dart';

import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/core/constants/assets.dart';
import 'package:iced26/presentation/app/theme/app_icons.dart';

/// Sección de encabezado scrollable — logo + icono de búsqueda.
class HomeHeaderSection extends StatelessWidget {
  const HomeHeaderSection({super.key, required this.onSearchTap});

  final VoidCallback onSearchTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.l,
        vertical: AppSpacing.m,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(Assets.logoIced26, height: 48, fit: BoxFit.contain),
          IconButton(
            onPressed: onSearchTap,
            icon: Icon(AppIcons.search, color: colorScheme.primary),
            style: IconButton.styleFrom(
              backgroundColor: colorScheme.primary.withValues(alpha: 0.08),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.l),
                side: BorderSide(color: colorScheme.outlineVariant, width: 1.2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
