import 'package:flutter/material.dart';

class NewsCard extends StatelessWidget {
  const NewsCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final String imageUrl;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      // Estética M3: Superficie sutil
      color: theme.colorScheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            _NewsImage(imageUrl: imageUrl),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget de apoyo para la imagen de la noticia.
// Aplicamos el principio de Responsabilidad Única (SOLID) separando
// la lógica de carga de la lógica de diseño del "placeholder".
class _NewsImage extends StatelessWidget {
  const _NewsImage({required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    // Si la URL está vacía, mostramos directamente el diseño expresivo.
    if (imageUrl.isEmpty) {
      return _NewsPlaceholder(colors: colors);
    }

    // Si hay URL, intentamos cargarla con Image.network.
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(color: colors.surfaceContainerHighest),
      child: Image.network(
        imageUrl,
        fit: BoxFit.cover,
        // Este constructor se ejecuta MIENTRAS la imagen carga.
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            return child;
          }
          return Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
        // Este constructor es la CLAVE: se ejecuta si hay un ERROR de carga
        // (como el fallo de certificado SSL que mencionas).
        errorBuilder: (context, error, stackTrace) {
          // En lugar de mostrar un error feo, mostramos nuestro diseño M3 Expression.
          return _NewsPlaceholder(colors: colors);
        },
      ),
    );
  }
}

// Widget que diseña el fondo artístico cuando no hay imagen disponible.
// En M3 Expression 2026, preferimos usar una imagen de diseño (Asset)
// que es más orgánica y profesional que dibujarla manualmente.
class _NewsPlaceholder extends StatelessWidget {
  const _NewsPlaceholder({required this.colors});

  final ColorScheme colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest,
        // Usamos una imagen local como fondo decorativo.
        // TIP de Arquitecto: BoxFit.cover asegura que rellene todo el espacio.
        image: const DecorationImage(
          image: AssetImage('assets/brand/expressive_shape.jpg'),
          fit: BoxFit.cover,
          opacity:
              0.5, // Le damos una transparencia suave para que no distraiga.
        ),
      ),
      child: Center(
        // Icono semántico sobre el fondo artístico.
        // Lo ponemos con color sólido (sin opacidad) para que sea 
        // perfectamente legible sobre el fondo decorativo.
        child: Icon(
          Icons.newspaper_rounded,
          size: 32,
          color: colors.primary, // Color sólido para máxima legibilidad.
        ),
      ),
    );
  }
}
