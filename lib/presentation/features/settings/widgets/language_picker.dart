import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/l10n/app_localizations.dart';
import 'package:iced26/presentation/app/state/locale_provider.dart';
import 'package:iced26/presentation/app/theme/app_icons.dart';
import 'package:iced26/presentation/features/settings/widgets/settings_section.dart';

// Los nombres de idioma se muestran en su propio idioma, independientemente
// del locale activo — no van a ARB.
const _kLabelSystem = 'System';
const _kLabelEnglish = 'English';
const _kLabelSpanish = 'Español';

/// Ítem de idioma: muestra el idioma activo y abre el picker al tocar.
class LanguageItem extends ConsumerWidget {
  const LanguageItem({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final locale = ref.watch(localeProvider).value;

    return SettingsItem(
      icon: AppIcons.translate,
      title: l10n.settingsLanguageItemTitle,
      subtitle: _localeLabel(locale),
      onTap: () {
        showDialog<void>(
          context: context,
          builder: (_) {
            return _LanguagePickerDialog(initialLocale: locale);
          },
        );
      },
    );
  }
}

/// Cuadro de diálogo que permite seleccionar el idioma de la aplicación.
class _LanguagePickerDialog extends ConsumerStatefulWidget {
  const _LanguagePickerDialog({required this.initialLocale});

  final Locale? initialLocale;

  @override
  ConsumerState<_LanguagePickerDialog> createState() =>
      _LanguagePickerDialogState();
}

/// Estado del cuadro de diálogo que permite seleccionar el idioma de la aplicación.
class _LanguagePickerDialogState extends ConsumerState<_LanguagePickerDialog> {
  late Locale? _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialLocale;
  }

  void _select(Locale? locale) {
    setState(() {
      _selected = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Text(l10n.settingsLanguageDialogTitle),
      contentPadding: const EdgeInsets.only(top: AppSpacing.s),
      content: RadioGroup<Locale?>(
        groupValue: _selected,
        onChanged: _select,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final locale in LocaleNotifier.supportedLocales)
              _LanguageOptionTile(locale: locale),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: () {
            if (_selected != widget.initialLocale) {
              ref.read(localeProvider.notifier).setLocale(_selected);
            }
            Navigator.pop(context);
          },
          child: Text(l10n.done),
        ),
      ],
    );
  }
}

/// Opción de idioma en el cuadro de diálogo que permite seleccionar el idioma de la aplicación.
class _LanguageOptionTile extends StatelessWidget {
  const _LanguageOptionTile({required this.locale});

  final Locale? locale;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.m),
      ),
      child: RadioListTile<Locale?>(
        value: locale,
        contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
        title: Text(
          _localeLabel(locale),
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }
}

/// Devuelve el nombre del idioma en su propio idioma.
String _localeLabel(Locale? locale) {
  return switch (locale?.languageCode) {
    'en' => _kLabelEnglish,
    'es' => _kLabelSpanish,
    _ => _kLabelSystem,
  };
}
