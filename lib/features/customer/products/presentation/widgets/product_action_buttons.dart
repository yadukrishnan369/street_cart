import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/features/shop/products/data/models/product_model.dart';

class ProductActionButtons extends StatelessWidget {
  final ProductModel product;

  final int availableQty;

  const ProductActionButtons({
    super.key,
    required this.product,
    this.availableQty = 0,
  });

  @override
  Widget build(BuildContext context) {
    final bool canAdd = availableQty > 0;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: CustomerAppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, -4),
            blurRadius: 10,
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: canAdd
                    ? () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${product.name} added to cart!'),
                            backgroundColor: CustomerAppColors.primary,
                          ),
                        );
                      }
                    : null,
                icon: Icon(
                  Icons.shopping_cart_outlined,
                  color: canAdd ? CustomerAppColors.primary : Colors.grey[400],
                ),
                label: Text(
                  canAdd ? 'Add to Cart' : 'Out of Stock',
                  style: TextStyle(
                    color: canAdd
                        ? CustomerAppColors.primary
                        : Colors.grey[400],
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: canAdd
                      ? CustomerAppColors.primary
                      : Colors.grey[400],
                  side: BorderSide(
                    color: canAdd
                        ? CustomerAppColors.primary
                        : Colors.grey[300]!,
                  ),
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: ElevatedButton(
                onPressed: canAdd
                    ? () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Proceeding to checkout with ${product.name}!',
                            ),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: CustomerAppColors.primary,
                  disabledBackgroundColor: Colors.grey[300],
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: const Text('Buy Now'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
