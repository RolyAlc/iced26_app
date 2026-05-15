import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/di/domain_providers.dart';
import 'package:iced26/domain/entities/event.dart';
import 'package:iced26/domain/entities/event_status.dart';
import 'package:iced26/domain/logic/event_status_resolver.dart';
import 'package:iced26/presentation/app/theme/app_icons.dart';
import 'package:iced26/presentation/features/schedule/view/widgets/event_detail_sheet.dart';
import 'package:iced26/presentation/shared/widgets/app_card.dart';
import 'package:iced26/presentation/shared/widgets/slot_time_label.dart';

/// Tarjeta principal de evento.
class EventCard extends ConsumerWidget {
  const EventCard({super.key, required this.event});
  final Event event;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = _buildViewModel(context, ref);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: AppCard(
        onTap: () => _onTap(context),
        bordered: true,
        child: _EventContent(viewModel: viewModel, eventId: event.id),
      ),
    );
  }

  /// Construye todos los datos derivados necesarios para la UI
  /// MEJORA: separa lógica de presentación del widget
  _EventViewModel _buildViewModel(BuildContext context, WidgetRef ref) {
    final locale = Localizations.localeOf(context).languageCode;

    final isLive = EventStatusResolver.resolve(event) == EventStatus.live;

    final isFavorite = ref.watch(
      favoriteIdsProvider.select(
        (ids) => ids.value?.contains(event.id) ?? false,
      ),
    );

    return _EventViewModel(
      title: event.title.resolve(locale),
      time: event.filterTime,
      isLive: isLive,
      isFavorite: isFavorite,
    );
  }

  /// Acción al pulsar la card
  void _onTap(BuildContext context) {
    showEventDetail(context, event);
  }
}

/// Modelo de datos para la UI
class _EventViewModel {
  const _EventViewModel({
    required this.title,
    required this.time,
    required this.isLive,
    required this.isFavorite,
  });
  final String title;
  final String? time;
  final bool isLive;
  final bool isFavorite;
}

/// Contenido interno de la card
class _EventContent extends StatelessWidget {
  const _EventContent({required this.viewModel, required this.eventId});
  final _EventViewModel viewModel;
  final String eventId;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.m,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          if (viewModel.time != null) ...[
            SlotTimeLabel(time: viewModel.time!, isLive: viewModel.isLive),
            const SizedBox(width: AppSpacing.sm),
          ],
          Expanded(child: _EventTitle(title: viewModel.title)),
          _BookmarkButton(eventId: eventId, isFavorite: viewModel.isFavorite),
          _ChevronIcon(),
        ],
      ),
    );
  }
}

/// Widget separado para el título
class _EventTitle extends StatelessWidget {
  const _EventTitle({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(
        context,
      ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }
}

/// Icono final de navegación
class _ChevronIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Icon(
      AppIcons.chevronRight,
      color: Theme.of(context).colorScheme.outline,
      size: 20,
    );
  }
}

/// Botón para marcar como favorito.
class _BookmarkButton extends ConsumerWidget {
  const _BookmarkButton({required this.eventId, required this.isFavorite});
  final String eventId;
  final bool isFavorite;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;

    return IconButton(
      icon: Icon(
        isFavorite ? AppIcons.bookmarkOn : AppIcons.bookmarkOff,
        color: isFavorite ? colors.primary : colors.onSurfaceVariant,
        size: 20,
      ),
      onPressed: () {
        HapticFeedback.lightImpact();
        ref.read(toggleFavoriteUseCaseProvider).execute(eventId);
      },
      visualDensity: VisualDensity.compact,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
    );
  }
}
