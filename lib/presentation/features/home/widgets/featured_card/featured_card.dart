import 'package:flutter/material.dart';

import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/presentation/features/home/viewmodel/models/event_ui_model.dart';
import 'package:iced26/presentation/features/home/widgets/featured_card/featured_card_content.dart';
import 'package:iced26/presentation/features/home/widgets/featured_card/featured_card_footer.dart';
import 'package:iced26/presentation/features/schedule/view/widgets/event_detail_sheet.dart';
import 'package:iced26/presentation/shared/widgets/app_card.dart';

/// Tarjeta de evento destacado.
class FeaturedCard extends StatelessWidget {
  const FeaturedCard({super.key, required this.event});
  final EventUIModel event;

  static const double widthFactor = 0.85;
  static const double aspectRatio = 0.82;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return AppCard(
      onTap: () => showEventDetail(context, event.event),
      borderRadius: AppRadius.container,
      color: colors.surfaceContainer,
      padding: const EdgeInsets.all(AppSpacing.m),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: FeaturedCardContent(event: event)),
          const SizedBox(height: AppSpacing.l),
          FeaturedCardFooter(event: event),
        ],
      ),
    );
  }
}
