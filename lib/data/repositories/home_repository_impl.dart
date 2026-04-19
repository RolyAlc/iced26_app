import 'package:iced26/core/errors/result.dart';
import 'package:iced26/data/mappers/news_mapper.dart';
import 'package:iced26/data/mappers/social_activity_mapper.dart';
import 'package:iced26/data/mappers/submission_type_mapper.dart';
import 'package:iced26/data/sources/local/database/app_database.dart';
import 'package:iced26/domain/entities/new.dart';
import 'package:iced26/domain/entities/social_activity.dart';
import 'package:iced26/domain/entities/submission_type.dart';
import 'package:iced26/domain/repositories/home_repository.dart';
import 'package:iced26/core/logger/logger.dart';

/// Repositorio para la gestión de la home.
class HomeRepositoryImpl implements HomeRepository {
  final AppDatabase _db;

  HomeRepositoryImpl(this._db);

  /// Método auxiliar para manejar errores de base de datos.
  Future<Result<T>> _guard<T>(Future<T> Function() call) async {
    try {
      final data = await call();
      return Success(data);
    } catch (e) {
      logger.e('Database Error (Home): $e');
      return Failure('Error al cargar datos de inicio: $e');
    }
  }

  /// Obtiene todas las noticias.
  @override
  Future<Result<List<NewsItem>>> getAllNews() async {
    return _guard(() async {
      final results = await _db.select(_db.news).get();
      return results.map((e) => NewsMapper.fromDrift(e)).toList();
    });
  }

  /// Obtiene todas las actividades sociales.
  @override
  Future<Result<List<SocialActivity>>> getAllSocialActivities() async {
    return _guard(() async {
      final results = await _db.select(_db.socialActivities).get();
      return results.map((e) => SocialActivityMapper.fromDrift(e)).toList();
    });
  }

  /// Obtiene todos los tipos de submission (categorias).
  @override
  Future<Result<List<SubmissionType>>> getAllSubmissionTypes() async {
    return _guard(() async {
      final results = await _db.select(_db.submissionTypes).get();
      return results.map((e) => SubmissionTypeMapper.fromDrift(e)).toList();
    });
  }
}
