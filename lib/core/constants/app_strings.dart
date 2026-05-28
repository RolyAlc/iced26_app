import 'package:iced26/domain/entities/event_status.dart';

/// Strings de UI compartidos entre múltiples pantallas.
/// Strings específicos de una sola pantalla van como `_kXxx` en su propio fichero.
abstract final class AppStrings {
  static const String genericErrorMessage =
      'Something went wrong. Please try again.';
  // TODO: Eliminar paulativamente el separator o reemplazarlo por otro más acorde.
  static const String separator = '  ·  ';
  static const String retry = 'Retry';

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

  static const String diaryDeleteNoteTitle = 'Delete note?';
  static const String diaryDeleteNoteConfirm = 'This action cannot be undone.';
  static const String startupErrorTitle = 'Could not start the app';
  static const String startupErrorMessage = 'Try restarting the application';
}
