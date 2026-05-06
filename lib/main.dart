import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:iced26/core/config/app_config.dart';
import 'package:iced26/presentation/app/app.dart';

/// Punto de entrada de la aplicación.
void main() {
  WidgetsFlutterBinding.ensureInitialized(); // Inicializa el motor de Flutter.
  AppConfig.applyDebugFlags(); // Aplica flags de depuración.

  runApp(const ProviderScope(child: MyApp()));
}
