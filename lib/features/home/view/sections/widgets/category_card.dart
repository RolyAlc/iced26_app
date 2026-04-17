import 'package:flutter/material.dart';
import 'package:iced26/features/home/view/sections/configs/category_style_config.dart';

/// Tarjeta individual para cada categoría en la pantalla de inicio.
/// Sigue el diseño "M3 Expression" de 2026: formas orgánicas y colores pastel.
/// En esta versión, usamos una imagen local para garantizar calidad visual "premium".
class CategoryCard extends StatelessWidget {
  const CategoryCard({
    super.key,
    required this.name,
    required this.style,
    required this.onTap,
  });

  final String name;
  final CategoryStyleConfig style;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // Obtenemos los colores y temas actuales de la aplicación.
    final ThemeData theme = Theme.of(context);
    final ColorScheme colors = theme.colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // CONTENEDOR ARTÍSTICO (M3 Expression 2026)
            Container(
              height: 64,
              width: 64,
              clipBehavior: Clip.antiAlias, // Redondea la imagen.
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                color: style.color.withOpacity(0.08), // Fondo suave de reserva.
                border: Border.all(
                  color: style.color.withOpacity(0.15),
                  width: 1.5,
                ),
                // USAMOS IMAGEN CON TINTE DINÁMICO (Senior Technique)
                image: DecorationImage(
                  // Usamos una imagen abstracta local.
                  // RECUERDA: Debes añadir 'assets/brand/expressive_shape.png'
                  image: const AssetImage('assets/brand/expressive_shape.png'),
                  fit: BoxFit.cover,
                  opacity: 0.6,
                  // Filtramos la imagen abstracta con el color de la categoría.
                  // Esto permite que una sola imagen sirva para todas las categorías.
                  colorFilter: ColorFilter.mode(
                    style.color.withOpacity(0.2),
                    BlendMode.srcATop,
                  ),
                ),
              ),
              child: Center(
                // El icono semántico encima del diseño orgánico.
                // Usamos el color sólido de la categoría para mejor contraste.
                child: Icon(
                  style.icon,
                  color: style.color,
                  size: 28,
                ),
              ),
            ),

            const SizedBox(height: 8),

            // Texto descriptivo debajo del icono.
            Text(
              name,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colors.onSurface.withOpacity(0.85),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
