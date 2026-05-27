import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:iced26/data/mappers/conference_theme_mapper.dart';
import 'package:iced26/data/mappers/zone_mapper.dart';
import 'package:iced26/data/sources/local/database/app_database.dart';
import 'package:iced26/domain/entities/app_data.dart';

/// Carga el JSON del congreso y lo vuelca en la base de datos local.
///
/// Responsabilidad única: sabe cómo leer [AppDataSource] y cómo escribir
/// en cada tabla de [AppDatabase]. No decide cuándo hacerlo — eso es
/// responsabilidad de [ConfigRepositoryImpl].
class ConferenceDataSeeder {
  const ConferenceDataSeeder(this._db);

  final AppDatabase _db;

  /// Elimina todas las tablas de datos del congreso.
  ///
  /// Llamar siempre dentro de una transacción gestionada por el orquestador.
  Future<void> reset() async {
    await _db.delete(_db.sessionBlocks).go();
    await _db.delete(_db.events).go();
    await _db.delete(_db.news).go();
    await _db.delete(_db.socialActivities).go();
    await _db.delete(_db.submissionTypes).go();
    await _db.delete(_db.rooms).go();
    await _db.delete(_db.zones).go();
    await _db.delete(_db.days).go();
    await _db.delete(_db.people).go();
  }

  /// Inserta todos los datos del congreso en un único batch.
  ///
  /// Llamar siempre dentro de una transacción gestionada por el orquestador.
  Future<void> seed(AppData appData) async {
    await _db.batch((batch) {
      _insertDays(batch, appData);
      _insertSubmissionTypes(batch, appData);
      _insertRooms(batch, appData);
      _insertZones(batch, appData);
      _insertEvents(batch, appData);
      _insertSessionBlocks(batch, appData);
      _insertNews(batch, appData);
      _insertSocialActivities(batch, appData);
      _insertPeople(batch, appData);
      _insertAppConfigs(batch, appData);
    });
  }

  void _insertDays(Batch batch, AppData appData) {
    batch.insertAll(
      _db.days,
      appData.collections.days.map(
        (d) => DaysCompanion.insert(id: d.id, date: d.date, title: d.title),
      ),
      mode: InsertMode.insertOrReplace,
    );
  }

  void _insertSubmissionTypes(Batch batch, AppData appData) {
    batch.insertAll(
      _db.submissionTypes,
      appData.collections.submissionTypes.map(
        (st) => SubmissionTypesCompanion.insert(
          id: st.id,
          name: st.name,
          durationMin: Value(st.durationMin),
          lang: Value(st.lang),
          description: st.description,
          scheduleDescription: st.scheduleDescription,
        ),
      ),
      mode: InsertMode.insertOrReplace,
    );
  }

  void _insertRooms(Batch batch, AppData appData) {
    batch.insertAll(
      _db.rooms,
      appData.collections.rooms.map(
        (r) => RoomsCompanion.insert(
          id: r.id,
          name: r.name,
          capacity: Value(r.capacity),
          zoneId: Value(r.zoneId),
          sessionStyle: Value(r.sessionStyle),
        ),
      ),
      mode: InsertMode.insertOrReplace,
    );
  }

  void _insertZones(Batch batch, AppData appData) {
    batch.insertAll(
      _db.zones,
      appData.collections.zones.map(
        (z) => ZonesCompanion.insert(
          id: z.id,
          name: ZoneMapper.resolveDisplayName(z),
          lang: Value(z.lang),
          description: Value(z.description),
        ),
      ),
      mode: InsertMode.insertOrReplace,
    );
  }

