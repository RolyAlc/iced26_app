import 'package:flutter/material.dart';
import 'package:iced26/domain/entities/event.dart';
import 'package:iced26/presentation/features/schedule/view/widgets/event_detail_sheet.dart';
import 'package:iced26/presentation/features/schedule/view/widgets/presentation_detail/presentation_detail_sheet.dart';

void showEventSheet(BuildContext context, Event event) {
  if (event.type.isPresentation) {
    showPresentationDetail(context, event);
  } else {
    showEventDetail(context, event);
  }
}
