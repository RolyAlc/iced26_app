import 'package:flutter/services.dart';
import 'package:iced26/core/constants/assets.dart';

class LocalJsonService {
  const LocalJsonService();

  /// Carga el JSON de la aplicación.
  /// Devolvemos el contenido del JSON como una cadena.
  Future<String> loadAppDataJson() async {
    return rootBundle.loadString(Assets.appData);
  }
}
