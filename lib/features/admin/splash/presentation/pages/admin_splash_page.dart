import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';
import 'package:street_cart/core/theme/admin/admin_text_styles.dart';
import 'package:street_cart/features/admin/auth/presentation/bloc/admin_auth_bloc.dart';
import 'package:street_cart/features/admin/auth/presentation/bloc/admin_auth_event.dart';
import 'package:street_cart/shared/widgets/app_logo.dart';
import 'package:street_cart/di/dependency_injection.dart';
import 'package:street_cart/features/admin/splash/presentation/bloc/admin_splash_bloc.dart';
import 'package:street_cart/features/admin/splash/presentation/bloc/admin_splash_event.dart';
import 'package:street_cart/features/admin/splash/presentation/bloc/admin_splash_state.dart';

class AdminSplashPage extends StatefulWidget {
  const AdminSplashPage({super.key});

  @override
  State<AdminSplashPage> createState() => _AdminSplashPageState();
}

class _AdminSplashPageState extends State<AdminSplashPage> {
  double _progress = 0.0;
  String _loadingText = 'Initializing secure assets';
  Timer? _progressTimer;
  late AdminSplashBloc _splashBloc;

  @override
  void initState() {
    super.initState();
    _splashBloc = sl<AdminSplashBloc>();
    _startLoadingAnimation();
  }

  void _startLoadingAnimation() {
    const totalDuration = Duration(milliseconds: 2000);
    const tickDuration = Duration(milliseconds: 50);
    final ticks = totalDuration.inMilliseconds / tickDuration.inMilliseconds;
    double increment = 1.0 / ticks;

    _progressTimer = Timer.periodic(tickDuration, (timer) {
      setState(() {
        _progress += increment;
        if (_progress >= 0.35 && _progress < 0.7) {
          _loadingText = 'Loading system configurations';
        } else if (_progress >= 0.7 && _progress < 0.9) {
          _loadingText = 'Verifying admin credentials';
        } else if (_progress >= 0.9) {
          _loadingText = 'Launching dashboard';
        }

        if (_progress >= 1.0) {
          _progress = 1.0;
          timer.cancel();
          _checkAuthAndNavigate();
        }
      });
    });
  }

  void _checkAuthAndNavigate() {
    _splashBloc.add(CheckAdminSplashSessionEvent());
  }

  @override
  void dispose() {
    _progressTimer?.cancel();
    _splashBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _splashBloc,
      child: BlocListener<AdminSplashBloc, AdminSplashState>(
        listener: (context, state) {
          if (state is AdminSplashAuthenticated) {
            context.read<AdminAuthBloc>().add(
              const AdminAuthSessionVerified(true),
            );
          } else if (state is AdminSplashUnauthenticated ||
              state is AdminSplashError) {
            context.read<AdminAuthBloc>().add(
              const AdminAuthSessionVerified(false),
            );
          }
        },
        child: Scaffold(
          backgroundColor: AdminAppColors.backgroundLight,
          body: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isDesktop = constraints.maxWidth > 800;

                return Center(
                  child: Container(
                    width: isDesktop ? 600.w : double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(), // Spacer
                        // Center Logo & Title & Loading Bar
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const AppLogo(
                              size: 80,
                              backgroundColor: AdminAppColors.primaryColor,
                              logoColor: AdminAppColors.surfaceWhite,
                            ),
                            SizedBox(height: 24.h),

                            // App Title
                            Text(
                              'Street Cart Admin',
                              style: AdminAppTextStyles.heading1.copyWith(
                                color: AdminAppColors.textPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: isDesktop ? 32.sp : 26.sp,
                              ),
                            ),
                            SizedBox(height: 8.h),

                            // Subtitle
                            Text(
                              'Loading system...',
                              style: AdminAppTextStyles.bodyMedium.copyWith(
                                color: AdminAppColors.textSecondary,
                              ),
                            ),
                            SizedBox(height: 48.h),

                            // Progress Labels
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _loadingText,
                                  style: AdminAppTextStyles.bodySmall.copyWith(
                                    color: AdminAppColors.textSecondary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  '${(_progress * 100).toInt()}%',
                                  style: AdminAppTextStyles.bodySmall.copyWith(
                                    color: AdminAppColors.primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8.h),

                            // Progress Bar
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4.r),
                              child: LinearProgressIndicator(
                                value: _progress,
                                minHeight: 8.h,
                                backgroundColor: AdminAppColors.primaryLight
                                    .withOpacity(0.3),
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                  AdminAppColors.primaryColor,
                                ),
                              ),
                            ),
                            SizedBox(height: 32.h),

                            // Secure environment label
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.lock_outline,
                                  color: AdminAppColors.primaryColor
                                      .withOpacity(0.6),
                                  size: 14.sp,
                                ),
                                SizedBox(width: 6.w),
                                Text(
                                  'SECURE ENVIRONMENT',
                                  style: AdminAppTextStyles.caption.copyWith(
                                    color: AdminAppColors.primaryColor,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        // Footer Copyright
                        Padding(
                          padding: EdgeInsets.only(bottom: 24.h),
                          child: Text(
                            '© 2026 Street Cart Systems Inc.',
                            style: AdminAppTextStyles.caption.copyWith(
                              color: AdminAppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
