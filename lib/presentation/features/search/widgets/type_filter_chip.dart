import 'package:flutter/material.dart';

import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/domain/entities/event_type.dart';
import 'package:iced26/presentation/features/search/widgets/chip_container.dart';
import 'package:iced26/presentation/features/search/widgets/filter_chip.dart';
import 'package:iced26/presentation/shared/helpers/event_type_style.dart';

/// Chip que filtra por tipo de evento.
class TypeFilterChip extends StatelessWidget {
  final EventType type;
  final bool selected;
  final VoidCallback onTap;

  const TypeFilterChip({
    super.key,
    required this.type,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final style = type.style(colors);

    return ChipContainer(
      selected: selected,
      accentColor: style.color,
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            style.icon,
            size: 16,
            color: selected ? style.color : colors.onSurfaceVariant,
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(
            type.label,
            style: chipLabelStyle(
              theme.textTheme,
              selected: selected,
              color: selected ? style.color : colors.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
