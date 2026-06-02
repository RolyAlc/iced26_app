import 'package:flutter/material.dart';
import 'package:iced26/core/constants/text_size_preference.dart';
import 'package:iced26/l10n/app_localizations.dart';
import 'package:iced26/presentation/shared/utils/text_size_l10n.dart';

/// Selector de tamaño de texto como [SegmentedButton].
///
/// Widget puramente presentacional: recibe el valor seleccionado y notifica
/// cambios mediante [onChanged]. El llamador gestiona el estado y el provider.
///
/// Cada segmento renderiza su etiqueta al scale factor que representa,
/// para que el usuario vea el efecto visualmente.
class TextSizeSelector extends StatelessWidget {
  const TextSizeSelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final TextSizePreference selected;
  final ValueChanged<TextSizePreference> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return SegmentedButton<TextSizePreference>(
      segments: [
        for (final pref in TextSizePreference.values)
          ButtonSegment<TextSizePreference>(
            value: pref,
            label: MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(textScaler: TextScaler.linear(pref.scaleFactor)),
              child: Text(textSizeLabel(pref, l10n)),
            ),
          ),
      ],
      selected: {selected},
      onSelectionChanged: (s) => onChanged(s.first),
    );
  }
}
