/// Contrato para cargar los datos del congreso como JSON.
///
/// Permite intercambiar la fuente de datos (assets, red, mock)
/// sin tocar ninguna otra capa.
abstract class AppDataSource {
  Future<String> loadAppDataJson();
}
