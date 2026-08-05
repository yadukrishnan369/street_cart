import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';
import 'package:go_router/go_router.dart';
import 'package:street_cart/core/router/admin/route_paths.dart';
import 'package:street_cart/features/admin/reviews/presentation/utils/review_helper.dart';
import 'package:street_cart/features/customer/review/data/models/review_model.dart';

// Reviews Table
class ReviewsTable extends StatelessWidget {
  final List<ReviewModel> reviews;
  final Map<String, String> productNames;
  final Function(ReviewModel) onViewDetail;

  const ReviewsTable({
    super.key,
    required this.reviews,
    required this.productNames,
    required this.onViewDetail,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Empty State
    if (reviews.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 80.h),
        child: Center(
          child: Column(
            children: [
              Icon(
                Icons.rate_review_outlined,
                color: AdminAppColors.primaryColor,
                size: 64.sp,
              ),
              SizedBox(height: 16.h),
              Text(
                'No matching Reviews found',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: AdminAppColors.primaryColor,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Table(
      columnWidths: const {
        0: FlexColumnWidth(2.0), // Customer
        1: FlexColumnWidth(1.8), // To Reviewed
        2: FlexColumnWidth(1.5), // Rating
        3: FlexColumnWidth(3.0), // Comment
        4: FlexColumnWidth(1.2), // Date
        5: FlexColumnWidth(1.0), // Action
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        TableRow(
          decoration: BoxDecoration(
            color: isDark
                ? AdminAppColors.darkInputBackground
                : const Color(0xFFF4F5F7),
            border: Border(
              bottom: BorderSide(
                color: isDark
                    ? AdminAppColors.darkBorder
                    : const Color(0xFFE8E7ED),
                width: 1.5,
              ),
            ),
          ),
          // Table Titles
          children: [
            _buildTableHeaderCell('CUSTOMER', isDark),
            _buildTableHeaderCell('TO REVIEWED', isDark),
            _buildTableHeaderCell('RATING', isDark),
            _buildTableHeaderCell('COMMENT', isDark),
            _buildTableHeaderCell('DATE', isDark),
            _buildTableHeaderCell('ACTION', isDark),
          ],
        ),
        ...reviews.map((r) => _buildTableRow(context, r, isDark)),
      ],
    );
  }

  Widget _buildTableHeaderCell(String text, bool isDark) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11.sp,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.8,
          color: isDark
              ? AdminAppColors.darkTextSecondary
              : const Color(0xFF8A8A9E),
        ),
      ),
    );
  }

  TableRow _buildTableRow(BuildContext context, ReviewModel r, bool isDark) {
    final formattedDate = AdminReviewHelper.getFormattedTimeAgo(r.createdAt);
    final productName = productNames[r.productId] ?? 'Unknown Product';

    return TableRow(
      decoration: BoxDecoration(
        color: isDark ? AdminAppColors.darkSurface : Colors.white,
        border: Border(
          bottom: BorderSide(
            color: isDark ? AdminAppColors.darkBorder : const Color(0xFFF0EFF5),
            width: 1.0,
          ),
        ),
      ),
      children: [
        // Customer Profile Badge
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: InkWell(
            onTap: () {
              context.push(
                RoutePaths.customerDetails.replaceAll(':id', r.customerId),
              );
            },
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16.r,
                  backgroundColor: isDark
                      ? AdminAppColors.primaryColor.withValues(alpha: 0.15)
                      : const Color(0xFFF4EBFF),
                  child: Text(
                    r.customerName.isNotEmpty
                        ? r.customerName[0].toUpperCase()
                        : 'C',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                      color: AdminAppColors.primaryColor,
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    r.customerName.isNotEmpty ? r.customerName : 'Anonymous',
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? AdminAppColors.darkTextPrimary
                          : AdminAppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Product Name
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Text(
            productName,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              color: isDark
                  ? AdminAppColors.darkTextPrimary
                  : AdminAppColors.textPrimary,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),

        // Stars Rating
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(5, (index) {
              return Icon(
                index < r.rating
                    ? Icons.star_rounded
                    : Icons.star_border_rounded,
                size: 16.sp,
                color: AdminAppColors.warningColor,
              );
            }),
          ),
        ),

        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Text(
            r.reviewText.isNotEmpty
                ? r.reviewText
                : 'No text comment provided.',
            style: TextStyle(
              fontSize: 13.sp,
              color: r.isHidden
                  ? AdminAppColors.errorColor
                  : (isDark
                        ? AdminAppColors.darkTextSecondary
                        : const Color(0xFF6C6C80)),
              decoration: r.isHidden ? TextDecoration.lineThrough : null,
              decorationColor: AdminAppColors.errorColor,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),

        // Date and Time
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Text(
            formattedDate,
            style: TextStyle(
              fontSize: 13.sp,
              color: isDark
                  ? AdminAppColors.darkTextSecondary
                  : const Color(0xFF6C6C80),
            ),
          ),
        ),

        // Action view
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: InkWell(
            onTap: () => onViewDetail(r),
            child: Text(
              'View',
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.bold,
                color: AdminAppColors.primaryColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
