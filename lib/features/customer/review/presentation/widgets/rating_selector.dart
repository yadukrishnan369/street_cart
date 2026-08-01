import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/features/customer/review/presentation/utils/review_helper.dart';

// Rating Selector
class RatingSelector extends StatelessWidget {
  final int rating;
  final ValueChanged<int> onRatingChanged;

  const RatingSelector({
    super.key,
    required this.rating,
    required this.onRatingChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        // Title
        Text(
          'HOW WOULD YOU RATE IT?',
          style: TextStyle(
            color: isDark
                ? CustomerAppColors.darkTextSecondary
                : const Color(0xFF64748B),
            fontSize: 12.sp,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        SizedBox(height: 16.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          // List of Rating Stars
          children: List.generate(5, (index) {
            final starRating = index + 1;
            final isFilled = starRating <= rating;
            return GestureDetector(
              onTap: () => onRatingChanged(starRating),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Icon(
                  isFilled ? Icons.star_rounded : Icons.star_outline_rounded,
                  color: isFilled
                      ? CustomerAppColors.primary
                      : (isDark ? Colors.grey[700] : const Color(0xFFCBD5E1)),
                  size: 44.sp,
                ),
              ),
            );
          }),
        ),
        if (rating > 0) ...[
          SizedBox(height: 12.h),
          // Rating Titles
          Text(
            ReviewHelper.getRatingText(rating),
            style: TextStyle(
              color: isDark
                  ? CustomerAppColors.darkTextSecondary
                  : const Color(0xFF64748B),
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }
}
