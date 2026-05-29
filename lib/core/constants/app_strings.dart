/// Strings de UI que aún no han sido migrados a ARB.
/// TODO: Migrar startupError* a ARB cuando se refactorice app.dart.
abstract final class AppStrings {
  // TODO: Eliminar paulativamente el separator o reemplazarlo por otro más acorde.
  static const String separator = '  ·  ';

  static const String startupErrorTitle = 'Could not start the app';
  static const String startupErrorMessage = 'Try restarting the application';
}
