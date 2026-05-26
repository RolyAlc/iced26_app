import 'package:iced26/domain/entities/event_status.dart';

/// Strings de UI compartidos entre múltiples pantallas.
/// Strings específicos de una sola pantalla van como `_kXxx` en su propio fichero.
abstract final class AppStrings {
  static const String genericErrorMessage =
      'Something went wrong. Please try again.';
  // TODO: Eliminar paulativamente el separator o reemplazarlo por otro más acorde.
  static const String separator = '  ·  ';
  static const String retry = 'Retry';
  static const String myScheduleTitle = 'My schedule';
  static const String myScheduleNothingSavedTitle = 'Nothing saved yet';
  static const String myScheduleNothingSavedMessage =
      'Bookmark sessions and talks to build your schedule';
  static const String myScheduleErrorTitle = 'Could not load your schedule';

  static const String scheduleTitle = 'Schedule';
  static const String scheduleViewingAllDays = 'Viewing all days';
  static const String scheduleNoSessionsTitle =
      'No sessions match your filters';
  static const String scheduleNoSessionsMessage =
      'Try a different category or clear the filter';
  static const String scheduleViewFormatList = 'List';
  static const String scheduleViewFormatAgenda = 'Agenda';

  static const String searchDone = 'Done';
  static String searchShowResults(int count) {
    return 'Show $count result${count == 1 ? '' : 's'}';
  }

  static const String searchExploreTitle = 'Explore';
  static const String searchExploreSubtitle =
      'Search by text, or filter by day, type and language.';
  static const String searchNoResultsTitle = 'No results';
  static const String searchNoResultsSubtitle =
      'Try adjusting your search or filters.';
  static const String searchFilterDay = 'Day';
  static const String searchFilterType = 'Type';
  static const String searchFilterZone = 'Zone';
  static const String searchFilterDuration = 'Duration';
  static const String searchFilterStatus = 'Status';
  static const String searchStatusLiveNow = 'Live now';
  static const String searchStatusUpNext = 'Up next';
  static const String searchStatusEnded = 'Ended';
  static String searchStatusLabel(EventStatus status) {
    return switch (status) {
      EventStatus.live => searchStatusLiveNow,
      EventStatus.next => searchStatusUpNext,
      EventStatus.ended => searchStatusEnded,
    };
  }

  static const String searchFilters = 'Filters';
  static String searchFiltersActive(int count) {
    return 'Filters ($count)';
  }

  static const String searchInputHint = 'Type author, title or room...';
  static const String searchBarHint = 'Search sessions, authors, rooms...';
  static const String searchRecentTitle = 'Recent';
  static const String searchRecentlyViewedTitle = 'Recently viewed';
  static const String searchRecentlyViewedPeopleTitle =
      'Recently viewed people';
  static const String searchClearAll = 'Clear all';
  static const String noRoom = 'No room';
  static const String searchPeopleLabel = 'People';
  static const String searchSessionsLabel = 'Sessions';
  static String searchShowMore(int count) {
    return 'Show $count more';
  }

  static String searchResultsCount(int count) {
    return '$count result${count == 1 ? '' : 's'}';
  }

  static const String searchRemoveRecent = 'Remove from recent';
  static String searchDurationLabel(int minutes) {
    return '$minutes min';
  }

  static String talkCountLabel(int count) {
    return '$count talk${count == 1 ? '' : 's'}';
  }

  static const String labelSpeakers = 'Speakers';
  static const String scheduleButtonSaved = 'Saved to my schedule';
  static const String scheduleButtonAdd = 'Add to my schedule';

  // Overflow de ponentes en listas compactas: "Name & +N more".
  static String speakersOverflow(int count) {
    return '& +$count more';
  }

  static const String themeLight = 'Light';
  static const String themeDark = 'Dark';
  static const String themeSystem = 'System';
}
