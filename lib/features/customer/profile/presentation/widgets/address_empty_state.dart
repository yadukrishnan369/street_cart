import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/core/theme/customer/customer_text_styles.dart';
import 'package:street_cart/shared/widgets/primary_button.dart';

// Address Empty State
class AddressEmptyState extends StatelessWidget {
  final VoidCallback onAddAddress;

  const AddressEmptyState({super.key, required this.onAddAddress});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.location_off_outlined,
            size: 80.sp,
            color: CustomerAppColors.primary,
          ),
          SizedBox(height: 16.h),
          // Title
          Text(
            'No saved addresses yet',
            style: CustomerAppTextStyles.heading2.copyWith(
              fontSize: 18.sp,
              color: isDark
                  ? CustomerAppColors.darkTextSecondary
                  : Colors.grey.shade400,
            ),
          ),
          SizedBox(height: 8.h),
          // Subtitle
          Text(
            'Add an address to make delivery faster',
            style: CustomerAppTextStyles.body.copyWith(
              color: isDark
                  ? CustomerAppColors.darkTextSecondary
                  : Colors.grey.shade500,
            ),
          ),
          SizedBox(height: 24.h),
          // Button For Adding New Address
          SizedBox(
            width: 200.w,
            child: PrimaryButton(
              text: 'Add New Address',
              onPressed: onAddAddress,
            ),
          ),
        ],
      ),
    );
  }
}
