import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/features/shop/products/data/models/product_model.dart';
import 'package:street_cart/core/utils/date_formatter.dart';

// Product Listing Details Card
class ProductListingDetailsCard extends StatelessWidget {
  final ProductModel product;
  final double commissionRate;

  const ProductListingDetailsCard({
    super.key,
    required this.product,
    required this.commissionRate,
  });

  @override
  Widget build(BuildContext context) {
    final p = product;
    final String dateStr = p.createdAt != null
        ? DateFormatter.formatToReadableDate(p.createdAt!)
        : 'Unknown';

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFE8E7ED), width: 1.5),
      ),
      padding: EdgeInsets.all(28.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            'Listing Details',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF1E1E2F),
            ),
          ),
          SizedBox(height: 20.h),
          _buildDetailRow('Date Added', dateStr),
          _buildDetailRow(
            'Commission Rate',
            '${commissionRate.toStringAsFixed(0)}%',
          ),
          _buildDetailRow(
            'Colors',
            p.colors.isNotEmpty ? p.colors.join(', ') : 'None',
          ),
          _buildDetailRow(
            'Size',
            p.sizes.isNotEmpty ? p.sizes.join(', ') : 'None',
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 13.sp,
              color: const Color(0xFF8A8A9E),
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: 13.sp,
                color: const Color(0xFF1E1E2F),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
