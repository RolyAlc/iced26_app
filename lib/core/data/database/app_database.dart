import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'package:iced26/domain/entities/i18n_str.dart';

part 'app_database.g.dart';

/// Convertidor de I18nStr a String y viceversa.
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
  TextColumn get subtitle => text().nullable().map(const I18nConverter())();
  DateTimeColumn get startDate => dateTime().nullable()();
  DateTimeColumn get endDate => dateTime().nullable()();
  TextColumn get zoneId => text().nullable()();
  TextColumn get roomId => text().nullable().references(Rooms, #id)();
  TextColumn get type => text()();
  TextColumn get lang => text().nullable()();
  TextColumn get filterDate => text().nullable()();
  TextColumn get filterTime => text().nullable()();

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

/// Base de datos de la aplicación.
@DriftDatabase(tables: [Days, Rooms, Events, News, SocialActivities])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (m, from, to) async {
      // Si subimos de versión, nos aseguramos de crear las tablas nuevas.
      await m.createAll();
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
