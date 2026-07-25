import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/features/customer/review/data/models/review_model.dart';
import 'package:street_cart/features/customer/review/presentation/utils/review_helper.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';
import 'package:street_cart/features/shop/products/data/models/product_model.dart';
import 'package:street_cart/shared/widgets/image_preview_page.dart';
import 'package:street_cart/shared/widgets/product_image_placeholder.dart';

class ReviewCard extends StatelessWidget {
  final ReviewModel review;
  final ProductModel product;
  final ShopProfileModel shop;
  final String? currentUserId;
  final String? selectedColor;
  final String? selectedSize;

  const ReviewCard({
    super.key,
    required this.review,
    required this.product,
    required this.shop,
    required this.currentUserId,
    this.selectedColor,
    this.selectedSize,
  });

  @override
  Widget build(BuildContext context) {
    final customerName = review.customerName;
    final customerImage = review.customerImage;
    final rating = review.rating;
    final comment = review.reviewText;
    final images = review.images.where((img) => img.trim().isNotEmpty).toList();
    final formattedDate = ReviewHelper.getFormattedTimeAgo(review.createdAt);
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
                      imageBuilder: (context, imageProvider) => CircleAvatar(
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
                      errorWidget: (context, url, error) => CircleAvatar(
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
                        Text(
                          customerName,
                          style: TextStyle(
                            color: CustomerAppColors.textPrimary,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (isOwnReview)
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () => ReviewHelper.onEditReview(
                                  context: context,
                                  review: review,
                                  product: product,
                                  shop: shop,
                                  selectedColor: selectedColor,
                                  selectedSize: selectedSize,
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
                              GestureDetector(
                                onTap: () => ReviewHelper.onDeleteReview(
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
                                    color: Colors.redAccent,
                                    size: 16.sp,
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                    SizedBox(height: 2.h),
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
                      imageBuilder: (context, imageProvider) => Container(
                        width: 60.w,
                        margin: EdgeInsets.only(right: 8.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(color: const Color(0xFFCBD5E1)),
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
                          child: ProductImagePlaceholder(height: 60),
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
  }
}
