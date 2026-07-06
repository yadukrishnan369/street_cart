import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/core/theme/customer/customer_text_styles.dart';
import 'package:street_cart/di/dependency_injection.dart';
import 'package:street_cart/features/customer/settings/presentation/bloc/settings_bloc.dart';
import 'package:street_cart/features/customer/settings/presentation/bloc/settings_event.dart';
import 'package:street_cart/features/customer/settings/presentation/bloc/settings_state.dart';
import 'package:street_cart/features/customer/settings/presentation/widgets/settings_switch_tile.dart';
import 'package:street_cart/features/customer/settings/presentation/widgets/settings_action_tile.dart';
import 'package:street_cart/features/customer/auth/domain/usecases/check_email_password_user.dart';
import 'package:street_cart/features/customer/settings/presentation/pages/change_password_page.dart';
import 'package:street_cart/shared/widgets/custom_alert_dialog.dart';
import 'package:street_cart/shared/widgets/custom_confirmation_modal.dart';
import 'package:street_cart/features/customer/auth/presentation/bloc/auth_bloc.dart';
import 'package:street_cart/features/customer/auth/presentation/bloc/auth_state.dart';
import 'package:street_cart/features/customer/auth/presentation/pages/login_page.dart';
import 'package:street_cart/features/customer/settings/presentation/pages/delete_account_page.dart';
import 'package:street_cart/features/customer/settings/presentation/widgets/shimmer/settings_shimmer.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  Widget _buildSectionHeader(String text) {
    return Padding(
      padding: EdgeInsets.only(left: 16.w, top: 24.h, bottom: 8.h),
      child: Text(
        text,
        style: CustomerAppTextStyles.body.copyWith(
          color: CustomerAppColors.textSecondary,
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<SettingsBloc>()..add(FetchSettingsData()),
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAccountDeleted || state is AuthInitial) {
            // when account is deleted or auth resets, go to login
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
            title: Text(
              'Settings',
              style: CustomerAppTextStyles.heading2.copyWith(fontSize: 20.sp),
            ),
          ),
          body: BlocBuilder<SettingsBloc, SettingsState>(
            builder: (context, state) {
              if (state is SettingsLoading || state is SettingsInitial) {
                return const SettingsShimmer();
              } else if (state is SettingsError) {
                return Center(child: Text(state.message));
              } else if (state is SettingsLoaded) {
                final s = state.settings;

                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionHeader('APP PREFERENCES'),
                      SettingsSwitchTile(
                        icon: Icons.nightlight_round,
                        iconColor: CustomerAppColors.primary,
                        backgroundColor: CustomerAppColors.primary.withOpacity(
                          0.1,
                        ),
                        title: 'Dark Mode',
                        value: s['darkMode'] ?? false,
                        onChanged: (val) {
                          context.read<SettingsBloc>().add(
                            ToggleSetting(key: 'darkMode', value: val),
                          );
                        },
                      ),
                      if (state.hasLocationData)
                        SettingsSwitchTile(
                          icon: Icons.location_on_outlined,
                          iconColor: CustomerAppColors.primary,
                          backgroundColor: CustomerAppColors.primary.withOpacity(
                            0.1,
                          ),
                          title: 'Location Services',
                          value: s['locationServices'] ?? true,
                          onChanged: (val) {
                            if (val == false) {
                              showDialog(
                                context: context,
                                builder: (dialogContext) => ConfirmationModal(
                                  title: 'Disable Location?',
                                  content:
                                      'Are you sure you want to disable location services? You might miss out on nearby shop updates.',
                                  onConfirm: () {
                                    context.read<SettingsBloc>().add(
                                      ToggleSetting(
                                        key: 'locationServices',
                                        value: false,
                                      ),
                                    );
                                    Navigator.pop(dialogContext);
                                  },
                                  onCancel: () => Navigator.pop(dialogContext),
                                ),
                              );
                            } else {
                              context.read<SettingsBloc>().add(
                                ToggleSetting(
                                  key: 'locationServices',
                                  value: true,
                                ),
                              );
                            }
                          },
                        ),

                      _buildSectionHeader('NOTIFICATION SETTINGS'),
                      SettingsSwitchTile(
                        icon: Icons.notifications_none_outlined,
                        iconColor: CustomerAppColors.primary,
                        backgroundColor: CustomerAppColors.primary.withOpacity(
                          0.1,
                        ),
                        title: 'Push Notifications',
                        value: s['pushNotifications'] ?? true,
                        onChanged: (val) {
                          context.read<SettingsBloc>().add(
                            ToggleSetting(key: 'pushNotifications', value: val),
                          );
                        },
                      ),
                      SettingsSwitchTile(
                        icon: Icons.shopping_bag_outlined,
                        iconColor: CustomerAppColors.primary,
                        backgroundColor: CustomerAppColors.primary.withOpacity(
                          0.1,
                        ),
                        title: 'Order Alerts',
                        value: s['orderAlerts'] ?? true,
                        onChanged: (val) {
                          context.read<SettingsBloc>().add(
                            ToggleSetting(key: 'orderAlerts', value: val),
                          );
                        },
                      ),

                      _buildSectionHeader('PRIVACY & SECURITY'),
                      SettingsActionTile(
                        icon: Icons.lock_outline,
                        iconColor: CustomerAppColors.primary,
                        backgroundColor: CustomerAppColors.primary.withOpacity(
                          0.1,
                        ),
                        title: 'Change Password',
                        showArrow: true,
                        onTap: () async {
                          final checkUser = sl<CheckEmailPasswordUser>();
                          final isEmailUser = await checkUser();

                          if (context.mounted) {
                            if (isEmailUser) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const ChangePasswordPage(),
                                ),
                              );
                            } else {
                              showDialog(
                                context: context,
                                builder: (context) => CustomAlertDialog(
                                  title: 'Linked Account',
                                  content:
                                      'Your account is linked to Google. Password changes are managed by Google.',
                                  icon: Icons.info_outline,
                                  primaryActionLabel: 'Got it',
                                  onPrimaryAction: () => Navigator.pop(context),
                                ),
                              );
                            }
                          }
                        },
                      ),
                       SettingsActionTile(
                        icon: Icons.delete_outline,
                        iconColor: Colors.red,
                        backgroundColor: Colors.red.withOpacity(0.1),
                        title: 'Delete Account',
                        titleColor: Colors.red,
                        showArrow: true,
                        onTap: () async {
                          final checkUser = sl<CheckEmailPasswordUser>();
                          final isEmailUser = await checkUser();

                          if (context.mounted) {
                            final authBloc = context.read<AuthBloc>();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BlocProvider.value(
                                  value: authBloc,
                                  child: DeleteAccountPage(isEmailUser: isEmailUser),
                                ),
                              ),
                            );
                          }
                        },
                      ),

                      _buildSectionHeader('APP SETTINGS'),
                      SettingsActionTile(
                        icon: Icons.cleaning_services_outlined,
                        iconColor: CustomerAppColors.primary,
                        backgroundColor: CustomerAppColors.primary.withOpacity(
                          0.1,
                        ),
                        title: 'Clear Data',
                        showArrow: true,
                        onTap: () {
                          // Implement clear data logic
                        },
                      ),

                      40.verticalSpace,
                      Center(
                        child: Text(
                          'STREET CART APP\nVersion 2.4.0',
                          textAlign: TextAlign.center,
                          style: CustomerAppTextStyles.body.copyWith(
                            color: CustomerAppColors.textSecondary.withOpacity(
                              0.5,
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
