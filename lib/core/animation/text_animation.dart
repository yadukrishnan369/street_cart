import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class AppTextAnimation {
  // Typewriter Animation
  static Widget typewriter(
    String text, {
    TextStyle? style,
    TextAlign textAlign = TextAlign.start,
    Duration speed = const Duration(milliseconds: 60),
    Key? key,
  }) {
    return AnimatedTextKit(
      key: key,
      animatedTexts: [
        TypewriterAnimatedText(
          text,
          textStyle: style,
          textAlign: textAlign,
          speed: speed,
        ),
      ],
      totalRepeatCount: 1,
      isRepeatingAnimation: false,
      displayFullTextOnTap: true,
    );
  }

  // Fade Animation
  static Widget fade(
    String text, {
    TextStyle? style,
    TextAlign textAlign = TextAlign.start,
    Duration duration = const Duration(milliseconds: 800),
    Key? key,
  }) {
    return TweenAnimationBuilder<double>(
      key: key,
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: duration,
      curve: Curves.easeIn,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Text(text, style: style, textAlign: textAlign),
        );
      },
    );
  }

  // Scale Animation
  static Widget scale(
    String text, {
    TextStyle? style,
    TextAlign textAlign = TextAlign.start,
    Duration duration = const Duration(milliseconds: 800),
    Key? key,
  }) {
    return TweenAnimationBuilder<double>(
      key: key,
      tween: Tween<double>(begin: 0.6, end: 1.0),
      duration: duration,
      curve: Curves.easeOutBack,
      builder: (context, scaleValue, child) {
        return TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0.0, end: 1.0),
          duration: duration,
          curve: Curves.easeIn,
          builder: (context, opacityValue, child) {
            return Opacity(
              opacity: opacityValue,
              child: Transform.scale(
                scale: scaleValue,
                child: Text(text, style: style, textAlign: textAlign),
              ),
            );
          },
        );
      },
    );
  }
}
