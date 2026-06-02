import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/presentation/app/theme/app_icons.dart';
import 'package:iced26/presentation/features/home/viewmodel/models/conference_theme_ui_model.dart';
import 'package:iced26/presentation/shared/widgets/reading_controls_pill.dart';

// Constants
const _kBack = 'Back';
const _kTopicsInclude = 'Topics include';
const _kReadTimeLabel = 'min';
const _kCopiedMessage = 'Copied to clipboard';
// Sizes & positions
const _kBackButtonSize = 36.0;
const _kBackButtonIconSize = 20.0;
const _kChipIconSize = 14.0;
const _kChipLabelPaddingLeft = 2.0;
const _kProgressBarHeight = 2.0;
// Espacio extra en la parte inferior para que los FABs no tapen el último párrafo.
const _kFabScrollClearance = AppLayout.navBarHeight;
// Píxeles de scroll necesarios para que aparezca el botón "volver arriba".
const _kScrollToTopThreshold = 200.0;

/// Pantalla completa de detalle de un tema de la conferencia.
class ConferenceThemeDetailPage extends StatefulWidget {
  const ConferenceThemeDetailPage({super.key, required this.theme});

  final ConferenceThemeUIModel theme;

  static void open(BuildContext context, ConferenceThemeUIModel theme) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, _) {
          return ConferenceThemeDetailPage(theme: theme);
        },
        transitionsBuilder: (context, animation, _, child) {
          final curved = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOut,
          );
          return FadeTransition(
            opacity: curved,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.04),
                end: Offset.zero,
              ).animate(curved),
              child: child,
            ),
          );
        },
        reverseTransitionDuration: AppDuration.fast,
      ),
    );
  }

  @override
  State<ConferenceThemeDetailPage> createState() {
    return _ConferenceThemeDetailPageState();
  }
}

/// State del detalle de un tema de la conferencia.
class _ConferenceThemeDetailPageState extends State<ConferenceThemeDetailPage> {
  final _scrollController = ScrollController();
  double _readProgress = 0.0;
  bool _showScrollToTop = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final offset = _scrollController.offset;
    final max = _scrollController.position.maxScrollExtent;
    if (max <= 0) return;
    final showTop = offset >= _kScrollToTopThreshold;
    setState(() {
      _readProgress = offset / max;
      _showScrollToTop = showTop;
    });
  }

  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(_kCopiedMessage),
        behavior: SnackBarBehavior.floating,
        duration: AppDuration.medium,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final name = widget.theme.name;
    final description = widget.theme.description;
    final readMinutes = widget.theme.readMinutes;

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppBar(
        backgroundColor: colors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        title: const _BackButton(),
        titleSpacing: AppSpacing.m,
        actions: [
          IconButton(
            icon: const Icon(AppIcons.copyContent),
            tooltip: _kCopiedMessage,
            onPressed: () => _copyToClipboard(context, '$name\n\n$description'),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(_kProgressBarHeight),
          child: LinearProgressIndicator(
            value: _readProgress,
            minHeight: _kProgressBarHeight,
            backgroundColor: colors.surfaceContainerHighest,
            valueColor: AlwaysStoppedAnimation(colors.primary),
          ),
        ),
      ),
      floatingActionButton: ReadingControlsFab(
        scrollController: _scrollController,
        showScrollToTop: _showScrollToTop,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SafeArea(
        child: SelectionArea(
          child: SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.l,
              AppSpacing.l,
              AppSpacing.l,
              AppSpacing.l + _kFabScrollClearance,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.s),
                _ReadTimeChip(minutes: readMinutes),
                const SizedBox(height: AppSpacing.l),
                _ThemeDetailContent(theme: widget.theme),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Botón de navegación hacia atrás: icono circular + texto "Back".
class _BackButton extends StatelessWidget {
  const _BackButton();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return InkWell(
      onTap: () => Navigator.pop(context),
      borderRadius: BorderRadius.circular(_kBackButtonSize),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xs,
          vertical: AppSpacing.xs,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: _kBackButtonSize,
              height: _kBackButtonSize,
              decoration: BoxDecoration(
                color: colors.surfaceContainerHigh,
                shape: BoxShape.circle,
              ),
              child: Icon(
                AppIcons.arrowBack,
                color: colors.onSurface,
                size: _kBackButtonIconSize,
              ),
            ),
            const SizedBox(width: AppSpacing.m),
            Text(
              _kBack,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colors.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Chip que indica el tiempo estimado de lectura.
class _ReadTimeChip extends StatelessWidget {
  const _ReadTimeChip({required this.minutes});

  final int minutes;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Chip(
      avatar: Icon(
        AppIcons.timerOutlined,
        size: _kChipIconSize,
        color: colors.onSurface,
      ),
      label: Text('$minutes $_kReadTimeLabel'),
      labelStyle: theme.textTheme.labelSmall?.copyWith(color: colors.onSurface),
      backgroundColor: colors.surfaceContainerHigh,
      side: BorderSide.none,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
      labelPadding: const EdgeInsets.only(
        left: _kChipLabelPaddingLeft,
        right: AppSpacing.xs,
      ),
      visualDensity: VisualDensity.compact,
    );
  }
}

/// Descripción completa del tema + lista de tópicos.
class _ThemeDetailContent extends StatelessWidget {
  const _ThemeDetailContent({required this.theme});

  final ConferenceThemeUIModel theme;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final description = theme.description;
    final topics = theme.topics;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          description,
          style: textTheme.bodyLarge?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            height: 1.6,
          ),
        ),
        if (topics.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.l),
          Text(
            _kTopicsInclude,
            style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppSpacing.s),
          _TopicsList(topics: topics),
        ],
      ],
    );
  }
}

/// Lista de tópicos con viñeta de bala alineada a la primera línea.
class _TopicsList extends StatelessWidget {
  const _TopicsList({required this.topics});

  final List<String> topics;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bulletStyle = theme.textTheme.bodyMedium?.copyWith(
      color: theme.colorScheme.primary,
      fontWeight: FontWeight.bold,
    );
    final contentStyle = theme.textTheme.bodyMedium?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
      height: 1.4,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final topic in topics)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.s),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('•', style: bulletStyle),
                const SizedBox(width: AppSpacing.s),
                Expanded(child: Text(topic, style: contentStyle)),
              ],
            ),
          ),
      ],
    );
  }
}
