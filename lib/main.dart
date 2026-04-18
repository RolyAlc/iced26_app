import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:iced26/app/app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // TODO: Quitar en producción
  debugPaintSizeEnabled = false; // Muestra los bordes de widgets para depurar

  runApp(const ProviderScope(child: MyApp()));
}
