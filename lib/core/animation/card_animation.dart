import 'package:flutter/material.dart';

// Card Animation for Staggered Cards
class CardAnimation extends StatefulWidget {
  final Widget child;
  final int index;
  final Duration duration;
  final double slideOffset;

  const CardAnimation({
    super.key,
    required this.child,
    required this.index,
    this.duration = const Duration(milliseconds: 350),
    this.slideOffset = 15.0,
  });

  @override
  State<CardAnimation> createState() => _CardAnimationState();
}

class _CardAnimationState extends State<CardAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _slideAnimation;
  bool _hasStarted = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _slideAnimation = Tween<double>(
      begin: widget.slideOffset,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _startAnimation();
  }

  Future<void> _startAnimation() async {
    if (_hasStarted) return;
    _hasStarted = true;

    // Stagger delay - 100ms per index
    final delayMs = widget.index * 100;
    await Future.delayed(Duration(milliseconds: delayMs));

    if (mounted) {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: Transform.translate(
            offset: Offset(0, _slideAnimation.value),
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
}
