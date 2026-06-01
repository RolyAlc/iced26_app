import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:iced26/core/config/app_config.dart';
import 'package:iced26/presentation/app/app.dart';

/// Punto de entrada de la aplicación.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppConfig.applyDebugFlags();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(const ProviderScope(child: MyApp()));
}
