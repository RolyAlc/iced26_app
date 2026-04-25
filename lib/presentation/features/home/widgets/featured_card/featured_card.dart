import 'package:flutter/material.dart';
import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/presentation/features/event/viewmodel/models/event_ui_model.dart';
import 'package:iced26/presentation/features/home/widgets/featured_card/featured_card_content.dart';
import 'package:iced26/presentation/features/home/widgets/featured_card/featured_card_footer.dart';
import 'package:iced26/presentation/widgets/app_card.dart';

/// Tarjeta que muestra el evento destacado con los mejores horarios.
/// Orquesta el contenido principal y el footer de la tarjeta.
class FeaturedCard extends StatelessWidget {
  final EventUIModel event;

  const FeaturedCard({super.key, required this.event});

  /// Ancho relativo en el carrusel.
  static const double widthFactor = 0.85;

  /// Relación de aspecto editorial.
  static const double aspectRatio = 0.82;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return AppCard(
      onTap: () {},
      borderRadius: AppRadius.container,
      color: colors.surfaceContainerLowest,
      padding: const EdgeInsets.all(AppSpacing.l),
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
