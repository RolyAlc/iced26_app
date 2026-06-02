import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/l10n/app_localizations.dart';
import 'package:iced26/presentation/app/state/theme_mode_provider.dart';
import 'package:iced26/presentation/app/theme/app_icons.dart';
import 'package:iced26/presentation/features/settings/widgets/settings_section.dart';
import 'package:iced26/presentation/shared/utils/theme_mode_l10n.dart';
import 'package:iced26/presentation/shared/widgets/theme_mode_selector.dart';

/// Ítem de tema: muestra el modo activo y abre el picker al tocar.
class ThemeItem extends ConsumerWidget {
  const ThemeItem({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final mode = ref.watch(themeModeProvider).value ?? ThemeMode.system;

    return SettingsItem(
      icon: AppIcons.forThemeMode(mode),
      title: l10n.settingsThemeTitle,
      subtitle: themeModeLabel(mode, l10n),
      onTap: () {
        showDialog<void>(
          context: context,
          builder: (_) {
            return _ThemePickerDialog(initialMode: mode);
          },
        );
      },
    );
  }
}

/// Diálogo de selección de tema con preview de colores en tiempo real.
/// Aplica el cambio al instante para que el usuario vea el resultado; Cancel revierte.
class _ThemePickerDialog extends ConsumerStatefulWidget {
  const _ThemePickerDialog({required this.initialMode});

  final ThemeMode initialMode;

  @override
  ConsumerState<_ThemePickerDialog> createState() => _ThemePickerDialogState();
}

/// Estado del diálogo de selección de tema.
class _ThemePickerDialogState extends ConsumerState<_ThemePickerDialog> {
  late ThemeMode _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialMode;
  }

  /// Aplica el tema inmediatamente para el preview reactivo.
  void _select(ThemeMode mode) {
    setState(() {
      _selected = mode;
    });
    ref.read(themeModeProvider.notifier).setMode(mode);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isLandscape =
        MediaQuery.orientationOf(context) == Orientation.landscape;

    return AlertDialog(
      title: Text(l10n.settingsThemeTitle),
      contentPadding: EdgeInsets.only(
        top: AppSpacing.s,
        left: isLandscape ? AppSpacing.m : 0,
        right: isLandscape ? AppSpacing.m : 0,
        bottom: isLandscape ? AppSpacing.m : 0,
      ),
      content: isLandscape
          ? SizedBox(
              width: double.maxFinite,
              child: ThemeModeSelector(selected: _selected, onChanged: _select),
            )
          : RadioGroup<ThemeMode>(
              groupValue: _selected,
              onChanged: (v) {
                if (v != null) {
                  _select(v);
                }
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (final mode in ThemeMode.values)
                    _ThemeOptionTile(mode: mode),
                ],
              ),
            ),
      actions: [
        TextButton(
          onPressed: () {
            // Descarta el cambio si el usuario no confirma.
            if (_selected != widget.initialMode) {
              ref.read(themeModeProvider.notifier).setMode(widget.initialMode);
            }
            Navigator.pop(context);
          },
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(l10n.done),
        ),
      ],
    );
  }
}

/// Fila de opción de tema con radio, icono y etiqueta.
class _ThemeOptionTile extends StatelessWidget {
  const _ThemeOptionTile({required this.mode});

  final ThemeMode mode;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Material(
      color: Colors.transparent,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.m),
      ),
      child: RadioListTile<ThemeMode>(
        value: mode,
        contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
        title: Row(
          children: [
            Icon(AppIcons.forThemeMode(mode), size: 20),
            const SizedBox(width: AppSpacing.s),
            Text(
              themeModeLabel(mode, l10n),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
