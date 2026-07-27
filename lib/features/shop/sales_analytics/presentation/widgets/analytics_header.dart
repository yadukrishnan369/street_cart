import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';
import 'package:street_cart/features/shop/sales_analytics/presentation/bloc/sales_analytics_bloc.dart';
import 'package:street_cart/features/shop/sales_analytics/presentation/bloc/sales_analytics_event.dart';
import 'package:street_cart/features/shop/sales_analytics/presentation/utils/sales_analytics_helper.dart';

// Analytics Header
class AnalyticsHeader extends StatelessWidget {
  final String selectedTimeframe;
  final String selectedCategory;
  final List<String> availableCategories;
  final DateTime? customStartDate;
  final DateTime? customEndDate;

  const AnalyticsHeader({
    super.key,
    required this.selectedTimeframe,
    required this.selectedCategory,
    required this.availableCategories,
    this.customStartDate,
    this.customEndDate,
  });
  // Time Frame Menu Bottomsheet
  void _showTimeframeMenu(BuildContext context) {
    final bloc = context.read<SalesAnalyticsBloc>();
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (sheetCtx) {
        return Container(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                'Select Timeframe',
                style: ShopAppTextStyles.bodyLargeBold.copyWith(
                  fontSize: 18.sp,
                ),
              ),
              // Time Frames
              SizedBox(height: 16.h),
              ...[
                'Today',
                'Last 7 Days',
                'Last Month',
                'Last 6 Month',
                'Last 1 Year',
              ].map((timeframe) {
                final isSelected = selectedTimeframe == timeframe;
                return ListTile(
                  title: Text(
                    timeframe,
                    style: ShopAppTextStyles.bodyMedium.copyWith(
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: isSelected
                          ? ShopAppColors.primary
                          : ShopAppColors.textPrimary,
                    ),
                  ),
                  trailing: isSelected
                      ? Icon(
                          Icons.check_circle,
                          color: ShopAppColors.primary,
                          size: 20.sp,
                        )
                      : null,
                  onTap: () {
                    Navigator.pop(sheetCtx);
                    bloc.add(ChangeTimeframeFilter(timeframe));
                  },
                );
              }),
              // Date Picker Section
              ListTile(
                title: Text(
                  'Select Custom Range...',
                  style: ShopAppTextStyles.bodyMedium.copyWith(
                    fontWeight: selectedTimeframe == 'Custom'
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: selectedTimeframe == 'Custom'
                        ? ShopAppColors.primary
                        : ShopAppColors.textPrimary,
                  ),
                ),
                trailing: const Icon(
                  Icons.date_range_outlined,
                  color: ShopAppColors.textSecondary,
                ),
                // Showing Date Range Picker
                onTap: () async {
                  Navigator.pop(sheetCtx);
                  final picked = await showDateRangePicker(
                    context: context,
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                    initialDateRange:
                        customStartDate != null && customEndDate != null
                        ? DateTimeRange(
                            start: customStartDate!,
                            end: customEndDate!,
                          )
                        : null,
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: const ColorScheme.light(
                            primary: ShopAppColors.primary,
                            onPrimary: Colors.white,
                            onSurface: ShopAppColors.textPrimary,
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (picked != null) {
                    bloc.add(
                      ChangeCustomDateRangeFilter(picked.start, picked.end),
                    );
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Product Category Menu Bottomsheet
  void _showCategoryMenu(BuildContext context) {
    final bloc = context.read<SalesAnalyticsBloc>();
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (sheetCtx) {
        return Container(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                'Select Product Category',
                style: ShopAppTextStyles.bodyLargeBold.copyWith(
                  fontSize: 18.sp,
                ),
              ),
              SizedBox(height: 16.h),
              // List of Available Categories
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: availableCategories.length,
                  itemBuilder: (context, idx) {
                    final category = availableCategories[idx];
                    final isSelected = selectedCategory == category;
                    return ListTile(
                      title: Text(
                        category,
                        style: ShopAppTextStyles.bodyMedium.copyWith(
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: isSelected
                              ? ShopAppColors.primary
                              : ShopAppColors.textPrimary,
                        ),
                      ),
                      trailing: isSelected
                          ? Icon(
                              Icons.check_circle,
                              color: ShopAppColors.primary,
                              size: 20.sp,
                            )
                          : null,
                      onTap: () {
                        Navigator.pop(sheetCtx);
                        bloc.add(ChangeCategoryFilter(category));
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Header
        Text(
          'PERFORMANCE',
          style: ShopAppTextStyles.bodySmallBold.copyWith(
            color: ShopAppColors.primary,
            letterSpacing: 0.5.sp,
          ),
        ),
        Row(
          children: [
            // Category Filter Button
            InkWell(
              onTap: () => _showCategoryMenu(context),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Text(
                      selectedCategory,
                      style: ShopAppTextStyles.bodySmallBold.copyWith(
                        color: ShopAppColors.primary,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 16.sp,
                      color: ShopAppColors.primary,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 8.w),

            // Timeframe Filter Button
            InkWell(
              onTap: () => _showTimeframeMenu(context),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Text(
                      SalesAnalyticsHelper.getDisplayTimeframe(
                        selectedTimeframe,
                        customStartDate,
                        customEndDate,
                      ),
                      style: ShopAppTextStyles.bodySmallBold.copyWith(
                        color: ShopAppColors.primary,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 16.sp,
                      color: ShopAppColors.primary,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
