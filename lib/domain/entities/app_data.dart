import 'package:iced26/domain/entities/metadata.dart';
import 'package:iced26/domain/entities/conference.dart';
import 'package:iced26/domain/entities/collections.dart';
import 'package:iced26/domain/entities/theme_config.dart';

class AppData {
  final Metadata metadata;
  final Conference conference;
  final ThemeConfig theme;
  final Collections collections;

  AppData({
    required this.metadata,
    required this.conference,
    required this.theme,
    required this.collections,
  });
}
