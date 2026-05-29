import 'package:flutter/material.dart';
import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/presentation/app/theme/app_icons.dart';
import 'package:url_launcher/url_launcher.dart';

const _kAboutLabel = 'About the presentation';
const _kVideoLabel = 'Watch video';

/// enlaza a recursos externos del JSON — usa url_launcher para salir de la app.
class PresentationLinkButtons extends StatelessWidget {
  const PresentationLinkButtons({super.key, this.aboutUrl, this.videoUrl});
  final String? aboutUrl;
  final String? videoUrl;

  Future<void> _open(String url) async {
    final uri = Uri.tryParse(url);
    if (uri != null) await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Wrap(
      spacing: AppSpacing.s,
      runSpacing: AppSpacing.s,
      children: [
        if (aboutUrl != null)
          OutlinedButton.icon(
            onPressed: () {
              _open(aboutUrl!);
            },
            icon: const Icon(AppIcons.info, size: 18),
            label: const Text(_kAboutLabel),
            style: OutlinedButton.styleFrom(
              foregroundColor: theme.colorScheme.primary,
              side: BorderSide(color: theme.colorScheme.outline),
              textStyle: theme.textTheme.labelMedium,
            ),
          ),
        if (videoUrl != null)
          OutlinedButton.icon(
            onPressed: () {
              _open(videoUrl!);
            },
            icon: const Icon(AppIcons.playCircleOutline, size: 18),
            label: const Text(_kVideoLabel),
            style: OutlinedButton.styleFrom(
              foregroundColor: theme.colorScheme.primary,
              side: BorderSide(color: theme.colorScheme.outline),
              textStyle: theme.textTheme.labelMedium,
            ),
          ),
      ],
    );
  }
}
