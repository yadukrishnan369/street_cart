import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';
import 'package:street_cart/features/admin/revenue/presentation/bloc/admin_revenue_bloc.dart';
import 'package:street_cart/features/admin/revenue/presentation/bloc/admin_revenue_event.dart';
import 'package:street_cart/features/admin/revenue/presentation/bloc/admin_revenue_state.dart';
import 'package:street_cart/features/admin/revenue/presentation/utils/admin_revenue_helper.dart';

// Revenue Filter Bar
class RevenueFilterBar extends StatelessWidget {
  const RevenueFilterBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminRevenueBloc, AdminRevenueState>(
      builder: (context, state) {
        if (state is! AdminRevenueLoaded) return const SizedBox.shrink();
        return Wrap(
          spacing: 16.w,
          runSpacing: 12.h,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            // Business Category Dropdown
            _buildDropdown(
              context: context,
              label: 'Business Category',
              value: state.selectedBusinessCategory,
              items: state.businessCategories,
              onChanged: (v) => context.read<AdminRevenueBloc>().add(
                RevenueFilterChanged(businessCategory: v),
              ),
            ),
            // Product Category Dropdown
            _buildDropdown(
              context: context,
              label: 'Product Category',
              value: state.selectedProductCategory,
              items: state.productCategories,
              onChanged: (v) => context.read<AdminRevenueBloc>().add(
                RevenueFilterChanged(productCategory: v),
              ),
            ),
            // Time Frame Dropdown
            _buildDropdown(
              context: context,
              label: 'Timeframe',
              value: state.selectedTimeframe,
              items: AdminRevenueHelper.timeframes,
              onChanged: (v) {
                if (v == 'Custom') {
                  _pickDateRange(context, state);
                } else {
                  context.read<AdminRevenueBloc>().add(
                    RevenueFilterChanged(
                      timeframe: v,
                      customStart: null,
                      customEnd: null,
                    ),
                  );
                }
              },
            ),
            if (state.selectedTimeframe == 'Custom' &&
                state.customStart != null &&
                state.customEnd != null)
              _buildDateRangeChip(context, state),
          ],
        );
      },
    );
  }

  // Dropdown Button
  Widget _buildDropdown({
    required BuildContext context,
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: 44.h,
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      decoration: BoxDecoration(
        color: isDark ? AdminAppColors.darkInputBackground : Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: isDark ? AdminAppColors.darkBorder : const Color(0xFFE0E0E0),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          dropdownColor: isDark ? AdminAppColors.darkSurface : Colors.white,
          value: items.contains(value) ? value : items.first,
          items: items
              .map(
                (e) => DropdownMenuItem(
                  value: e,
                  child: Text(
                    e,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: isDark
                          ? AdminAppColors.darkTextPrimary
                          : AdminAppColors.textPrimary,
                    ),
                  ),
                ),
              )
              .toList(),
          onChanged: onChanged,
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 18.sp,
            color: isDark
                ? AdminAppColors.darkTextSecondary
                : AdminAppColors.textSecondary,
          ),
          hint: Text(
            label,
            style: TextStyle(
              fontSize: 13.sp,
              color: isDark
                  ? AdminAppColors.darkTextSecondary
                  : AdminAppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }

  // Selected Date Range Chip
  Widget _buildDateRangeChip(BuildContext context, AdminRevenueLoaded state) {
    final helper = AdminRevenueHelper.formatDate;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AdminAppColors.primaryColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: AdminAppColors.primaryColor.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.calendar_today_outlined,
            size: 14.sp,
            color: AdminAppColors.primaryColor,
          ),
          SizedBox(width: 6.w),
          Text(
            '${helper(state.customStart!)} — ${helper(state.customEnd!)}',
            style: TextStyle(
              fontSize: 12.sp,
              color: AdminAppColors.primaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(width: 8.w),
          GestureDetector(
            onTap: () => context.read<AdminRevenueBloc>().add(
              const RevenueFilterChanged(timeframe: 'All Time'),
            ),
            child: Icon(
              Icons.close,
              size: 14.sp,
              color: AdminAppColors.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  // Date Picker Modal
  void _pickDateRange(BuildContext context, AdminRevenueLoaded state) async {
    final bloc = context.read<AdminRevenueBloc>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: state.customStart != null && state.customEnd != null
          ? DateTimeRange(start: state.customStart!, end: state.customEnd!)
          : null,
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: isDark
              ? const ColorScheme.dark(
                  primary: AdminAppColors.primaryColor,
                  onPrimary: Colors.white,
                  surface: AdminAppColors.darkSurface,
                  onSurface: AdminAppColors.darkTextPrimary,
                )
              : const ColorScheme.light(
                  primary: AdminAppColors.primaryColor,
                  onPrimary: Colors.white,
                  surface: Colors.white,
                  onSurface: AdminAppColors.textPrimary,
                ),
          dialogTheme: DialogThemeData(
            backgroundColor: isDark
                ? AdminAppColors.darkInputBackground
                : Colors.white,
          ),
        ),
        child: Dialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 40.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Container(
            width: 540.w,
            height: 520.h,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: child,
          ),
        ),
      ),
    );
    if (picked != null) {
      bloc.add(
        RevenueFilterChanged(
          timeframe: 'Custom',
          customStart: picked.start,
          customEnd: picked.end,
        ),
      );
    }
  }
}
