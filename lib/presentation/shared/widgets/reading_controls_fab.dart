import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:iced26/core/constants/app_strings.dart';
import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/core/constants/text_size_preference.dart';
import 'package:iced26/presentation/app/state/text_size_provider.dart';
import 'package:iced26/presentation/app/state/theme_mode_provider.dart';
import 'package:iced26/presentation/app/theme/app_icons.dart';

const _kTextSizeLabel = 'Text size';
const _kThemeLabel = 'Theme';
const _kScrollToTopTooltip = 'Back to top';

const double _kFabIconSize = 22.0;
const double _kFabButtonPaddingH = 18.0;
const double _kFabButtonPaddingV = 14.0;
const double _kFabDividerHeight = 22.0;
const double _kFabElevation = 3.0;

/// Píldora flotante centrada con controles de lectura: tamaño de texto y tema.
class ReadingControlsFab extends ConsumerWidget {
  const ReadingControlsFab({
    super.key,
    this.scrollController,
    this.showScrollToTop = false,
  });

  // Controlador del scroll. Necesario para el botón "back to top".
  final ScrollController? scrollController;
  // Si es true y [scrollController] no es null, muestra el botón "↑".
  final bool showScrollToTop;

  void _openSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (_) => const _ReadingControlsSheet(),
    );
  }

  void _scrollToTop() {
    scrollController?.animateTo(
      0,
      duration: AppDuration.entrance,
      curve: Curves.easeOut,
    );
  }

  Widget _buildScrollToTopSlot(ColorScheme colors) {
    if (scrollController == null) {
      return const SizedBox.shrink();
    }

    // AnimatedSize colapsa el ancho cuando el botón no es visible,
    // evitando que la píldora ocupe espacio extra innecesariamente.
    return AnimatedSize(
      duration: AppDuration.fast,
      curve: Curves.easeOut,
      child: showScrollToTop
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _PillIconButton(
                  icon: AppIcons.collapse,
                  color: colors.onPrimaryContainer,
                  tooltip: _kScrollToTopTooltip,
                  onTap: _scrollToTop,
                ),
                _PillDivider(color: colors.onPrimaryContainer),
              ],
            )
          : const SizedBox.shrink(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider).value ?? ThemeMode.system;
    final colors = Theme.of(context).colorScheme;

    return Material(
      color: colors.primaryContainer,
      elevation: _kFabElevation,
      shadowColor: colors.shadow,
      borderRadius: BorderRadius.circular(AppRadius.full),
      clipBehavior: Clip.antiAlias,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildScrollToTopSlot(colors),
          _PillIconButton(
            icon: AppIcons.textField,
            color: colors.onPrimaryContainer,
            tooltip: _kTextSizeLabel,
            onTap: () => _openSheet(context),
          ),
          _PillDivider(color: colors.onPrimaryContainer),
          _PillIconButton(
            icon: AppIcons.forThemeMode(themeMode),
            color: colors.onPrimaryContainer,
            tooltip: _kThemeLabel,
            onTap: () => _openSheet(context),
          ),
        ],
      ),
    );
  }
}

/// Botón de icono interno de la píldora. Ripple rectangular acotado al área del botón.
class _PillIconButton extends StatelessWidget {
  const _PillIconButton({
    required this.icon,
    required this.color,
    required this.tooltip,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: _kFabButtonPaddingH,
            vertical: _kFabButtonPaddingV,
          ),
          child: Icon(icon, size: _kFabIconSize, color: color),
        ),
      ),
    );
  }
}

/// Separador visual de 1px entre botones de la píldora.
class _PillDivider extends StatelessWidget {
  const _PillDivider({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: _kFabDividerHeight,
      color: color.withValues(alpha: 0.15),
    );
  }
}

/// Panel de controles de lectura: tamaño de texto y modo de tema.
/// Los cambios son globales, en tiempo real y persisten entre sesiones.
class _ReadingControlsSheet extends ConsumerWidget {
  const _ReadingControlsSheet();

  Widget _buildSection(ThemeData theme, String label, Widget control) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.labelMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppSpacing.s),
        SizedBox(width: double.infinity, child: control),
      ],
    );
  }

  Widget _buildTextSizeControl(WidgetRef ref, TextSizePreference current) {
    return SegmentedButton<TextSizePreference>(
      segments: [
        for (final pref in TextSizePreference.values)
          ButtonSegment<TextSizePreference>(
            value: pref,
            label: Text(pref.label),
            tooltip: pref.displayName,
          ),
      ],
      selected: {current},
      onSelectionChanged: (selection) {
        ref.read(textSizeProvider.notifier).setPreference(selection.first);
      },
    );
  }

  Widget _buildThemeModeControl(WidgetRef ref, ThemeMode current) {
    return SegmentedButton<ThemeMode>(
      segments: const [
        ButtonSegment<ThemeMode>(
          value: ThemeMode.light,
          icon: Icon(AppIcons.lightTheme),
          label: Text(AppStrings.themeLight),
        ),
        ButtonSegment<ThemeMode>(
          value: ThemeMode.system,
          icon: Icon(AppIcons.systemTheme),
          label: Text(AppStrings.themeSystem),
        ),
        ButtonSegment<ThemeMode>(
          value: ThemeMode.dark,
          icon: Icon(AppIcons.darkTheme),
          label: Text(AppStrings.themeDark),
        ),
      ],
      selected: {current},
      onSelectionChanged: (selection) {
        ref.read(themeModeProvider.notifier).setMode(selection.first);
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textSize =
        ref.watch(textSizeProvider).value ?? TextSizePreference.medium;
    final themeMode = ref.watch(themeModeProvider).value ?? ThemeMode.system;
    final theme = Theme.of(context);

    return SafeArea(
      child: Padding(
        // Top reducido: showDragHandle ya añade espacio visual suficiente arriba.
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.l,
          AppSpacing.s,
          AppSpacing.l,
          AppSpacing.l,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              theme,
              _kTextSizeLabel,
              _buildTextSizeControl(ref, textSize),
            ),
            const SizedBox(height: AppSpacing.l),
            _buildSection(
              theme,
              _kThemeLabel,
              _buildThemeModeControl(ref, themeMode),
            ),
          ],
        ),
      ),
    );
  }
}
