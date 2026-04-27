import 'package:flutter/material.dart';

import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/presentation/features/home/view/sheets/speaker_detail_sheet.dart';
import 'package:iced26/presentation/features/home/viewmodel/models/keynote_speaker_ui_model.dart';
import 'package:iced26/presentation/features/home/widgets/speaker_card.dart';
import 'package:iced26/presentation/widgets/app_dots_indicator.dart';

/// Sección de keynote speakers — carousel con peek + dots + CTA opcional.
class HomeKeynoteSection extends StatefulWidget {
  const HomeKeynoteSection({super.key, required this.speakers, this.onViewAll});

  final List<KeynoteSpeakerUIModel> speakers;
  final VoidCallback? onViewAll;

  @override
  State<HomeKeynoteSection> createState() => _HomeKeynoteSectionState();
}

class _HomeKeynoteSectionState extends State<HomeKeynoteSection> {
  late final PageController _controller;
  int _currentPage = 0;

  static const double _viewportFraction = 0.78;

  @override
  void initState() {
    super.initState();
    _controller = PageController(viewportFraction: _viewportFraction);
    _controller.addListener(_onScroll);
  }

  @override
  void dispose() {
    _controller.removeListener(_onScroll);
    _controller.dispose();
    super.dispose();
  }

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
        const SizedBox(height: AppSpacing.l),
        AppDotsIndicator(count: widget.speakers.length, current: _currentPage),
        if (widget.onViewAll != null) ...[
          const SizedBox(height: AppSpacing.m),
          _ViewAllButton(onTap: widget.onViewAll!),
        ],
      ],
    );
  }

  Widget _buildCarousel() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = constraints.maxWidth * _viewportFraction;
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
                  onTap: () => showSpeakerDetailSheet(context, speaker),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

/// Botón para ver todos los ponentes.
class _ViewAllButton extends StatelessWidget {
  const _ViewAllButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return TextButton.icon(
      onPressed: onTap,
      icon: Icon(Icons.people_outline_rounded, size: 18, color: colors.primary),
      label: Text(
        'Ver todos los ponentes',
        style: TextStyle(color: colors.primary),
      ),
    );
  }
}
