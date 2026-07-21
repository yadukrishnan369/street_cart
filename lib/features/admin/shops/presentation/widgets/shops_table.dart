import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:street_cart/core/router/admin/route_paths.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';
import 'package:street_cart/features/admin/shops/presentation/bloc/admin_shop_bloc.dart';
import 'package:street_cart/features/admin/shops/presentation/bloc/admin_shop_event.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';

// Shops Table
class ShopsTable extends StatelessWidget {
  final List<ShopProfileModel> shops;
  final int currentPage;
  final int perPage;

  const ShopsTable({
    super.key,
    required this.shops,
    required this.currentPage,
    required this.perPage,
  });

  @override
  Widget build(BuildContext context) {
    // Shops Table
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(2.0),
        1: FlexColumnWidth(1.5),
        2: FlexColumnWidth(2.0),
        3: FlexColumnWidth(1.8),
        4: FlexColumnWidth(1.5),
        5: FlexColumnWidth(1.2),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        TableRow(
          decoration: const BoxDecoration(
            color: Color(0xFFF4F5F7),
            border: Border(
              bottom: BorderSide(color: Color(0xFFE8E7ED), width: 1.5),
            ),
          ),
          // Table Title
          children: [
            _buildTableHeaderCell('SHOP NAME'),
            _buildTableHeaderCell('CATEGORY'),
            _buildTableHeaderCell('LOCATION'),
            _buildTableHeaderCell('DELIVERY RADIUS'),
            _buildTableHeaderCell('STATUS'),
            _buildTableHeaderCell('ACTIONS'),
          ],
        ),
        ...shops.map((shop) => _buildTableRow(context, shop)),
      ],
    );
  }

  Widget _buildTableHeaderCell(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11.sp,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.8,
          color: const Color(0xFF8A8A9E),
        ),
      ),
    );
  }

  TableRow _buildTableRow(BuildContext context, ShopProfileModel shop) {
    final isSuspended = shop.isSuspended;

    return TableRow(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFF0EFF5), width: 1.2),
        ),
      ),
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3E8FF),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  Icons.storefront_outlined,
                  color: const Color(0xFF7B2CBF),
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Shop Name
                    Text(
                      shop.shopName,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1E1E2F),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 2.h),
                    // Shop ID
                    Text(
                      'ID: #${shop.uid.substring(0, shop.uid.length > 8 ? 8 : shop.uid.length).toUpperCase()}',
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: const Color(0xFF8A8A9E),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Shop Category
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Text(
            shop.category,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1E1E2F),
            ),
          ),
        ),
        // Shop Address
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Text(
            () {
              if (shop.fullAddress.trim().isNotEmpty) {
                return shop.fullAddress;
              }
              final parts = [
                if (shop.city.trim().isNotEmpty) shop.city.trim(),
                if (shop.state.trim().isNotEmpty) shop.state.trim(),
              ];
              return parts.isEmpty ? 'Not provided' : parts.join(', ');
            }(),
            style: TextStyle(fontSize: 13.sp, color: const Color(0xFF6C6C80)),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        // Shop Delivery Radius KM
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Text(
            '${shop.deliveryRadius.toInt()} KM',
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1E1E2F),
            ),
          ),
        ),
        // Status Label
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: isSuspended
                    ? const Color(0xFFFDE8E8)
                    : const Color(0xFFDEF7EC),
                borderRadius: BorderRadius.circular(100.r),
              ),
              child: Text(
                isSuspended ? 'Suspended' : 'Active',
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.bold,
                  color: isSuspended
                      ? const Color(0xFF9B1C1C)
                      : const Color(0xFF03543F),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              // Navigate to Shop Details Page
              onPressed: () async {
                final refresh = await context.push(
                  RoutePaths.shopDetails.replaceAll(':id', shop.uid),
                );
                if (refresh == true && context.mounted) {
                  context.read<AdminShopBloc>().add(
                    LoadAdminShop(page: currentPage, limit: perPage),
                  );
                }
              },
              child: Text(
                'View',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold,
                  color: AdminAppColors.primaryColor,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
