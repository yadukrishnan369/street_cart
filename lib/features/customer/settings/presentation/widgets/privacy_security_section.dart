import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/core/theme/customer/customer_text_styles.dart';
import 'package:street_cart/di/dependency_injection.dart';
import 'package:street_cart/features/customer/settings/presentation/bloc/settings_bloc.dart';
import 'package:street_cart/features/customer/settings/presentation/widgets/settings_action_tile.dart';
import 'package:street_cart/features/customer/auth/domain/usecases/check_email_password_user.dart';
import 'package:street_cart/features/customer/settings/presentation/pages/change_password_page.dart';
import 'package:street_cart/features/customer/settings/presentation/pages/delete_account_page.dart';
import 'package:street_cart/features/customer/auth/presentation/bloc/auth_bloc.dart';
import 'package:street_cart/shared/widgets/custom_alert_dialog.dart';
import 'package:street_cart/core/navigation/page_transitions.dart';

Widget _buildSectionHeader(BuildContext context, String text) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  return Padding(
    padding: EdgeInsets.only(left: 16.w, top: 24.h, bottom: 8.h),
    child: Text(
      text,
      style: CustomerAppTextStyles.body.copyWith(
        color: isDark
            ? CustomerAppColors.darkTextSecondary
            : CustomerAppColors.textSecondary,
        fontSize: 12.sp,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
    ),
  );
}

// Privacy Security Section
class PrivacySecuritySection extends StatelessWidget {
  const PrivacySecuritySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(context, 'PRIVACY & SECURITY'),
        SettingsActionTile(
          icon: Icons.lock_outline,
          iconColor: CustomerAppColors.primary,
          backgroundColor: CustomerAppColors.primary.withValues(alpha: 0.1),
          title: 'Change Password',
          showArrow: true,
          onTap: () async {
            final checkUser = sl<CheckEmailPasswordUser>();
            final isEmailUser = await checkUser();

            if (context.mounted) {
              if (isEmailUser) {
                final settingsBloc = context.read<SettingsBloc>();
                // Navigate to Change Password Page
                Navigator.push(
                  context,
                  AppPageTransitions.slide(
                    BlocProvider.value(
                      value: settingsBloc,
                      child: const ChangePasswordPage(),
                    ),
                  ),
                );
              } else {
                // Show Alert, if Google Signup Account
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
          iconColor: CustomerAppColors.error,
          backgroundColor: CustomerAppColors.error.withValues(alpha: 0.1),
          title: 'Delete Account',
          titleColor: CustomerAppColors.error,
          showArrow: true,
          onTap: () async {
            final checkUser = sl<CheckEmailPasswordUser>();
            final isEmailUser = await checkUser();

            if (context.mounted) {
              final authBloc = context.read<AuthBloc>();
              final settingsBloc = context.read<SettingsBloc>();
              // Navigate to Delete Account Page
              Navigator.push(
                context,
                AppPageTransitions.slide(
                  MultiBlocProvider(
                    providers: [
                      BlocProvider.value(value: authBloc),
                      BlocProvider.value(value: settingsBloc),
                    ],
                    child: DeleteAccountPage(isEmailUser: isEmailUser),
                  ),
                ),
              );
            }
          },
        ),
      ],
    );
  }
}
