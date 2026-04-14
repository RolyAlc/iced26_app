import 'package:flutter/material.dart';

class HomeSearchSection extends StatelessWidget {
  const HomeSearchSection({super.key});

  @override
  Widget build(BuildContext context) {
    // Creamos la barra de búsqueda con botón de filtro.
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Row(
              children: [
                Expanded(
                  child: Text(
                    'Search',
                    style: TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ),
                Icon(Icons.search, size: 20),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Container(
          height: 48,
          width: 48,
          decoration: BoxDecoration(
            color: const Color(0xFFEFF3F2),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(Icons.tune, size: 20),
        ),
      ],
    );
  }
}
