import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/features/customer/payment/presentation/animation/animated_delivery_boy.dart';

// Riding Scooter Animation
class RidingScooterAnimation extends StatefulWidget {
  const RidingScooterAnimation({super.key});

  @override
  State<RidingScooterAnimation> createState() => _RidingScooterAnimationState();
}

class _RidingScooterAnimationState extends State<RidingScooterAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    // Stop riding animation
    Future.delayed(const Duration(seconds: 7), () {
      if (mounted) {
        _controller.stop();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      height: 180.h,
      decoration: BoxDecoration(
        color: isDark ? CustomerAppColors.darkSurface : const Color(0xFFF0F4F8),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: isDark
              ? CustomerAppColors.darkBorder
              : Colors.grey.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24.r),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final t = _controller.value;
            return Stack(
              children: [
                // Clouds
                Positioned(
                  top: 20.h,
                  left: (350.w - (t * 450.w)) % 450.w - 80.w,
                  child: Icon(
                    Icons.cloud,
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.15)
                        : Colors.white,
                    size: 48.sp,
                  ),
                ),
                Positioned(
                  top: 45.h,
                  left: (150.w - (t * 450.w)) % 450.w - 80.w,
                  child: Icon(
                    Icons.cloud,
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.1)
                        : Colors.white.withValues(alpha: 0.7),
                    size: 32.sp,
                  ),
                ),
                // Trees sliding past
                Positioned(
                  bottom: 35.h,
                  left: (300.w - (t * 600.w)) % 600.w - 50.w,
                  child: Icon(
                    Icons.park,
                    color: isDark ? const Color(0xFF1E3A2B) : Colors.green[200],
                    size: 36.sp,
                  ),
                ),
                Positioned(
                  bottom: 35.h,
                  left: (550.w - (t * 600.w)) % 600.w - 50.w,
                  child: Icon(
                    Icons.park,
                    color: isDark ? const Color(0xFF14291E) : Colors.green[100],
                    size: 42.sp,
                  ),
                ),
                // Road surface
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 35.h,
                    color: isDark
                        ? const Color(0xFF2D3748)
                        : const Color(0xFFE2E8F0),
                  ),
                ),
                // Sliding road dashed lines
                Positioned(
                  bottom: 15.h,
                  left: -(t * 120.w),
                  child: Row(
                    children: List.generate(8, (index) {
                      return Container(
                        margin: EdgeInsets.only(right: 60.w),
                        width: 30.w,
                        height: 4.h,
                        color: isDark ? Colors.grey[500] : Colors.white,
                      );
                    }),
                  ),
                ),
                // Animated Delivery Boy & Scooter
                Positioned(
                  bottom: 22.h,
                  left: 90.w,
                  child: SizedBox(
                    width: 140.w,
                    height: 110.h,
                    child: AnimatedDeliveryBoy(animationValue: t),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
