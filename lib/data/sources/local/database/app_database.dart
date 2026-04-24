import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'package:iced26/domain/entities/i18n_str.dart';

part 'app_database.g.dart';

// TODO: Consultar con los datos del json y los mappers.

/// Convertidor de I18nStr a String y viceversa.
class I18nConverter extends TypeConverter<I18nStr, String> {
  const I18nConverter();

  /// Convierte un String a I18nStr.
  @override
  I18nStr fromSql(String fromDb) {
    final Map<String, dynamic> json =
        jsonDecode(fromDb) as Map<String, dynamic>;
    return I18nStr(json.map((key, value) => MapEntry(key, value.toString())));
  }

  /// Convierte un I18nStr a String.
  @override
  String toSql(I18nStr value) {
    return jsonEncode(value.values);
  }
}

/// Tabla de días.
@DataClassName('DayTable')
class Days extends Table {
  TextColumn get id => text()();
  TextColumn get date => text()();
  TextColumn get title => text().map(const I18nConverter())();

  @override
  Set<Column> get primaryKey => {id};
}

/// Tabla de rooms.
@DataClassName('RoomTable')
class Rooms extends Table {
  TextColumn get id => text()();
  TextColumn get name => text().map(const I18nConverter())();
  IntColumn get capacity => integer().nullable()();
  TextColumn get zoneId => text().nullable()();
  TextColumn get sessionStyle => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Tabla de eventos.
@DataClassName('EventTable')
class Events extends Table {
  TextColumn get id => text()();
  TextColumn get title => text().map(const I18nConverter())();
  // 'subtitle' almacena el campo 'abstract' del contrato (renombrado en entidad a abstract_)
  TextColumn get subtitle => text().nullable().map(const I18nConverter())();
  TextColumn get description => text().nullable()();
  TextColumn get subtype => text().nullable()();
  TextColumn get track => text().nullable()();
  TextColumn get tagsJson => text().nullable()();
  IntColumn get durationMin => integer().nullable()();
  DateTimeColumn get startDate => dateTime().nullable()();
  DateTimeColumn get endDate => dateTime().nullable()();
  TextColumn get zoneId => text().nullable()();
  TextColumn get roomId => text().nullable().references(Rooms, #id)();
  TextColumn get type => text()();
  TextColumn get lang => text().nullable()();
  TextColumn get filterDate => text().nullable()();
  TextColumn get filterTime => text().nullable()();
  TextColumn get speakerIdsJson => text().nullable()();
  TextColumn get aboutPresentationUrl => text().nullable()();
  TextColumn get videoPresentationUrl => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Tabla de news.
@DataClassName('NewsTable')
class News extends Table {
  TextColumn get id => text()();
  TextColumn get title => text().map(const I18nConverter())();
  TextColumn get content => text().map(const I18nConverter())();
  TextColumn get imgUrl => text()();
  TextColumn get webUrl => text()();
  TextColumn get date => text()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Tabla de social activities.
@DataClassName('SocialActivityTable')
class SocialActivities extends Table {
  TextColumn get id => text()();
  TextColumn get title => text().map(const I18nConverter())();
  TextColumn get description => text().map(const I18nConverter())();
  TextColumn get date => text()();
  TextColumn get time => text()();
  TextColumn get location => text().map(const I18nConverter())();
  TextColumn get imgUrl => text()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Tabla de personas de la conferencia (speakers, organizadores...).
@DataClassName('PersonTable')
class People extends Table {
  TextColumn get id => text()();
  TextColumn get name => text().map(const I18nConverter())();
  TextColumn get country => text().nullable()();
  TextColumn get title => text().nullable()();
  TextColumn get institution => text().nullable()();
  TextColumn get bio => text().nullable()();
  TextColumn get photoUrl => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Tabla de configuración de la aplicación.
@DataClassName('AppConfigTable')
class AppConfigs extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}

/// Tabla de favoritos del usuario.
@DataClassName('FavoriteTable')
class Favorites extends Table {
  TextColumn get eventId => text()();
  DateTimeColumn get savedAt =>
      dateTime().clientDefault(() => DateTime.now())();

  @override
  Set<Column> get primaryKey => {eventId};
}

/// Tabla de tipos de presentación.
@DataClassName('SubmissionTypeTable')
class SubmissionTypes extends Table {
  TextColumn get id => text()();
  TextColumn get name => text().map(const I18nConverter())();
  IntColumn get durationMin => integer().nullable()();
  TextColumn get lang => text().nullable()();
  TextColumn get description => text().map(const I18nConverter())();
  TextColumn get scheduleDescription => text().map(const I18nConverter())();

  @override
  Set<Column> get primaryKey => {id};
}

/// Base de datos de la aplicación.
@DriftDatabase(
  tables: [
    Days,
    Rooms,
    Events,
    News,
    SocialActivities,
    AppConfigs,
    SubmissionTypes,
    Favorites,
    People,
  ],
)
/// Implementación de la base de datos.
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  // TODO: Añadir un ADR para versionado de la base de datos.
  /// Versionado de la base de datos.
  @override
  int get schemaVersion => 10;

  /// Estrategia de migración.
  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (m, from, to) async {
      if (from < 7) {
        await m.addColumn(events, events.speakerIdsJson);
      }
      if (from < 8) {
        await m.addColumn(events, events.description);
        await m.addColumn(events, events.subtype);
        await m.addColumn(events, events.track);
        await m.addColumn(events, events.tagsJson);
        await m.addColumn(events, events.durationMin);
      }
      if (from < 9) {
        await m.addColumn(people, people.country);
        await m.addColumn(people, people.title);
        await m.addColumn(people, people.bio);
      }
      if (from < 10) {
        await m.addColumn(events, events.aboutPresentationUrl);
        await m.addColumn(events, events.videoPresentationUrl);
      }
    },
  );
}

/// Abre la conexión a la base de datos.
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'iced26.sqlite'));
    return NativeDatabase(file);
  });
}
