import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';
import 'package:street_cart/core/services/communication_service.dart';
import 'package:street_cart/di/dependency_injection.dart';
import 'package:street_cart/features/customer/profile/data/models/address_model.dart';
import 'package:street_cart/features/admin/customers/data/models/customer_model.dart';
import 'package:street_cart/features/admin/customers/presentation/utils/admin_customers_helper.dart';

// Admin Customer Contact Info Card
class AdminCustomerContactInfoCard extends StatelessWidget {
  final CustomerModel customer;
  final List<AddressModel> addresses;

  const AdminCustomerContactInfoCard({
    super.key,
    required this.customer,
    required this.addresses,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // Primary address
    final primaryAddressText = AdminCustomersHelper.getPrimaryAddressText(
      addresses,
    );

    return Container(
      padding: EdgeInsets.all(20.w),
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
                Icons.info_outline,
                color: AdminAppColors.primaryColor,
                size: 18.sp,
              ),
              SizedBox(width: 8.w),
              // Title
              Text(
                'CONTACT INFORMATION',
                style: TextStyle(
                  fontSize: 14.sp,
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
            thickness: 1.2,
          ),

          // Email Address
          Text(
            'Email Address',
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w800,
              color: isDark
                  ? AdminAppColors.darkTextSecondary
                  : const Color(0xFF8A8A9E),
            ),
          ),
          SizedBox(height: 6.h),
          Tooltip(
            message: "Send a mail",
            child: InkWell(
              onTap: () => sl<CommunicationService>().sendEmail(customer.email),
              child: Text(
                customer.email.isNotEmpty ? customer.email : 'Unknown',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: AdminAppColors.primaryColor,
                ),
              ),
            ),
          ),
          SizedBox(height: 20.h),

          // Phone Number
          Text(
            'Phone Number',
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w800,
              color: isDark
                  ? AdminAppColors.darkTextSecondary
                  : const Color(0xFF8A8A9E),
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            customer.phone.isNotEmpty ? customer.phone : 'Not Provided',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: isDark
                  ? AdminAppColors.darkTextPrimary
                  : AdminAppColors.textPrimary,
            ),
          ),
          SizedBox(height: 20.h),

          // Primary Address
          Text(
            'Primary Address',
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w800,
              color: isDark
                  ? AdminAppColors.darkTextSecondary
                  : const Color(0xFF8A8A9E),
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            primaryAddressText,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: isDark
                  ? AdminAppColors.darkTextPrimary
                  : AdminAppColors.textPrimary,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
