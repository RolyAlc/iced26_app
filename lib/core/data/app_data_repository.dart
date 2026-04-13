import 'package:iced26/core/models/app_data.dart';
import 'package:iced26/core/services/local_json_service.dart';

/// Repositorio para cargar los datos de la aplicación desde un JSON local.
class AppDataRepository {
  const AppDataRepository({LocalJsonService? localJsonService})
    : _localJsonService = localJsonService ?? const LocalJsonService();

  final LocalJsonService _localJsonService;

  Future<AppData> load() async {
    // Cargamos el JSON real desde el servicio local.
    final jsonString = await _localJsonService.loadAppDataJson();
    return AppData.fromJson(jsonString);
  }
}
