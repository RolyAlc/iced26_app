# Comandos utiles

```bash
# Para iniciar la app
flutter run
# Para limpiar el proyecto
flutter clean
# Para generar los iconos de la app.
# Se debe de asegurar que el pubspec.yaml tenga
# la configuración correcta y el logo en assets.
flutter pub run flutter_launcher_icons
# Formatear code by dart
dart format .
# Analizar code by dart
dart analyze .
# Generar drift code
dart run build_runner build --delete-conflicting-outputs
```

```bash
dart format . && dart analyze .
```
