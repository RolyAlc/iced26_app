import 'package:flutter/material.dart';

import 'package:iced26/core/constants/app_strings.dart';
import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/presentation/app/theme/app_icons.dart';

// TODO: Doble return

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

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        return TextField(
          controller: controller,
          autofocus: true,
          textInputAction: TextInputAction.search,
          onChanged: onChanged,
          onSubmitted: onSubmitted,
          decoration: InputDecoration(
            hintText: AppStrings.searchInputHint,
            prefixIcon: Icon(AppIcons.search, color: colors.primary),
            filled: true,
            fillColor: colors.surfaceContainerLow,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.m),
              borderSide: BorderSide.none,
            ),
            suffixIcon: controller.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(AppIcons.close),
                    onPressed: () {
                      controller.clear();
                      onChanged('');
                    },
                  )
                : null,
          ),
        );
      },
    );
  }
}
