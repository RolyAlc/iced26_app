import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/presentation/app/state/theme_mode_provider.dart';
import 'package:iced26/presentation/app/theme/app_icons.dart';
import 'package:iced26/presentation/features/settings/widgets/settings_section.dart';

/// Ítem de tema: muestra el modo activo y abre el picker al tocar.
class ThemeItem extends ConsumerWidget {
  const ThemeItem({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(themeModeProvider).value ?? ThemeMode.system;

    return SettingsItem(
      icon: _themeIcon(mode),
      title: 'Theme',
      subtitle: _themeLabel(mode),
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
    return AlertDialog(
      title: const Text('Theme'),
      contentPadding: const EdgeInsets.only(top: AppSpacing.s),
      content: RadioGroup<ThemeMode>(
        groupValue: _selected,
        onChanged: (v) {
          if (v != null) {
            _select(v);
          }
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final mode in ThemeMode.values) _ThemeOptionTile(mode: mode),
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
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Done'),
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
            Icon(_themeIcon(mode), size: 20),
            const SizedBox(width: AppSpacing.s),
            Text(
              _themeLabel(mode),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}

// Helpers de ThemeMode compartidos entre _ThemeItem y _ThemePickerDialog.
IconData _themeIcon(ThemeMode mode) {
  return switch (mode) {
    ThemeMode.light => AppIcons.lightTheme,
    ThemeMode.dark => AppIcons.darkTheme,
    ThemeMode.system => AppIcons.systemTheme,
  };
}

String _themeLabel(ThemeMode mode) {
  return switch (mode) {
    ThemeMode.light => 'Light',
    ThemeMode.dark => 'Dark',
    ThemeMode.system => 'System',
  };
}
