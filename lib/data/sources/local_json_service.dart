import 'package:flutter/services.dart';
import 'package:iced26/core/constants/assets.dart';

/// Servicio para cargar el JSON de la aplicación desde los assets.
/// Devolvemos el contenido del JSON como una cadena para que luego pueda ser parseada a AppData.
class LocalJsonService {
  const LocalJsonService();

  /// Carga el JSON de la aplicación.
  Future<String> loadAppDataJson() async {
    return rootBundle.loadString(Assets.appData);
  }
}
