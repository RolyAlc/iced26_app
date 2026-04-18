import 'package:flutter/material.dart';

// TODO: Buscar widget de material 3 para este componente.
/// Widget base para los paneles deslizantes de la app.
class AppBottomSheet extends StatelessWidget {
  const AppBottomSheet({
    super.key,
    required this.title,
    required this.child,
    this.actions,
    this.isFullHeight = false,
    this.scrollable = true,
  });

  final String title;
  final Widget child;
  final List<Widget>? actions;
  final bool isFullHeight;
  final bool scrollable;

  /// Muestra el modal de forma estandarizada.
  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required Widget child,
    List<Widget>? actions,
    bool isFullHeight = false,
    bool scrollable = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black54,
      builder: (context) => AppBottomSheet(
        title: title,
        actions: actions,
        isFullHeight: isFullHeight,
        scrollable: scrollable,
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final mediaQuery = MediaQuery.of(context);

    // 🛡️ Lógica de Techo Fijo (10% de margen superior)
    final double statusBarHeight = mediaQuery.padding.top;
    final double keyboardHeight = mediaQuery.viewInsets.bottom;
    final double screenHeight = mediaQuery.size.height;

    // Calculamos el punto exacto donde el modal debe detenerse (Techo).
    // Usamos el 10% de la pantalla o al menos el statusBar + margen.
    final double ceilingMargin = (screenHeight * 0.10).clamp(
      statusBarHeight + 12,
      100.0,
    );

    // Altura Máxima = Pantalla - Techo - Teclado
    // Al restar el teclado de la altura máxima, logramos que el modal SE COMPRIMA
    // en lugar de desplazarse hacia arriba e invadir el sistema.
    final double availableModalHeight =
        screenHeight - ceilingMargin - keyboardHeight;

    return Padding(
      // Empujamos solo la parte inferior con el teclado para que el contenido fluya
      padding: EdgeInsets.only(bottom: keyboardHeight),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: isFullHeight
              ? availableModalHeight
              : (screenHeight * 0.70),
        ),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: SafeArea(
          // Protegemos el notch (si llegáramos a tocarlo) y la zona inferior de gestos.
          top: false,
          bottom: keyboardHeight == 0,
          child: Column(
            mainAxisSize: isFullHeight ? MainAxisSize.max : MainAxisSize.min,
            children: [
              // GRABBER / HANDLE
              const SizedBox(height: 12),
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: colors.onSurfaceVariant.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              const SizedBox(height: 16),

              // CABECERA (Sticky-like)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colors.onSurface,
                        ),
                      ),
                    ),
                    IconButton.filledTonal(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close_rounded, size: 20),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // CONTENIDO FLEXIBLE
              Flexible(
                fit: isFullHeight ? FlexFit.tight : FlexFit.loose,
                child: scrollable
                    ? SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                        child: child,
                      )
                    : Padding(
                        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                        child: child,
                      ),
              ),

              // ACCIONES
              if (actions != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  child: Row(
                    children: actions!
                        .map(
                          (action) => Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                              ),
                              child: action,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
