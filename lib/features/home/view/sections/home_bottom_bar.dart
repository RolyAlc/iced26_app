import 'package:flutter/material.dart';

class HomeBottomBar extends StatelessWidget {
  const HomeBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    // Mostramos una barra inferior fija con 5 items.
    return Container(
      height: 78,
      decoration: const BoxDecoration(
        color: Color(0xFF7DA097),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: const [
          _BottomItem(icon: Icons.home_filled, label: 'Home', active: true),
          _BottomItem(icon: Icons.event, label: 'Schedule'),
          _BottomItem(icon: Icons.search, label: 'Search'),
          _BottomItem(icon: Icons.bookmark, label: 'Diary'),
          _BottomItem(icon: Icons.settings, label: 'Setting'),
        ],
      ),
    );
  }
}

class _BottomItem extends StatelessWidget {
  const _BottomItem({
    required this.icon,
    required this.label,
    this.active = false,
  });

  final IconData icon;
  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final color = active ? Colors.white : Colors.white70;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 22, color: color),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 10, color: color)),
      ],
    );
  }
}
