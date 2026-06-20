import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';
import 'package:street_cart/shared/widgets/custom_snackbar.dart';

class AdminShopProductsCard extends StatelessWidget {
  const AdminShopProductsCard({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock products data matching the user's mockup image
    final mockProducts = [
      {
        'name': 'Oversized Beige T-Shirt',
        'category': 'T- Shirt',
        'price': '₹45.00',
        'stock': '124 in stock',
        'status': 'Active',
        'image': 'onboarding_1.png',
      },
      {
        'name': 'Recycled Denim Jeans',
        'category': 'Jeans',
        'price': '₹89.00',
        'stock': '58 in stock',
        'status': 'Active',
        'image': 'shop_login_header.png',
      },
      {
        'name': 'Mens T-Shirt',
        'category': 'T- Shirt',
        'price': '₹22.00',
        'stock': 'Out of Stock',
        'status': 'Hidden',
        'image': 'onboarding_2.png',
      },
      {
        'name': 'Essential Black Hoodie',
        'category': 'Hoddies',
        'price': '₹65.00',
        'stock': '210 in stock',
        'status': 'Active',
        'image': 'shop_onboarding_1.png',
      },
      {
        'name': 'Recycled Denim Jeans',
        'category': 'Jeans',
        'price': '₹89.00',
        'stock': '58 in stock',
        'status': 'Active',
        'image': 'shop_onboarding_2.png',
      },
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFE8E7ED), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(24.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.format_list_bulleted,
                      color: AdminAppColors.primaryColor,
                      size: 18.sp,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'Products (24)',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w800,
                        color: AdminAppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9FAFC),
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                      color: const Color(0xFFE8E7ED),
                      width: 1.2,
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Filters',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1E1E2F),
                        ),
                      ),
                      SizedBox(width: 6.w),
                      Icon(
                        Icons.filter_list,
                        size: 14.sp,
                        color: const Color(0xFF8A8A9E),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Table(
            columnWidths: const {
              0: FlexColumnWidth(3.0),
              1: FlexColumnWidth(1.5),
              2: FlexColumnWidth(1.2),
              3: FlexColumnWidth(1.5),
              4: FlexColumnWidth(1.2),
              5: FlexColumnWidth(1.0),
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
                children: [
                  _buildTableHeaderCell('PRODUCT'),
                  _buildTableHeaderCell('CATEGORY'),
                  _buildTableHeaderCell('PRICE'),
                  _buildTableHeaderCell('STOCK'),
                  _buildTableHeaderCell('STATUS'),
                  _buildTableHeaderCell('ACTIONS'),
                ],
              ),
              ...mockProducts.map((p) {
                final isOutOfStock = p['stock'] == 'Out of Stock';
                final isHidden = p['status'] == 'Hidden';

                return TableRow(
                  decoration: const BoxDecoration(
                     border: Border(
                      bottom: BorderSide(color: Color(0xFFF0EFF5), width: 1.2),
                    ),
                  ),
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 16.h,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 36.w,
                            height: 36.h,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3E8FF),
                              borderRadius: BorderRadius.circular(6.r),
                              image: DecorationImage(
                                image: AssetImage(
                                  'assets/images/${p['image']}',
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Text(
                              p['name']!,
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF1E1E2F),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: Text(
                        p['category']!,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: const Color(0xFF6C6C80),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: Text(
                        p['price']!,
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1E1E2F),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: isOutOfStock
                              ? const Color(0xFFFDE8E8)
                              : const Color(0xFFDEF7EC),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Text(
                          p['stock']!,
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                            color: isOutOfStock
                                ? const Color(0xFF9B1C1C)
                                : const Color(0xFF03543F),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: Row(
                        children: [
                          Container(
                            width: 6.w,
                            height: 6.h,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isHidden
                                  ? const Color(0xFF8A8A9E)
                                  : const Color(0xFF31C48D),
                            ),
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            p['status']!,
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: isHidden
                                  ? const Color(0xFF8A8A9E)
                                  : const Color(0xFF31C48D),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: TextButton(
                        onPressed: () {
                          CustomSnackBar.show(
                            context,
                            message:
                                'Products editing will be implemented in future',
                          );
                        },
                        child: Text(
                          'View',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                            color: AdminAppColors.primaryColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ],
          ),
          SizedBox(height: 24.h),
        ],
      ),
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
}
