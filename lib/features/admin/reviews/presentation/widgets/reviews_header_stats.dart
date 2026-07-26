import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';
import 'package:street_cart/core/utils/number_formatter.dart';
import 'review_stat_card.dart';

// Reviews Header Stats Section
class ReviewsHeaderStats extends StatelessWidget {
  final int totalReviews;
  final double averageRating;
  final bool isWide;

  const ReviewsHeaderStats({
    super.key,
    required this.totalReviews,
    required this.averageRating,
    required this.isWide,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // Total Review Counts
        SizedBox(
          width: isWide ? 260.w : 160.w,
          child: ReviewStatCard(
            title: 'Total Reviews',
            value: NumberFormatter.formatNumber(totalReviews),
            icon: Icons.rate_review_outlined,
            iconColor: AdminAppColors.primaryColor,
            iconBgColor: const Color(0xFFF4EBFF),
          ),
        ),
        SizedBox(width: 20.w),
        // Average Rating
        SizedBox(
          width: isWide ? 260.w : 160.w,
          child: ReviewStatCard(
            title: 'Average Rating',
            value: averageRating.toStringAsFixed(1),
            icon: Icons.star_rounded,
            iconColor: Colors.amber,
            iconBgColor: const Color(0xFFFFFBEB),
          ),
        ),
      ],
    );
  }
}
