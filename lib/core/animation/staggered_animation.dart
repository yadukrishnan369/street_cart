import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class AppStaggeredAnimation {
  // Wraps lists/grids container
  static Widget limiter({required Widget child}) {
    return AnimationLimiter(child: child);
  }

  // Staggered List item animation
  static Widget staggeredList({
    required int index,
    required Widget child,
    Duration duration = const Duration(milliseconds: 300),
    double verticalOffset = 30.0,
  }) {
    return AnimationConfiguration.staggeredList(
      position: index,
      duration: duration,
      child: SlideAnimation(
        verticalOffset: verticalOffset,
        child: FadeInAnimation(child: child),
      ),
    );
  }

  // Staggered Grid item animation
  static Widget staggeredGrid({
    required int index,
    required int columnCount,
    required Widget child,
    Duration duration = const Duration(milliseconds: 300),
    double scale = 0.9,
  }) {
    return AnimationConfiguration.staggeredGrid(
      position: index,
      duration: duration,
      columnCount: columnCount,
      child: ScaleAnimation(
        scale: scale,
        child: FadeInAnimation(child: child),
      ),
    );
  }

  // Static Column staggered list builder
  static List<Widget> toStaggeredList({
    required List<Widget> children,
    Duration duration = const Duration(milliseconds: 300),
    double verticalOffset = 30.0,
  }) {
    return AnimationConfiguration.toStaggeredList(
      duration: duration,
      childAnimationBuilder: (widget) => SlideAnimation(
        verticalOffset: verticalOffset,
        child: FadeInAnimation(child: widget),
      ),
      children: children,
    );
  }
}
