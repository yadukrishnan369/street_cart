import 'package:flutter/material.dart';

class AppPageTransitions {
  // Slide from Right to Left - default
  static Route<T> slide<T>(Widget page) {
    return _slide<T>(page, const Offset(1.0, 0.0));
  }

  // Slide from Left to Right
  static Route<T> slideFromLeft<T>(Widget page) {
    return _slide<T>(page, const Offset(-1.0, 0.0));
  }

  // Slide from Bottom to Top
  static Route<T> slideFromBottom<T>(Widget page) {
    return PageRouteBuilder<T>(
      transitionDuration: const Duration(milliseconds: 280),
      reverseTransitionDuration: const Duration(milliseconds: 240),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curveAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.fastOutSlowIn,
          reverseCurve: Curves.fastOutSlowIn,
        );
        final tween = Tween<Offset>(
          begin: const Offset(0.0, 1.0),
          end: Offset.zero,
        );
        return SlideTransition(
          position: curveAnimation.drive(tween),
          child: child,
        );
      },
    );
  }

  // Slide from Top-Right
  static Route<T> slideFromTopRight<T>(Widget page) {
    return _slide<T>(page, const Offset(1.0, -1.0));
  }

  // Private reusable slide transition builder
  static Route<T> _slide<T>(Widget page, Offset beginOffset) {
    return PageRouteBuilder<T>(
      transitionDuration: const Duration(milliseconds: 260),
      reverseTransitionDuration: const Duration(milliseconds: 220),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curveAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.fastOutSlowIn,
          reverseCurve: Curves.fastOutSlowIn,
        );

        final tween = Tween<Offset>(begin: beginOffset, end: Offset.zero);

        return SlideTransition(
          position: curveAnimation.drive(tween),
          child: child,
        );
      },
    );
  }

  // Fade transition
  static Route<T> fade<T>(Widget page) {
    return PageRouteBuilder<T>(
      transitionDuration: const Duration(milliseconds: 260),
      reverseTransitionDuration: const Duration(milliseconds: 220),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curveAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeIn,
        );
        return FadeTransition(opacity: curveAnimation, child: child);
      },
    );
  }

  // Scale transition
  static Route<T> scale<T>(Widget page) {
    return PageRouteBuilder<T>(
      transitionDuration: const Duration(milliseconds: 260),
      reverseTransitionDuration: const Duration(milliseconds: 220),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curveAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutBack,
        );

        final tween = Tween<double>(begin: 0.0, end: 1.0);

        return ScaleTransition(
          scale: curveAnimation.drive(tween),
          child: child,
        );
      },
    );
  }

  // splash exit transition
  static Route<T> splashExit<T>(Widget page) {
    return PageRouteBuilder<T>(
      opaque: false,
      transitionDuration: const Duration(milliseconds: 700),
      reverseTransitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curveAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeIn,
        );
        return FadeTransition(opacity: curveAnimation, child: child);
      },
    );
  }

  // Slide exit transition from splash screen
  static Route<T> splashSlideExit<T>(Widget page) {
    return PageRouteBuilder<T>(
      opaque: false,
      transitionDuration: const Duration(milliseconds: 300),
      reverseTransitionDuration: const Duration(milliseconds: 260),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curveAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.fastOutSlowIn,
          reverseCurve: Curves.fastOutSlowIn,
        );
        final tween = Tween<Offset>(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        );
        return SlideTransition(
          position: curveAnimation.drive(tween),
          child: child,
        );
      },
    );
  }

  // Zoom out / Shrink fade transition for login/signup exit to Home
  static Route<T> loginExit<T>(Widget page) {
    return PageRouteBuilder<T>(
      opaque: false,
      transitionDuration: const Duration(milliseconds: 650),
      reverseTransitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final fadeAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOut,
        );
        final scaleAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOut,
        );

        final scaleTween = Tween<double>(
          begin: 1.08, // Entering page zooms down to 1.0
          end: 1.0,
        );

        return FadeTransition(
          opacity: fadeAnimation,
          child: ScaleTransition(
            scale: scaleAnimation.drive(scaleTween),
            child: child,
          ),
        );
      },
    );
  }
}
