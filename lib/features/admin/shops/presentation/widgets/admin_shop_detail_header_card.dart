import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';
import 'package:street_cart/features/admin/shops/presentation/utils/shop_products_card_helper.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';
import 'package:street_cart/shared/widgets/image_preview_page.dart';
import 'package:street_cart/shared/widgets/shop_image_placeholder.dart';

// Admin Shop Detail Header Card
class AdminShopDetailHeaderCard extends StatelessWidget {
  final ShopProfileModel shop;
  final bool isWide;

  const AdminShopDetailHeaderCard({
    super.key,
    required this.shop,
    required this.isWide,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final merchantId = ShopProductsCardHelper.generateMerchantId(shop);
    final joinedDate = ShopProductsCardHelper.formatJoinedDate(shop);

    final isSuspended = shop.isSuspended;
    final isApproved = shop.isApproved;

    final headerInfo = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Logo and Shop Profile Image
        GestureDetector(
          onTap: shop.profileImageUrl.isNotEmpty
              ? () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ImagePreviewPage(
                        images: [shop.profileImageUrl],
                        initialIndex: 0,
                      ),
                    ),
                  );
                }
              : null,
          child: Container(
            width: 80.w,
            height: 80.h,
            decoration: BoxDecoration(
              color: isDark
                  ? AdminAppColors.darkInputBackground
                  : const Color(0xFFF3F2F7),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: isDark
                    ? AdminAppColors.darkBorder
                    : const Color(0xFFE8E7ED),
                width: 1,
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: shop.profileImageUrl.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: shop.profileImageUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => ShopImagePlaceholder(
                      iconSize: 35,
                      width: 35,
                      height: 35,
                    ),
                    errorWidget: (context, url, error) => ShopImagePlaceholder(
                      iconSize: 35,
                      width: 35,
                      height: 35,
                    ),
                  )
                : ShopImagePlaceholder(iconSize: 70, width: 70, height: 70),
          ),
        ),
        SizedBox(width: 24.w),

        // shop info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      shop.shopName,
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w800,
                        color: isDark
                            ? AdminAppColors.darkTextPrimary
                            : AdminAppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(width: 12.w),

                  // Status badge
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: isSuspended
                          ? const Color(0xFFFDE8E8)
                          : !isApproved
                          ? const Color(0xFFFFF3CD)
                          : const Color(0xFFDEF7EC),
                      borderRadius: BorderRadius.circular(100.r),
                    ),
                    child: Text(
                      isSuspended
                          ? 'Suspended'
                          : !isApproved
                          ? 'Pending'
                          : 'Active',
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.bold,
                        color: isSuspended
                            ? const Color(0xFF9B1C1C)
                            : !isApproved
                            ? const Color(0xFF856404)
                            : const Color(0xFF03543F),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              // Shop Category
              Row(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.local_offer_outlined,
                        size: 14.sp,
                        color: isDark
                            ? AdminAppColors.darkTextSecondary
                            : const Color(0xFF6C6C80),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        shop.category,
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: isDark
                              ? AdminAppColors.darkTextSecondary
                              : const Color(0xFF6C6C80),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 16.w),
                  Icon(
                    Icons.location_on_outlined,
                    size: 14.sp,
                    color: isDark
                        ? AdminAppColors.darkTextSecondary
                        : const Color(0xFF8A8A9E),
                  ),
                  SizedBox(width: 4.w),
                  // Shop Location
                  Text(
                    shop.city.isNotEmpty
                        ? '${shop.city}, ${shop.state}'
                        : 'Unknown Location',
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: isDark
                          ? AdminAppColors.darkTextSecondary
                          : const Color(0xFF6C6C80),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              // Shop ID
              Text(
                'Merchant ID: $merchantId   •   Joined: $joinedDate',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: isDark
                      ? AdminAppColors.darkTextSecondary
                      : const Color(0xFF8A8A9E),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );

    final actionButtons = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Suspend/Activate Button
        OutlinedButton.icon(
          onPressed: () =>
              ShopProductsCardHelper.confirmSuspensionToggle(context, shop),
          icon: Icon(
            isSuspended ? Icons.play_circle_outline : Icons.block,
            color: isSuspended
                ? AdminAppColors.successColor
                : AdminAppColors.errorColor,
            size: 16.sp,
          ),
          label: Text(
            isSuspended ? 'Activate' : 'Suspend',
            style: TextStyle(
              color: isSuspended
                  ? AdminAppColors.successColor
                  : AdminAppColors.errorColor,
              fontWeight: FontWeight.w700,
            ),
          ),
          style: OutlinedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            side: BorderSide(
              color: isSuspended
                  ? AdminAppColors.successColor
                  : AdminAppColors.errorColor,
              width: 1.5,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
        ),
        SizedBox(width: 16.w),

        // Delete Button
        ElevatedButton(
          onPressed: () => ShopProductsCardHelper.confirmDelete(context, shop),
          style: ElevatedButton.styleFrom(
            backgroundColor: AdminAppColors.errorColor,
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
          child: const Text(
            'Delete',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );

    return Container(
      padding: EdgeInsets.all(28.w),
      decoration: BoxDecoration(
        color: isDark ? AdminAppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isDark ? AdminAppColors.darkBorder : const Color(0xFFE8E7ED),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E1E2F).withValues(alpha: 0.01),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: isWide
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: headerInfo),
                SizedBox(width: 32.w),
                actionButtons,
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                headerInfo,
                SizedBox(height: 24.h),
                actionButtons,
              ],
            ),
    );
  }
}
