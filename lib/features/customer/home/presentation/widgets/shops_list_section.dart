import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/features/customer/shops/presentation/pages/customer_shops_page.dart';
import 'package:street_cart/features/customer/shops/presentation/pages/shop_details_page.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ShopsListSection extends StatelessWidget {
  final List<ShopProfileModel> shops;

  const ShopsListSection({super.key, required this.shops});

  @override
  Widget build(BuildContext context) {
    if (shops.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: const Color(0xFFFEF2F2),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: const Color(0xFFFCA5A5), width: 1),
          ),
          child: Column(
            children: [
              Icon(
                Icons.storefront_outlined,
                color: CustomerAppColors.error,
                size: 32.sp,
              ),
              SizedBox(height: 8.h),
              Text(
                'No shops nearby your location',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: CustomerAppColors.error,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                'We currently do not have any registered shops delivering to your location. Try selecting a different location.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: CustomerAppColors.error,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final row1Shops = <ShopProfileModel>[];
    final row2Shops = <ShopProfileModel>[];

    for (int i = 0; i < shops.length; i++) {
      if (i % 2 == 0) {
        row1Shops.add(shops[i]);
      } else {
        row2Shops.add(shops[i]);
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${shops.length} ${shops.length == 1 ? 'shop' : 'shops'} near by you',
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (_, __, ___) => const CustomerShopsPage(),
                      transitionDuration: Duration.zero,
                    ),
                  );
                },
                child: Text(
                  'See all Shops',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: CustomerAppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 12.h),
        if (row1Shops.isNotEmpty)
          SizedBox(
            height: 90.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              itemCount: row1Shops.length,
              itemBuilder: (context, index) {
                return _buildShopCard(context, row1Shops[index]);
              },
            ),
          ),
        if (row2Shops.isNotEmpty) ...[
          SizedBox(height: 12.h),
          SizedBox(
            height: 90.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              itemCount: row2Shops.length,
              itemBuilder: (context, index) {
                return _buildShopCard(context, row2Shops[index]);
              },
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildShopCard(BuildContext context, ShopProfileModel shop) {
    return Padding(
      padding: EdgeInsets.only(right: 16.w),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => ShopDetailsPage(shop: shop)),
          );
        },
        child: Container(
          width: 280.w,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.08),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(8.w),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: Container(
                    width: 74.w,
                    height: 74.h,
                    color: Colors.grey[200],
                    child: shop.profileImageUrl.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: shop.profileImageUrl,
                            fit: BoxFit.cover,
                            errorWidget: (_, __, ___) => const Icon(
                              Icons.storefront,
                              color: Colors.grey,
                            ),
                          )
                        : const Icon(Icons.storefront, color: Colors.grey),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        shop.shopName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.orange, size: 14.sp),
                          SizedBox(width: 4.w),
                          Text(
                            '4.5',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            '• ${shop.category}',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        shop.state.isNotEmpty
                            ? '${shop.city}, ${shop.state}'
                            : shop.city,
                        style: TextStyle(fontSize: 11.sp, color: Colors.grey),
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
    );
  }
}
