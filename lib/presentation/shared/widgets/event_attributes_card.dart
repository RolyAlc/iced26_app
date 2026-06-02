import 'package:flutter/material.dart';
import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/presentation/shared/widgets/attribute_cell.dart';

class AttributeCellData {
  const AttributeCellData({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;
}

/// Grid 2 columnas de celdas icono+etiqueta+valor — acepta cualquier número
/// par de [cells] y separa las filas con un divider sutil.
class EventAttributesCard extends StatelessWidget {
  const EventAttributesCard({super.key, required this.cells})
    : assert(cells.length % 2 == 0, 'cells must be even — rendered in pairs');

  final List<AttributeCellData> cells;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final rows = <Widget>[];
    for (var i = 0; i < cells.length; i += 2) {
      if (i > 0) {
        rows.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.s),
            child: Divider(
              height: 1,
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.2),
            ),
          ),
        );
      }
      rows.add(
        Row(
          children: [
            Expanded(
              child: AttributeCell(
                icon: cells[i].icon,
                label: cells[i].label,
                value: cells[i].value,
              ),
            ),
            Expanded(
              child: AttributeCell(
                icon: cells[i + 1].icon,
                label: cells[i + 1].label,
                value: cells[i + 1].value,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(AppSpacing.m),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppRadius.m),
      ),
      child: Column(children: rows),
    );
  }
}
