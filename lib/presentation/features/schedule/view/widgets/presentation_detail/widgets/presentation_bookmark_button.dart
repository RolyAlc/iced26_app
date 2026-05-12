import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:iced26/presentation/app/theme/app_icons.dart';

import 'package:iced26/di/domain_providers.dart';

/// extrae el Consumer de favoritos para no hacer ConsumerWidget al widget padre.
class PresentationBookmarkButton extends ConsumerWidget {
  final String presentationId;

  const PresentationBookmarkButton({super.key, required this.presentationId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final favoriteIds = ref.watch(presentationFavoriteIdsProvider).value ?? {};
    final isFavorite = favoriteIds.contains(presentationId);

    return IconButton(
      icon: Icon(
        isFavorite ? AppIcons.bookmarkOn : AppIcons.bookmarkOutline,
        color: isFavorite ? colors.primary : colors.onSurfaceVariant,
        size: 22,
      ),
      onPressed: () {
        HapticFeedback.lightImpact();
        ref
            .read(togglePresentationFavoriteUseCaseProvider)
            .execute(presentationId);
      },
      visualDensity: VisualDensity.compact,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
    );
  }
}
