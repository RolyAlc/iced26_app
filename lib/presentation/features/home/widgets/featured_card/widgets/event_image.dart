import 'package:flutter/material.dart';
import 'package:iced26/core/constants/assets.dart';
import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/presentation/features/home/viewmodel/models/event_ui_model.dart';
import 'package:iced26/presentation/shared/widgets/app_network_image.dart';

/// Evento imagen destacada
class EventImage extends StatelessWidget {
  const EventImage({super.key, required this.event});
  final EventUIModel event;

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
        placeholder: const AppNetworkImageAssetPlaceholder(
          assetPath: Assets.expressiveShape,
        ),
      ),
    );
  }
}
