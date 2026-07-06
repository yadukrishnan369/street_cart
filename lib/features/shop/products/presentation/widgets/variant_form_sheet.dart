import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';
import 'package:street_cart/core/utils/image_picker_helper.dart';
import 'package:street_cart/features/shop/products/presentation/bloc/add_edit_product_state.dart';
import 'color_selector.dart';
import 'image_picker_area.dart';
import 'size_qty_grid.dart';

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
  late String _selectedColor;
  late List<dynamic> _images;
  late Map<String, TextEditingController> _sizeControllers;
  bool _isPickingImages = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    final existing = widget.existingVariant;
    // Set initial color selection
    _selectedColor =
        existing?.colorName ??
        (widget.availableColors.isNotEmpty
            ? widget.availableColors.keys.first
            : '');
    // Load existing variant images if editing
    _images = List.from(existing?.images ?? []);
    // Initialize controller inputs with current quantities
    _sizeControllers = {
      for (final size in widget.availableSizes)
        size: TextEditingController(
          text: (existing?.sizes[size] ?? 0).toString(),
        ),
    };
  }

  @override
  void dispose() {
    for (final c in _sizeControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  // Opens gallery to pick multiple images
  Future<void> _pickImages() async {
    setState(() => _isPickingImages = true);
    try {
      final files = await ImagePickerHelper.pickMultiImage(limit: 8);
      if (files.isNotEmpty) {
        setState(() => _images = List<dynamic>.from(files));
      }
    } catch (_) {
    } finally {
      setState(() => _isPickingImages = false);
    }
  }

  // Parses user text input controllers into a map of sizes and quantities
  Map<String, int> _buildSizesMap() {
    return _sizeControllers.map(
      (k, v) => MapEntry(k, int.tryParse(v.text) ?? 0),
    );
  }

  // Validates inputs and returns the variant configuration draft
  void _save() {
    setState(() => _errorMessage = null);

    if (_selectedColor.isEmpty) {
      setState(() => _errorMessage = 'Please select a color.');
      return;
    }
    if (_images.isEmpty) {
      setState(
        () => _errorMessage = 'Add at least one image for this variant.',
      );
      return;
    }

    final sizesMap = _buildSizesMap();
    if (sizesMap.isEmpty || sizesMap.values.every((qty) => qty == 0)) {
      setState(
        () => _errorMessage =
            'Please enter a stock quantity for at least one size.',
      );
      return;
    }

    widget.onSave(
      VariantDraft(
        colorName: _selectedColor,
        images: List<dynamic>.from(_images),
        sizes: sizesMap,
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existingVariant != null;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.92 - bottomInset,
        decoration: BoxDecoration(
          color: ShopAppColors.background,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        child: Column(
          children: [
            _SheetHeader(
              title: isEditing ? 'Edit Variant' : 'Add Variant',
              onClose: () => Navigator.pop(context),
              onSave: _save,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_errorMessage != null) _buildErrorCard(),
                    _SectionLabel('Color'),
                    SizedBox(height: 10.h),
                    ColorSelector(
                      availableColors: widget.availableColors,
                      selectedColor: _selectedColor,
                      onSelected: (c) => setState(() => _selectedColor = c),
                    ),
                    SizedBox(height: 24.h),
                    _SectionLabel('Images for this Color'),
                    SizedBox(height: 10.h),
                    ImagePickerArea(
                      images: _images,
                      isLoading: _isPickingImages,
                      onPick: _pickImages,
                      onRemove: (idx) => setState(() => _images.removeAt(idx)),
                    ),
                    SizedBox(height: 24.h),
                    if (widget.availableSizes.isNotEmpty) ...[
                      _SectionLabel('Size Quantities'),
                      SizedBox(height: 4.h),
                      Text(
                        'Enter the number of items available for each size.',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: ShopAppColors.textSecondary,
                        ),
                      ),
                      SizedBox(height: 14.h),
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
  }

  Widget _buildErrorCard() {
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
              _errorMessage!,
              style: TextStyle(fontSize: 12.sp, color: ShopAppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}

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
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
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
              color: Colors.grey[300],
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
                  color: ShopAppColors.textSecondary,
                  size: 22.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(child: Text(title, style: ShopAppTextStyles.heading3)),
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
