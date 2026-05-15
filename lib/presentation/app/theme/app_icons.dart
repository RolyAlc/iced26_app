import 'package:flutter/material.dart';

/// Catálogo central de iconos de la app.
abstract final class AppIcons {
  // --- Navegación ---
  static const homeOff = Icons.home_outlined;
  static const homeOn = Icons.home_filled;
  static const scheduleOff = Icons.calendar_month_outlined;
  static const scheduleOn = Icons.calendar_month_rounded;
  static const searchOff = Icons.search_outlined;
  static const searchOn = Icons.search_rounded;
  static const diaryOff = Icons.bookmark_border_rounded;
  static const diaryOn = Icons.bookmark_rounded;
  static const settingsOff = Icons.settings_outlined;
  static const settingsOn = Icons.settings_rounded;

  // --- Acciones generales ---
  static const search = Icons.search_rounded;
  static const searchEmpty = Icons.search_off_rounded;
  static const filter = Icons.tune_rounded;
  static const arrowBack = Icons.arrow_back_rounded;
  static const close = Icons.close_rounded;
  static const delete = Icons.delete_rounded;
  static const deleteOutline = Icons.delete_outline_rounded;
  static const expand = Icons.keyboard_arrow_down_rounded;
  static const collapse = Icons.keyboard_arrow_up_rounded;
  static const expandMore = Icons.expand_more_rounded;
  static const chevronLeft = Icons.chevron_left_rounded;
  static const chevronRight = Icons.chevron_right_rounded;
  static const arrowForward = Icons.arrow_forward_rounded;
  static const openInNew = Icons.open_in_new_rounded;
  static const refresh = Icons.refresh_rounded;
  static const add = Icons.add_rounded;
  static const editNote = Icons.edit_note_rounded;
  static const apps = Icons.apps_rounded;
  static const moreHoriz = Icons.more_horiz_rounded;

  // --- Guardar / Favorito ---
  static const bookmarkOff = Icons.bookmark_border_rounded;
  static const bookmarkOn = Icons.bookmark_rounded;
  static const bookmarkOutline = Icons.bookmark_outlined;
  static const bookmarkAdd = Icons.bookmark_add_rounded;
  static const bookmarkRemove = Icons.bookmark_remove_rounded;

  // --- Estado / Feedback ---
  static const error = Icons.error_outline_rounded;
  static const info = Icons.info_outline_rounded;
  static const empty = Icons.auto_awesome_rounded;
  static const history = Icons.history_rounded;

  // --- Tiempo y lugar ---
  static const time = Icons.access_time_rounded;
  static const accessTime = Icons.access_time_filled_rounded;
  static const duration = Icons.timelapse_rounded;
  static const clockOutline = Icons.access_time_outlined;
  static const calendarOutline = Icons.calendar_month_outlined;
  static const scheduleOutline = Icons.schedule_outlined;
  static const locationOn = Icons.location_on_rounded;
  static const meetingRoom = Icons.meeting_room_rounded;
  static const meetingRoomOutline = Icons.meeting_room_outlined;

  // --- Personas ---
  static const person = Icons.person_rounded;
  static const peopleOutline = Icons.people_outline_rounded;
  static const business = Icons.business_rounded;

  // --- Tipos de evento ---
  // Nota: workshop, sessions y forum comparten icono — pendiente revisión de diseño.
  static const mic = Icons.mic_rounded;
  static const handyman = Icons.handyman_rounded;
  static const article = Icons.article_rounded;
  static const collections = Icons.collections_rounded;
  static const recordVoiceOver = Icons.record_voice_over_rounded;
  static const workshop = Icons.forum_rounded;
  static const sessions = Icons.forum_rounded;
  static const forum = Icons.forum_rounded;
  static const gridView = Icons.grid_view_rounded;

  // --- Categorías y contenido ---
  static const category = Icons.category_rounded;
  static const news = Icons.newspaper_rounded;
  static const social = Icons.celebration_rounded;
  static const event = Icons.event_rounded;
  static const workspacePremium = Icons.workspace_premium_rounded;
  static const playCircleOutline = Icons.play_circle_outline_rounded;
  static const slideshow = Icons.slideshow_rounded;

  // --- Configuración ---
  static const textField = Icons.text_fields_rounded;
  static const darkTheme = Icons.dark_mode_outlined;
  static const lightTheme = Icons.light_mode_outlined;
  static const systemTheme = Icons.brightness_auto_outlined;
  static const translate = Icons.translate_rounded;
  static const smartphone = Icons.smartphone_rounded;
  static const language = Icons.language_rounded;

  // --- Eventos especiales ---
  static const coffee = Icons.coffee_rounded;
  static const celebration = Icons.celebration_rounded;
  static const flag = Icons.flag_rounded;
  static const wineBar = Icons.wine_bar_rounded;
  static const wavingHand = Icons.waving_hand_rounded;
  static const registration = Icons.how_to_reg_rounded;
}
