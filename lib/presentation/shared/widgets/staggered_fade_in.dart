import 'package:flutter/material.dart';
import 'package:iced26/core/constants/design_tokens.dart';

/// Widget para animaciones de entrada escalonadas.
class StaggeredFadeIn extends StatefulWidget {
  const StaggeredFadeIn({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = AppDuration.entrance,
    this.offset = const Offset(0, 0.1),
  });

  /// [:: Dev] Cambia a false para deshabilitar todas las animaciones de entrada.
  static const bool kEnabled = false;

  final Widget child;
  final Duration delay;
  final Duration duration;
  final Offset offset;

  @override
  State<StaggeredFadeIn> createState() => _StaggeredFadeInState();
}

/// Estado del widget StaggeredFadeIn.
class _StaggeredFadeInState extends State<StaggeredFadeIn>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // Inicializamos el controlador de animación
    _controller = AnimationController(vsync: this, duration: widget.duration);

    // Curva de aceleración.
    final curvedAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    // Animación de Opacidad.
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(curvedAnimation);

    // Animación de Desplazamiento.
    _slideAnimation = Tween<Offset>(
      begin: widget.offset,
      end: Offset.zero,
    ).animate(curvedAnimation);

    // Iniciamos la animación con el retraso indicado.
    Future.delayed(widget.delay, () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  /// Libera los recursos del controlador de animación.
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Construye el widget de animación escalonada.
  @override
  Widget build(BuildContext context) {
    if (!StaggeredFadeIn.kEnabled) {
      return widget.child;
    }
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(position: _slideAnimation, child: widget.child),
    );
  }
}
