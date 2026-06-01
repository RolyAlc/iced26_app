import 'package:flutter/material.dart';

import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/l10n/app_localizations.dart';
import 'package:iced26/presentation/app/theme/app_icons.dart';

/// Campo de entrada de texto para la búsqueda.
class SearchInputField extends StatelessWidget {
  const SearchInputField({
    super.key,
    required this.controller,
    required this.onChanged,
    this.onSubmitted,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final ValueChanged<String>? onSubmitted;

  // ListenableBuilder reconstruye solo este subtree cuando cambia el texto,
  // necesario para mostrar/ocultar el botón de borrar sin afectar al árbol padre.
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(listenable: controller, builder: _buildTextField);
  }

  Widget _buildTextField(BuildContext context, Widget? _) {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;

    return TextField(
      controller: controller,
      autofocus: true,
      textInputAction: TextInputAction.search,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      decoration: InputDecoration(
        hintText: l10n.searchInputHint,
        prefixIcon: Icon(AppIcons.search, color: colors.primary),
        filled: true,
        fillColor: colors.surfaceContainerHigh,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.m),
          borderSide: BorderSide.none,
        ),
        suffixIcon: _buildClearButton(),
      ),
    );
  }

  Widget? _buildClearButton() {
    if (controller.text.isEmpty) {
      return null;
    }

    return IconButton(
      icon: const Icon(AppIcons.close),
      onPressed: () {
        controller.clear();
        onChanged('');
      },
    );
  }
}
