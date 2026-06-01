import 'package:iced26/core/constants/text_size_preference.dart';
import 'package:iced26/l10n/app_localizations.dart';

/// Devuelve la etiqueta localizada de [pref].
/// Función compartida entre todos los widgets que renderizan opciones de tamaño de texto.
String textSizeLabel(TextSizePreference pref, AppLocalizations l10n) {
  return switch (pref) {
    TextSizePreference.small => l10n.settingsTextSizeSmall,
    TextSizePreference.medium => l10n.settingsTextSizeMedium,
    TextSizePreference.large => l10n.settingsTextSizeLarge,
    TextSizePreference.xl => l10n.settingsTextSizeXl,
  };
}
