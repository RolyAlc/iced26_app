import 'package:flutter/material.dart';

import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/presentation/features/home/view/sheets/keynote_speaker_detail_sheet.dart';
import 'package:iced26/presentation/features/home/viewmodel/models/keynote_speaker_ui_model.dart';
import 'package:iced26/presentation/features/home/widgets/speaker_card.dart';
import 'package:iced26/presentation/shared/widgets/app_dots_indicator.dart';

/// Sección de keynote speakers: carousel con peek + dots.
class HomeKeynoteSection extends StatefulWidget {
  const HomeKeynoteSection({super.key, required this.speakers});

  final List<KeynoteSpeakerUIModel> speakers;

  @override
  State<HomeKeynoteSection> createState() => _HomeKeynoteSectionState();
}

/// Estado de la sección de keynote speakers.
class _HomeKeynoteSectionState extends State<HomeKeynoteSection> {
  late final PageController _controller;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _controller = PageController(viewportFraction: SpeakerCard.widthFactor);
    _controller.addListener(_onScroll);
  }

  @override
  void dispose() {
    _controller.removeListener(_onScroll);
    _controller.dispose();
    super.dispose();
  }

  /// Maneja el scroll del carousel.
  void _onScroll() {
    final page = _controller.page?.round() ?? 0;
    if (page != _currentPage) setState(() => _currentPage = page);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.speakers.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildCarousel(),
        if (widget.speakers.length > 1) ...[
          const SizedBox(height: AppSpacing.l),
          AppDotsIndicator(
            count: widget.speakers.length,
            current: _currentPage,
          ),
        ],
      ],
    );
  }

  Widget _buildCarousel() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = constraints.maxWidth * SpeakerCard.widthFactor;
        final cardHeight = cardWidth / SpeakerCard.aspectRatio;

        return SizedBox(
          height: cardHeight,
          child: PageView.builder(
            controller: _controller,
            itemCount: widget.speakers.length,
            itemBuilder: (context, index) {
              final speaker = widget.speakers[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s),
                child: SpeakerCard(
                  speaker: speaker,
                  onTap: () => showKeynoteSpeakerDetail(context, speaker),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
