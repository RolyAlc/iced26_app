import 'package:flutter/material.dart';
import 'package:iced26/core/constants/assets.dart';

class HomeHeaderSection extends StatelessWidget {
  const HomeHeaderSection({super.key, required this.dayLabel});

  final String dayLabel;

  @override
  Widget build(BuildContext context) {
    // Mostramos logo a la izquierda y fecha a la derecha.
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image.asset(Assets.logoIced26, width: 120, fit: BoxFit.contain),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              children: [
                const Icon(Icons.calendar_month, size: 18),
                const SizedBox(width: 6),
                Text(
                  dayLabel.isEmpty ? 'Fecha pendiente' : dayLabel,
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 4),
            const Text(
              'Welcome to day 1 of 4',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ],
    );
  }
}
