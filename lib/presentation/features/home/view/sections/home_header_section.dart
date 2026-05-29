import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:iced26/core/constants/assets.dart';
import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/presentation/app/state/search_provider.dart';
import 'package:iced26/presentation/app/theme/app_icons.dart';
import 'package:iced26/presentation/shared/widgets/smart_search_bar.dart';

const double _kBadgeSize = 8.0;
const double _kBadgeOffset = -3.0;

/// Encabezado colapsado — logo + accesos directos a búsqueda y filtros.
class HomeHeaderSection extends ConsumerWidget {
  const HomeHeaderSection({super.key, required this.searchNotifier});

  final Search searchNotifier;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFilterActive = ref.watch(
      searchProvider.select((s) => s.filters.isActive),
    );
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppLayout.horizontalPadding(context),
        vertical: AppSpacing.m,
      ),
      child: Row(
        children: [
          Image.asset(Assets.logoIced26, height: 48, fit: BoxFit.contain),
          const Spacer(),
          _HeaderIconButton(
            icon: AppIcons.search,
            color: colors,
            onTap: () => SmartSearchBar.open(context, searchNotifier),
          ),
          const SizedBox(width: AppSpacing.xs),
          _HeaderIconButton(
            icon: AppIcons.filter,
            color: colors,
            onTap: () => SmartSearchBar.open(
              context,
              searchNotifier,
              expandFilters: true,
            ),
            badge: isFilterActive,
          ),
        ],
      ),
    );
  }
}

/// Botón de icono con estilo consistente al de la search bar expandida.
class _HeaderIconButton extends StatelessWidget {
  const _HeaderIconButton({
    required this.icon,
    required this.color,
    required this.onTap,
    this.badge = false,
  });

  final IconData icon;
  final ColorScheme color;
  final VoidCallback onTap;
  final bool badge;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.l),
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: color.primaryContainer,
          borderRadius: BorderRadius.circular(AppRadius.l),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Icon(icon, color: color.onPrimaryContainer),
            if (badge)
              Positioned(
                top: _kBadgeOffset,
                right: _kBadgeOffset,
                child: Container(
                  width: _kBadgeSize,
                  height: _kBadgeSize,
                  decoration: BoxDecoration(
                    color: color.primary,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
