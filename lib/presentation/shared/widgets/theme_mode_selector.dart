import 'package:flutter/material.dart';
import 'package:iced26/l10n/app_localizations.dart';
import 'package:iced26/presentation/app/theme/app_icons.dart';

/// Selector de modo de tema como [SegmentedButton].
///
/// Widget puramente presentacional: recibe el valor seleccionado y notifica
/// cambios mediante [onChanged]. El llamador gestiona el estado y el provider.
class ThemeModeSelector extends StatelessWidget {
  const ThemeModeSelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final ThemeMode selected;
  final ValueChanged<ThemeMode> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return SegmentedButton<ThemeMode>(
      segments: [
        ButtonSegment<ThemeMode>(
          value: ThemeMode.light,
          icon: const Icon(AppIcons.lightTheme),
          label: Text(l10n.settingsThemeLight),
        ),
        ButtonSegment<ThemeMode>(
          value: ThemeMode.system,
          icon: const Icon(AppIcons.systemTheme),
          label: Text(l10n.settingsThemeSystem),
        ),
        ButtonSegment<ThemeMode>(
          value: ThemeMode.dark,
          icon: const Icon(AppIcons.darkTheme),
          label: Text(l10n.settingsThemeDark),
        ),
      ],
      selected: {selected},
      onSelectionChanged: (s) => onChanged(s.first),
    );
  }
}
