import 'package:flutter/material.dart';

import 'package:iced26/core/constants/design_tokens.dart';

/// Cabecera estándar de pantalla: título grande + trailing opcional.
class AppPageTitle extends StatelessWidget {
  const AppPageTitle({super.key, required this.title, this.trailing});

  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppLayout.horizontalPadding(context),
        AppSpacing.xl,
        AppLayout.horizontalPadding(context),
        AppSpacing.m,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          trailing ?? const SizedBox.shrink(),
        ],
      ),
    );
  }
}
