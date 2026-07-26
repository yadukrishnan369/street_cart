import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/di/dependency_injection.dart';
import 'package:street_cart/features/shop/reviews/presentation/pages/reviews_page.dart';
import 'package:street_cart/features/customer/review/presentation/utils/review_helper.dart';
import 'package:street_cart/shared/widgets/review_card.dart';
import 'package:street_cart/features/shop/products/data/models/product_model.dart';
import 'package:street_cart/features/shop/reviews/presentation/bloc/shop_reviews_bloc.dart';
import 'package:street_cart/features/shop/reviews/presentation/bloc/shop_reviews_event.dart';
import 'package:street_cart/features/shop/reviews/presentation/bloc/shop_reviews_state.dart';

// Shop Product Reviews Section
class ShopProductReviewsSection extends StatelessWidget {
  final ProductModel product;
  final String shopId;

  const ShopProductReviewsSection({
    super.key,
    required this.product,
    required this.shopId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      key: ValueKey(product.id),
      create: (context) =>
          sl<ShopReviewsBloc>()..add(LoadShopReviewsEvent(product.id)),
      child: BlocBuilder<ShopReviewsBloc, ShopReviewsState>(
        builder: (context, state) {
          if (state is ShopReviewsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ShopReviewsError) {
            return Text(
              'Failed to load reviews: ${state.message}',
              style: TextStyle(color: ShopAppColors.error, fontSize: 13.sp),
            );
          }

          if (state is ShopReviewsLoaded) {
            final reviews = state.reviews;
            // Empty State
            if (reviews.isEmpty) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Empty Title
                  Text(
                    'Customer Reviews',
                    style: TextStyle(
                      color: CustomerAppColors.textPrimary,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Text(
                      'No reviews yet for this product.',
                      style: TextStyle(
                        color: const Color(0xFF64748B),
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
                    // Reviews Title
                    Text(
                      'Product Ratings & Reviews',
                      style: TextStyle(
                        color: CustomerAppColors.textPrimary,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.star_rounded,
                          color: CustomerAppColors.primary,
                          size: 18.sp,
                        ),
                        SizedBox(width: 4.w),
                        // Average Product Rating
                        Text(
                          averageRating.toStringAsFixed(1),
                          style: TextStyle(
                            color: CustomerAppColors.textPrimary,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // Count of Total Reviews
                        Text(
                          ' (${reviews.length})',
                          style: TextStyle(
                            color: const Color(0xFF64748B),
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
                      currentUserId: null, // Shop owner can't edit reviews
                    );
                  },
                ),
                if (reviews.length > 3) ...[
                  SizedBox(height: 12.h),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        // Navigate to Shop Reviews Page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ShopReviewsPage(
                              reviews: reviews,
                              product: product,
                              shopId: shopId,
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

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
