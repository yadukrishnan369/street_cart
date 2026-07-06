import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';
import 'package:street_cart/features/shop/products/data/models/product_model.dart';
import 'package:street_cart/features/customer/shops/presentation/pages/shop_details_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:street_cart/shared/widgets/shop_image_placeholder.dart';

class HomeBanner extends StatefulWidget {
  final List<ShopProfileModel> shops;
  final List<ProductModel> products;

  const HomeBanner({super.key, required this.shops, required this.products});

  @override
  State<HomeBanner> createState() => _HomeBannerState();
}

class _HomeBannerState extends State<HomeBanner> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  List<Map<String, dynamic>> _getBanners() {
    final List<Map<String, dynamic>> dynamicBanners = [];

    for (final shop in widget.shops) {
      final shopProducts = widget.products
          .where((p) => p.shopId == shop.uid)
          .toList();
      final offerProducts = shopProducts
          .where((p) => p.offerPrice != null && p.offerPrice! < p.originalPrice)
          .toList();

      // Check if shop has 5 or more products with offer
      if (offerProducts.length >= 5) {
        final discountPercents = offerProducts
            .map(
              (p) =>
                  ((p.originalPrice - p.offerPrice!) / p.originalPrice) * 100,
            )
            .toList();
        final averagePercent =
            discountPercents.reduce((a, b) => a + b) / discountPercents.length;

        dynamicBanners.add({
          'title': 'HOT DEAL AT ${shop.shopName.toUpperCase()}',
          'subtitle': shop.shopName,
          'discount': 'AVERAGE ${averagePercent.toStringAsFixed(0)}% OFF',
          'image': shop.profileImageUrl.isNotEmpty
              ? shop.profileImageUrl
              : 'assets/images/fallback_banner.jpg',
          'isAsset': shop.profileImageUrl.isEmpty,
          'shop': shop,
        });
      }
    }

    if (dynamicBanners.isNotEmpty) {
      return dynamicBanners;
    }

    // Fallback placeholder banner if no shop has >= 5 offer products
    return [
      {
        'title': 'COMMUNITY DEALS',
        'subtitle': 'Exciting Offers Coming Soon!',
        'discount': 'STAY TUNED',
        'image': 'assets/images/fallback_banner.jpg',
        'isAsset': true,
      },
    ];
  }

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 4), (Timer timer) {
      if (_pageController.hasClients) {
        final totalBanners = _getBanners().length;
        int nextPage = _currentPage + 1;
        if (nextPage >= totalBanners) {
          nextPage = 0;
          _pageController.animateToPage(
            nextPage,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        } else {
          _pageController.animateToPage(
            nextPage,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bannerList = _getBanners();

    if (bannerList.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          height: 160.h,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: bannerList.length,
            itemBuilder: (context, index) {
              final banner = bannerList[index];
              final ShopProfileModel? shop =
                  banner['shop'] as ShopProfileModel?;

              return GestureDetector(
                onTap: shop != null
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ShopDetailsPage(shop: shop),
                          ),
                        );
                      }
                    : null,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      banner['isAsset'] == true
                          ? Image.asset(
                              banner['image']!,
                              fit: BoxFit.cover,
                            )
                          : CachedNetworkImage(
                              imageUrl: banner['image']!,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const ShopImagePlaceholder(),
                              errorWidget: (context, url, error) => const ShopImagePlaceholder(),
                            ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.r),
                          gradient: LinearGradient(
                            colors: [
                              Colors.black.withOpacity(0.7),
                              Colors.transparent,
                            ],
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(20.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              banner['title']!,
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              banner['subtitle']!,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 6.h,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              child: Text(
                                banner['discount']!,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 8.h),
        // Dots Indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            bannerList.length,
            (index) => Container(
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              width: _currentPage == index ? 12.w : 8.w,
              height: 8.h,
              decoration: BoxDecoration(
                color: _currentPage == index
                    ? CustomerAppColors.primary
                    : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