  void _insertEvents(Batch batch, AppData appData) {
    batch.insertAll(
      _db.events,
      appData.collections.events.map(
        (e) => EventsCompanion.insert(
          id: e.id,
          title: e.title,
          description: Value(e.description),
          subtype: Value(e.subtype),
          tagsJson: Value(e.tags.isEmpty ? null : jsonEncode(e.tags)),
          durationMin: Value(e.durationMin),
          startDate: Value(e.startDate),
          endDate: Value(e.endDate),
          zoneId: Value(e.zoneId),
          roomId: Value(e.roomId),
          type: e.type.jsonValue,
          defaultLang: Value(e.defaultLang),
          filterDate: Value(e.filterDate),
          filterTime: Value(e.filterTime),
          speakersJson: Value(
            e.speakers.isEmpty
                ? null
                : jsonEncode(
                    e.speakers
                        .map((s) => {'personId': s.personId, 'role': s.role})
                        .toList(),
                  ),
          ),
          slotLabel: Value(e.slotLabel),
          parentId: Value(e.parentId),
          sessionId: Value(e.sessionId),
          track: Value(e.track),
          abstract_: Value(e.abstract_),
          number: Value(e.number),
          isSession: Value(e.isSession),
          extraRoomsJson: Value(
            e.extraRooms.isEmpty ? null : jsonEncode(e.extraRooms),
          ),
          submissionFormatsJson: Value(
            e.submissionFormats.isEmpty
                ? null
                : jsonEncode(e.submissionFormats),
          ),
          externalRef: Value(e.externalRef),
          aboutPresentationUrl: Value(e.aboutPresentationUrl),
          videoPresentationUrl: Value(e.videoPresentationUrl),
        ),
      ),
      mode: InsertMode.insertOrReplace,
    );
  }

  void _insertSessionBlocks(Batch batch, AppData appData) {
    batch.insertAll(
      _db.sessionBlocks,
      appData.collections.sessionBlocks.map(
        (sb) => SessionBlocksCompanion.insert(
          id: sb.id,
          parentId: sb.parentId,
          roomId: Value(sb.roomId),
          track: Value(sb.track),
          title: Value(sb.title),
          startDate: Value(sb.startDate),
          endDate: Value(sb.endDate),
          submissionFormatsJson: Value(
            sb.submissionFormats.isEmpty
                ? null
                : jsonEncode(sb.submissionFormats),
          ),
          defaultLang: Value(sb.defaultLang),
          externalRef: Value(sb.externalRef),
        ),
      ),
      mode: InsertMode.insertOrReplace,
    );
  }

  void _insertNews(Batch batch, AppData appData) {
    batch.insertAll(
      _db.news,
      appData.collections.news.map(
        (n) => NewsCompanion.insert(
          id: n.id,
          title: n.title,
          content: n.content,
          imgUrl: n.imgUrl,
          webUrl: n.webUrl,
          date: n.datePublish.toIso8601String(),
        ),
      ),
      mode: InsertMode.insertOrReplace,
    );
  }

  void _insertSocialActivities(Batch batch, AppData appData) {
    batch.insertAll(
      _db.socialActivities,
      appData.collections.socials.map(
        (sa) => SocialActivitiesCompanion.insert(
          id: sa.id,
          title: sa.title,
          description: sa.description,
          date: sa.date,
          time: sa.time,
          location: sa.location,
          imgUrl: sa.imgUrl,
        ),
      ),
      mode: InsertMode.insertOrReplace,
    );
  }

  void _insertPeople(Batch batch, AppData appData) {
    batch.insertAll(
      _db.people,
      appData.collections.people.map(
        (p) => PeopleCompanion.insert(
          id: p.id,
          name: p.name,
          country: Value(p.country),
          title: Value(p.title),
          institution: Value(p.institution),
          bio: Value(p.bio),
          photoUrl: Value(p.photoUrl),
        ),
      ),
      mode: InsertMode.insertOrReplace,
    );
  }

  void _insertAppConfigs(Batch batch, AppData appData) {
    batch.insert(
      _db.appConfigs,
      AppConfigsCompanion.insert(
        key: 'event_id',
        value: appData.metadata.eventId,
      ),
      mode: InsertMode.insertOrReplace,
    );
    batch.insert(
      _db.appConfigs,
      AppConfigsCompanion.insert(
        key: 'theme_config',
        value: jsonEncode({
          'colors': appData.theme.colors,
          'typography': appData.theme.typography,
          'logo': appData.theme.logo,
        }),
      ),
      mode: InsertMode.insertOrReplace,
    );
    batch.insert(
      _db.appConfigs,
      AppConfigsCompanion.insert(
        key: 'conference_themes',
        value: jsonEncode(
          appData.conference.conferenceThemes
              .map(ConferenceThemeMapper.toMap)
              .toList(),
        ),
      ),
      mode: InsertMode.insertOrReplace,
    );
  }
}
