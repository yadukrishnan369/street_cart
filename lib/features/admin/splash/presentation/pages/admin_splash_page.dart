import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';
import 'package:street_cart/core/theme/admin/admin_text_styles.dart';
import 'package:street_cart/di/dependency_injection.dart';
import 'package:street_cart/features/admin/auth/presentation/bloc/admin_auth_bloc.dart';
import 'package:street_cart/features/admin/auth/presentation/bloc/admin_auth_event.dart';
import 'package:street_cart/features/admin/splash/presentation/bloc/admin_splash_bloc.dart';
import 'package:street_cart/features/admin/splash/presentation/bloc/admin_splash_event.dart';
import 'package:street_cart/features/admin/splash/presentation/bloc/admin_splash_state.dart';
import 'package:street_cart/shared/widgets/app_logo.dart';

// Admin Splash Page
class AdminSplashPage extends StatefulWidget {
  const AdminSplashPage({super.key});

  @override
  State<AdminSplashPage> createState() => _AdminSplashPageState();
}

class _AdminSplashPageState extends State<AdminSplashPage> {
  late AdminSplashBloc _splashBloc;

  @override
  void initState() {
    super.initState();
    _splashBloc = sl<AdminSplashBloc>();
    // Start animation
    _splashBloc.add(const StartSplashAnimation());
  }

  @override
  void dispose() {
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

                return BlocBuilder<AdminSplashBloc, AdminSplashState>(
                  builder: (context, state) {
                    final progress = state is AdminSplashAnimating
                        ? state.progress
                        : (state is AdminSplashLoading ? 1.0 : 0.0);
                    final loadingText = state is AdminSplashAnimating
                        ? state.loadingText
                        : 'Initializing secure assets';

                    return Center(
                      child: Container(
                        width: isDesktop ? 600.w : double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SizedBox(),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // App logo
                                const AppLogo(
                                  size: 80,
                                  backgroundColor: AdminAppColors.primaryColor,
                                  logoColor: AdminAppColors.surfaceWhite,
                                ),
                                SizedBox(height: 24.h),
                                Text(
                                  'Street Cart Admin',
                                  style: AdminAppTextStyles.heading1.copyWith(
                                    color: AdminAppColors.textPrimary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: isDesktop ? 32.sp : 26.sp,
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  'Loading system...',
                                  style: AdminAppTextStyles.bodyMedium.copyWith(
                                    color: AdminAppColors.textSecondary,
                                  ),
                                ),
                                SizedBox(height: 48.h),
                                // Progress label
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      loadingText,
                                      style: AdminAppTextStyles.bodySmall
                                          .copyWith(
                                            color: AdminAppColors.textSecondary,
                                            fontWeight: FontWeight.w500,
                                          ),
                                    ),
                                    Text(
                                      '${(progress * 100).toInt()}%',
                                      style: AdminAppTextStyles.bodySmall
                                          .copyWith(
                                            color: AdminAppColors.primaryColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8.h),
                                // Progress bar
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(4.r),
                                  child: LinearProgressIndicator(
                                    value: progress,
                                    minHeight: 8.h,
                                    backgroundColor: AdminAppColors.primaryLight
                                        .withOpacity(0.3),
                                    valueColor:
                                        const AlwaysStoppedAnimation<Color>(
                                          AdminAppColors.primaryColor,
                                        ),
                                  ),
                                ),
                                SizedBox(height: 32.h),
                                // Secure environment badge
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
                                      style: AdminAppTextStyles.caption
                                          .copyWith(
                                            color: AdminAppColors.primaryColor,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 1.0,
                                          ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            // Footer
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
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
