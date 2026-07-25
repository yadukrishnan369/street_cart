import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/features/customer/review/data/models/review_model.dart';
import 'package:street_cart/features/customer/review/presentation/utils/review_helper.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';
import 'package:street_cart/features/shop/products/data/models/product_model.dart';
import 'package:street_cart/shared/widgets/image_preview_page.dart';

// Product Review Section
class ProductReviewsSection extends StatelessWidget {
  final List<ReviewModel> reviews;
  final ProductModel product;
  final ShopProfileModel shop;

  const ProductReviewsSection({
    super.key,
    required this.reviews,
    required this.product,
    required this.shop,
  });

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    // Empty State
    if (reviews.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
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
            // Empty Info
            child: Text(
              'No reviews yet for this product.',
              style: TextStyle(color: const Color(0xFF64748B), fontSize: 13.sp),
            ),
          ),
        ],
      );
    }

    final averageRating = ReviewHelper.getAverageRating(reviews);

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
                color: CustomerAppColors.textPrimary,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            // Average Product Rating
            Row(
              children: [
                Icon(
                  Icons.star_rounded,
                  color: CustomerAppColors.primary,
                  size: 18.sp,
                ),
                SizedBox(width: 4.w),
                Text(
                  averageRating.toStringAsFixed(1),
                  style: TextStyle(
                    color: CustomerAppColors.textPrimary,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
          itemCount: reviews.length,
          separatorBuilder: (_, __) => SizedBox(height: 12.h),
          itemBuilder: (context, index) {
            final review = reviews[index];
            final customerName = review.customerName;
            final customerImage = review.customerImage;
            final rating = review.rating;
            final comment = review.reviewText;
            final images = review.images;
            final formattedDate = ReviewHelper.getFormattedTimeAgo(
              review.createdAt,
            );
            final isOwnReview = review.customerId == currentUserId;

            return Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Customer Profile Image
                  Row(
                    children: [
                      customerImage.isEmpty
                          ? CircleAvatar(
                              radius: 18.r,
                              backgroundColor: const Color(0xFFF1F5F9),
                              child: Icon(
                                Icons.person_rounded,
                                color: const Color(0xFF94A3B8),
                                size: 20.sp,
                              ),
                            )
                          : CachedNetworkImage(
                              imageUrl: customerImage,
                              imageBuilder: (context, imageProvider) =>
                                  CircleAvatar(
                                    radius: 18.r,
                                    backgroundImage: imageProvider,
                                  ),
                              placeholder: (context, url) => CircleAvatar(
                                radius: 18.r,
                                backgroundColor: const Color(0xFFF1F5F9),
                                child: SizedBox(
                                  width: 14.w,
                                  height: 14.w,
                                  child: const CircularProgressIndicator(
                                    strokeWidth: 1.5,
                                  ),
                                ),
                              ),
                              errorWidget: (context, url, error) =>
                                  CircleAvatar(
                                    radius: 18.r,
                                    backgroundColor: const Color(0xFFF1F5F9),
                                    child: Icon(
                                      Icons.person_rounded,
                                      color: const Color(0xFF94A3B8),
                                      size: 20.sp,
                                    ),
                                  ),
                            ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Customer Name
                                Text(
                                  customerName,
                                  style: TextStyle(
                                    color: CustomerAppColors.textPrimary,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                // Showing Edit/Delete option, if Own Review
                                if (isOwnReview)
                                  Row(
                                    children: [
                                      // Edit Review
                                      GestureDetector(
                                        onTap: () => ReviewHelper.onEditReview(
                                          context: context,
                                          review: review,
                                          product: product,
                                          shop: shop,
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 4.w,
                                          ),
                                          child: Icon(
                                            Icons.edit_outlined,
                                            color: const Color(0xFF64748B),
                                            size: 16.sp,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 6.w),
                                      // Delete Review
                                      GestureDetector(
                                        onTap: () =>
                                            ReviewHelper.onDeleteReview(
                                              context: context,
                                              reviewId: review.id,
                                              product: product,
                                            ),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 4.w,
                                          ),
                                          child: Icon(
                                            Icons.delete_outline_rounded,
                                            color: CustomerAppColors.error,
                                            size: 16.sp,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                            SizedBox(height: 2.h),
                            // Review Posted Date and Time
                            Row(
                              children: [
                                Row(
                                  children: List.generate(5, (starIndex) {
                                    return Icon(
                                      starIndex < rating
                                          ? Icons.star_rounded
                                          : Icons.star_outline_rounded,
                                      color: CustomerAppColors.primary,
                                      size: 14.sp,
                                    );
                                  }),
                                ),
                                const Spacer(),
                                Text(
                                  formattedDate,
                                  style: TextStyle(
                                    color: const Color(0xFF94A3B8),
                                    fontSize: 11.sp,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // Comment
                  if (comment.trim().isNotEmpty) ...[
                    SizedBox(height: 12.h),
                    Text(
                      comment,
                      style: TextStyle(
                        color: const Color(0xFF334155),
                        fontSize: 13.sp,
                        height: 1.4,
                      ),
                    ),
                  ],
                  // List of Review Images
                  if (images.isNotEmpty) ...[
                    SizedBox(height: 12.h),
                    SizedBox(
                      height: 60.h,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: images.length,
                        itemBuilder: (context, imageIndex) {
                          return GestureDetector(
                            onTap: () {
                              // Navigate to Image Preview Page
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ImagePreviewPage(
                                    images: images,
                                    initialIndex: imageIndex,
                                  ),
                                ),
                              );
                            },
                            child: CachedNetworkImage(
                              imageUrl: images[imageIndex],
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                    width: 60.w,
                                    margin: EdgeInsets.only(right: 8.w),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.r),
                                      border: Border.all(
                                        color: const Color(0xFFCBD5E1),
                                      ),
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                              placeholder: (context, url) => Container(
                                width: 60.w,
                                margin: EdgeInsets.only(right: 8.w),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.r),
                                  color: const Color(0xFFF1F5F9),
                                ),
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              ),
                              errorWidget: (context, url, error) => Container(
                                width: 60.w,
                                margin: EdgeInsets.only(right: 8.w),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.r),
                                  color: const Color(0xFFF1F5F9),
                                ),
                                child: Icon(
                                  Icons.broken_image_outlined,
                                  color: const Color(0xFF94A3B8),
                                  size: 20.sp,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
