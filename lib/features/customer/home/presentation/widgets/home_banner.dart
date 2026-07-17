import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';
import 'package:street_cart/features/shop/products/data/models/product_model.dart';
import 'package:street_cart/features/customer/shops/presentation/pages/shop_details_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:street_cart/shared/widgets/shop_image_placeholder.dart';
import 'package:street_cart/features/customer/home/presentation/bloc/home_bloc.dart';
import 'package:street_cart/features/customer/home/presentation/bloc/home_event.dart';
import 'package:street_cart/features/customer/home/presentation/bloc/home_state.dart';
import 'package:street_cart/features/customer/home/presentation/utils/home_helper.dart';

// Home Banner
class HomeBanner extends StatefulWidget {
  final List<ShopProfileModel> shops;
  final List<ProductModel> products;

  const HomeBanner({super.key, required this.shops, required this.products});

  @override
  State<HomeBanner> createState() => _HomeBannerState();
}

class _HomeBannerState extends State<HomeBanner> {
  final PageController _pageController = PageController();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = HomeHelper.startBannerAutoScroll(
      pageController: _pageController,
      context: context,
      shops: widget.shops,
      products: widget.products,
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bannerList = HomeHelper.getBanners(
      shops: widget.shops,
      products: widget.products,
    );

    if (bannerList.isEmpty) {
      return const SizedBox.shrink();
    }

    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        final currentPage = state.currentBannerPage;
        return Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              height: 160.h,
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  context.read<HomeBloc>().add(ChangeBannerPage(index));
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
                              ? Image.asset(banner['image']!, fit: BoxFit.cover)
                              : CachedNetworkImage(
                                  imageUrl: banner['image']!,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) =>
                                      const ShopImagePlaceholder(),
                                  errorWidget: (context, url, error) =>
                                      const ShopImagePlaceholder(),
                                ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.r),
                              gradient: LinearGradient(
                                colors: [
                                  Colors.black.withValues(alpha: 0.7),
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
                                    color: Colors.grey.withValues(alpha: 0.5),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                bannerList.length,
                (index) => Container(
                  margin: EdgeInsets.symmetric(horizontal: 4.w),
                  width: currentPage == index ? 12.w : 8.w,
                  height: 8.h,
                  decoration: BoxDecoration(
                    color: currentPage == index
                        ? CustomerAppColors.primary
                        : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
