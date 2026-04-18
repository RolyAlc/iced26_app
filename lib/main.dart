import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:iced26/app/app.dart';
import 'package:iced26/core/data/app_data_repository.dart';

void main() {
  debugPaintSizeEnabled = false; // Muestra los bordes de widgets para depurar
  final repository = AppDataRepository();
  runApp(MyApp(repository: repository));
}
