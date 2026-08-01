import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/core/theme/customer/customer_text_styles.dart';
import 'package:street_cart/features/customer/profile/data/models/address_model.dart';

// Address Card
class AddressCard extends StatelessWidget {
  final AddressModel address;
  final bool isSelected;
  final VoidCallback onSelect;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const AddressCard({
    super.key,
    required this.address,
    required this.isSelected,
    required this.onSelect,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: isDark
            ? CustomerAppColors.darkSurface
            : CustomerAppColors.surface,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: isSelected
              ? CustomerAppColors.primary
              : (isDark ? CustomerAppColors.darkBorder : Colors.transparent),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: onSelect,
                  child: Container(
                    margin: EdgeInsets.only(top: 4.h),
                    width: 24.w,
                    height: 24.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected
                            ? CustomerAppColors.primary
                            : Colors.grey.shade300,
                        width: 2,
                      ),
                    ),
                    child: isSelected
                        ? Center(
                            child: Container(
                              width: 12.w,
                              height: 12.w,
                              decoration: const BoxDecoration(
                                color: CustomerAppColors.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                          )
                        : null,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Name
                          Text(
                            address.fullName,
                            style: CustomerAppTextStyles.body.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp,
                              color: isDark
                                  ? CustomerAppColors.darkTextPrimary
                                  : CustomerAppColors.textPrimary,
                            ),
                          ),
                          // Address Type
                          _buildTypeBadge(),
                        ],
                      ),
                      SizedBox(height: 4.h),
                      // Phone
                      Text(
                        address.phone,
                        style: CustomerAppTextStyles.body.copyWith(
                          color: isDark
                              ? CustomerAppColors.darkTextSecondary
                              : Colors.grey.shade600,
                          fontSize: 14.sp,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      // Delivery Address
                      Text(
                        '${address.addressLine1}, ${address.addressLine2.isNotEmpty ? "${address.addressLine2}, " : ""}'
                        '${address.district.isNotEmpty ? address.district : address.city}'
                        '${address.state.isNotEmpty ? ", ${address.state}" : ""}'
                        ' - ${address.pincode}',
                        style: CustomerAppTextStyles.body.copyWith(
                          color: isDark
                              ? CustomerAppColors.darkTextSecondary
                              : Colors.grey.shade700,
                          fontSize: 14.sp,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
            color: isDark ? CustomerAppColors.darkBorder : Colors.grey.shade100,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Row(
              // Action Buttons for Edit/Delete
              children: [
                _buildActionButton(
                  icon: Icons.edit_outlined,
                  label: 'Edit',
                  onTap: onEdit,
                  color: CustomerAppColors.primary,
                ),
                SizedBox(width: 16.w),
                _buildActionButton(
                  icon: Icons.delete_outline_rounded,
                  label: 'Delete',
                  onTap: onDelete,
                  color: isDark
                      ? CustomerAppColors.darkTextSecondary
                      : Colors.grey.shade500,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeBadge() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: CustomerAppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Text(
        address.type,
        style: CustomerAppTextStyles.body.copyWith(
          fontSize: 10.sp,
          fontWeight: FontWeight.bold,
          color: CustomerAppColors.primary,
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required Color color,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Row(
          children: [
            Icon(icon, size: 18.sp, color: color),
            SizedBox(width: 8.w),
            Text(
              label,
              style: CustomerAppTextStyles.body.copyWith(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
