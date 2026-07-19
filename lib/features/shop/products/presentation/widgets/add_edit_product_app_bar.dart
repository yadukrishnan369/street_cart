import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';
import 'package:street_cart/features/shop/products/presentation/bloc/add_edit_product_bloc.dart';
import 'package:street_cart/features/shop/products/presentation/bloc/add_edit_product_state.dart';

// Add Edit Product App Bar
class AddEditProductAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final bool isEdit;
  final VoidCallback onPublish;

  const AddEditProductAppBar({
    super.key,
    required this.isEdit,
    required this.onPublish,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: ShopAppColors.textPrimary),
        onPressed: () => Navigator.pop(context),
      ),
      // App Bar Title
      title: Text(
        !isEdit ? 'Add Product' : 'Edit Product',
        style: ShopAppTextStyles.heading3,
      ),
      actions: [
        BlocBuilder<AddEditProductBloc, AddEditProductState>(
          builder: (context, state) {
            // Button for Uploading Product
            return TextButton(
              onPressed: state.isPublishing ? null : onPublish,
              child: Text(
                !isEdit ? 'PUBLISH' : 'SAVE',
                style: TextStyle(
                  color: state.isPublishing
                      ? ShopAppColors.textSecondary
                      : ShopAppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp,
                ),
              ),
            );
          },
        ),
        SizedBox(width: 8.w),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
