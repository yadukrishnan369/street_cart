import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/Customer_app_colors.dart';

class AppLogo extends StatefulWidget {
  final bool isDark;
  final double size;

  const AppLogo({super.key, this.isDark = false, this.size = 80});

  @override
  State<AppLogo> createState() => _AppLogoState();
}

class _AppLogoState extends State<AppLogo> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: widget.size.w,
          height: widget.size.w,
          decoration: BoxDecoration(
            color: widget.isDark
                ? CustomerAppColors.primary
                : CustomerAppColors.primaryLight,
            borderRadius: BorderRadius.circular((widget.size * 0.3).r),
            boxShadow: [
              BoxShadow(
                color: CustomerAppColors.primary.withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(widget.size * 0.1),
              child: Image.asset(
                'assets/icons/logo.png',
                width: (widget.size * 0.9).w,
                height: (widget.size * 0.9).w,
                color: widget.isDark ? Colors.white : CustomerAppColors.primary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
