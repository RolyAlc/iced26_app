import 'package:flutter/material.dart';
import 'package:iced26/core/constants/assets.dart';

/// Pantalla de carga genérica para mostrar mientras se inicializa la app o se cargan datos.
class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  static const _kLogoWidth = 200.0;

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image(
              image: AssetImage(Assets.logoIced26IconApp),
              width: _kLogoWidth,
            ),
            SizedBox(height: 24),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
