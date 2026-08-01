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
  final ShopProfileModel? shop;
  final String? currentUserId;
  final String? selectedColor;
  final String? selectedSize;

  const ReviewCard({
    super.key,
    required this.review,
    required this.product,
    this.shop,
    required this.currentUserId,
    this.selectedColor,
    this.selectedSize,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Color for both customer & shop app
    final cardBg = isDark ? CustomerAppColors.darkSurface : Colors.white;
    final cardBorder = isDark
        ? CustomerAppColors.darkBorder
        : const Color(0xFFE2E8F0);
    final avatarBg = isDark ? const Color(0xFF2A2A2A) : const Color(0xFFF1F5F9);
    final avatarIconColor = isDark
        ? const Color(0xFF6B7280)
        : const Color(0xFF94A3B8);
    final nameColor = isDark
        ? CustomerAppColors.darkTextPrimary
        : CustomerAppColors.textPrimary;
    final editIconColor = isDark
        ? const Color(0xFF9CA3AF)
        : const Color(0xFF64748B);
    final dateColor = isDark
        ? const Color(0xFF6B7280)
        : const Color(0xFF94A3B8);
    final commentColor = isDark
        ? CustomerAppColors.darkTextSecondary
        : const Color(0xFF334155);
    final imageBorderColor = isDark
        ? const Color(0xFF374151)
        : const Color(0xFFCBD5E1);
    final imagePlaceholderBg = isDark
        ? const Color(0xFF1F2937)
        : const Color(0xFFF1F5F9);

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
        color: cardBg,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Customer Avatar
              customerImage.isEmpty
                  ? CircleAvatar(
                      radius: 18.r,
                      backgroundColor: avatarBg,
                      child: Icon(
                        Icons.person_rounded,
                        color: avatarIconColor,
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
                        backgroundColor: avatarBg,
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
                        backgroundColor: avatarBg,
                        child: Icon(
                          Icons.person_rounded,
                          color: avatarIconColor,
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
                            color: nameColor,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // Edit / Delete actions own review only
                        if (isOwnReview)
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () => ReviewHelper.onEditReview(
                                  context: context,
                                  review: review,
                                  product: product,
                                  shop: shop!,
                                  selectedColor: selectedColor,
                                  selectedSize: selectedSize,
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 4.w,
                                  ),
                                  child: Icon(
                                    Icons.edit_outlined,
                                    color: editIconColor,
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
                        // Star Rating
                        Row(
                          children: List.generate(5, (starIndex) {
                            return Icon(
                              starIndex < rating
                                  ? Icons.star_rounded
                                  : Icons.star_outline_rounded,
                              color: CustomerAppColors.warning,
                              size: 14.sp,
                            );
                          }),
                        ),
                        const Spacer(),
                        // Date
                        Text(
                          formattedDate,
                          style: TextStyle(color: dateColor, fontSize: 11.sp),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Review Comment
          if (comment.trim().isNotEmpty) ...[
            SizedBox(height: 12.h),
            Text(
              comment,
              style: TextStyle(
                color: commentColor,
                fontSize: 13.sp,
                height: 1.4,
              ),
            ),
          ],
          // Review Images
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
                          border: Border.all(color: imageBorderColor),
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
                          color: imagePlaceholderBg,
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
                          color: imagePlaceholderBg,
                        ),
                        child: Icon(
                          Icons.broken_image_outlined,
                          color: avatarIconColor,
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
