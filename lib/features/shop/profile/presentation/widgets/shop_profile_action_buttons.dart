import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';
import 'package:street_cart/features/shop/profile/presentation/bloc/shop_profile_bloc.dart';
import 'package:street_cart/features/shop/profile/presentation/bloc/shop_profile_event.dart';
import 'package:street_cart/features/shop/profile/presentation/pages/edit_shop_profile_page.dart';

// Shop Profile Action Buttons
class ShopProfileActionButtons extends StatelessWidget {
  final ShopProfileModel profile;
  final VoidCallback onLogout;

  const ShopProfileActionButtons({
    super.key,
    required this.profile,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 48.h,
            child: ElevatedButton.icon(
              onPressed: () {
                final profileBloc = context.read<ShopProfileBloc>();
                // Navigate to Edit Shop Profile Page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BlocProvider.value(
                      value: profileBloc,
                      child: EditShopProfilePage(profile: profile),
                    ),
                  ),
                ).then((_) {
                  if (context.mounted) {
                    context.read<ShopProfileBloc>().add(FetchShopProfileData());
                  }
                });
              },
              icon: Icon(
                Icons.edit_note_outlined,
                size: 20.sp,
                color: Colors.white,
              ),
              label: Text(
                'Edit Profile Details',
                style: ShopAppTextStyles.buttonText.copyWith(fontSize: 15.sp),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: ShopAppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.r),
                ),
                elevation: 0,
              ),
            ),
          ),
          SizedBox(height: 12.h),
          // Shop Logout Button
          SizedBox(
            width: double.infinity,
            height: 48.h,
            child: OutlinedButton.icon(
              onPressed: onLogout,
              icon: Icon(
                Icons.logout,
                size: 18.sp,
                color: ShopAppColors.primary,
              ),
              label: Text(
                'Logout',
                style: ShopAppTextStyles.bodyMediumBold.copyWith(
                  color: ShopAppColors.primary,
                  fontSize: 15.sp,
                ),
              ),
              style: OutlinedButton.styleFrom(
                backgroundColor: const Color(0xFFF4F7F6),
                side: const BorderSide(color: Color(0xFFE2EBE9), width: 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.r),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
