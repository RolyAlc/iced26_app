import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/di/domain_providers.dart';
import 'package:iced26/presentation/features/home/viewmodel/models/event_ui_model.dart';
import 'package:iced26/presentation/features/home/widgets/featured_card/featured_card_content.dart';
import 'package:iced26/presentation/features/home/widgets/featured_card/featured_card_footer.dart';
import 'package:iced26/presentation/features/schedule/view/widgets/event_detail_sheet.dart';
import 'package:iced26/presentation/shared/widgets/app_card.dart';

/// Tarjeta de evento destacado.
///
/// Es el punto de entrada al estado de "guardado" — centraliza el watch
/// de providers para que [FeaturedCardFooter] sea un widget puramente
/// presentacional.
class FeaturedCard extends ConsumerWidget {
  const FeaturedCard({super.key, required this.event});
  final EventUIModel event;

  static const double widthFactor = 0.92;
  static const double aspectRatio = 0.82;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteIds = ref.watch(
      favoriteIdsProvider.select((ids) => ids.value ?? <String>{}),
    );
    final isSaved = favoriteIds.contains(event.id);
    final colors = Theme.of(context).colorScheme;

    return AppCard(
      onTap: () => showEventDetail(context, event.event),
      borderRadius: AppRadius.container,
      color: colors.surfaceContainerHigh,
      padding: const EdgeInsets.all(AppSpacing.m),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: FeaturedCardContent(event: event)),
          const SizedBox(height: AppSpacing.l),
          FeaturedCardFooter(
            event: event,
            isSaved: isSaved,
            onToggle: () {
              HapticFeedback.lightImpact();
              ref.read(toggleFavoriteUseCaseProvider).execute(event.id);
            },
          ),
        ],
      ),
    );
  }
}
