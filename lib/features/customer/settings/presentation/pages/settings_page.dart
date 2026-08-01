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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BlocListener<AuthBloc, AuthState>(
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
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Theme.of(context).appBarTheme.foregroundColor,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          // Page Header
          title: Text(
            'Settings',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: isDark
                  ? CustomerAppColors.darkTextPrimary
                  : CustomerAppColors.textPrimary,
            ),
          ),
          centerTitle: true,
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
                      child: Builder(
                        builder: (context) {
                          final isDark =
                              Theme.of(context).brightness == Brightness.dark;
                          return Text(
                            '${_appInfoService.appName.toUpperCase()} APP\n${_appInfoService.fullVersionString}',
                            textAlign: TextAlign.center,
                            style: CustomerAppTextStyles.body.copyWith(
                              color: isDark
                                  ? CustomerAppColors.darkTextSecondary
                                        .withValues(alpha: 0.5)
                                  : CustomerAppColors.textSecondary.withValues(
                                      alpha: 0.5,
                                    ),
                              fontSize: 12.sp,
                              height: 1.5,
                            ),
                          );
                        },
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
    );
  }
}
