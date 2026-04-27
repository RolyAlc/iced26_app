import 'package:flutter/material.dart';
import 'package:iced26/core/constants/assets.dart';
import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/presentation/features/event/viewmodel/models/event_ui_model.dart';
import 'package:iced26/presentation/widgets/app_network_image.dart';

/// Evento imagen destacada
class EventImage extends StatelessWidget {
  final EventUIModel event;

  const EventImage({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      height: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.m),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: AppNetworkImage(
        url: event.imageUrl ?? '',
        fit: BoxFit.cover,
        placeholder: AppNetworkImageAssetPlaceholder(
          assetPath: Assets.expressiveShape,
        ),
      ),
    );
  }
}
