import 'package:flutter/material.dart';
import 'package:iced26/core/constants/design_tokens.dart';

/// Row con icono y texto para mostrar información del evento.
class InfoRow extends StatelessWidget {
  const InfoRow({
    super.key,
    required this.icon,
    required this.text,
    required this.color,
    this.style,
  });
  final IconData icon;
  final String text;
  final TextStyle? style;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: AppIconSize.inline, color: color),
        const SizedBox(width: AppSpacing.xs),
        Flexible(
          child: Text(
            text,
            style: style,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ],
    );
  }
}
