import 'package:iced26/core/errors/result.dart';
import 'package:iced26/core/services/logger/logger.dart';
import 'package:iced26/data/mappers/home/news_mapper.dart';
import 'package:iced26/data/mappers/home/social_activity_mapper.dart';
import 'package:iced26/data/mappers/submission_type_mapper.dart';
import 'package:iced26/data/sources/local/database/app_database.dart';
import 'package:iced26/domain/entities/new.dart';
import 'package:iced26/domain/entities/social_activity.dart';
import 'package:iced26/domain/entities/submission_type.dart';
import 'package:iced26/domain/repositories/home_repository.dart';

/// Repositorio para la gestión de la home.
class HomeRepositoryImpl implements HomeRepository {
  HomeRepositoryImpl(this._db);
  final AppDatabase _db;

  /// Método auxiliar para manejar errores de base de datos.
  Future<Result<T>> _guard<T>(Future<T> Function() call) async {
    try {
      final data = await call();
      return Success(data);
    } catch (e) {
      AppLogger.e('Database Error (Home): $e');
      return Failure('Error al cargar datos de inicio: $e');
    }
  }

  /// Obtiene todas las noticias.
  @override
  Future<Result<List<NewsItem>>> getAllNews() async {
    return _guard(() async {
      final results = await _db.select(_db.news).get();
      return results.map(NewsMapper.fromDrift).toList();
    });
  }

  /// Obtiene todas las actividades sociales.
  @override
  Future<Result<List<SocialActivity>>> getAllSocialActivities() async {
    return _guard(() async {
      final results = await _db.select(_db.socialActivities).get();
      return results.map(SocialActivityMapper.fromDrift).toList();
    });
  }

  /// Obtiene todos los tipos de submission (categorias).
  @override
  Future<Result<List<SubmissionType>>> getAllSubmissionTypes() async {
    return _guard(() async {
      final results = await _db.select(_db.submissionTypes).get();
      return results.map(SubmissionTypeMapper.fromDrift).toList();
    });
  }
}
