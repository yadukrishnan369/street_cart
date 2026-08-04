import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';
import 'package:street_cart/features/customer/review/data/models/review_model.dart';
import 'package:street_cart/shared/widgets/review_card.dart';
import 'package:street_cart/features/shop/products/data/models/product_model.dart';

// Shop Reviews Page
class ShopReviewsPage extends StatelessWidget {
  final List<ReviewModel> reviews;
  final ProductModel product;
  final String shopId;

  const ShopReviewsPage({
    super.key,
    required this.reviews,
    required this.product,
    required this.shopId,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? ShopAppColors.darkBackground
          : const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: isDark ? ShopAppColors.darkBackground : Colors.white,
        elevation: isDark ? null : 1.0,
        shape: Border(
          bottom: BorderSide(
            color: isDark
                ? ShopAppColors.darkBorder
                : ShopAppColors.border.withValues(alpha: 1.5),
            width: 0.5,
          ),
        ),
        // Page Title
        title: Text(
          '${product.name} - Reviews',
          style: ShopAppTextStyles.bodyMediumBold.copyWith(
            color: isDark
                ? ShopAppColors.darkTextPrimary
                : ShopAppColors.textPrimary,
            fontSize: 16.sp,
          ),
        ),
        centerTitle: true,
        leading: BackButton(
          color: isDark
              ? ShopAppColors.darkTextPrimary
              : ShopAppColors.textPrimary,
        ),
      ),
      body: SafeArea(
        child: reviews.isEmpty
            // Empty State
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.rate_review_outlined,
                      size: 56.sp,
                      color: isDark
                          ? ShopAppColors.darkTextSecondary
                          : ShopAppColors.textTertiary,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'No reviews yet',
                      style: ShopAppTextStyles.bodyMediumBold.copyWith(
                        color: isDark
                            ? ShopAppColors.darkTextSecondary
                            : ShopAppColors.textSecondary,
                        fontSize: 16.sp,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      'Customer reviews will appear here.',
                      style: ShopAppTextStyles.bodySmall.copyWith(
                        color: isDark
                            ? ShopAppColors.darkTextSecondary
                            : ShopAppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              )
            // List of Reviews
            : ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                itemCount: reviews.length,
                separatorBuilder: (_, __) => SizedBox(height: 12.h),
                itemBuilder: (context, index) {
                  // Review Card
                  return ReviewCard(
                    review: reviews[index],
                    product: product,
                    currentUserId: null, // Shop owner can't edit reviews
                  );
                },
              ),
      ),
    );
  }
}
