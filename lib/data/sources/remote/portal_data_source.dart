import 'package:iced26/data/sources/app_data_source.dart';
import 'package:iced26/data/sources/remote/portal_api_client.dart';

/// Fuente remota que descarga el schedule completo desde el portal.
class PortalDataSource implements AppDataSource {
  const PortalDataSource(this._client);

  final PortalApiClient _client;

  @override
  Future<String> loadAppDataJson() {
    return _client.fetchScheduleJson();
  }
}
