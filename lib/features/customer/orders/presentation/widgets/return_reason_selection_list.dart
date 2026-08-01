import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';

// Return Reason Selection List
class ReturnReasonSelectionList extends StatelessWidget {
  final List<String> reasons;
  final String selectedReason;
  final ValueChanged<String> onSelect;

  const ReturnReasonSelectionList({
    super.key,
    required this.reasons,
    required this.selectedReason,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      children: reasons
          .map(
            (reason) => GestureDetector(
              onTap: () => onSelect(reason),
              child: Container(
                margin: EdgeInsets.only(bottom: 10.h),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(20.r),
                  border: isDark
                      ? Border.all(color: CustomerAppColors.darkBorder)
                      : null,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(
                        alpha: isDark ? 0.2 : 0.02,
                      ),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 22.w,
                      height: 22.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: selectedReason == reason
                              ? CustomerAppColors.primary
                              : isDark
                              ? CustomerAppColors.darkBorder
                              : Colors.grey[300]!,
                          width: 2,
                        ),
                      ),
                      child: selectedReason == reason
                          ? Center(
                              child: Container(
                                width: 12.w,
                                height: 12.w,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: CustomerAppColors.primary,
                                ),
                              ),
                            )
                          : null,
                    ),
                    SizedBox(width: 14.w),
                    // Reason
                    Text(
                      reason,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? CustomerAppColors.darkTextPrimary
                            : CustomerAppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
