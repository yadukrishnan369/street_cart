import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';
import 'package:street_cart/features/customer/shops/presentation/pages/shop_details_page.dart';
import 'package:street_cart/shared/widgets/shop_image_placeholder.dart';

class ShopCard extends StatelessWidget {
  final ShopProfileModel shop;

  const ShopCard({
    super.key,
    required this.shop,
  });

  @override
  Widget build(BuildContext context) {
    // Dummy rating for display
    const double dummyRating = 4.8;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.w).copyWith(bottom: 16.h),
      decoration: BoxDecoration(
        color: CustomerAppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16.r),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ShopDetailsPage(shop: shop),
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Shop image with rating badge
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.r),
                  topRight: Radius.circular(16.r),
                ),
                child: Stack(
                  children: [
                    // Image
                    SizedBox(
                      width: double.infinity,
                      height: 180.h,
                      child: shop.profileImageUrl.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: shop.profileImageUrl,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const ShopImagePlaceholder(),
                              errorWidget: (context, url, error) => const ShopImagePlaceholder(),
                            )
                          : const ShopImagePlaceholder(),
                    ),
                    // Rating badge
                    Positioned(
                      top: 12.h,
                      right: 12.w,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 5.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.12),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.star_rounded,
                              color: const Color(0xFFF59E0B),
                              size: 14.sp,
                            ),
                            SizedBox(width: 3.w),
                            Text(
                              dummyRating.toStringAsFixed(1),
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w700,
                                color: CustomerAppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Shop info section
              Padding(
                padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 14.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name + Category tag
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            shop.shopName,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: CustomerAppColors.textPrimary,
                              letterSpacing: -0.2,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        // Category chip
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: CustomerAppColors.primaryLight,
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Text(
                            shop.category,
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w600,
                              color: CustomerAppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 6.h),

                    // Description
                    Text(
                      shop.description.isNotEmpty
                          ? shop.description
                          : 'Quality products and artisanal goods crafted for the modern individual.',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: CustomerAppColors.textSecondary,
                        height: 1.5,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 12.h),

                    // Location + View Shop row
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 13.sp,
                          color: CustomerAppColors.textSecondary,
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: Text(
                            shop.city.isNotEmpty
                                ? '${shop.city}, ${shop.state}'
                                : shop.fullAddress,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: CustomerAppColors.textSecondary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        // View Shop button
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ShopDetailsPage(shop: shop),
                              ),
                            );
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'View Shop',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                  color: CustomerAppColors.primary,
                                ),
                              ),
                              SizedBox(width: 2.w),
                              Icon(
                                Icons.arrow_forward_rounded,
                                size: 13.sp,
                                color: CustomerAppColors.primary,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
