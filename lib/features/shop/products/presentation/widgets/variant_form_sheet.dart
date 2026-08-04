import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';
import 'package:street_cart/features/shop/products/presentation/bloc/add_edit_product_bloc.dart';
import 'package:street_cart/features/shop/products/presentation/bloc/add_edit_product_event.dart';
import 'package:street_cart/features/shop/products/presentation/bloc/add_edit_product_state.dart';
import 'package:street_cart/features/shop/products/presentation/utils/products_page_helper.dart';
import 'color_selector.dart';
import 'image_picker_area.dart';
import 'size_qty_grid.dart';

// Variant Form Sheet
class VariantFormSheet extends StatefulWidget {
  final VariantDraft? existingVariant;
  final Map<String, String> availableColors;
  final List<String> availableSizes;
  final ValueChanged<VariantDraft> onSave;

  const VariantFormSheet({
    super.key,
    this.existingVariant,
    required this.availableColors,
    required this.availableSizes,
    required this.onSave,
  });

  @override
  State<VariantFormSheet> createState() => _VariantFormSheetState();
}

class _VariantFormSheetState extends State<VariantFormSheet> {
  late Map<String, TextEditingController> _sizeControllers;

  @override
  void initState() {
    super.initState();
    final bloc = context.read<AddEditProductBloc>();

    // Initialize Variant Draft Event
    bloc.add(
      InitVariantDraftEvent(
        existingVariant: widget.existingVariant,
        availableSizes: widget.availableSizes,
        availableColors: widget.availableColors,
      ),
    );

    // Initialize controller inputs fields
    _sizeControllers = {
      for (final size in widget.availableSizes)
        size:
            TextEditingController(
              text: (widget.existingVariant?.sizes[size] ?? 0).toString(),
            )..addListener(() {
              final val = int.tryParse(_sizeControllers[size]!.text) ?? 0;
              bloc.add(UpdateDraftSizeQtyEvent(size, val));
            }),
    };
  }

  @override
  void dispose() {
    for (final c in _sizeControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existingVariant != null;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return BlocBuilder<AddEditProductBloc, AddEditProductState>(
      builder: (context, state) {
        final theme = Theme.of(context);
        final isDark = theme.brightness == Brightness.dark;

        final draft = state.editingVariant ?? const VariantDraft(colorName: '');
        final errorMessage = state.variantErrorMessage;

        return Padding(
          padding: EdgeInsets.only(bottom: bottomInset),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.92 - bottomInset,
            decoration: BoxDecoration(
              color: isDark
                  ? ShopAppColors.darkBackground
                  : ShopAppColors.background,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
            ),
            child: Column(
              children: [
                // Header Section
                _SheetHeader(
                  title: isEditing ? 'Edit Variant' : 'Add Variant',
                  onClose: () => Navigator.pop(context),
                  onSave: () => ProductsPageHelper.saveVariant(
                    context: context,
                    state: state,
                    onSave: widget.onSave,
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 16.h,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (errorMessage != null) _buildErrorCard(errorMessage),
                        // Section Label
                        const _SectionLabel('Color'),
                        SizedBox(height: 10.h),
                        // Color Selector
                        ColorSelector(
                          availableColors: widget.availableColors,
                          selectedColor: draft.colorName,
                          onSelected: (c) => context
                              .read<AddEditProductBloc>()
                              .add(UpdateDraftColorEvent(c)),
                        ),
                        SizedBox(height: 24.h),
                        // Section Label
                        const _SectionLabel('Images for this Color'),
                        SizedBox(height: 10.h),
                        // Image Picker Section
                        ImagePickerArea(
                          images: draft.images,
                          isLoading: state.isPickingImages,
                          onPick: () =>
                              ProductsPageHelper.pickVariantImages(context),
                          onRemove: (idx) {
                            final list = List<dynamic>.from(draft.images);
                            list.removeAt(idx);
                            context.read<AddEditProductBloc>().add(
                              UpdateDraftImagesEvent(list),
                            );
                          },
                        ),
                        SizedBox(height: 24.h),
                        if (widget.availableSizes.isNotEmpty) ...[
                          // Section Label
                          const _SectionLabel('Size Quantities'),
                          SizedBox(height: 4.h),
                          Text(
                            'Enter the number of items available for each size.',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: isDark
                                  ? ShopAppColors.darkTextSecondary
                                  : ShopAppColors.textSecondary,
                            ),
                          ),
                          SizedBox(height: 14.h),
                          // Size Quantity Grid
                          SizeQtyGrid(controllers: _sizeControllers),
                        ],
                        SizedBox(height: 32.h),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildErrorCard(String errorMsg) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: ShopAppColors.error.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: ShopAppColors.error.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: ShopAppColors.error, size: 18.sp),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              errorMsg,
              style: TextStyle(fontSize: 12.sp, color: ShopAppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}

// Sheet Header
class _SheetHeader extends StatelessWidget {
  final String title;
  final VoidCallback onClose;
  final VoidCallback onSave;

  const _SheetHeader({
    required this.title,
    required this.onClose,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: isDark ? ShopAppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: isDark ? ShopAppColors.darkBorder : Colors.grey[300],
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          SizedBox(height: 14.h),
          Row(
            children: [
              GestureDetector(
                onTap: onClose,
                child: Icon(
                  Icons.close_rounded,
                  color: isDark
                      ? ShopAppColors.darkTextSecondary
                      : ShopAppColors.textSecondary,
                  size: 22.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  title,
                  style: isDark
                      ? ShopAppTextStyles.heading3.copyWith(
                          color: ShopAppColors.darkTextPrimary,
                        )
                      : ShopAppTextStyles.heading3,
                ),
              ),
              ElevatedButton(
                onPressed: onSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: ShopAppColors.primary,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 10.h,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Save',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: TextStyle(
        fontSize: 11.sp,
        fontWeight: FontWeight.bold,
        color: ShopAppColors.primary,
        letterSpacing: 1.0,
      ),
    );
  }
}
