import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class AppPageTransitions {
  // Slide from Right to Left - default
  static Route<T> slide<T>(Widget page) {
    return PageTransition<T>(
      child: page,
      type: PageTransitionType.rightToLeft,
      duration: const Duration(milliseconds: 260),
      reverseDuration: const Duration(milliseconds: 220),
      curve: Curves.fastOutSlowIn,
    );
  }

  // Slide from Left to Right
  static Route<T> slideFromLeft<T>(Widget page) {
    return PageTransition<T>(
      child: page,
      type: PageTransitionType.leftToRight,
      duration: const Duration(milliseconds: 260),
      reverseDuration: const Duration(milliseconds: 220),
      curve: Curves.fastOutSlowIn,
    );
  }

  // Slide from Bottom to Top
  static Route<T> slideFromBottom<T>(Widget page) {
    return PageTransition<T>(
      child: page,
      type: PageTransitionType.bottomToTop,
      duration: const Duration(milliseconds: 280),
      reverseDuration: const Duration(milliseconds: 240),
      curve: Curves.fastOutSlowIn,
    );
  }

  // Custom Slide from Top-Right for notification pages
  static Route<T> slideFromTopRight<T>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: const Duration(milliseconds: 300),
      reverseTransitionDuration: const Duration(milliseconds: 260),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curveAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.fastOutSlowIn,
          reverseCurve: Curves.fastOutSlowIn,
        );
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, -1.0),
            end: Offset.zero,
          ).animate(curveAnimation),
          child: child,
        );
      },
    );
  }

  // Fade transition
  static Route<T> fade<T>(Widget page) {
    return PageTransition<T>(
      child: page,
      type: PageTransitionType.fade,
      duration: const Duration(milliseconds: 260),
      reverseDuration: const Duration(milliseconds: 220),
      curve: Curves.easeIn,
    );
  }

  // Scale transition
  static Route<T> scale<T>(Widget page) {
    return PageTransition<T>(
      child: page,
      type: PageTransitionType.scale,
      alignment: Alignment.center,
      duration: const Duration(milliseconds: 260),
      reverseDuration: const Duration(milliseconds: 220),
      curve: Curves.easeOutBack,
    );
  }

  // Rotate transition
  static Route<T> rotate<T>(Widget page) {
    return PageTransition<T>(
      child: page,
      type: PageTransitionType.rotate,
      alignment: Alignment.center,
      duration: const Duration(milliseconds: 350),
      reverseDuration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  // splash exit transition
  static Route<T> splashExit<T>(Widget page) {
    return PageTransition<T>(
      child: page,
      type: PageTransitionType.fade,
      opaque: false,
      duration: const Duration(milliseconds: 700),
      reverseDuration: const Duration(milliseconds: 400),
      curve: Curves.easeIn,
    );
  }

  // Slide exit transition from splash screen
  static Route<T> splashSlideExit<T>(Widget page) {
    return PageTransition<T>(
      child: page,
      type: PageTransitionType.rightToLeft,
      opaque: false,
      duration: const Duration(milliseconds: 300),
      reverseDuration: const Duration(milliseconds: 260),
      curve: Curves.fastOutSlowIn,
    );
  }

  // Zoom out / Shrink fade transition for login/signup exit to Home
  static Route<T> loginExit<T>(Widget page) {
    return PageTransition<T>(
      child: page,
      type: PageTransitionType.fade,
      opaque: false,
      duration: const Duration(milliseconds: 650),
      reverseDuration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }
}
