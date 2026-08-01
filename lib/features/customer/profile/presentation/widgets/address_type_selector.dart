import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/core/theme/customer/customer_text_styles.dart';

// Address Type Selector - Home, Office, Other
class AddressTypeSelector extends StatelessWidget {
  final String selectedType;
  final Function(String) onTypeChanged;

  const AddressTypeSelector({
    super.key,
    required this.selectedType,
    required this.onTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Save As',
          style: CustomerAppTextStyles.body.copyWith(
            fontWeight: FontWeight.w600,
            color: isDark
                ? CustomerAppColors.darkTextPrimary
                : CustomerAppColors.textPrimary,
          ),
        ),
        SizedBox(height: 12.h),
        // Types Of Address
        Row(
          children: [
            _buildTypeButton(
              context,
              'HOME',
              Icons.home_outlined,
              Icons.home_rounded,
            ),
            SizedBox(width: 12.w),
            _buildTypeButton(
              context,
              'OFFICE',
              Icons.work_outline_rounded,
              Icons.work_rounded,
            ),
            SizedBox(width: 12.w),
            _buildTypeButton(
              context,
              'OTHER',
              Icons.location_on_outlined,
              Icons.location_on_rounded,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTypeButton(
    BuildContext context,
    String type,
    IconData outlineIcon,
    IconData filledIcon,
  ) {
    final bool isSelected = selectedType == type;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Expanded(
      child: InkWell(
        onTap: () => onTypeChanged(type),
        borderRadius: BorderRadius.circular(16.r),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(vertical: 12.h),
          decoration: BoxDecoration(
            color: isSelected ? CustomerAppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: isSelected
                  ? CustomerAppColors.primary
                  : (isDark
                        ? CustomerAppColors.darkBorder
                        : Colors.grey.shade200),
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isSelected ? filledIcon : outlineIcon,
                size: 18.sp,
                color: isSelected
                    ? Colors.white
                    : (isDark
                          ? CustomerAppColors.darkTextSecondary
                          : Colors.grey.shade600),
              ),
              SizedBox(width: 8.w),
              Text(
                type[0] + type.substring(1).toLowerCase(),
                style: CustomerAppTextStyles.body.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 14.sp,
                  color: isSelected
                      ? Colors.white
                      : (isDark
                            ? CustomerAppColors.darkTextSecondary
                            : Colors.grey.shade600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
