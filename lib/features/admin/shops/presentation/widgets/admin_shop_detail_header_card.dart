import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';
import 'package:street_cart/core/utils/date_formatter.dart';
import 'package:street_cart/features/admin/shops/presentation/bloc/admin_shop_detail_bloc.dart';
import 'package:street_cart/features/admin/shops/presentation/bloc/admin_shop_detail_event.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';
import 'package:street_cart/shared/widgets/custom_alert_dialog.dart';

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
    final merchantPrefix = shop.shopName
        .substring(0, shop.shopName.length > 2 ? 2 : shop.shopName.length)
        .toUpperCase();
    final merchantId =
        '# $merchantPrefix-${shop.uid.substring(0, shop.uid.length > 4 ? 4 : shop.uid.length).toUpperCase()}';
    final joinedDate = shop.createdAt != null
        ? DateFormatter.formatToReadableDate(shop.createdAt!)
        : 'Oct 12, 2023';

    final isSuspended = shop.isSuspended;
    final isApproved = shop.isApproved;

    final headerInfo = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Logo or Fallback icon
        Container(
          width: 80.w,
          height: 80.h,
          decoration: BoxDecoration(
            color: const Color(0xFFF3F2F7),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: const Color(0xFFE8E7ED), width: 1),
            image: shop.profileImageUrl.isNotEmpty
                ? DecorationImage(
                    image: NetworkImage(shop.profileImageUrl),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: shop.profileImageUrl.isEmpty
              ? Icon(
                  Icons.storefront_outlined,
                  size: 32.sp,
                  color: const Color(0xFF8A8A9E),
                )
              : null,
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
                        color: AdminAppColors.textPrimary,
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
              Row(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.local_offer_outlined,
                        size: 14.sp,
                        color: const Color(0xFF6C6C80),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        shop.category,
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: const Color(0xFF6C6C80),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 16.w),
                  Icon(
                    Icons.location_on_outlined,
                    size: 14.sp,
                    color: const Color(0xFF8A8A9E),
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    shop.city.isNotEmpty
                        ? '${shop.city}, ${shop.state}'
                        : 'Calicut, Kerala',
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: const Color(0xFF6C6C80),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              Text(
                'Merchant ID: $merchantId   •   Joined: $joinedDate',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: const Color(0xFF8A8A9E),
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
          onPressed: () => _confirmSuspensionToggle(context, shop),
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
          onPressed: () => _confirmDelete(context, shop),
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFE8E7ED), width: 1.5),
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

  void _confirmSuspensionToggle(BuildContext context, ShopProfileModel shop) {
    final isSuspended = shop.isSuspended;
    showDialog(
      context: context,
      builder: (dialogCtx) => CustomAlertDialog(
        title: isSuspended ? 'Activate Shop' : 'Suspend Shop',
        content:
            'Are you sure you want to ${isSuspended ? "activate" : "suspend"} "${shop.shopName}"?',
        secondaryActionLabel: 'Cancel',
        primaryActionLabel: isSuspended ? 'Activate' : 'Suspend',
        icon: isSuspended
            ? Icons.play_circle_outline
            : Icons.pause_circle_outline,
        iconColor: isSuspended
            ? AdminAppColors.successColor
            : AdminAppColors.errorColor,
        primaryActionColor: isSuspended
            ? AdminAppColors.successColor
            : AdminAppColors.errorColor,
        onPrimaryAction: () {
          Navigator.pop(dialogCtx);
          context.read<AdminShopDetailBloc>().add(
            ToggleShopSuspensionRequested(
              shopId: shop.uid,
              isSuspended: !isSuspended,
            ),
          );
        },
      ),
    );
  }

  void _confirmDelete(BuildContext context, ShopProfileModel shop) {
    showDialog(
      context: context,
      builder: (dialogCtx) => CustomAlertDialog(
        title: 'Delete Shop',
        content: 'Are you sure you want to delete "${shop.shopName}"?',
        secondaryActionLabel: 'Cancel',
        primaryActionLabel: 'Delete',
        icon: Icons.delete_outline,
        iconColor: AdminAppColors.errorColor,
        primaryActionColor: AdminAppColors.errorColor,
        onPrimaryAction: () {
          Navigator.pop(dialogCtx);
          _confirmDeleteSecondStep(context, shop);
        },
      ),
    );
  }

  void _confirmDeleteSecondStep(BuildContext context, ShopProfileModel shop) {
    showDialog(
      context: context,
      builder: (dialogCtx) => CustomAlertDialog(
        title: 'Permanently Delete Shop',
        content:
            'This action is irreversible. All profile data for "${shop.shopName}" will be permanently deleted. Do you want to proceed?',
        secondaryActionLabel: 'Cancel',
        primaryActionLabel: 'Permanently Delete',
        icon: Icons.warning_amber_outlined,
        iconColor: AdminAppColors.errorColor,
        primaryActionColor: AdminAppColors.errorColor,
        onPrimaryAction: () {
          Navigator.pop(dialogCtx);
          context.read<AdminShopDetailBloc>().add(
            DeleteShopRequested(shop.uid),
          );
        },
      ),
    );
  }
}
