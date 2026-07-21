import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';
import 'package:street_cart/core/theme/admin/admin_text_styles.dart';
import 'package:street_cart/features/admin/auth/presentation/bloc/admin_auth_bloc.dart';
import 'package:street_cart/features/admin/auth/presentation/bloc/admin_auth_event.dart';
import 'package:street_cart/shared/widgets/custom_confirmation_modal.dart';

// Admin Profile Logout
class AdminProfileLogout extends StatelessWidget {
  const AdminProfileLogout({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFECEFF1), width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.logout_outlined,
                size: 20.sp,
                color: AdminAppColors.errorColor,
              ),
              SizedBox(width: 10.w),
              // Title
              Text(
                'Account Actions',
                style: AdminAppTextStyles.heading3.copyWith(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1E1E2F),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          // Subtitle
          Text(
            'Securely sign out of your administration portal session.',
            style: AdminAppTextStyles.bodySmall.copyWith(
              color: const Color(0xFF8A8A9E),
            ),
          ),
          SizedBox(height: 24.h),
          SizedBox(
            width: double.infinity,
            // Logout Confimation Dialog
            child: ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (dialogContext) => ConfirmationModal(
                    title: 'Logout',
                    content: 'Are you sure you want to logout?',
                    confirmText: 'Logout',
                    confirmColor: AdminAppColors.primaryColor,
                    surfaceColor: Colors.white,
                    onConfirm: () {
                      Navigator.pop(dialogContext);
                      context.read<AdminAuthBloc>().add(AdminLogoutRequested());
                    },
                    onCancel: () => Navigator.pop(dialogContext),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFEBEE),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                padding: EdgeInsets.symmetric(vertical: 14.h),
              ),
              child: Text(
                'Logout',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: AdminAppColors.errorColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
