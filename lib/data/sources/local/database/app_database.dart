import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:iced26/data/sources/local/database/note_color_converter.dart';
import 'package:iced26/domain/entities/i18n_str.dart';
import 'package:iced26/domain/entities/note_color.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

class I18nConverter extends TypeConverter<I18nStr, String> {
  const I18nConverter();

  @override
  I18nStr fromSql(String fromDb) {
    final Map<String, dynamic> json =
        jsonDecode(fromDb) as Map<String, dynamic>;
    return I18nStr(json.map((key, value) => MapEntry(key, value.toString())));
  }

  @override
  String toSql(I18nStr value) {
    return jsonEncode(value.values);
  }
}

/// Tabla de días
@DataClassName('DayTable')
class Days extends Table {
  TextColumn get id => text()();
  TextColumn get date => text()();
  TextColumn get title => text().map(const I18nConverter())();

  @override
  Set<Column> get primaryKey => {id};
}

/// Tabla de salas
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

/// Tabla de zonas
@DataClassName('ZoneTable')
class Zones extends Table {
  TextColumn get id => text()();
  // String plano: la resolución de locale ocurre en ZoneMapper antes de persistir.
  TextColumn get name => text()();
  TextColumn get lang => text().nullable()();
  TextColumn get description => text().nullable().map(const I18nConverter())();

  @override
  Set<Column> get primaryKey => {id};
}

/// N1 — schedule slot
@DataClassName('EventTable')
class Events extends Table {
  TextColumn get id => text()();
  TextColumn get title => text().map(const I18nConverter())();
  TextColumn get description => text().nullable()();
  TextColumn get subtype => text().nullable()();
  TextColumn get tagsJson => text().nullable()();
  IntColumn get durationMin => integer().nullable()();
  DateTimeColumn get startDate => dateTime().nullable()();
  DateTimeColumn get endDate => dateTime().nullable()();
  TextColumn get zoneId => text().nullable()();
  TextColumn get roomId => text().nullable().references(Rooms, #id)();
  TextColumn get type => text()();
  TextColumn get defaultLang => text().nullable()();
  TextColumn get filterDate => text().nullable()();
  TextColumn get filterTime => text().nullable()();
  TextColumn get speakersJson => text().nullable()();
  TextColumn get slotLabel => text().nullable()();
  TextColumn get parentId => text().nullable()();
  TextColumn get sessionId => text().nullable()();
  TextColumn get track => text().nullable()();
  TextColumn get abstract_ => text().nullable().map(const I18nConverter())();
  TextColumn get number => text().nullable()();
  BoolColumn get isSession => boolean().nullable()();
  TextColumn get extraRoomsJson => text().nullable()();
  TextColumn get submissionFormatsJson => text().nullable()();
  TextColumn get externalRef => text().nullable()();
  TextColumn get aboutPresentationUrl => text().nullable()();
  TextColumn get videoPresentationUrl => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// N2 — session block
@DataClassName('SessionBlockTable')
class SessionBlocks extends Table {
  TextColumn get id => text()();
  TextColumn get parentId => text()();
  TextColumn get roomId => text().nullable()();
  TextColumn get track => text().nullable()();
  TextColumn get title => text().nullable().map(const I18nConverter())();
  DateTimeColumn get startDate => dateTime().nullable()();
  DateTimeColumn get endDate => dateTime().nullable()();
  TextColumn get submissionFormatsJson => text().nullable()();
  TextColumn get defaultLang => text().nullable()();
  TextColumn get externalRef => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Noticias
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

/// Actividades sociales
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

/// Personas
@DataClassName('PersonTable')
class People extends Table {
  TextColumn get id => text()();
  TextColumn get name => text().map(const I18nConverter())();
  TextColumn get country => text().nullable()();
  // `title`, `institution` y `bio` vienen en un único idioma desde el backend —
  // no son campos multilingüe en el JSON fuente.
  TextColumn get title => text().nullable()();
  TextColumn get institution => text().nullable()();
  TextColumn get bio => text().nullable()();
  TextColumn get photoUrl => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Clave-valor para configuración interna (ej. `generated_at` del JSON remoto).
@DataClassName('AppConfigTable')
class AppConfigs extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}

/// Favoritos de eventos
@DataClassName('FavoriteTable')
class Favorites extends Table {
  TextColumn get eventId => text()();
  DateTimeColumn get savedAt => dateTime().clientDefault(DateTime.now)();

  @override
  Set<Column> get primaryKey => {eventId};
}

/// Notas personales del diario del usuario
@DataClassName('DiaryNoteTable')
class DiaryNotes extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime()();
  TextColumn get title => text().nullable()();
  TextColumn get content => text()();
  IntColumn get colorIndex => integer()
      .withDefault(const Constant(0))
      .map(const NoteColorConverter())();
  DateTimeColumn get createdAt => dateTime().clientDefault(DateTime.now)();
}

/// Tipos de submission
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

@DriftDatabase(
  tables: [
    Days,
    Rooms,
    Zones,
    Events,
    SessionBlocks,
    News,
    SocialActivities,
    AppConfigs,
    SubmissionTypes,
    Favorites,
    People,
    DiaryNotes,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 16;

  // Dos tipos de tablas con estrategias distintas:
  // - Configuración (Events, Zones…): ConfigRepositoryImpl las
  //   borra y recrea en cada arranque desde el JSON remoto. Sus migraciones son
  //   destructivas por diseño — no guardan datos del usuario.
  // - Locales (DiaryNotes, Favorites): requieren migraciones
  //   no destructivas porque el usuario no puede recuperar esos datos.
  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (m, from, to) async {
      if (from < 7) {
        await m.addColumn(events, events.speakersJson);
      }
      if (from < 8) {
        await m.addColumn(events, events.description);
        await m.addColumn(events, events.subtype);
        await m.addColumn(events, events.tagsJson);
        await m.addColumn(events, events.durationMin);
      }
      if (from < 9) {
        await m.addColumn(people, people.country);
        await m.addColumn(people, people.title);
        await m.addColumn(people, people.bio);
      }
      // v10 no llegó a producción — squasheada en v11.
      if (from < 11) {
        await m.createTable(zones);
      }
      if (from < 12) {
        // Events cambió de esquema de forma incompatible con ALTER TABLE.
        // Drop + recrear es seguro porque es tabla de configuración (sin datos de usuario).
        await customStatement('DROP TABLE IF EXISTS "events"');
        await m.createTable(events);
        await m.createTable(sessionBlocks);
      }
      if (from < 14) {
        await m.createTable(diaryNotes);
      }
      if (from < 15) {
        await m.addColumn(diaryNotes, diaryNotes.title);
        await m.addColumn(diaryNotes, diaryNotes.colorIndex);
      }
      if (from < 16) {
        await m.addColumn(events, events.sessionId);
        await m.addColumn(events, events.track);
        await m.addColumn(events, events.abstract_);
        await m.addColumn(events, events.number);
        await m.addColumn(events, events.isSession);
        await m.addColumn(events, events.aboutPresentationUrl);
        await m.addColumn(events, events.videoPresentationUrl);
        await customStatement(
          'INSERT OR IGNORE INTO favorites (event_id, saved_at) '
          'SELECT presentation_id, saved_at FROM saved_presentations',
        );
        await customStatement('DROP TABLE IF EXISTS "presentations"');
        await customStatement('DROP TABLE IF EXISTS "saved_presentations"');
      }
    },
  );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'iced26.sqlite'));
    return NativeDatabase(file);
  });
}
