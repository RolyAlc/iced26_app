import 'package:flutter/material.dart';
import 'package:iced26/core/constants/assets.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      // Usamos el color de fondo del tema por defecto para que no desentone
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Mostramos el logo que definiste en tus Assets
            Image(image: AssetImage(Assets.logoIced26IconApp), width: 200),
            SizedBox(height: 20),
            // Un indicador de progreso para que sepa que la app no está congelada
            CircularProgressIndicator(
              color: Color(0xFF7DA097), // Usamos tu verde corporativo
            ),
          ],
        ),
      ),
    );
  }
}
