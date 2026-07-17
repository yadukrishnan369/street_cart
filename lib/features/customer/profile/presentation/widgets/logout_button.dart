import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_cart/shared/widgets/custom_confirmation_modal.dart';
import 'package:street_cart/features/customer/auth/presentation/bloc/auth_bloc.dart';
import 'package:street_cart/features/customer/auth/presentation/bloc/auth_event.dart';

// Logout Button
class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  // Confirmation For Logout
  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => ConfirmationModal(
        title: 'Logout',
        content: 'Are you sure you want to log out?',
        confirmText: 'Logout',
        onConfirm: () {
          Navigator.pop(ctx);
          context.read<AuthBloc>().add(LogoutRequested());
        },
        onCancel: () {
          Navigator.pop(ctx);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showLogoutConfirmation(context),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w),
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.05),
          borderRadius: BorderRadius.circular(30.r),
          border: Border.all(color: Colors.red.shade100),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.exit_to_app, color: Colors.red.shade400, size: 20.sp),
            SizedBox(width: 8.w),
            Text(
              'Logout',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: Colors.red.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
