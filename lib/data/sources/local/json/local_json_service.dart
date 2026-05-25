import 'package:flutter/services.dart';
import 'package:iced26/core/constants/assets.dart';
import 'package:iced26/data/sources/app_data_source.dart';

/// Implementación de [AppDataSource] que carga el JSON desde los assets del proyecto.
class LocalJsonService implements AppDataSource {
  const LocalJsonService();

  @override
  Future<String> loadAppDataJson() async {
    return rootBundle.loadString(Assets.appData);
  }
}
