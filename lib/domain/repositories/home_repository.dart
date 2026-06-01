import 'package:iced26/core/errors/result.dart';
import 'package:iced26/domain/entities/conference_theme.dart';
import 'package:iced26/domain/entities/news_item.dart';
import 'package:iced26/domain/entities/social_activity.dart';
import 'package:iced26/domain/entities/submission_type.dart';

/// Contrato para la gestión de contenidos de la Home (Noticias, Sociales, Categorías).
abstract class HomeRepository {
  /// Obtiene todas las noticias.
  Future<Result<List<NewsItem>>> getAllNews();

  /// Obtiene todas las actividades sociales.
  Future<Result<List<SocialActivity>>> getAllSocialActivities();

  /// Obtiene todos los tipos de presentación (categorías).
  Future<Result<List<SubmissionType>>> getAllSubmissionTypes();

  /// Obtiene los temas de la conferencia.
  Future<Result<List<ConferenceTheme>>> getConferenceThemes();
}
