import 'package:flutter/material.dart';

import 'package:iced26/app/widgets/app_bottom_sheet.dart';
import 'package:iced26/features/home/viewmodel/search_viewmodel.dart';

class SmartSearchBar extends StatelessWidget {
  // Ahora el ViewModel se inyecta, permitiendo que el estado persista.
  final SearchViewModel searchViewModel;

  const SmartSearchBar({super.key, required this.searchViewModel});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Hero(
      tag: 'search_bar_hero',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _openSearch(context),
          borderRadius: BorderRadius.circular(32),
          child: _SearchBarVisualContainer(colors: colors),
        ),
      ),
    );
  }

  void _openSearch(BuildContext context) {
    AppBottomSheet.show(
      context: context,
      title: 'Search ICED26',
      isFullHeight: true,
      scrollable: false, // El modal gestiona su propio scroll con ListView
      child: _SearchModalBody(viewModel: searchViewModel),
    );
  }
}

/// Widget interno puramente visual para cumplir con KISS y mejorar legibilidad.
class _SearchBarVisualContainer extends StatelessWidget {
  final ColorScheme colors;
  const _SearchBarVisualContainer({required this.colors});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Color.alphaBlend(
          colors.primary.withValues(alpha: 0.08),
          colors.surface,
        ),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: colors.outlineVariant, width: 1.2),
      ),
      child: Row(
        children: [
          Icon(Icons.search_rounded, color: colors.primary),
          const SizedBox(width: 12),
          const Expanded(child: Text('Search sessions, authors, rooms...')),
          Icon(Icons.tune_rounded, color: colors.secondary),
        ],
      ),
    );
  }
}

class _SearchModalBody extends StatelessWidget {
  final SearchViewModel viewModel;
  const _SearchModalBody({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        return Column(
          children: [
            _SearchInputField(
              onChanged: viewModel.performSearch,
              query: viewModel.query,
            ),
            const SizedBox(height: 24),
            Expanded(child: _buildContent(context)),
          ],
        );
      },
    );
  }

  Widget _buildContent(BuildContext context) {
    if (viewModel.query.isEmpty) {
      return const _SearchHelper(
        title: 'Explore',
        subtitle: 'Find speakers and sessions...',
        icon: Icons.auto_awesome_outlined,
      );
    }

    if (viewModel.results.isEmpty) {
      return const _SearchHelper(
        title: 'No results',
        subtitle: 'Try another search...',
        icon: Icons.search_off_rounded,
      );
    }

    return ListView.builder(
      itemCount: viewModel.results.length,
      itemBuilder: (context, index) {
        final event = viewModel.results[index];
        final colors = Theme.of(context).colorScheme;

        return ListTile(
          contentPadding: const EdgeInsets.symmetric(vertical: 4),
          leading: CircleAvatar(
            backgroundColor: colors.primaryContainer.withValues(alpha: 0.2),
            child: Icon(Icons.event_rounded, color: colors.primary, size: 20),
          ),
          title: Text(
            event.title.resolve('en'),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(viewModel.getRoomName(event.roomId)),
          onTap: () => Navigator.pop(context),
        );
      },
    );
  }
}

/// El campo de texto estilizado para la búsqueda.
/// Se extrae para no ensuciar la lógica del Modal.
class _SearchInputField extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final String query;

  const _SearchInputField({required this.onChanged, required this.query});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return TextField(
      autofocus: true,
      onChanged: onChanged,
      // Decoración siguiendo el estilo Modern Tech de la app
      decoration: InputDecoration(
        hintText: 'Type Author, Title or Room...',
        prefixIcon: Icon(Icons.search_rounded, color: colors.primary),
        filled: true,
        fillColor: colors.surfaceContainerLow,
        // Bordes redondeados consistentes con los Cards de la App
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        // Botón para limpiar la búsqueda si hay texto
        suffixIcon: query.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.close_rounded),
                onPressed: () => onChanged(''),
              )
            : null,
      ),
    );
  }
}

/// Widget para estados vacíos o de bienvenida (Empty States).
/// Centraliza el diseño de "Icono + Título + Subtítulo".
class _SearchHelper extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const _SearchHelper({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Ocupa solo el espacio necesario
          children: [
            // Icono grande con opacidad baja para un look elegante
            Icon(icon, size: 64, color: colors.primary.withValues(alpha: 0.15)),
            const SizedBox(height: 16),
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: colors.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
