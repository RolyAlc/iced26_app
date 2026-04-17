import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Importamos la herramienta para abrir URLs

import 'package:iced26/domain/entities/new.dart';
import 'package:iced26/features/home/view/sections/widgets/news_card.dart';

/// Sección de noticias en la pantalla principal.
/// Muestra una lista de noticias que al pulsarlas abren la web oficial.
class HomeNewsSection extends StatelessWidget {
  const HomeNewsSection({super.key, required this.news});

  final List<NewsItem> news;
  final titleSection = 'Latest News';

  @override
  Widget build(BuildContext context) {
    // Si no hay noticias, no mostramos nada (KISS).
    if (news.isEmpty) {
      return const SizedBox.shrink();
    }

    final ThemeData theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Título de la sección
        Text(
          titleSection,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 12),

        // Generamos una tarjeta por cada noticia (Bucle for)
        for (var item in news)
          NewsCard(
            title: item.title.resolve('en'),
            subtitle: item.content.resolve('en'),
            imageUrl: item.imgUrl,
            // Al pulsar la tarjeta, llamamos a nuestra función de navegación.
            onTap: () {
              _launchURL(context, item.webUrl);
            },
          ),
      ],
    );
  }

  /// Función robusta para abrir una URL en el navegador del dispositivo.
  /// Es "pedagógica" porque explica cada paso del proceso asíncrono.
  Future<void> _launchURL(BuildContext context, String urlString) async {
    // 1. Convertimos el String en un objeto Uri (identificador de recurso).
    final Uri url = Uri.parse(urlString);

    try {
      // 2. Comprobamos si el sistema operativo sabe cómo abrir esta URL.
      if (await canLaunchUrl(url)) {
        // 3. Abrimos la URL en el navegador externo.
        await launchUrl(
          url,
          mode: LaunchMode.externalApplication, // Abrir fuera de la app.
        );
      } else {
        // Si no puede abrirla, avisamos al usuario con un mensaje amigable (UX).
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Could not open the link: $urlString')),
          );
        }
      }
    } catch (error) {
      // Si ocurre un error inesperado, lo capturamos para evitar que la app falle.
      debugPrint('Error launching URL: $error');
    }
  }
}
