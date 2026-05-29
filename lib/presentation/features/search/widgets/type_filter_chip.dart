import 'package:flutter/material.dart';

import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/domain/entities/event_type.dart';
import 'package:iced26/presentation/features/search/widgets/chip_container.dart';
import 'package:iced26/presentation/shared/helpers/event_type_style.dart';

const _kChipIconSize = 16.0;

/// Chip que filtra por tipo de evento.
class TypeFilterChip extends StatelessWidget {
  const TypeFilterChip({
    super.key,
    required this.type,
    required this.selected,
    required this.onTap,
  });
  final EventType type;
  final bool selected;
  final VoidCallback onTap;

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
            size: _kChipIconSize,
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
