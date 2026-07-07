import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AnimatedDeliveryBoy extends StatelessWidget {
  final double animationValue;

  const AnimatedDeliveryBoy({super.key, required this.animationValue});

  @override
  Widget build(BuildContext context) {
    final t = animationValue;
    final bob = sin(t * 4 * pi) * 2.5.h;
    final tilt = sin(t * 4 * pi) * 0.015;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Wind speed lines blowing past in the background
        ...List.generate(2, (index) {
          final windTime = (t + (index / 2)) % 1.0;
          return Positioned(
            top: 15.h + (index * 25.h),
            left: 200.w - (windTime * 300.w),
            child: Opacity(
              opacity: (1.0 - windTime).clamp(0.0, 1.0),
              child: Container(
                width: 30.w,
                height: 1.5.h,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(1.r),
                ),
              ),
            ),
          );
        }),

        // Exhaust smoke puffs drifting backward
        ...List.generate(3, (index) {
          final particleTime = (t + (index / 3)) % 1.0;
          final scale = 0.3 + (particleTime * 0.7);
          final opacity = 1.0 - particleTime;
          return Positioned(
            bottom: 12.h + (particleTime * 14.h),
            left: -8.w - (particleTime * 65.w),
            child: Opacity(
              opacity: opacity,
              child: Container(
                width: 14.w * scale,
                height: 14.w * scale,
                decoration: const BoxDecoration(
                  color: Color(0xFFCBD5E1),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          );
        }),

        // Rear Wheel
        Positioned(bottom: 0, left: 12.w, child: _buildWheel(t)),

        // Front Wheel
        Positioned(bottom: 0, left: 92.w, child: _buildWheel(t)),

        // Scooter Chassis & Frame
        Positioned(
          bottom: 6.h + bob,
          left: 12.w,
          child: Transform.rotate(
            angle: tilt,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // exhaust pipe
                Positioned(
                  left: -5.w,
                  bottom: 3.h,
                  child: Container(
                    width: 25.w,
                    height: 5.h,
                    decoration: BoxDecoration(
                      color: Colors.grey[600],
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                ),
                // Yellow floorboard
                Container(
                  width: 82.w,
                  height: 16.h,
                  decoration: BoxDecoration(
                    color: Colors.yellow[600],
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                // Front Stem column
                Positioned(
                  right: 6.w,
                  bottom: 8.h,
                  child: Transform.rotate(
                    angle: -0.15,
                    child: Container(
                      width: 7.w,
                      height: 48.h,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
                // Handlebar grips
                Positioned(
                  right: 0,
                  bottom: 52.h,
                  child: Container(
                    width: 16.w,
                    height: 6.h,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(3.r),
                    ),
                  ),
                ),
                // Headlight
                Positioned(
                  right: -42.w,
                  bottom: 18.h,
                  child: Transform.rotate(
                    angle: -0.1,
                    child: Container(
                      width: 40.w,
                      height: 25.h,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.yellow[300]!.withValues(alpha: 0.3),
                            Colors.yellow[100]!.withValues(alpha: 0.0),
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20.r),
                          bottomRight: Radius.circular(20.r),
                        ),
                      ),
                    ),
                  ),
                ),
                // Front Shield
                Positioned(
                  right: -2.w,
                  bottom: 6.h,
                  child: Transform.rotate(
                    angle: -0.15,
                    child: Container(
                      width: 10.w,
                      height: 40.h,
                      decoration: BoxDecoration(
                        color: Colors.yellow[600],
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(8.r),
                          bottomRight: Radius.circular(4.r),
                        ),
                      ),
                    ),
                  ),
                ),
                // Black seat
                Positioned(
                  left: 12.w,
                  bottom: 12.h,
                  child: Container(
                    width: 36.w,
                    height: 10.h,
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(5.r),
                    ),
                  ),
                ),
                // Back Mudguard
                Positioned(
                  left: -2.w,
                  bottom: 4.h,
                  child: Container(
                    width: 18.w,
                    height: 14.h,
                    decoration: BoxDecoration(
                      color: Colors.yellow[700],
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Delivery Boy Driver
        Positioned(
          bottom: 26.h + bob,
          left: 28.w,
          child: Transform.rotate(
            angle: tilt * 0.5,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Blue trousers/legs
                Positioned(
                  bottom: -15.h,
                  left: 10.w,
                  child: Transform.rotate(
                    angle: 0.35,
                    child: Container(
                      width: 9.w,
                      height: 24.h,
                      decoration: BoxDecoration(
                        color: Colors.blue[700],
                        borderRadius: BorderRadius.circular(3.r),
                      ),
                    ),
                  ),
                ),
                // Red Jacket body
                Container(
                  width: 26.w,
                  height: 34.h,
                  decoration: BoxDecoration(
                    color: Colors.red[600],
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                // Backpack strap details
                Positioned(
                  left: 4.w,
                  top: 2.h,
                  bottom: 2.h,
                  child: Container(
                    width: 3.w,
                    color: Colors.black.withValues(alpha: 0.3),
                  ),
                ),
                Positioned(
                  left: 18.w,
                  top: 2.h,
                  bottom: 2.h,
                  child: Container(
                    width: 3.w,
                    color: Colors.black.withValues(alpha: 0.3),
                  ),
                ),
                // Arm reaching to handlebar
                Positioned(
                  right: -10.w,
                  top: 6.h,
                  child: Transform.rotate(
                    angle: -0.65,
                    child: Container(
                      width: 22.w,
                      height: 7.h,
                      decoration: BoxDecoration(
                        color: Colors.red[600],
                        borderRadius: BorderRadius.circular(3.r),
                      ),
                    ),
                  ),
                ),
                // Head with Green Helmet
                Positioned(
                  top: -24.h,
                  left: 2.w,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Face skin
                      Container(
                        width: 20.w,
                        height: 20.w,
                        decoration: const BoxDecoration(
                          color: Color(0xFFFFD1A9),
                          shape: BoxShape.circle,
                        ),
                      ),
                      // Helmet shell
                      Positioned(
                        top: -1.h,
                        child: Container(
                          width: 22.w,
                          height: 14.h,
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      // Visor with shiny reflections
                      Positioned(
                        right: 0,
                        top: 4.h,
                        child: Container(
                          width: 8.w,
                          height: 5.h,
                          decoration: const BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.horizontal(
                              right: Radius.circular(2),
                            ),
                          ),
                          child: Align(
                            alignment: Alignment.topRight,
                            child: Container(
                              margin: EdgeInsets.all(1.w),
                              width: 3.w,
                              height: 1.5.h,
                              color: Colors.white.withValues(alpha: 0.6),
                            ),
                          ),
                        ),
                      ),
                      // Helmet Chin strap
                      Positioned(
                        bottom: 1.h,
                        child: Container(
                          width: 8.w,
                          height: 1.5.h,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                // Yellow Delivery Box backpack on back
                Positioned(
                  left: -20.w,
                  top: 2.h,
                  child: Container(
                    width: 20.w,
                    height: 24.h,
                    decoration: BoxDecoration(
                      color: Colors.yellow[700],
                      borderRadius: BorderRadius.circular(4.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        'SC',
                        style: TextStyle(
                          fontSize: 8.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWheel(double t) {
    return Transform.rotate(
      angle: -t * 6 * pi,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Tire
          Container(
            width: 26.w,
            height: 26.w,
            decoration: BoxDecoration(
              color: Colors.grey[800],
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey[900]!, width: 2.w),
            ),
          ),
          // Rim
          Container(
            width: 14.w,
            height: 14.w,
            decoration: const BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.circle,
            ),
          ),
          // Spokes lines
          Container(width: 12.w, height: 1.5.h, color: Colors.white),
          Transform.rotate(
            angle: pi / 2,
            child: Container(width: 12.w, height: 1.5.h, color: Colors.white),
          ),
          Transform.rotate(
            angle: pi / 4,
            child: Container(width: 12.w, height: 1.5.h, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
