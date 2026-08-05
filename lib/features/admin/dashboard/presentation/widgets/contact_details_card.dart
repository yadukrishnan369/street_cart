import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';
import 'package:street_cart/core/services/communication_service.dart';
import 'package:street_cart/di/dependency_injection.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';
import 'package:street_cart/shared/widgets/custom_snackbar.dart';

// Contact Details Card
class ContactDetailsCard extends StatelessWidget {
  final ShopProfileModel shop;

  const ContactDetailsCard({super.key, required this.shop});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: isDark ? AdminAppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isDark ? AdminAppColors.darkBorder : const Color(0xFFE8E7ED),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.contacts_outlined,
                color: AdminAppColors.primaryColor,
                size: 20.sp,
              ),
              SizedBox(width: 8.w),
              // Title
              Text(
                'Contact Details',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w800,
                  color: isDark
                      ? AdminAppColors.darkTextPrimary
                      : AdminAppColors.textPrimary,
                ),
              ),
            ],
          ),
          Divider(
            height: 32.h,
            color: isDark ? AdminAppColors.darkBorder : const Color(0xFFF0EFF5),
          ),
          // Owner Name
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: isDark
                      ? AdminAppColors.darkInputBackground
                      : const Color(0xFFF4F5F7),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.person_outline,
                  color: isDark
                      ? AdminAppColors.darkTextSecondary
                      : const Color(0xFF6C6C80),
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'OWNER NAME',
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w800,
                        color: isDark
                            ? AdminAppColors.darkTextSecondary
                            : const Color(0xFF8A8A9E),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      shop.ownerName,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: isDark
                            ? AdminAppColors.darkTextPrimary
                            : AdminAppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          // Email Address
          InkWell(
            onTap: () async {
              try {
                await sl<CommunicationService>().sendEmail(shop.email);
              } catch (e) {
                if (context.mounted) {
                  CustomSnackBar.show(context, message: e.toString());
                }
              }
            },
            borderRadius: BorderRadius.circular(8.r),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AdminAppColors.darkInputBackground
                        : const Color(0xFFF4F5F7),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.mail_outline,
                    color: isDark
                        ? AdminAppColors.darkTextSecondary
                        : const Color(0xFF6C6C80),
                    size: 20.sp,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'EMAIL ADDRESS',
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w800,
                          color: isDark
                              ? AdminAppColors.darkTextSecondary
                              : const Color(0xFF8A8A9E),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        shop.email,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: AdminAppColors.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
