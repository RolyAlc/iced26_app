import 'package:iced26/data/mappers/app_data_mapper.dart';
import 'package:iced26/data/sources/local/json/local_json_service.dart';
import 'package:iced26/domain/entities/app_data.dart';

/// Repositorio para cargar los datos de la aplicación desde un JSON local.
/// DEvuelve un objeto AppData con toda la información necesaria para la app.
class AppDataRepositoryImpl {
  const AppDataRepositoryImpl({LocalJsonService? localJsonService})
    : _localJsonService = localJsonService ?? const LocalJsonService();

  final LocalJsonService _localJsonService;

  Future<AppData> load() async {
    // Obtenemos el texto del archivo JSON y lo convertimos a AppData
    final String jsonString = await _localJsonService.loadAppDataJson();
    final AppData appData = AppDataMapper.fromJsonString(jsonString);

    return appData;
  }
}
