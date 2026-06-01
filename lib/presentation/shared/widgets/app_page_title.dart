import 'package:flutter/material.dart';

import 'package:iced26/core/constants/design_tokens.dart';

/// Cabecera estándar de pantalla: título grande + trailing opcional.
///
/// [trailing] debe usar `materialTapTargetSize: MaterialTapTargetSize.shrinkWrap`
/// (o equivalente) si es un chip o botón — de lo contrario su tap target de 48dp
/// infla la Row y el header queda más alto que el de otras screens.
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
        children: [
          Expanded(
            child: Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}
