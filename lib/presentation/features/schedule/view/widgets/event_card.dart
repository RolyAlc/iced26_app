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
import 'package:iced26/presentation/features/schedule/view/widgets/schedule_card_row.dart';
import 'package:iced26/presentation/shared/helpers/event_type_style.dart';
import 'package:iced26/presentation/shared/widgets/app_card.dart';

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
        child: ScheduleCardRow(
          title: viewModel.title,
          infoBadges: [
            if (event.subtype != null && event.subtype!.isNotEmpty)
              ScheduleInfoChip(
                label: event.subtype!,
                icon: event.type.style(Theme.of(context).colorScheme).icon,
              ),
          ],
          time: viewModel.time,
          isLive: viewModel.isLive,
          topAction: _BookmarkButton(
            eventId: event.id,
            isFavorite: viewModel.isFavorite,
          ),
          bottomAction: _ChevronIcon(),
        ),
      ),
    );
  }

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

/// Icono final de navegación
class _ChevronIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Icon(
      AppIcons.chevronRight,
      color: colors.onSurfaceVariant,
      size: 22,
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
      style: IconButton.styleFrom(
        backgroundColor: isFavorite
            ? colors.tertiary.withValues(alpha: 0.15)
            : null,
        foregroundColor: isFavorite ? colors.tertiary : colors.onSurfaceVariant,
      ),
      icon: Icon(
        isFavorite ? AppIcons.bookmarkOn : AppIcons.bookmarkOff,
        size: 20,
      ),
      onPressed: () {
        HapticFeedback.lightImpact();
        ref.read(toggleFavoriteUseCaseProvider).execute(eventId);
      },
      visualDensity: VisualDensity.compact,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
    );
  }
}
