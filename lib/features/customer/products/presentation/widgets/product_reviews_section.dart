import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/features/customer/review/data/models/review_model.dart';
import 'package:street_cart/features/customer/review/presentation/utils/review_helper.dart';
import 'package:street_cart/shared/widgets/review_card.dart';
import 'package:street_cart/features/customer/review/presentation/pages/all_reviews_page.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';
import 'package:street_cart/features/shop/products/data/models/product_model.dart';

// Product Review Section
class ProductReviewsSection extends StatelessWidget {
  final List<ReviewModel> reviews;
  final ProductModel product;
  final ShopProfileModel shop;
  final String? selectedColor;
  final String? selectedSize;

  const ProductReviewsSection({
    super.key,
    required this.reviews,
    required this.product,
    required this.shop,
    this.selectedColor,
    this.selectedSize,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;

    if (reviews.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            'Customer Reviews',
            style: TextStyle(
              color: isDark
                  ? CustomerAppColors.darkTextPrimary
                  : CustomerAppColors.textPrimary,
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: isDark ? CustomerAppColors.darkSurface : Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: isDark
                    ? CustomerAppColors.darkBorder
                    : const Color(0xFFE2E8F0),
              ),
            ),
            // Empty Info
            child: Text(
              'No reviews yet for this product.',
              style: TextStyle(
                color: isDark
                    ? CustomerAppColors.darkTextSecondary
                    : const Color(0xFF64748B),
                fontSize: 13.sp,
              ),
            ),
          ),
        ],
      );
    }

    final averageRating = ReviewHelper.getAverageRating(reviews);
    final displayCount = reviews.length > 3 ? 3 : reviews.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Title
            Text(
              'Ratings & Reviews',
              style: TextStyle(
                color: isDark
                    ? CustomerAppColors.darkTextPrimary
                    : CustomerAppColors.textPrimary,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            // Average Product Rating
            Row(
              children: [
                Icon(
                  Icons.star_rounded,
                  color: CustomerAppColors.warning,
                  size: 18.sp,
                ),
                SizedBox(width: 4.w),
                Text(
                  averageRating.toStringAsFixed(1),
                  style: TextStyle(
                    color: isDark
                        ? CustomerAppColors.darkTextPrimary
                        : CustomerAppColors.textPrimary,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  ' (${reviews.length})',
                  style: TextStyle(
                    color: isDark
                        ? CustomerAppColors.darkTextSecondary
                        : const Color(0xFF64748B),
                    fontSize: 13.sp,
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 12.h),
        // List of Reviews
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: displayCount,
          separatorBuilder: (_, __) => SizedBox(height: 12.h),
          itemBuilder: (context, index) {
            return ReviewCard(
              review: reviews[index],
              product: product,
              shop: shop,
              currentUserId: currentUserId,
              selectedColor: selectedColor,
              selectedSize: selectedSize,
            );
          },
        ),
        // View All Customer Review
        if (reviews.length > 3) ...[
          SizedBox(height: 12.h),
          Center(
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AllReviewsPage(
                      reviews: reviews,
                      product: product,
                      shop: shop,
                      selectedColor: selectedColor,
                      selectedSize: selectedSize,
                    ),
                  ),
                );
              },
              child: Text(
                'View All Reviews (${reviews.length})',
                style: TextStyle(
                  color: CustomerAppColors.primary,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
