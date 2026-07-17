import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/features/shop/products/data/models/product_model.dart';
import 'package:street_cart/features/customer/products/presentation/bloc/product_filter_bloc.dart';
import 'package:street_cart/features/customer/products/presentation/bloc/product_filter_event.dart';
import 'package:street_cart/features/customer/products/presentation/widgets/filter/filter_sort_section.dart';
import 'package:street_cart/features/customer/products/presentation/widgets/filter/filter_price_section.dart';
import 'package:street_cart/features/customer/products/presentation/widgets/filter/filter_categories_section.dart';
import 'package:street_cart/features/customer/products/presentation/widgets/filter/filter_colors_section.dart';
import 'package:street_cart/features/customer/products/presentation/widgets/filter/filter_sizes_section.dart';
import 'package:street_cart/features/customer/products/presentation/widgets/filter/filter_rating_section.dart';

// Product Filter Page
class ProductFilterPage extends StatelessWidget {
  final List<ProductModel> allProducts;
  final List<String> categories;
  final String selectedSort;
  final RangeValues priceRange;
  final Set<String> selectedCategories;
  final String? selectedRating;
  final Set<String> selectedColors;
  final Set<String> selectedSizes;

  const ProductFilterPage({
    super.key,
    required this.allProducts,
    required this.categories,
    required this.selectedSort,
    required this.priceRange,
    required this.selectedCategories,
    required this.selectedRating,
    required this.selectedColors,
    required this.selectedSizes,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProductFilterBloc>(
      create: (_) => ProductFilterBloc()
        ..add(
          InitProductFilter(
            allProducts: allProducts,
            selectedSort: selectedSort,
            initialRange: priceRange,
            selectedCategories: selectedCategories,
            selectedRating: selectedRating,
            selectedColors: selectedColors,
            selectedSizes: selectedSizes,
          ),
        ),
      child: const _ProductFilterPageBody(),
    );
  }
}

class _ProductFilterPageBody extends StatefulWidget {
  const _ProductFilterPageBody();

  @override
  State<_ProductFilterPageBody> createState() => _ProductFilterPageBodyState();
}

class _ProductFilterPageBodyState extends State<_ProductFilterPageBody> {
  late final TextEditingController _minPriceController;
  late final TextEditingController _maxPriceController;

  @override
  void initState() {
    super.initState();
    // Initialize Price Values
    final bloc = context.read<ProductFilterBloc>();
    _minPriceController = TextEditingController(
      text: bloc.state.minPrice.round().toString(),
    );
    _maxPriceController = TextEditingController(
      text: bloc.state.maxPrice.round().toString(),
    );
  }

  @override
  void dispose() {
    _minPriceController.dispose();
    _maxPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<ProductFilterBloc>();

    return BlocListener<ProductFilterBloc, ProductFilterState>(
      // Text Fields sync With Slider Moves
      listenWhen: (prev, curr) =>
          prev.minPrice != curr.minPrice || prev.maxPrice != curr.maxPrice,
      listener: (context, state) {
        final minStr = state.minPrice.round().toString();
        final maxStr = state.maxPrice.round().toString();
        if (_minPriceController.text != minStr) {
          _minPriceController.text = minStr;
        }
        if (_maxPriceController.text != maxStr) {
          _maxPriceController.text = maxStr;
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.close, color: Colors.black87),
            onPressed: () => Navigator.pop(context),
          ),
          centerTitle: true,
          title: Text(
            'Filters',
            style: TextStyle(
              color: Colors.black87,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            // Reset Button
            TextButton(
              onPressed: () => bloc.add(ResetProductFilter()),
              child: Text(
                'Reset',
                style: TextStyle(
                  color: CustomerAppColors.primary,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        body: BlocBuilder<ProductFilterBloc, ProductFilterState>(
          builder: (context, state) {
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Sort Option Chips
                        FilterSortSection(
                          selectedSort: state.selectedSort,
                          bloc: bloc,
                        ),
                        SizedBox(height: 24.h),
                        // Price Range Slider and Text Inputs
                        FilterPriceSection(
                          state: state,
                          bloc: bloc,
                          minPriceController: _minPriceController,
                          maxPriceController: _maxPriceController,
                        ),
                        SizedBox(height: 24.h),
                        // Category Search and List
                        FilterCategoriesSection(state: state, bloc: bloc),
                        SizedBox(height: 24.h),
                        // Color Selector
                        FilterColorsSection(state: state, bloc: bloc),
                        SizedBox(height: 24.h),
                        // Size Chips
                        FilterSizesSection(state: state, bloc: bloc),
                        // Rating Filter Chips
                        FilterRatingSection(
                          selectedRating: state.selectedRating,
                          bloc: bloc,
                        ),
                        SizedBox(height: 24.h),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 16.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(top: BorderSide(color: Colors.grey[100]!)),
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    height: 48.h,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context, {
                          'selectedSort': state.selectedSort,
                          'priceRange': RangeValues(
                            state.minPrice,
                            state.maxPrice,
                          ),
                          'selectedCategories': state.selectedCategories,
                          'selectedRating': state.selectedRating,
                          'selectedColors': state.selectedColors,
                          'selectedSizes': state.selectedSizes,
                        });
                      },
                      // Show Result Button
                      style: ElevatedButton.styleFrom(
                        backgroundColor: CustomerAppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24.r),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Show Results',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
