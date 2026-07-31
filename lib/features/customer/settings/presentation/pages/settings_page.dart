import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/core/theme/customer/customer_text_styles.dart';
import 'package:street_cart/core/services/app_info_service.dart';
import 'package:street_cart/di/dependency_injection.dart';
import 'package:street_cart/features/customer/settings/presentation/bloc/settings_bloc.dart';
import 'package:street_cart/features/customer/settings/presentation/bloc/settings_event.dart';
import 'package:street_cart/features/customer/settings/presentation/bloc/settings_state.dart';
import 'package:street_cart/features/customer/auth/presentation/bloc/auth_bloc.dart';
import 'package:street_cart/features/customer/auth/presentation/bloc/auth_state.dart';
import 'package:street_cart/features/customer/auth/presentation/pages/login_page.dart';
import 'package:street_cart/features/customer/settings/presentation/widgets/shimmer/settings_shimmer.dart';
import 'package:street_cart/features/customer/settings/presentation/widgets/app_preferences_section.dart';
import 'package:street_cart/features/customer/settings/presentation/widgets/notification_settings_section.dart';
import 'package:street_cart/features/customer/settings/presentation/widgets/privacy_security_section.dart';
import 'package:street_cart/features/customer/settings/presentation/widgets/app_settings_section.dart';
import 'package:street_cart/shared/widgets/app_error_view.dart';

// Settings Page
class SettingsPage extends StatelessWidget {
  final IAppInfoService _appInfoService = sl<IAppInfoService>();

  SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<SettingsBloc>()..add(FetchSettingsData()),
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAccountDeleted || state is AuthInitial) {
            // Navigate to login page By deletion or reset
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const LoginPage()),
              (route) => false,
            );
          }
        },
        child: Scaffold(
          backgroundColor: CustomerAppColors.background,
          appBar: AppBar(
            backgroundColor: CustomerAppColors.background,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black87),
              onPressed: () => Navigator.pop(context),
            ),
            // Page Header
            title: Text(
              'Settings',
              style: CustomerAppTextStyles.heading2.copyWith(fontSize: 20.sp),
            ),
          ),
          body: BlocBuilder<SettingsBloc, SettingsState>(
            builder: (context, state) {
              if (state is SettingsLoading || state is SettingsInitial) {
                // Settings Shimmer
                return const SettingsShimmer();
              } else if (state is SettingsError) {
                // Error Text
                return AppErrorView(
                  message: state.message,
                  onRetry: () =>
                      context.read<SettingsBloc>().add(FetchSettingsData()),
                );
              } else if (state is SettingsLoaded) {
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // App preference sections
                      AppPreferencesSection(
                        settings: state.settings,
                        hasLocationData: state.hasLocationData,
                      ),
                      // Notification Section
                      NotificationSettingsSection(settings: state.settings),
                      // Privacy and Security Section
                      const PrivacySecuritySection(),
                      // App Settings Section
                      const AppSettingsSection(),
                      40.verticalSpace,
                      Center(
                        // Bottom App name and Version
                        child: Text(
                          '${_appInfoService.appName.toUpperCase()} APP\n${_appInfoService.fullVersionString}',
                          textAlign: TextAlign.center,
                          style: CustomerAppTextStyles.body.copyWith(
                            color: CustomerAppColors.textSecondary.withValues(
                              alpha: 0.5,
                            ),
                            fontSize: 12.sp,
                            height: 1.5,
                          ),
                        ),
                      ),
                      40.verticalSpace,
                    ],
                  ),
                );
              }
              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }
}
