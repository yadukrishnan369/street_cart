import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';
import 'package:street_cart/core/utils/validators.dart';
import 'package:street_cart/shared/widgets/custom_text_field.dart';

class ProductBasicDetailsForm extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController priceController;
  final TextEditingController offerPriceController;
  final TextEditingController descController;
  final TextEditingController stockController;

  const ProductBasicDetailsForm({
    super.key,
    required this.nameController,
    required this.priceController,
    required this.offerPriceController,
    required this.descController,
    required this.stockController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'BASIC DETAILS',
          style: ShopAppTextStyles.caption.copyWith(
            color: ShopAppColors.primary,
          ),
        ),
        SizedBox(height: 12.h),

        CustomTextField(
          label: 'Product Name',
          hintText: 'e.g. Slim Fit Cotton Shirt',
          controller: nameController,
          prefixIcon: Icon(
            Icons.shopping_bag_outlined,
            color: ShopAppColors.primary,
            size: 20.sp,
          ),
          labelStyle: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.bold,
            color: ShopAppColors.textSecondary,
          ),
          fillColor: Colors.white,
          borderColor: Colors.grey[300],
          focusedBorderColor: ShopAppColors.primary,
          validator: Validators.validateProductName,
        ),
        SizedBox(height: 16.h),

        Row(
          children: [
            Expanded(
              child: CustomTextField(
                label: 'Original Price (₹)',
                hintText: '0.00',
                controller: priceController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                prefixIcon: Icon(
                  Icons.currency_rupee_outlined,
                  color: ShopAppColors.primary,
                  size: 20.sp,
                ),
                labelStyle: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold,
                  color: ShopAppColors.textSecondary,
                ),
                fillColor: Colors.white,
                borderColor: Colors.grey[300],
                focusedBorderColor: ShopAppColors.primary,
                validator: Validators.validateProductOriginalPrice,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: CustomTextField(
                label: 'Offer Price (₹)',
                hintText: '0.00',
                controller: offerPriceController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                prefixIcon: Icon(
                  Icons.local_offer_outlined,
                  color: ShopAppColors.primary,
                  size: 20.sp,
                ),
                labelStyle: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold,
                  color: ShopAppColors.textSecondary,
                ),
                fillColor: Colors.white,
                borderColor: Colors.grey[300],
                focusedBorderColor: ShopAppColors.primary,
                validator: (val) => Validators.validateProductOfferPrice(
                  val,
                  priceController.text,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Text(
          'Leave offer price empty if no discount available',
          style: TextStyle(
            fontSize: 11.sp,
            color: ShopAppColors.textSecondary,
          ),
        ),
        SizedBox(height: 16.h),

        CustomTextField(
          label: 'Description',
          hintText: 'Describe your product...',
          controller: descController,
          maxLines: 4,
          prefixIcon: Icon(
            Icons.description_outlined,
            color: ShopAppColors.primary,
            size: 20.sp,
          ),
          labelStyle: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.bold,
            color: ShopAppColors.textSecondary,
          ),
          fillColor: Colors.white,
          borderColor: Colors.grey[300],
          focusedBorderColor: ShopAppColors.primary,
          validator: Validators.validateProductDescription,
        ),
        SizedBox(height: 16.h),

        CustomTextField(
          label: 'Stock Quantity',
          hintText: '0',
          controller: stockController,
          keyboardType: TextInputType.number,
          prefixIcon: Icon(
            Icons.inventory_2_outlined,
            color: ShopAppColors.primary,
            size: 20.sp,
          ),
          labelStyle: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.bold,
            color: ShopAppColors.textSecondary,
          ),
          fillColor: Colors.white,
          borderColor: Colors.grey[300],
          focusedBorderColor: ShopAppColors.primary,
          validator: Validators.validateProductStock,
        ),
      ],
    );
  }
}
