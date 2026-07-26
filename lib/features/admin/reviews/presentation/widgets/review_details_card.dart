import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:street_cart/core/router/admin/route_paths.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';
import 'package:street_cart/features/admin/reviews/presentation/utils/review_helper.dart';
import 'package:street_cart/features/customer/review/data/models/review_model.dart';
import 'package:street_cart/shared/widgets/image_preview_page.dart';
import 'package:street_cart/shared/widgets/product_image_placeholder.dart';

// Review Details Card
class ReviewDetailsCard extends StatelessWidget {
  final ReviewModel review;
  final String productName;
  final String shopName;

  const ReviewDetailsCard({
    super.key,
    required this.review,
    required this.productName,
    required this.shopName,
  });

  @override
  Widget build(BuildContext context) {
    final formattedDate = AdminReviewHelper.getFormattedTimeAgo(
      review.createdAt,
    );

    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFE8E7ED), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Customer info header
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Navigate to Customer Details Page
              Expanded(
                child: InkWell(
                  onTap: () {
                    context.push(
                      RoutePaths.customerDetails.replaceAll(
                        ':id',
                        review.customerId,
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      // Customer Profile Avatar
                      ClipRRect(
                        borderRadius: BorderRadius.circular(24.r),
                        child: Container(
                          width: 48.w,
                          height: 48.h,
                          decoration: const BoxDecoration(
                            color: Color(0xFFF4EBFF),
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            review.customerName.isNotEmpty
                                ? review.customerName[0].toUpperCase()
                                : 'C',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: AdminAppColors.primaryColor,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Customer Name
                            Row(
                              children: [
                                Text(
                                  review.customerName.isNotEmpty
                                      ? review.customerName
                                      : 'Anonymous',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF1E1E2F),
                                  ),
                                ),
                                // Hidden Badge
                                if (review.isHidden) ...[
                                  SizedBox(width: 8.w),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8.w,
                                      vertical: 2.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFEF2F2),
                                      borderRadius: BorderRadius.circular(4.r),
                                      border: Border.all(
                                        color: const Color(0xFFFCA5A5),
                                      ),
                                    ),
                                    child: Text(
                                      'HIDDEN',
                                      style: TextStyle(
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.bold,
                                        color: AdminAppColors.errorColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            SizedBox(height: 2.h),
                            // Customer ID
                            Text(
                              'ID: #${review.id.length > 6 ? review.id.substring(0, 6).toUpperCase() : review.id}',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: const Color(0xFF8A8A9E),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Review Posted Time
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'POSTED ON',
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                      color: const Color(0xFF8A8A9E),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    formattedDate,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1E1E2F),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 24.h),
          const Divider(color: Color(0xFFF0EFF5), height: 1),
          SizedBox(height: 20.h),

          // Rating stars
          Row(
            children: [
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    index < review.rating
                        ? Icons.star_rounded
                        : Icons.star_border_rounded,
                    size: 20.sp,
                    color: Colors.amber,
                  );
                }),
              ),
              SizedBox(width: 12.w),
              Text(
                '${review.rating.toDouble()} / 5.0',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1E1E2F),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // Complete Review Comment
          Text(
            review.reviewText.isNotEmpty
                ? '"${review.reviewText}"'
                : 'No text comment provided.',
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1E1E2F),
            ),
          ),
          SizedBox(height: 24.h),

          // Attached Review Images
          if (review.images
              .where((img) => img.trim().isNotEmpty)
              .isNotEmpty) ...[
            // Title
            Text(
              'ATTACHED IMAGES',
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF8A8A9E),
                letterSpacing: 0.5,
              ),
            ),
            SizedBox(height: 12.h),
            SizedBox(
              height: 100.h,
              // List of Review Images
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: review.images.length,
                separatorBuilder: (_, __) => SizedBox(width: 12.w),
                itemBuilder: (context, index) {
                  final imgUrl = review.images[index];
                  if (imgUrl.trim().isEmpty) return const SizedBox.shrink();
                  return InkWell(
                    onTap: () =>
                        (BuildContext context, List<String> images, int index) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ImagePreviewPage(
                                images: images,
                                initialIndex: index,
                              ),
                            ),
                          );
                        }(context, review.images, index),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.r),
                      child: CachedNetworkImage(
                        imageUrl: imgUrl,
                        height: 100.h,
                        width: 100.w,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => ProductImagePlaceholder(
                          width: 72.w,
                          height: 72.w,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        errorWidget: (context, url, error) =>
                            ProductImagePlaceholder(
                              width: 72.w,
                              height: 72.w,
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 24.h),
          ],

          // Product and Shop tags
          Row(
            children: [
              // Product Card
              Expanded(
                child: InkWell(
                  onTap: () {
                    // Navigate to Product Details Page
                    context.push(
                      RoutePaths.productDetails.replaceAll(
                        ':id',
                        review.productId,
                      ),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(color: const Color(0xFFE8E7ED)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8.w),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF4EBFF),
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          child: Icon(
                            Icons.inventory_2_outlined,
                            size: 18.sp,
                            color: AdminAppColors.primaryColor,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Title
                              Text(
                                'PRODUCT',
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFF8A8A9E),
                                ),
                              ),
                              SizedBox(height: 2.h),
                              // Product Name
                              Text(
                                productName,
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF1E1E2F),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16.w),
              // Shop Card
              Expanded(
                child: InkWell(
                  // Navigate to Shop Details Page
                  onTap: () {
                    context.push(
                      RoutePaths.shopDetails.replaceAll(':id', review.shopId),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(color: const Color(0xFFE8E7ED)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8.w),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF4EBFF),
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          child: Icon(
                            Icons.storefront_outlined,
                            size: 18.sp,
                            color: AdminAppColors.primaryColor,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Title
                              Text(
                                'SHOP',
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFF8A8A9E),
                                ),
                              ),
                              SizedBox(height: 2.h),
                              // Shop Name
                              Text(
                                shopName,
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF1E1E2F),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
