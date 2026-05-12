import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/core/constants/text_size_preference.dart';
import 'package:iced26/presentation/app/state/text_size_provider.dart';
import 'package:iced26/presentation/app/theme/app_icons.dart';
import 'package:iced26/presentation/features/settings/widgets/settings_section.dart';

/// Ítem de tamaño de texto: muestra la preferencia activa y abre el picker al tocar.
class TextSizeItem extends ConsumerWidget {
  const TextSizeItem({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pref = ref.watch(textSizeProvider).value ?? TextSizePreference.medium;

    return SettingsItem(
      icon: AppIcons.textField,
      title: 'Text size',
      subtitle: pref.displayName,
      onTap: () {
        showDialog<void>(
          context: context,
          builder: (_) {
            return _TextSizePickerDialog(initialPref: pref);
          },
        );
      },
    );
  }
}

/// Diálogo de selección de tamaño de texto.
/// Cada opción se renderiza en su propio tamaño — el label ES la demo.
/// Aplica el cambio al instante; Cancel revierte.
class _TextSizePickerDialog extends ConsumerStatefulWidget {
  const _TextSizePickerDialog({required this.initialPref});

  final TextSizePreference initialPref;

  @override
  ConsumerState<_TextSizePickerDialog> createState() =>
      _TextSizePickerDialogState();
}

class _TextSizePickerDialogState extends ConsumerState<_TextSizePickerDialog> {
  late TextSizePreference _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialPref;
  }

  /// Aplica el tamaño inmediatamente para el preview reactivo.
  void _select(TextSizePreference pref) {
    setState(() {
      _selected = pref;
    });
    ref.read(textSizeProvider.notifier).setPreference(pref);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Text size'),
      // Sin padding lateral para que el InkWell de cada opción llegue al borde.
      contentPadding: const EdgeInsets.only(top: AppSpacing.s),
      content: RadioGroup<TextSizePreference>(
        groupValue: _selected,
        onChanged: (v) {
          if (v != null) {
            _select(v);
          }
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final pref in TextSizePreference.values)
              _TextSizeOptionTile(pref: pref, onSelect: _select),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            // Descarta el cambio si el usuario no confirma.
            if (_selected != widget.initialPref) {
              ref
                  .read(textSizeProvider.notifier)
                  .setPreference(widget.initialPref);
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

/// Fila de opción: radio + label renderizado en el tamaño que representa.
/// El propio texto demuestra visualmente el efecto de cada opción.
class _TextSizeOptionTile extends StatelessWidget {
  const _TextSizeOptionTile({required this.pref, required this.onSelect});

  final TextSizePreference pref;
  final ValueChanged<TextSizePreference> onSelect;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onSelect(pref);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.m,
          vertical: AppSpacing.xs,
        ),
        child: Row(
          children: [
            Radio<TextSizePreference>(
              value: pref,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            const SizedBox(width: AppSpacing.xs),
            // MediaQuery override aislado: el label se renderiza a su propio scale,
            // independiente de la preferencia activa en el resto de la app.
            MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(textScaler: TextScaler.linear(pref.scaleFactor)),
              child: Text(
                pref.displayName,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            if (pref == TextSizePreference.medium) ...[
              const SizedBox(width: AppSpacing.s),
              Text(
                'Default',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
