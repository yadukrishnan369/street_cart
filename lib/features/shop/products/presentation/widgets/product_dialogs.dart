import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/features/shop/products/presentation/bloc/shop_products_bloc.dart';
import 'package:street_cart/features/shop/products/presentation/bloc/shop_products_event.dart';

// Product Dialogs
class ProductDialogs {
  static void showAddSizeModal({
    required BuildContext context,
    required String selectedSizeStandard,
    required String shopId,
    required ShopProductsBloc productsBloc,
    required Function(String) onSizeAdded,
  }) {
    final textController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Size to $selectedSizeStandard'),
        content: TextField(
          controller: textController,
          decoration: const InputDecoration(
            hintText: 'e.g. XXXL, 12, 38',
            border: OutlineInputBorder(),
          ),
          textCapitalization: TextCapitalization.characters,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final size = textController.text.trim();
              if (size.isNotEmpty) {
                productsBloc.add(
                  AddCustomSizeEvent(
                    shopId: shopId,
                    sizeStandard: selectedSizeStandard,
                    newSize: size,
                  ),
                );
                onSizeAdded(size);
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ShopAppColors.primary,
            ),
            child: const Text('Add', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  static void showAddColorModal({
    required BuildContext context,
    required String shopId,
    required ShopProductsBloc productsBloc,
    required Function(String) onColorAdded,
  }) {
    final List<String> palette = [
      'Black',
      'Blue',
      'Red',
      'White',
      'Green',
      'Orange',
      'Purple',
      'Pink',
      'Yellow',
      'Teal',
      'Cyan',
      'Brown',
      'Grey',
    ];

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Add Color'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Select a predefined color:'),
              SizedBox(height: 12.h),
              SizedBox(
                width: double.maxFinite,
                height: 200.h,
                child: GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    childAspectRatio: 1.4,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                  ),
                  itemCount: palette.length,
                  itemBuilder: (context, index) {
                    final colorName = palette[index];
                    final color = ShopAppColors.getColorFromName(colorName);
                    final isWhite = color.value == 0xFFFFFFFF;
                    return GestureDetector(
                      onTap: () {
                        productsBloc.add(
                          AddCustomColorEvent(
                            shopId: shopId,
                            newColorHex: colorName,
                          ),
                        );
                        onColorAdded(colorName);
                        Navigator.pop(dialogContext);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 16.r,
                              height: 16.r,
                              decoration: BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isWhite
                                      ? Colors.grey[400]!
                                      : Colors.transparent,
                                  width: 1.w,
                                ),
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              colorName,
                              style: TextStyle(fontSize: 10.sp),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}
