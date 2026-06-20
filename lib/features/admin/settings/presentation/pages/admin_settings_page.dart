import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';
import 'package:street_cart/di/dependency_injection.dart';
import 'package:street_cart/shared/widgets/custom_snackbar.dart';
import 'package:street_cart/features/admin/settings/presentation/bloc/admin_settings_bloc.dart';
import 'package:street_cart/features/admin/settings/presentation/bloc/admin_settings_event.dart';
import 'package:street_cart/features/admin/settings/presentation/bloc/admin_settings_state.dart';
import 'package:street_cart/features/admin/settings/presentation/widgets/platform_business_settings.dart';
import 'package:street_cart/features/admin/settings/presentation/widgets/categories_card.dart';
import 'package:street_cart/features/admin/settings/presentation/widgets/security_access_card.dart';
import 'package:street_cart/features/admin/settings/presentation/widgets/appearance_card.dart';
import 'package:street_cart/features/admin/settings/presentation/widgets/notification_preferences_card.dart';

class AdminSettingsPage extends StatelessWidget {
  const AdminSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AdminSettingsBloc>()..add(LoadAdminSettings()),
      child: Scaffold(
        backgroundColor: AdminAppColors.backgroundLight,
        body: BlocListener<AdminSettingsBloc, AdminSettingsState>(
          listener: (context, state) {
            if (state is AdminSettingsActionSuccess) {
              CustomSnackBar.show(context, message: state.message);
            } else if (state is AdminSettingsActionFailure) {
              if (!state.message.contains('Incorrect current password')) {
                CustomSnackBar.show(
                  context,
                  message: state.message,
                  isError: true,
                );
              }
            }
          },
          child: BlocBuilder<AdminSettingsBloc, AdminSettingsState>(
            builder: (context, state) {
              if (state is AdminSettingsLoading) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AdminAppColors.primaryColor,
                  ),
                );
              }

              if (state is AdminSettingsLoadFailure) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Failed to load settings: ${state.message}',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AdminAppColors.errorColor,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      ElevatedButton(
                        onPressed: () {
                          context.read<AdminSettingsBloc>().add(
                            LoadAdminSettings(),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AdminAppColors.primaryColor,
                        ),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              // Extract settings if available
              final currentSettings = (state is AdminSettingsLoadSuccess)
                  ? state.settings
                  : (state is AdminSettingsActionSuccess)
                  ? state.settings
                  : (state is AdminSettingsActionFailure)
                  ? state.settings
                  : null;

              final isInProgress = state is AdminSettingsActionInProgress;

              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 40.w,
                    vertical: 32.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Platform Business Settings
                      PlatformBusinessSettings(
                        settings: currentSettings,
                        isInProgress: isInProgress,
                      ),
                      SizedBox(height: 24.h),

                      // Categories Card
                      const CategoriesCard(),
                      SizedBox(height: 24.h),

                      // Security & Access Settings
                      SecurityAccessCard(
                        isInProgress: isInProgress,
                      ),
                      SizedBox(height: 24.h),

                      // Appearance Settings
                      const AppearanceCard(),
                      SizedBox(height: 24.h),

                      // Notification Preferences Card
                      const NotificationPreferencesCard(),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

