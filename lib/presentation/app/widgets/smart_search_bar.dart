import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/presentation/app/theme/app_icons.dart';
import 'package:iced26/presentation/app/state/search_provider.dart';
import 'package:iced26/presentation/app/widgets/search/search_modal_body.dart';

class SmartSearchBar extends ConsumerWidget {
  final Search searchNotifier;

  const SmartSearchBar({super.key, required this.searchNotifier});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFilterActive = ref.watch(
      searchProvider.select((s) => s.filters.isActive),
    );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.l),
        onTap: () => open(context, searchNotifier),
        child: _SearchBarVisualContainer(
          isFilterActive: isFilterActive,
          onFilterTap: () => open(context, searchNotifier, expandFilters: true),
        ),
      ),
    );
  }

  static void open(
    BuildContext context,
    Search notifier, {
    bool expandFilters = false,
  }) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, _) =>
            _SearchScreen(notifier: notifier, expandFilters: expandFilters),
        transitionsBuilder: (context, animation, _, child) {
          final curved = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOut,
          );
          return FadeTransition(
            opacity: curved,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.04),
                end: Offset.zero,
              ).animate(curved),
              child: child,
            ),
          );
        },
        transitionDuration: AppDuration.medium,
        reverseTransitionDuration: AppDuration.fast,
      ),
    );
  }
}

class _SearchScreen extends StatelessWidget {
  final Search notifier;
  final bool expandFilters;

  const _SearchScreen({required this.notifier, required this.expandFilters});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.l,
            AppSpacing.m,
            AppSpacing.l,
            AppSpacing.m,
          ),
          child: SearchModalBody(
            notifier: notifier,
            initiallyExpandedFilters: expandFilters,
          ),
        ),
      ),
    );
  }
}

class _SearchBarVisualContainer extends StatelessWidget {
  final bool isFilterActive;
  final VoidCallback onFilterTap;

  const _SearchBarVisualContainer({
    required this.isFilterActive,
    required this.onFilterTap,
  });

  static const double _height = 56;
  static const EdgeInsets _padding = EdgeInsets.symmetric(
    horizontal: AppSpacing.m,
  );

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      height: _height,
      padding: _padding,
      decoration: BoxDecoration(
        color: Color.alphaBlend(
          colors.primary.withValues(alpha: 0.08),
          colors.surface,
        ),
        borderRadius: BorderRadius.circular(AppRadius.l),
        border: Border.all(color: colors.outlineVariant, width: 1.2),
      ),
      child: Row(
        children: [
          Icon(AppIcons.search, color: colors.primary),
          const SizedBox(width: AppSpacing.sm),
          const Expanded(child: Text('Search sessions, authors, rooms...')),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onFilterTap,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xs),
              child: _FilterIcon(isActive: isFilterActive, colors: colors),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterIcon extends StatelessWidget {
  final bool isActive;
  final ColorScheme colors;

  const _FilterIcon({required this.isActive, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Icon(
          AppIcons.filter,
          color: isActive ? colors.primary : colors.secondary,
        ),
        if (isActive)
          Positioned(
            top: -3,
            right: -3,
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: colors.primary,
                shape: BoxShape.circle,
              ),
            ),
          ),
      ],
    );
  }
}
