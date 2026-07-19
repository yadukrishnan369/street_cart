import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';
import 'package:street_cart/core/utils/validators.dart';
import 'package:street_cart/shared/widgets/custom_text_field.dart';

// Basic product details form
class ProductBasicDetailsForm extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController priceController;
  final TextEditingController offerPriceController;
  final TextEditingController descController;

  // Category + size standard
  final String selectedCategory;
  final List<String> categories;
  final String selectedSizeStandard;
  final List<String> sizeStandards;
  final ValueChanged<String?> onCategoryChanged;
  final ValueChanged<String?> onSizeStandardChanged;

  const ProductBasicDetailsForm({
    super.key,
    required this.nameController,
    required this.priceController,
    required this.offerPriceController,
    required this.descController,
    required this.selectedCategory,
    required this.categories,
    required this.selectedSizeStandard,
    required this.sizeStandards,
    required this.onCategoryChanged,
    required this.onSizeStandardChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Text(
          'BASIC DETAILS',
          style: ShopAppTextStyles.caption.copyWith(
            color: ShopAppColors.primary,
          ),
        ),
        SizedBox(height: 12.h),

        // Product Name Field
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

        // Prices Field
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
        SizedBox(height: 6.h),
        // Info
        Text(
          'Leave offer price empty if no discount available',
          style: TextStyle(fontSize: 11.sp, color: ShopAppColors.textSecondary),
        ),
        SizedBox(height: 16.h),

        // Product Description Field
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

        // Product Category dropdown
        Text(
          'Category',
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.bold,
            color: ShopAppColors.textSecondary,
          ),
        ),
        SizedBox(height: 8.h),
        DropdownButtonFormField<String>(
          value: categories.contains(selectedCategory)
              ? selectedCategory
              : (categories.isNotEmpty ? categories.first : null),
          isExpanded: true,
          dropdownColor: Colors.white,
          decoration: _dropdownDecoration(Icons.category_outlined),
          items: categories
              .map((c) => DropdownMenuItem(value: c, child: Text(c)))
              .toList(),
          onChanged: onCategoryChanged,
        ),
        SizedBox(height: 16.h),

        // Size standard dropdown
        Text(
          'Size Standard',
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.bold,
            color: ShopAppColors.textSecondary,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          'Changing this updates the available sizes for all variants.',
          style: TextStyle(fontSize: 11.sp, color: ShopAppColors.textSecondary),
        ),
        SizedBox(height: 8.h),
        DropdownButtonFormField<String>(
          value: sizeStandards.contains(selectedSizeStandard)
              ? selectedSizeStandard
              : (sizeStandards.isNotEmpty ? sizeStandards.first : null),
          isExpanded: true,
          dropdownColor: Colors.white,
          decoration: _dropdownDecoration(Icons.straighten_outlined),
          items: sizeStandards
              .map((s) => DropdownMenuItem(value: s, child: Text(s)))
              .toList(),
          onChanged: onSizeStandardChanged,
        ),
      ],
    );
  }

  InputDecoration _dropdownDecoration(IconData icon) {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: ShopAppColors.primary),
      ),
      prefixIcon: Icon(icon, color: ShopAppColors.primary, size: 20.sp),
    );
  }
}
