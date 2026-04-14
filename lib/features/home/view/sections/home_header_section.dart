import 'package:flutter/material.dart';

import 'package:iced26/core/constants/assets.dart';
import 'package:iced26/features/home/view/sections/home_search_section.dart';

class HomeHeaderSection extends StatelessWidget {
  const HomeHeaderSection({
    super.key,
    required this.today,
    required this.infoLabel,
  });

  final DateTime today;
  final String infoLabel;

  @override
  Widget build(BuildContext context) {
    final locale = MaterialLocalizations.of(context);
    final dateLabel = locale.formatFullDate(today);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              flex: 2,
              child: Image.asset(
                Assets.logoIced26,
                height: 56,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Icon(Icons.calendar_month, size: 18),
                      const SizedBox(width: 6),
                      Text(dateLabel, style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    infoLabel,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        const HomeSearchSection(),
      ],
    );
  }
}
