import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:iced26/presentation/features/diary/view/widgets/diary_body.dart';
import 'package:iced26/presentation/features/diary/view/widgets/diary_fab.dart';
import 'package:iced26/presentation/features/diary/view/widgets/diary_header.dart';
import 'package:iced26/presentation/shared/widgets/app_page.dart';

class DiaryView extends ConsumerWidget {
  const DiaryView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      children: [
        AppPage(header: const DiaryHeader(), children: [const DiaryBody()]),
        const DiaryFab(),
      ],
    );
  }
}
